def merge_file(result_file, headers, file_list, output_path, full_path)
  # headers must be a string "opex" or "capex"
  # assigning right headers:
  if headers == "opex"
    headers = %w{SYSID	MANDT	KOKRS	REFBK	K_GJAHR	PERIO	ZZLEISTPER	KOSTL	OBJNR_N1	REFBN	BELNR	BUZEI	BLART	BLTXT_F	SGTXT_F	BLDAT_F	BUDAT_F	KSTAR	KSTAR_KTXT	GKONT	GKOAR	GKONT_KTXT	WOGBTR_F	OWAER	WTGBTR_F	TWAER	WKGBTR_F	KWAER	MBGBTR_F	VBUND	ZZZUKO1	REFBN_ZUONR_F	STOKZ	STFLG	AWORG_REV	AWREF_REV	XBLNR_F}
  elsif headers == "capex"
    headers = %w{SYSID	MANDT	KOKRS	BUKRS	ANLN1	ANLN2	KOSTL	ANLKL	GJAHR	MONAT	BELNR	BUDAT_F	BWASL	ANBTR_F	WAERS	SGTXT_F	BZDAT_F	MENGE_F	MEINS	ORIGIN_F	XBLNR_F	CAUFN	ANLHTXT_F}
  end
  result_full_path = output_path + result_file

  # debugging
  puts "\n result_full_path"
  p result_full_path
  puts "\n file_list"
  p file_list
  puts "\n full_path"
  p full_path

  CSV.open(result_full_path, 'w') do |csv|
    csv << headers
    file_list.each do |filename|
      # CSV.open(filename, headers: true)
      CSV.foreach(full_path + filename, headers: true) {|row| csv << row.values_at(*headers) }
    end
  end
end

def display_file_stats(filenames, full_path, opex_files, capex_files)
  # puts
  # p "filenames: #{filenames}"
  # puts
  # p "opex_files: #{opex_files}"
  # puts
  # p "capex_files: #{capex_files}"

  puts
  puts "combining files found in: #{full_path}"
  # List found files
  puts "Showing Full file list --> There is a total of #{filenames.length} files"
  # filenames.each { |file| puts file }
  puts "Showing OPEX file list --> There is a total of #{opex_files.length} OPEX files"
  # opex_files.each { |file| puts file }
  puts "Showing CAPEX file list --> There is a total of #{capex_files.length} CAPEX files"
  # capex_files.each { |file| puts file }
  puts "Opex + Capex files count matches to the count of all .gz and .csv files" if filenames.length == (opex_files.length + capex_files.length)
  puts " ---------------------------------------------------------------- "
  puts
  puts "Merging files ... will take just a coffee ..."
end

def get_opex_files(filenames)
  # check filenames array and select only the ones that contains opex or CP in the name
  p filenames
  filenames.select do |filename|
    filename.include?("CP") ||
      filename.include?("opex")
  end
end
def get_capex_files(filenames)
  # check filenames array and select only the ones that contains capex or AMP in the name
  p filenames
  filenames.select do |filename|
    filename.include?("AMP") ||
      filename.include?("capex")
  end
end

def combine_files_by_folder(full_path, output_path, folder)
  puts
  p "full_path: #{full_path}"
  begin
    # Get list of files
    filenames = Dir.entries(full_path).sort
  rescue StandardError=>e
    puts "\n\tERROR: #{e}"
    puts "\tThe directory will be skipped...\n"
  else
    # Select only .csv and .gz files
    filenames.select! do |filename|
      filename.include?(".gz") ||
        filename.include?(".csv")
    end
    # divide opex and capex files
    opex_files = get_opex_files(filenames)
    capex_files = get_capex_files(filenames)
    # display stats in console
    display_file_stats(filenames, folder, opex_files, capex_files)

    puts "\nfolder>>>#{folder}"
    merge_file(folder + "_combined_opex.csv", "opex", opex_files, output_path, full_path)
    merge_file(folder + "_combined_capex.csv", "capex", capex_files, output_path, full_path)

    puts "Files are ready in #{output_path}"
  end
end

def combine_specific_files(full_path, filenames_array, output_path, period)
  puts
  p "full_path: #{full_path}"

  filenames = filenames_array

  # divide opex and capex files
  opex_files = get_opex_files(filenames)
  capex_files = get_capex_files(filenames)
  # display stats in console
  display_file_stats(filenames, full_path, opex_files, capex_files)

  puts
  p "opex_files: #{opex_files}"
  p "capex_files: #{capex_files}"
  merge_file(period + "z_FullMonth_combined_opex.csv", "opex", opex_files, output_path, full_path)
  merge_file(period + "z_FullMonth_combined_capex.csv", "capex", capex_files, output_path, full_path)

  puts "Files are ready in #{output_path}"

end