require 'csv'
require 'fileutils'
require_relative './lib/library'
require_relative './lib/environment'

puts 'CSVMerger initialized.'

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
