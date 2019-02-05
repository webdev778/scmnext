# == Schema Information
#
# Table name: dlt_files
#
#  id         :bigint(8)        not null, primary key
#  setting_id :bigint(8)
#  state      :integer          default("state_untreated"), not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Dlt::File < ApplicationRecord
  belongs_to :setting, class_name: "Dlt::Setting"
  has_one_attached :content

  enum state: {
    state_untreated: 0,
    state_complated: 1,
    state_in_progress: 2,
    state_complated_with_error: 3,
    state_exception: 4
  }

  def filename
    self.content_attachment.filename
  end

  def as_json(options = {})
    if options.blank?
      options = {
        methods: [
          :filename
        ]
      }
    end
    super options
  end

  #
  # ステータスを変更しつつ取込処理を実行
  #
  def perform_document_read
    self.state_in_progress!
    begin
      zip_file = Zip::File.open_buffer(self.content.download)
      doc = REXML::Document.new(zip_file.read(zip_file.entries.first.name))
      result = yield(doc)
      if result.failed_instances.count > 0
        self.state_complated_with_error!
      else
        self.state_complated!
      end
    rescue =>e
      self.state_exception!
      raise e
    end
  end

  #
  # パラメータで指定された条件に応じてファイル名に基づいた検索を行う
  #
  scope :filter_by_filename, ->(data_type, voltage_class, date = nil, time_index = nil){
    pattern = make_filename_pattern(data_type, voltage_class, date, time_index)
    logger.debug(pattern)
    eager_load([:content_blob, :content_attachment, :setting])
    .where(["active_storage_blobs.filename LIKE ?", pattern])
  }

  scope :includes_for_index, ->{
    includes([:content_attachment, :content_blob])
  }

  scope :includes_for_show, ->{
    includes([:content_attachment, :content_blob])
  }

  class << self
    #
    # ダウンロードの実行
    #
    def download
      Dlt::Setting.all.each do |setting|
        file_list = get_file_list(setting)
        filenames = file_list.map{|no, list_item| list_item[:filename]}
        downloaded_filenames = Dlt::File.includes([:setting, :content_blob])
          .where(
            "setting_id"=>setting.id,
            "active_storage_blobs.filename"=>filenames
          ).pluck("active_storage_blobs.filename")
        file_list.each do |no, list_item|
          next if downloaded_filenames.include?(list_item[:filename])
          next if block_given? && !yield(list_item[:filename])
          puts "download:#{list_item[:filename]}"
          result = get_file(list_item[:filename], setting)
          # @todo ファイルサイズをここでチェックする
          Dlt::File
            .create(setting_id: setting.id)
            .content.attach(io: StringIO.new(result.body), filename: list_item[:filename])
        end
      end
    end

        #
    # 指定された条件に応じてファイル名のパターンを設定する
    #
    # @param [symbol] data_type データ区分(:today 当日ファイル, :past 過去ファイル, :fixed 確定使用量)
    # @param [symbol] voltage_class 電圧区分(:high 特高、高圧, :low 低圧)
    # @param [Date/String] date 日付(YYYYMMDD形式の文字列もしくは日付型の日付、nullの場合はワイルドカード指定
    # @param [integer] time_index 時刻コード(当日ファイルのみ指定可能、nullの場合はワイルドカード指定)
    # @return [String] ファイル名のパターン
    def make_filename_pattern(data_type, voltage_class, date = nil, time_index = nil)
      if date.nil?
        yyyymmdd = '________'
      elsif date.is_a?(String)
        yyyymmdd = date
      else
        yyyymmdd = date.strftime("%Y%m%d")
      end
      if time_index.nil?
        time_pattern = '____'
      else
        time_pattern = TimeIndex.to_time_of_day(time_index).strftime("%H%M")
      end
      case
      when( voltage_class == :high and data_type == :today )
        "W40110#{yyyymmdd}#{time_pattern}____.zip"
      when( voltage_class == :low and data_type == :today )
        "W41110#{yyyymmdd}#{time_pattern}______.zip"
      when( voltage_class == :high and data_type == :past )
        "W40120#{yyyymmdd}0000____.zip"
      when( voltage_class == :low and data_type == :past )
        "W41120#{yyyymmdd}0000______.zip"
      when( voltage_class == :high and data_type == :fixed )
        "W51210#{yyyymmdd}_______.zip"
      when( voltage_class == :low and data_type == :fixed )
        "W51220#{yyyymmdd}_______.zip"
      else
        raise "invalid combination of parameter: data_type=#{data_type}, voltage_class=#{voltage_class}"
      end
    end

    private
    #
    # ファイル一覧の取得
    #
    def get_file_list(setting)
      result = setting.connection.get("#{setting.district.dlt_path}/FileListReceiver")
      file_list = result.body
        .gsub(/\n/, '')
        .gsub(/.*<comment>(.*)<\/comment>.*/, '\1')
        .split(",").reduce({}) do |map, line|
          case line
          when /(rfilename)([0-9]*):"(.*)"/
            map[$2] ||= {}
            map[$2][:filename] = $3
          when /(rfilesize)([0-9]*):"(.*)"/
            map[$2] ||= {}
            map[$2][:size] = $3.to_i
          else
            puts line
          end
          map
        end
    end

    #
    # ファイルの取得
    #
    def get_file(filename, setting)
      setting.connection.get("#{setting.district.dlt_path}/FileReceiver", {file: filename})
    end

  end
end
