require 'date'
require 'fileutils'
require_relative './lib/library'
require_relative './lib/environment'

# get time

def main
  # Get last month combined opex and capex filenames
  files = read_directory(CSV_DAILY_ACTUALS)
  last_month_z_file_opex = get_last_month_z_file(files, "opex")
  last_month_z_file_capex = get_last_month_z_file(files, "capex")

  puts get_full_datetime
  # import new combined_files
  new_combined_opex_file = copy_files(CSV_ACTUALS, CSV_DAILY_ACTUALS, "combined_opex.csv", get_full_datetime+"_combined_opex.csv")
  new_combined_capex_file = copy_files(CSV_ACTUALS, CSV_DAILY_ACTUALS, "combined_capex.csv", get_full_datetime+"_combined_capex.csv")

  # create array containing files to be merged
  filenames_array = []
  filenames_array.push(new_combined_capex_file.to_s,
                       new_combined_opex_file.to_s,
                       last_month_z_file_opex[0].to_s,
                       last_month_z_file_capex[0].to_s)

  # Result file name
  result_name = get_period + "z_FullMonth_combined"

  # combine last daily file with last month file
  puts "\nCSV_DAILY_ACTUALS #{CSV_DAILY_ACTUALS}"
  combine_specific_files(CSV_DAILY_ACTUALS, filenames_array, CSV_DAILY_ACTUALS, result_name )

  # remove yesterday files
  puts "removing files"
  remove_files(CSV_DAILY_ACTUALS, get_yesterday_csv_files(CSV_DAILY_ACTUALS))

  # remove files older than 125 days

end

main