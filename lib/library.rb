require 'csv'
require 'fileutils'

# Removing files on the output directory
def clean_output_directory(directory)
  p directory + '/*.csv'
  FileUtils.rm Dir.glob(directory + '/*.csv')
end

def remove_specific_files(directory, filename)
  # if file exists
  if File.exist?(directory + filename)
    puts 'Removing file: ' + directory + filename
    FileUtils.rm Dir.glob(directory + filename)
  else
    puts 'File does not exist'
  end
end

def menu
  puts "\t-------------------------------------------------------------------"
  puts "\t-------------------------------------------------------------------"
  puts "\t[0] - EXIT --------------------------------------------------------"
  puts "\t[1] - REMOVE Flat Files on 'combined_files' directory--------------"
  puts "\t[2] - MERGE SAP files that are included in the ARRAY --------------"
  puts "\t[3] - RECOMBINE output files from step 2 in only 1 file -----------"
  puts "\t[4] - Modify ARRAY (work in progress) -----------------------------"
  puts "\t-------------------------------------------------------------------"
  puts "\t-------------------------------------------------------------------\n"
end

def clear_screen
  puts "Going to clear the screen"
  if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
    system('cls')
  else
    system('clear')
  end
end

def clean(directory)
  puts "\n---------- [1] - Are you sure that you want to REMOVE all CSV and GZ files inside the output directory ??"
  puts
  puts "---------- Following files will be DELETED: "
  files = get_all_csv_files(directory)
  files.each { |file| puts "---------- -> #{directory + file}" }
  puts "---------- "
  puts "---------- Please confirm with [y]"
  puts "---------- To cancel, press Enter"
  input = gets.chomp
  if input == "y"
    puts "cleaning output directory #{directory}"
    remove_files(directory, get_all_csv_files(directory))
  else
    clear_screen
    puts "\n\tOutput directory was NOT cleaned this time\n\n"
  end
end

def merge_sap(output_path, array, base_path)
  puts "\n---------- [2] - The SAP folders mentioned in the array will be merged by each folder/date ??"
  puts "\n---------- The array contains the next folders"
  array.each { |folder| puts "         -> #{folder}" }
  puts
  puts "---------- Please confirm with [y]"
  puts "---------- To cancel, press Enter"
  input = gets.chomp
  if input == "y"
    # go through the array and combine all the files found into the folders
    array.each do |element|
      # FOLDER'S NAME TO BE PROCESSED as for example "20230613"
      folder = element

      # path (it must exists)
      full_path = base_path + folder + "/"

      combine_files_by_folder(full_path, output_path, folder, '_combined')
    end
  else
    clear_screen
    puts "\n\tSAP files were NOT merged this time\n\n"
  end
end

def recombine(output_path, base_path)
  puts "\n---------- [3] - Files into the output folder will be RECOMBINED in a new file ??"
  puts
  puts "---------- Following files will be recombined: "
  files = get_all_csv_files(output_path)
  files.each { |file| puts "---------- -> #{output_path + file}" }
  puts
  puts "---------- Please confirm with [y]"
  puts "---------- To cancel, press Enter"

  input = gets.chomp
  if input == "y"
    puts "\n---------- Prefix for new files is -> #{files[0][..5]}"
    puts "\n---------- Press [ENTER] to continue "
    puts "\n---------- Or type a New Prefix  "
    prefix = gets.chomp
    if prefix == ''
      prefix = files[0][..5]
    end
    combine_files_by_folder(base_path + 'combined_files/', output_path, prefix, 'z_FullMonth_combined')

    puts "\n---------- Would you like to remove the files that have been USED to create the NEW ones ??"
    files.each { |file| puts "---------- -> #{output_path + file}" }
    puts
    puts "---------- Please confirm with [y]"
    puts "---------- To cancel, press Enter"

    # ask user if remove used files or not
    input = gets.chomp
    if input == "y"
      remove_files(output_path, files)
    else
      clear_screen
    end
    puts "\nNow the directory contains the next files: "
    get_all_csv_files(output_path).each { |file| puts "---------- -> #{output_path + file}" }
    sleep 1
  else
    clear_screen
    puts "\n\tFiles were were NOT recombined this time\n\n"
  end
end

def get_first_input_for_array
  puts "\n Enter the first Folder for example --> 20240101"
  gets.chomp
  end
def get_last_input_for_array
  puts "\n Enter the last Folder for example --> 20240130"
  gets.chomp
