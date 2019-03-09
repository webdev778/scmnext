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
  belongs_to :setting, class_name: Dlt::Setting.to_s
  has_many :usage_fixed_header
  has_one_attached :content

  enum state: {
    state_untreated: 0,
    state_complated: 1,
    state_in_progress: 2,
    state_complated_with_error: 3,
    state_exception: 4
  }

  #
  # パラメータで指定された条件に応じてファイル名に基づいた検索を行う
  #
  scope :filter_by_filename, lambda { |data_type, voltage_class, date = nil, time_index = nil|
    pattern = make_filename_pattern(data_type, voltage_class, date, time_index)
    logger.debug(pattern)
    eager_load(%i[content_blob content_attachment setting])
      .where(['active_storage_blobs.filename LIKE ?', pattern])
  }

  scope :includes_for_index, lambda {
    includes(%i[content_attachment content_blob])
  }

  scope :includes_for_show, lambda {
    includes(%i[content_attachment content_blob])
  }

  # class methods
  class << self
    #
    # サーバーから取得可能なファイルの一覧を取得して、ダウンロードを行う
    # ブロックが与えられた場合は、取得可能な各ファイルを引数とし、偽を返した場合は
    # 当該ファイルのダウンロードをスキップする
    #
    # @yield [filename] 偽を返した場合はダウンロードをスキップする
    #
    def download
      Dlt::Setting.all.find_each do |setting|
        target_name = "#{setting.company.name} #{setting.district.name}"
        if setting.connection.nil?
          logger.error("[#{target_name}]のダウンロードをスキップしました。")
          next
        end
        file_list = get_file_list(setting)
        logger.info("[#{target_name}]の託送データをダウンロードします。")
        filenames = file_list.map { |_no, list_item| list_item[:filename] }
        downloaded_filenames = Dlt::File.includes(%i[setting content_blob])
                                        .where(
                                          'setting_id' => setting.id,
                                          'active_storage_blobs.filename' => filenames
                                        ).pluck('active_storage_blobs.filename')
        file_list.each do |_no, list_item|
          next if downloaded_filenames.include?(list_item[:filename])
          next if block_given? && !yield(list_item[:filename])

          logger.info("download:#{list_item[:filename]}")
          result = get_file(list_item[:filename], setting)
          # @todo ファイルサイズをここでチェックする
          Dlt::File
            .create(setting_id: setting.id)
            .content.attach(io: StringIO.new(result.body), filename: list_item[:filename])
        end
        logger.info("[#{target_name}]のダウンロードを完了しました。")
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
      yyyymmdd = if date.nil?
                   '________'
                 elsif date.is_a?(String)
                   date
                 else
                   date.strftime('%Y%m%d')
                 end
      time_pattern = if time_index.nil?
                       '____'
                     else
                       TimeIndex.to_time_of_day(time_index).strftime('%H%M')
                     end
      if (voltage_class == :high) && (data_type == :today)
        "W40110#{yyyymmdd}#{time_pattern}____.zip"
      elsif (voltage_class == :low) && (data_type == :today)
        "W41110#{yyyymmdd}#{time_pattern}______.zip"
      elsif (voltage_class == :high) && (data_type == :past)
        "W40120#{yyyymmdd}0000____.zip"
      elsif (voltage_class == :low) && (data_type == :past)
        "W41120#{yyyymmdd}0000______.zip"
      elsif (voltage_class == :high) && (data_type == :fixed)
        "W51210#{yyyymmdd}_______.zip"
      elsif (voltage_class == :low) && (data_type == :fixed)
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
      begin
        result = setting.connection.get("#{setting.path_prefix}/FileListReceiver")
      rescue
        logger.error("接続できません。")
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

  def as_json(options = {})
    if options.blank?
      options = {
        include: %i[
          content_attachment
          content_blob
        ]
      }
    end
    super options
  end

  #
  # ステータスを変更しつつ取込処理を実行
  #
  def perform_document_read
    state_in_progress!
    begin
      zip_file = Zip::File.open_buffer(content.download)
      doc = REXML::Document.new(zip_file.read(zip_file.entries.first.name), ignore_whitespace_nodes: :all)
      result = yield(doc)
      if result.failed_instances.count > 0
        state_complated_with_error!
      else
        state_complated!
      end
    rescue StandardError => e
      state_exception!
      raise e
    end
  end
end
