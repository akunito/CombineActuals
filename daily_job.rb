require 'date'
require 'fileutils'
require_relative './lib/combine_CSV_files'
require_relative './lib/environment'

# get time
def get_full_datetime
  d = DateTime.now
  d.strftime("%Y%m%d_%Hh%Mm")
end

def get_yesterday_csv_files
  d = Date.today.prev_day
  files = read_directory(_daily_actuals_dir)
  yesterday_files = d.strftime("%Y%m%d")
  files.select { |f| f.include?(yesterday_files)}
end

def get_period
  d = DateTime.now
  d.strftime("%Y%m")
end

# read directories
def read_directory(daily_actuals)
  # puts Dir.entries daily_actuals
  (Dir.entries(daily_actuals).select { |f| File.file? File.join(daily_actuals, f) }).to_ary
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


def main()
  # Get last month combined opex and capex's filenames
  files = read_directory(_daily_actuals_dir)
  last_month_z_file_opex = get_last_month_z_file(files, "opex")
  last_month_z_file_capex = get_last_month_z_file(files, "capex")

  puts get_full_datetime
  # import new combined_files
  new_combined_opex_file = copy_files(actuals_dir, _daily_actuals_dir, "combined_opex.csv", get_full_datetime+"_combined_opex.csv")
  new_combined_capex_file = copy_files(actuals_dir, _daily_actuals_dir, "combined_capex.csv", get_full_datetime+"_combined_capex.csv")

  # create array containing files to be merged
  filenames_array = []
  filenames_array.push(new_combined_capex_file.to_s,
                       new_combined_opex_file.to_s,
                       last_month_z_file_opex[0].to_s,
                       last_month_z_file_capex[0].to_s)

  # Result file name
  result_name = period + "z_FullMonth_combined"

  # combine last daily file with last month file
  puts "\n_daily_actuals_dir #{_daily_actuals_dir}"
  combine_specific_files(_daily_actuals_dir, filenames_array, _daily_actuals_dir, get_period )

  # remove yesterday files
  remove_files(_daily_actuals_dir, get_yesterday_csv_files)

  # remove files older than 125 days

end

main