end
def modify_array(output_path, array, base_path)
  puts "\n\tThis function will update the array of folders"
  puts "\tYou have to choose from which one to which one"
  puts "\tFor example if you choose: "
  puts "\t\tFROM -> Year: 2024 Month: 01 Day 01"
  puts "\t\tTO   ->                      Day 30"
  puts "\n\t"
  sleep 1
  puts "\tArray will contain the dates/folders like follow:"
  puts "\t\t 20240101, 20240102, 20240103 ....... 20240130"
  puts "\n\tIf a folder does not exist, it will be skipped"
  sleep 1
  puts "\n---------- "
  puts "---------- Please confirm with [y]"
  puts "---------- To cancel, press Enter"

  input = gets.chomp
  if input == "y"
    first_input = get_first_input_for_array
    last_input = get_last_input_for_array
    begin
      array = first_input..last_input
    rescue
      puts "ERROR"
    else
      puts "\nThe new array is: "
      array.each { |element| puts element }
      array
    end
  else
    clear_screen
    puts "\n\tThe Array was NOT modified\n\n"
    sleep 1
  end
end
def get_full_datetime
  d = DateTime.now
  d.strftime("%Y%m%d_%Hh%Mm")
end

# create a directory with the given name
def create_directory(directory)
  Dir.mkdir(directory) unless Dir.exist?(directory)
end

def read_directory(directory)
  (Dir.entries(directory).select { |f| File.file? File.join(directory, f) }).to_ary
end

def get_all_csv_files(directory)
  files = read_directory(directory)
  files.select { |f| f.include?('.csv') ||
                           f.include?('.gz')}
end

def get_yesterday_csv_files(directory)
  d = Date.today.prev_day
  files = read_directory(directory)
  yesterday_files = d.strftime("%Y%m%d")
  files.select { |f| f.include?(yesterday_files)}
end

def get_period
  d = DateTime.now
  d.strftime("%Y%m")
end

def get_last_month_z_file(files, opt)
  # 'files' must be an array including filenames
  # 'opt' argument must includes an string to be found in the filename, ex: "opex" or "capex"
  looking = get_period + 'z'
  # puts "\n---looking for: #{looking}"
  files_period = files.select { |f| f.include?(looking)}
  files_period.select { |f| f.include?(opt)}
end

def remove_files(directory, files)
  files.each { |file| puts "Removing --> #{directory + file}" }
  # puts "\n\nRemoving files --> #{files} "
  # puts "In the following directory --> #{directory} \n\n"
  files.each { |file| FileUtils.rm Dir.glob(directory + file) }
end

def copy_files(origin, destination, origen_filename, destination_filename)
  origin = origin + origen_filename
  destination = destination + "/" + destination_filename
  puts "origin: #{origin}"
  puts "destination: #{destination}"
  FileUtils.cp(origin, destination)
  destination_filename
end

# move given files from one directory to another
def move_files(origin, destination, files)
  files.each do |file|
    puts "Moving --> #{origin + file} to --> #{destination + file}"
    FileUtils.mv(origin + file, destination)
  end
end

def merge_file(result_file, headers, file_list, output_path, full_path)
  unless file_list.empty?
    # headers must be a string "opex" or "capex"
    # assigning right headers:
    if headers == "opex"
      headers = %w{SYSID	MANDT	KOKRS	REFBK	K_GJAHR	PERIO	ZZLEISTPER	KOSTL	OBJNR_N1	REFBN	BELNR	BUZEI	BLART	BLTXT_F	SGTXT_F	BLDAT_F	BUDAT_F	KSTAR	KSTAR_KTXT	GKONT	GKOAR	GKONT_KTXT	WOGBTR_F	OWAER	WTGBTR_F	TWAER	WKGBTR_F	KWAER	MBGBTR_F	VBUND	ZZZUKO1	REFBN_ZUONR_F	STOKZ	STFLG	AWORG_REV	AWREF_REV	XBLNR_F}
    elsif headers == "capex"
      headers = %w{SYSID	MANDT	KOKRS	BUKRS	ANLN1	ANLN2	KOSTL	ANLKL	GJAHR	MONAT	BELNR	BUDAT_F	BWASL	ANBTR_F	WAERS	SGTXT_F	BZDAT_F	MENGE_F	MEINS	ORIGIN_F	XBLNR_F	CAUFN	ANLHTXT_F}
    elsif headers == "capex_depr"
      headers = %w{SYSID MANDT KOKRS BUKRS ANLN0 AKTIV_F ANLHTXT_F ANSW_GJE_F AFA_GJE_F BCHWRT_GJE_F WAERS ANLKL TXK50_F CAUFN KOSTL LIEFE_F ZUJHR URJHR NDJAR NDPER BERDATUM_F}
    end
    result_full_path = output_path + result_file
    # # debugging
    # puts "\n///////// debugging merge_file"
    # p "result_full_path: #{result_full_path}"
    # p "headers: #{headers}"
    # p "file_list: #{file_list}"
    # p "output_path: #{output_path}"
    # p "full_path: #{full_path}"
    # p full_path + file_list[0]
    # p full_path + file_list[1]
    CSV.open(result_full_path, 'w') do |csv|
      csv << headers
      file_list.each do |filename|
        # CSV.open(filename, headers: true)
        CSV.foreach(full_path + filename, headers: true) {|row| csv << row.values_at(*headers) }
      end
    end
  end
