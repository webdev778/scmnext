namespace :occto do
  # private function callCurl($url){
  #   if ($this->company==null){
  #     throw new Exception('company idがセットされていません。');
  #   };
  #   $curl = curl_init();
  #   curl_setopt($curl, CURLOPT_URL, $url);
  #   curl_setopt($curl, CURLOPT_SSLCERT, $this->getCertPath());
  #   curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
  #   curl_setopt($curl, CURLOPT_POST, true);
  #   curl_setopt($curl, CURLOPT_VERBOSE, false);
  #   curl_setopt($curl, CURLOPT_HEADER, true);
  #   curl_setopt($curl, CURLOPT_HTTPHEADER, $this->getHeaders());
  #   curl_setopt($curl, CURLOPT_POSTFIELDS, $this->getParams());

  #   $result = curl_exec($curl);
  #   $info = curl_getinfo($curl);
  #   $header = substr ($result, 0, $info["header_size"]);
  #   $body = substr ($result, $info["header_size"]);

  #   if (!preg_match('/resultcode\: (.*)\r\n/', $result, $match)){
  #     throw new Exception("失敗しました。{$result}");
  #   }
  #   $resultCode = $match[1];
  #   curl_close($curl);
  #   if ($resultCode!="0000") {
  #     throw new Exception("失敗しました。{$resultCode}");
  #   }
  #   if ( !empty($this->uploadFilename) && file_exists($this->uploadFilename) ) {
  #     unlink($this->uploadFilename);
  #     $this->uploadFilename = null;
  #   }
  #   return $body;
  # }

  def extract_single_file_zip_from_base64stream(base64_stream)
    zip_stream = Base64.decode64(base64_stream)
    zip_file = Zip::File.open_buffer(zip_stream)
    zip_file.read(zip_file.entries.first.name)
  end

  def get_first_filename_from_base64stream(base64_stream)
    zip_stream = Base64.decode64(base64_stream)
    zip_file = Zip::File.open_buffer(zip_stream)
    zip_file.entries.first.name
  end

  namespace :fit_plan do
    namespace :tomorrow do
      desc '翌日発電販売計画取込'
      task filelist: :environment do |_task, _args|
        bg_member = BgMember.find(27) # 京葉瓦斯
        account = bg_member.company.company_account_occto
        if account.nil?
          logger.error("#{bg_member.company.name}の広域アカウント情報がありません。")
          return nil
        end
        from_date = Date.tomorrow
        result = account.execute_occto_api('/service/RP12/OCCTO/api/listDownload/getW6BP0152FileList', {from: from_date.strftime('%Y%m%d')})
        xml_text = extract_single_file_zip_from_base64stream(result.body)
        doc = REXML::Document.new(xml_text, ignore_whitespace_nodes: :all)
        File.write(get_first_filename_from_base64stream(result.body), xml_text)
      end

      desc '翌日発電販売計画読込'
      task read: :environment do |_task, _args|
        xml_text = File.read('W6_0152.xml')
        doc = REXML::Document.new(xml_text, ignore_whitespace_nodes: :all)
        doc.get_elements('SBD-MSG/FIT_INFO').map do |node|
          node.elements["FIT_ID"].text
          node.elements["LAST_UPD_DAYTIME"].text
          node.elements["SBMIT_DAYTIME"].text
          node.elements["CRE_DAYTIME"].text
          node.elements["STAT"].text
          node.elements["STAT_NM"].text
          node.elements["FIT_RECPT_STAT"].text
          node.elements["FIT_RECPT_STAT_NM"].text
        end
      end

      desc '翌日発電販売計画取得'
      task get: :environment do |_task, _args|
        # raise "FIT_IDを指定してください" if ENV['FIT_ID'].nil?
        # bg_member = BgMember.find(27) # 京葉瓦斯
        # account = bg_member.company.company_account_occto
        # result = account.execute_occto_api('/service/RP12/OCCTO/api/fileDownload/getW6BP0152File', {fitid: ENV['FIT_ID']})
        # xml_text = extract_single_file_zip_from_base64stream(result.body)
        # filename = get_first_filename_from_base64stream(result.body)
        # puts filename
        # File.write(filename, xml_text.encode('UTF-8', 'UTF-8'))
        xml_text = File.read("W6_0152_20190611_00_61293_3.xml")
        doc = REXML::Document.new(xml_text, ignore_whitespace_nodes: :all)
      end
    end
  end

  namespace :plan do
    namespace :tomorrow do
      desc '翌日需要・調達計画取込'
      task import: :environment do |_task, _args|
        raise '取込対象となるファイルを環境変数TARGETで指定してください。' if ENV['TARGET'].nil?
        Occto::Plan.import_data(ENV['TARGET'])
      end

      desc '翌日需要・調達計画取込(旧システムより)'
      task import_from_legacy: :environment do |_task, _args|
        target_date = determine_target_date(Date.tomorrow)
        logger.info("処理日:#{target_date}")
        BalancingGroup.find_each do |bg|
          Legacy::TblAreaSupplyValue.generate_position_data(bg.id, target_date)
        end
      end
    end
  end
end
