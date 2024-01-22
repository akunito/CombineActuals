require 'csv'
require 'fileutils'
require_relative './lib/combine_CSV_files'
require_relative './lib/environment'

puts 'CSVReader initialized.'

# to run the script use:
# ruby D:\data_exchange\archive\menu.rb

# Add to the array all the folders that must be combined
array = %w[
20240101
20240102
20240103]
# 20240104
# 20240105
# 20240106
# 20240107
# 20240108
# 20240109
# 20240110
# 20240111
# 20240112
# 20240113
# 20240114
# 20240115
# 20240116
# 20240117
# 20240118
# 20240119
# 20240120
# 20240121
# 20240122
# 20240123
# 20240124
# 20240125
# 20240126
# 20240127
# 20240128
# 20240129
# 20240130
# 20240131
# ]




# Removing files on the output directory
def clean_output_directory(output_path)
  FileUtils.rm Dir.glob(output_path + '*')
end

def menu
  puts "\t-------------------------------------------------------------------"
  puts "\t-------------------------------------------------------------------"
  puts "\t[0] - EXIT --------------------------------------------------------"
  puts "\t[1] - CLEAN output folder -----------------------------------------"
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

def clean(output_path, array, base_path)
  puts "\n---------- [1] - Are you sure that you want to REMOVE all files inside the output directory ??"
  puts "---------- #{output_path}"
  puts "---------- "
  puts "---------- Please confirm with [y]"
  puts "---------- To cancel, press Enter"
  input = gets.chomp
  if input == "y"
    puts "cleaning output directory #{output_path}"
    clean_output_directory(output_path)
  else
    clear_screen
    puts "\n\tOutput directory was NOT cleaned this time\n\n"
  end
end

def merge_sap(output_path, array, base_path)
  puts "\n---------- [2] - The SAP folders mentioned in the array will be merge by each folder/date ??"
  puts "---------- "
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

      combine_files_by_folder(full_path, output_path, folder)
    end
  else
    clear_screen
    puts "\n\tSAP files were NOT merged this time\n\n"
  end
end

def recombine(output_path, array, base_path)
  puts "\n---------- [3] - Files into the output folder will be  RECOMBINED in a new file ??"
  puts "---------- "
  puts "---------- Please confirm with [y]"
  puts "---------- To cancel, press Enter"

  input = gets.chomp
  if input == "y"
    puts "recombining"
    combine_files_by_folder(base_path + 'combined_files/', output_path, 'combined_files')
  else
    clear_screen
    puts "\n\tFiles were NOT recombined this time\n\n"
  end
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
    puts "recombining"
    combine_files_by_folder(base_path + 'combined_files/', output_path, 'combined_files')
  else
    clear_screen
    puts "\n\tFiles were NOT recombined this time\n\n"
  end
  sleep 1
end

def main(output_path, array, base_path)
  input = 99
  while input != 0
    menu
    puts "\nPlease, choose an option >>"
    begin
      input = Kernel.gets.match(/\d+/)[0].to_i
    rescue
      puts "Erroneous input! Try again..."
      sleep 1
      menu
    else
      case input
      when 0
        exit!
      when 1
        clear_screen
        clean(output_path, array, base_path)
      when 2
        clear_screen
        merge_sap(output_path, array, base_path)
      when 3
        clear_screen
        recombine(output_path, array, base_path)
      when 4
        clear_screen
        modify_array(output_path, array, base_path)
      else
        clear_screen
        puts "option not available"
        sleep 1
      end
    end
  end
end

clear_screen

main(output_path, array, base_path)
