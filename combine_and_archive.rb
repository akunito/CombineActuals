require 'date'
require 'fileutils'
require_relative './lib/library'
require_relative './lib/environment'


def main
    # Get today combined opex and capex filenames from the current folder
    files = read_directory(CSV_ACTUALS)
    opex_files = get_opex_files_by_extension(files, ".gz")
    capex_files = get_capex_files_by_extension(files, ".gz")
    capex_depr_files = get_capex_depr_files_by_extension(files, ".gz")
    # combined file names
    combined_opex_name = "combined_opex.csv"
    combined_capex_name = "combined_capex.csv"
    combined_capex_depr_name = "combined_capex_depr.csv"

    # list opex_files
    puts "\ncount opex files: #{opex_files.length}"
    opex_files.each { |file| puts file }
    # list capex_files
    puts "\ncount capex files: #{capex_files.length}"
    capex_files.each { |file| puts file }
    # list capex_depr_files
    puts "\ncount capex_depr files: #{capex_depr_files.length}"
    capex_depr_files.each { |file| puts file }

    # # delete previous combined files
    remove_specific_files(CSV_ACTUALS, combined_capex_name)
    remove_specific_files(CSV_ACTUALS, combined_opex_name)
    remove_specific_files(CSV_ACTUALS, combined_capex_depr_name)
    
    # # combine files
    merge_file(combined_opex_name, "opex", opex_files, CSV_ACTUALS, CSV_ACTUALS)
    merge_file(combined_capex_name, "capex", capex_files, CSV_ACTUALS, CSV_ACTUALS)
    merge_file(combined_capex_depr_name, "capex_depr", capex_depr_files, CSV_ACTUALS, CSV_ACTUALS)
  
    # get full datetime
    full_datetime = get_full_datetime
    # create a directory with full_datetime
    create_directory(CSV_ARCHIVE+full_datetime) if (opex_files.length + capex_files.length + capex_depr_files.length) > 0

    # move opex and capex .gz files to archive folder
    move_files(CSV_ACTUALS, (CSV_ARCHIVE+full_datetime), opex_files)
    move_files(CSV_ACTUALS, (CSV_ARCHIVE+full_datetime), capex_files)
    move_files(CSV_ACTUALS, (CSV_ARCHIVE+full_datetime), capex_depr_files)
  end
  
  main  