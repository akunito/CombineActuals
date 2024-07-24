require 'csv'
require 'fileutils'
require_relative './lib/library'
require_relative './lib/environment'

puts 'CSVMerger initialized.'

# Add to the array all the folders that must be combined
array = %w[
  20240721_02h00m
]
# 20240517
# 20240518
# 20240519
# 20240520
# 20240521
# 20240522
# 20240523
# 20240524
# 20240525
# 20240526
# 20240527
# 20240528
# 20240529
# ]


def main(array)
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
        clean(CSV_COMBINED_FILES)
      when 2
        clear_screen
        merge_sap(CSV_COMBINED_FILES, array, CSV_ARCHIVE)
      when 3
        clear_screen
        recombine(CSV_COMBINED_FILES, CSV_ARCHIVE)
      when 4
        clear_screen
        array = modify_array(CSV_COMBINED_FILES, array, CSV_ARCHIVE)
      when 5
        clear_screen
        # D:\data_exchange\archive\combined_files\20240723_02h00m_combined_opex.csv
        analyze_problematic_characters(CSV_COMBINED_FILES, "20240723_02h00m_combined_opex.csv")
      when 6
        clear_screen
        # compare two files and get characters that were not in the previous one
        # new file:   "20240722_02h00m_combined_opex.csv"
        # prev file:  "20240723_02h00m_combined_opex.csv"
        find_new_chars_missing_on_previous_file(CSV_COMBINED_FILES, "20240722_02h00m_combined_opex.csv", "20240723_02h00m_combined_opex.csv")
      when 7
        clear_screen
        # compare two folders and get new unique chars 
        # prev_path: D:\data_exchange\archive\20240722_02h00m
        # new_path: D:\data_exchange\archive\20240723_02h00m            # NOTE on WINDOWS Systems: you have to swith \ to / in the paths !!!!
        compare_files_between_two_folders_and_find_new_unique_chars("D:/data_exchange/archive/20240722_02h00m/", "D:/data_exchange/archive/20240723_02h00m/")
      else
        clear_screen
        puts "option not available"
        sleep 1
      end
    end
  end
end

clear_screen

main(array)
