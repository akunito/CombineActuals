def combine_files(full_path, output_path, folder)
  def merge_file(result_file, headers, file_list, output_path, full_path)
    result_full_path = output_path + result_file
    CSV.open(result_full_path, 'w') do |csv|
      csv << headers
      file_list.each do |filename|
        # CSV.open(filename, headers: true)
        CSV.foreach(full_path + filename, headers: true) {|row| csv << row.values_at(*headers) }
      end
    end
  end

  puts
  p "full_path: #{full_path}"
  # Get list of files
  begin
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

    # Divide list for Opex and Capex
    opex_files = filenames.select do |filename|
      filename.include?("CP") ||
        filename.include?("opex")
    end
    capex_files = filenames.select do |filename|
      filename.include?("AMP") ||
        filename.include?("capex")
    end

    # puts
    # p "filenames: #{filenames}"
    # puts
    # p "opex_files: #{opex_files}"
    # puts
    # p "capex_files: #{capex_files}"

    puts
    puts "combining folder #{folder}"

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
    merge_file(folder + "_opex_result.csv", opex_header, opex_files, output_path, full_path)
    merge_file(folder + "_capex_result.csv", capex_header, capex_files, output_path, full_path)

    puts "Files are ready in #{output_path}"
  end
end