end

def filter_by_extension(filenames, extension)
  filenames.select! { |filename| filename.match?(extension) }
  filenames
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
  # check filenames array and select only the ones that match the opex or the opex pattern
  puts "note that this does not filter by extension !!"
  p filenames
  # select only if matches the pattern
  filenames.select do |filename|
    filename.match?(pattern) ||
      filename.include?("opex")
  end
end

# get opex files filtered by extension
def get_opex_files_by_extension(filenames, extension)
  # check filenames array and select only the ones that contains opex or the opex pattern
  # matching the given extension
  pattern = /CP.*B1F/
  # remove all files that are not matching the extension
  filenames.select! { |filename| filename.match?(extension) }
  # select only if matches the pattern
  filenames.select do |filename|
    filename.match?(pattern) ||
      filename.include?("opex")
  end
end

# get capex files filtered by extension
def get_capex_files_by_extension(filenames, extension)
  # check filenames array and select only the ones that contains capex or AMP in the name
  # remove all files that are not matching the extension
  filenames.select! { |filename| filename.match?(extension) }
  filenames.select do |filename|
    filename.include?("AMPB1F") ||
      filename.include?("capex")
  end
end

def get_capex_files(filenames)
  # check filenames array and select only the ones that contains capex or AMP in the name
  puts "note that this does not filter by extension !!"
  p filenames
  filenames.select do |filename|
    filename.include?("AMPB1F") ||
      filename.include?("capex")
  end
end

# get capex files filtered by extension
def get_capex_depr_files_by_extension(filenames, extension)
  # check filenames array and select only the ones that contains capex or AMP in the name
  # remove all files that are not matching the extension
  filenames.select! { |filename| filename.match?(extension) }
  filenames.select do |filename|
    filename.include?("AMIB1F") ||
      filename.include?("capex_depr")
  end
end

def get_capex_depr_files(filenames)
  # check filenames array and select only the ones that contains capex or AMP in the name
  puts "note that this does not filter by extension !!"
  p filenames
  filenames.select do |filename|
    filename.include?("AMIB1F") ||
      filename.include?("capex_depr")
  end
end

def combine_files_by_folder(full_path, output_path, folder, result_file)
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
    merge_file(folder + result_file + "_opex.csv", "opex", opex_files, output_path, full_path)
    merge_file(folder + result_file + "_capex.csv", "capex", capex_files, output_path, full_path)

    puts "Files are ready in #{output_path}"
  end
end

def combine_specific_files(full_path, filenames_array, output_path, result_file)
  filenames = filenames_array
  # divide opex and capex files
  opex_files = get_opex_files(filenames)
  capex_files = get_capex_files(filenames)
  # display stats in console
  display_file_stats(filenames, full_path, opex_files, capex_files)

  # # debugging
  # puts "\n///////// debugging combine_specific_files"
  # p "result_file: #{result_file}"
  # p "opex_files: #{opex_files}"
  # p "capex_files: #{capex_files}"
  # p "output_path: #{output_path}"
  # p "full_path: #{full_path}"
  merge_file(result_file + "_opex.csv", "opex", opex_files, output_path, full_path)
  merge_file(result_file + "_capex.csv", "capex", capex_files, output_path, full_path)
  puts "Files are ready in #{output_path}"
end

def clean_sap_files
  # Get a list of all .gz files in the folder
  puts "=============== Cleaning SAP files: Reading sftp on:  #{CSV_SFTP_FILES}"
  sap_files = read_directory(CSV_SFTP_FILES)
  sap_files = filter_by_extension(sap_files, ".gz")

  unless sap_files.empty?
    # Process each .csv file in the folder
    puts "\n============ Cleaning: Starting cleaning loop ========================"
    sap_files.each do |fileName|
      file_path = CSV_SFTP_FILES + fileName
      # Read the content of the .csv file
      csv_data = CSV.read(file_path, quote_char: "\x00") # Use a custom quote character (null byte)

      # Remove double quotes and exclamation marks from each cell
      modified_data = csv_data.map do |row|
        row.map do |cell|
          next cell if cell.nil? # Skip empty cells
          cell.gsub(/["!]/, '')
        end
      end

      # Write the modified data back to the .csv file
      CSV.open(file_path, 'w', quote_char: "\x00") do |csv| # Use the same custom quote character
        modified_data.each { |row| csv << row }
      end
    end
    puts "Double quotes and exclamation marks removed from all .gz files in #{CSV_SFTP_FILES}."
  else
    puts "========= Cleaning: No .gz files to clean found in #{CSV_SFTP_FILES}."
  end
end
