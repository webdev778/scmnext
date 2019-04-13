workbook = RubyXL::Workbook.new
worksheet = workbook.worksheets[0]
@table_data.each.with_index do |values, row|
  values.each.with_index do |value, col|
    worksheet.add_cell(row, col, value)
  end
end
workbook.stream
