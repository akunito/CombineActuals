require 'csv'
require 'fileutils'
require_relative './lib/library'
require_relative './lib/environment'

puts 'CSVMerger initialized.'

# Add to the array all the folders that must be combined
array = %w[
  20240524
  20240525
  20240526
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
