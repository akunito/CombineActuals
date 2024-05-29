require 'date'
require 'fileutils'
require_relative './lib/library'
require_relative './lib/environment'


def main
    # Get today combined opex and capex filenames from the current folder
    files = read_directory(CSV_ACTUALS)
    opex_files = get_opex_files_by_extension(files, ".gz")
    capex_files = get_capex_files_by_extension(files, ".gz")
    # combined file names
    combined_capex_name = "combined_capex.csv"
    combined_opex_name = "combined_opex.csv"

    # list opex_files
    opex_files.each { |file| puts file }
    # list capex_files
    capex_files.each { |file| puts file }

    # # delete previous combined files
    remove_specific_files(CSV_ACTUALS, combined_capex_name)
    remove_specific_files(CSV_ACTUALS, combined_opex_name)
    
    # # combine files
    merge_file(combined_capex_name, "capex", capex_files, CSV_ACTUALS, CSV_ACTUALS)
    merge_file(combined_opex_name, "opex", opex_files, CSV_ACTUALS, CSV_ACTUALS)
  
    # get full datetime
    full_datetime = get_full_datetime
    # create a directory with full_datetime
    create_directory(CSV_ARCHIVE+full_datetime)

    # move opex and capex .gz files to archive folder
    move_files(CSV_ACTUALS, (CSV_ARCHIVE+full_datetime), opex_files)
    move_files(CSV_ACTUALS, (CSV_ARCHIVE+full_datetime), capex_files)

    # depr??

  end
  
  main  