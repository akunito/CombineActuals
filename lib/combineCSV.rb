require 'csv'

puts 'CSVReader initialized.'

# Add to the array all the folders that must be combined
@array = %w[
20240101
20240102
20240103
20240104
20240105
20240106
20240107
20240108
20240109
20240110
20240111
20240112
20240113
20240114
20240115
20240116
20240117
20240118
20240119
20240120
20240121
20240122
20240123
20240124
20240125
20240126
20240127
20240128
20240129
20240130
20240131
]

@array.each do |element|
  # FOLDER'S NAME TO BE PROCESSED as for example "20230613"
  @folder = element
  puts
  puts "combining folder #{@folder}"

  # path (it must exists)
  @base_path = "C:/data_exchange/archive/" + @folder + "/"
  @output_path = "C:/data_exchange/archive/combined_files/"

  def merge_file(result_file, headers, file_list)
    result_full_path = @output_path + result_file
    CSV.open(result_full_path, 'w') do |csv|
      csv << headers
      file_list.each do |filename|
        # CSV.open(filename, headers: true)
        full_path = @base_path + filename
        CSV.foreach(full_path, headers: true) {|row| csv << row.values_at(*headers) }
      end
    end
  end

  # Get list of files
  filenames = Dir.entries(@base_path).sort
  # Select only .csv and .gz files
  filenames.select! do |filename|
    filename.include?(".gz") ||
    filename.include?(".csv")
  end
  # Divide list for Opex and Capex
  opex_files = filenames.select do |filename|
    filename.include?("CP") ||
    filename.include?("opex")
  end
  capex_files = filenames.select do |filename|
    filename.include?("AMP") ||
    filename.include?("capex")
  end

  # List found files
  puts "Showing Full file list --> There is a total of #{filenames.length}"
  # filenames.each { |file| puts file }
  puts "Showing OPEX file list --> There is a total of #{opex_files.length}"
  # opex_files.each { |file| puts file }
  puts "Showing CAPEX file list --> There is a total of #{capex_files.length}"
  # capex_files.each { |file| puts file }
  puts "so opex + capex files is equal to the total of files .gz" if filenames.length == (opex_files.length + capex_files.length)
  puts " ---------------------------------------------------------------- "

  opex_header = %w{SYSID	MANDT	KOKRS	REFBK	K_GJAHR	PERIO	ZZLEISTPER	KOSTL	OBJNR_N1	REFBN	BELNR	BUZEI	BLART	BLTXT_F	SGTXT_F	BLDAT_F	BUDAT_F	KSTAR	KSTAR_KTXT	GKONT	GKOAR	GKONT_KTXT	WOGBTR_F	OWAER	WTGBTR_F	TWAER	WKGBTR_F	KWAER	MBGBTR_F	VBUND	ZZZUKO1	REFBN_ZUONR_F	STOKZ	STFLG	AWORG_REV	AWREF_REV	XBLNR_F}
  capex_header = %w{SYSID	MANDT	KOKRS	BUKRS	ANLN1	ANLN2	KOSTL	ANLKL	GJAHR	MONAT	BELNR	BUDAT_F	BWASL	ANBTR_F	WAERS	SGTXT_F	BZDAT_F	MENGE_F	MEINS	ORIGIN_F	XBLNR_F	CAUFN	ANLHTXT_F}

  puts
  puts "Merging files ... will take just a coffee ..."
  merge_file(@folder + "_opex_result.csv", opex_header, opex_files)
  merge_file(@folder + "_capex_result.csv", capex_header, capex_files)

  puts "Files are ready in #{@output_path}"

end



