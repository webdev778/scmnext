require 'scanf'

namespace :dlt do
  desc "速報値ダウンロードテスト"
  task download: :environment  do |task, args|
    # 東京電力
    # https://pu00.www6.tepco.co.jp/LNXWPWSS01OH/LNXWPWSS01I/FileListReceiver
    # https://pu00.www6.tepco.co.jp/LNXWPWSS01OH/LNXWPWSS01I/FileReceiver
    # 関西電力
    # https://www4.kepco.co.jp/prx/000/http/kanden/jidoDL/FileListReceiver
    # https://www4.kepco.co.jp/prx/000/http/kanden/jidoDL/FileReceiver
    # 中部電力
    # https://epcdss-www.chuden.co.jp/41294/FileListReceiver
    # https://epcdss-www.chuden.co.jp/41294/FileReceiver
    # 東北電力
    # https://takuso-web.takuso.tohoku-epco.co.jp/G83PPS_Auto/FileListReceiver
    # https://takuso-web.takuso.tohoku-epco.co.jp/G83PPS_Auto/FileReceiver
    # 九州電力
    # https://nsc-www.network.kyuden.co.jp/LNXWPWSS01I/App/FileListReceiver
    # https://nsc-www.network.kyuden.co.jp/LNXWPWSS01I/App/FileReceiver
    client_cert = File.read(Rails.root.join("config/legacy_convert/certs/occto/eneop.pem"))
    con = Faraday::Connection.new(
      url: 'https://epcdss-www.chuden.co.jp',
      ssl: {
        client_key: OpenSSL::PKey::RSA.new(client_cert),
        client_cert: OpenSSL::X509::Certificate.new(client_cert)
      }
    )

    base_url = '/41294/'

    file_list_url = "#{base_url}FileListReceiver"
    file_url = "#{base_url}FileReceiver"

    result = con.get(file_list_url)
    file_list = result.body
      .gsub(/\n/, '')
      .gsub(/.*<comment>(.*)<\/comment>.*/, '\1')
      .split(",").reduce({}) do |map, line|
        case line
        when /(rfilename)([0-9]*):"(.*)"/
          map[$2] ||= {}
          map[$2]['filename'] = $3
        when /(rfilesize)([0-9]*):"(.*)"/
          map[$2] ||= {}
          map[$2]['size'] = $3.to_i
        else
          puts line
        end
        map
      end
    file_list.each do |key ,item|
      result = con.get(file_url, {file: item[:filename]})
      binding.pry
    end
    # $commentTag = preg_replace("/.*<comment>(.*)<\/comment>.*/s", "$1", $result);
    # $lines = explode(",", $commentTag);
    # $list = array();
    # foreach($lines as $line){
    #   $id = null;
    #   list($key, $value) = explode(':', $line);
    #   if (strpos($key, 'rfilename')!==false){
    #     $id = substr($key, strpos($key, 'rfilename') + 9);
    #     $key = 'filename';
    #   }elseif(strpos($key, 'rfilesize')!==false){
    #     $id = substr($key, strpos($key, 'rfilesize') + 9);
    #     $key = 'size';
    #   }
    #   if ($id != null){
    #     if (!isset($list[$id])){
    #       $list[$id] = array();
    #     }
    #     $list[$id][$key] = json_decode($value);
    #   }
    # }
    # return $list;
  end
end
