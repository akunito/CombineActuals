# remove files older than 120 days
# ForFiles /p "C:\Users\adm.dierueda\OneDrive - Schenker AG\Documents\_Daily_Actuals\" /s /d -120 /c “cmd /c del /q @file"
#
# # Import Actuals to current directory
# robocopy D:\data_exchange\actuals "C:\Users\adm.dierueda\OneDrive - Schenker AG\Documents\_Daily_Actuals" "combined_capex.csv"
# robocopy D:\data_exchange\actuals "C:\Users\adm.dierueda\OneDrive - Schenker AG\Documents\_Daily_Actuals" "combined_opex.csv"
#
# # rename files
# ren "C:\Users\adm.dierueda\OneDrive - Schenker AG\Documents\_Daily_Actuals\combined_capex.csv" %date:~10,4%%date:~7,2%%date:~4,2%combined_capex.csv
#
# ren "C:\Users\adm.dierueda\OneDrive - Schenker AG\Documents\_Daily_Actuals\combined_opex.csv" %date:~10,4%%date:~7,2%%date:~4,2%combined_opex.csv

# libraries
require 'date'
require 'fileutils'

# get time
def get_full_datetime
  d = DateTime.now
  d.strftime("%Y%m%d_%Hh%Mm")
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

# remove files older than 120 days

# Import Actuals to current directory
def copy_files(origin, destination, origen_filename, destination_filename)
  origin = origin + origen_filename
  destination = destination + "\\" + destination_filename
  puts "origin: #{origin}"
  puts "destination: #{destination}"
  FileUtils.cp(origin, destination)
  destination
end
# combine last files with month file


def main(environment)
  # Get userprofile path in Windows
  user_path = ENV["USERPROFILE"]

  # Get path variables
  daily_actuals = user_path + '\OneDrive - Schenker AG\Documents\_Daily_Actuals'
  environment == "PROD" ? actuals_dir = "D:\\data_exchange\\actuals\\" : actuals_dir = "C:\\data_exchange\\actuals\\"

  # Get last month combined opex and capex's filenames
  files = read_directory(daily_actuals)
  last_month_z_file_opex = get_last_month_z_file(files, "opex")
  last_month_z_file_capex = get_last_month_z_file(files, "capex")

  puts get_full_datetime
  # import new combined_files
  new_combined_opex_file = copy_files(actuals_dir, daily_actuals, "combined_opex.csv", get_full_datetime+"_combined_opex.csv")
  new_combined_capex_file = copy_files(actuals_dir, daily_actuals, "combined_capex.csv", get_full_datetime+"_combined_capex.csv")

  puts
  puts new_combined_opex_file
  puts new_combined_capex_file
end

main("TEST")
# main("PROD")