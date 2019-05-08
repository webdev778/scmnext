# == Schema Information
#
# Table name: dlt_files
#
#  id                   :bigint(8)        not null, primary key
#  setting_id           :bigint(8)
#  voltage_mode         :integer
#  data_type            :integer
#  record_date          :date
#  record_time_index_id :integer
#  section_number       :integer
#  revision             :integer
#  state                :integer          default("state_untreated"), not null
#  created_by           :integer
#  updated_by           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Dlt::File < ApplicationRecord
  include RansackableEnum
  belongs_to :setting, class_name: Dlt::Setting.to_s
  has_many :usage_fixed_header
  has_one_attached :content

  before_save :set_file_information

  validates :content,
    presence: true
  validates :data_type,
    uniqueness: {scope: [:setting_id, :voltage_mode, :record_date, :record_time_index_id, :section_number, :revision]}

  ransackable_enum voltage_mode: {
    high: 1,
    low: 2
  }

  ransackable_enum data_type: {
    today: 1,
    past: 2,
    fixed: 3,
    exchange: 4,
    extra: 5
  }

  ransackable_enum state: {
    state_untreated: 0,
    state_complated: 1,
    state_in_progress: 2,
    state_complated_with_error: 3,
    state_exception: 4,
    state_corrupted: 5
  }

  #
  # 全てのデータを取込の対象とするか
  #
  # @param force [Boolean] falseを指定すると処理中及び完了分のみ。trueだとすべてを対象にする
  #
  scope :filter_force, lambda { |force|
    unless force
      where.not(state: [:state_complated, :state_in_progress])
    end
  }

  scope :includes_for_index, lambda {
    includes([
      :content_attachment,
      :content_blob,
      {
        setting: {
          bg_member: [
            :company,
            :balancing_group
          ]
        }
      }
    ])
  }

  scope :includes_for_show, lambda {
    includes(%i[content_attachment content_blob])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        methods: [
          :voltage_mode_i18n,
          :data_type_i18n,
          :state_i18n
        ],
        include: [
          :content_attachment,
          :content_blob,
          {
            setting: {
              include: {
                bg_member: {
                  include: [
                    :company,
                    :balancing_group
                  ]
                }
              }
            }
          }
        ]
      }
    end
    super options
  end

  # class methods
  class << self
    #
    # サーバーから取得可能なファイルの一覧を取得して、ダウンロードを行う
    # ダウンロードの対象は既にダウンロード済みで破損していないもの
    # また、ブロックが与えられた場合は、取得可能な各ファイルを引数とし、偽を返した場合は
    # 当該ファイルのダウンロードをスキップする
    #
    # @yield [filename] 偽を返した場合はダウンロードをスキップする
    #
    def download
      Dlt::Setting.filter_state_active.find_each do |setting|
        target_name = "#{setting.bg_member.company.name} #{setting.bg_member.balancing_group.district.name}"
        if setting.connection.nil?
          logger.error("[#{target_name}]のダウンロードをスキップしました。")
          next
        end
        logger.info("[#{target_name}]の託送データをダウンロードします。")
        file_list = get_file_list(setting)
        filenames = file_list.map { |_no, list_item| list_item[:filename] }
        downloaded_file_maps = Dlt::File.includes(%i[setting content_blob])
                                        .where(
                                          'setting_id' => setting.id,
                                          'active_storage_blobs.filename' => filenames
                                        ).map do |file|
                                          [file.content.filename.to_s, file]
                                        end.to_h
        logger.debug(filenames)
        file_list.each do |_no, list_item|
          next if block_given? && !yield(list_item[:filename])
          # 既にダウンロード済みかつ破損してない場合はスキップする
          next if downloaded_file_maps[list_item[:filename]] && !downloaded_file_maps[list_item[:filename]].state_corrupted?

          logger.info("download:#{list_item[:filename]}")
          result = get_file(list_item[:filename], setting)
          if result.body.size != list_item[:size]
            logger.warn("ファイルサイズが一致しないためスキップしました")
          end
          # @todo ファイルサイズをここでチェックする
          dlt_file = downloaded_file_maps[list_item[:filename]]
          dlt_file ||= Dlt::File.new(setting_id: setting.id)
          dlt_file.state = :state_untreated
          dlt_file.content.attach(io: StringIO.new(result.body), filename: list_item[:filename])
          unless dlt_file.save
            logger.warn("保存エラー", dlt_file.errors.full_messages.join(" "))
          end
        end
        logger.info("[#{target_name}]のダウンロードを完了しました。")
      end
    end

    private
    #
    # ファイル一覧の取得
    #
    def get_file_list(setting)
      begin
        result = setting.connection.get("#{setting.path_prefix}/FileListReceiver")
      rescue Exception=>ex
        logger.error("接続できません。")
        logger.error(ex)
        return []
      end
      file_list = result.body
                        .delete("\n")
                        .gsub(%r{.*<comment>(.*)</comment>.*}, '\1')
                        .split(',').each_with_object({}) do |line, map|
        case line
        when /(rfilename)([0-9]*):"(.*)"/
          map[Regexp.last_match(2)] ||= {}
          map[Regexp.last_match(2)][:filename] = Regexp.last_match(3)
        when /(rfilesize)([0-9]*):"(.*)"/
          map[Regexp.last_match(2)] ||= {}
          map[Regexp.last_match(2)][:size] = Regexp.last_match(3).to_i
        else
          logger.debug(line)
        end
      end
    end

    #
    # ファイルの取得
    #
    def get_file(filename, setting)
      setting.connection.get("#{setting.path_prefix}/FileReceiver", file: filename)
    end
  end

  #
  # コンテンツ中のXMLをREXMLオブジェクトとして返す
  # @return [REXML::Document] コンテンツ中のXML
  #
  def xml_document
    file_buffer = content.download
    zip_file = Zip::File.open_buffer(file_buffer)
    xml_entry = zip_file.entries.first.name
    xml_buffer = zip_file.read(xml_entry)
    doc = REXML::Document.new(xml_buffer, ignore_whitespace_nodes: :all)
    zip_file = nil
    xml_entry = nil
    xml_buffer = nil
    GC.start
    doc
  end

  private
  #
  # ファイル名から電圧モード、データ種別、記録日、記録時間枠ID、更新番号、分割番号をセットする
  #
  def set_file_information
    filename = content.filename.to_s
    case filename[0, 2]
    when "W4"
      case filename[2, 2]
      when "01"
        self.voltage_mode = :high
      when "11"
        self.voltage_mode = :low
      else
        raise "不明な電圧モード [#{filename[2, 2]}]"
      end
      case filename[4..5]
      when "10"
        self.data_type = :today
      when "20"
        self.data_type = :past
      else
        raise "不明なデータ種別 [#{filename[4, 2]}]"
      end
      record_time = DateTime.strptime(filename[6, 12], '%Y%m%d%H%M')
      self.record_date = record_time.to_date
      if data_type.to_sym == :today
        self.record_time_index_id = TimeIndex.from_time(record_time).id
      end
      self.revision = filename[18, 2].to_i
      case voltage_mode.to_sym
      when :high
        self.section_number = filename[20, 2].to_i
      when :low
        self.section_number = filename[20, 4].to_i
      end
    when "W5"
      case filename[2, 2]
      when "12"
        self.data_type = :fixed
      when "13"
        self.data_type = :exchange
      when "14"
        self.data_type = :extra
      else
        raise "不明なデータ種別 [#{filename[2, 2]}]"
      end
      case filename[4, 2]
      when "10"
        self.voltage_mode = :high
      when "20"
        self.voltage_mode = :low
      else
        raise "不明な電圧モード [#{filename[4, 2]}]"
      end
      record_time = DateTime.strptime(filename[6, 8], '%Y%m%d')
      self.record_date = record_time.to_date
      self.revision = filename[14, 2].to_i
      self.section_number = filename[16, 5].to_i
    else
      raise "不明なBPID副機関コードド [#{filename[0, 2]}]"
    end
  end
end
