class Dlt::File < ApplicationRecord
  belongs_to :setting, class_name: "Dlt::Setting"
  has_one_attached :content

  class << self
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
          puts "download:#{list_item[:filename]}"
          result = get_file(list_item[:filename], setting)
          # @todo ファイルサイズをここでチェックする
          Dlt::File
            .create(setting_id: setting.id)
            .content.attach(io: StringIO.new(result.body), filename: list_item[:filename])
        end
      end
    end

    private
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

    def get_file(filename, setting)
      setting.connection.get("#{setting.district.dlt_path}/FileReceiver", {file: filename})
    end
  end
end
