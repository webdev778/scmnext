require 'csv'
bom = %w(EF BB BF).map { |e| e.hex.chr }.join
bom = ""
CSV.generate(bom) do |csv|
  @table_data.each do |values|
    csv << values
  end
end.encode("Shift_JIS")
