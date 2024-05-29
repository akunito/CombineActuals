# NOTE: Environment variables must be created in your system to be able to use the program

def clean_var_slashes(variable)
  variable = variable.split('')
  variable.map! { |c| (c == "\\") ? '/' : c }
  variable.join
end

CSV_COMBINED_FILES = clean_var_slashes(ENV["CSV_COMBINED_FILES"])

CSV_ARCHIVE = clean_var_slashes(ENV["CSV_ARCHIVE"])

USER_PATH = clean_var_slashes(ENV["USERPROFILE"])

CSV_ONEDRIVE = clean_var_slashes(ENV["CSV_ONEDRIVE_DR"])

CSV_DAILY_ACTUALS = clean_var_slashes(ENV["CSV_DAILY_ACTUALS"])

CSV_ACTUALS = clean_var_slashes(ENV["CSV_ACTUALS"])

# CSV_SFTP_FILES = clean_var_slashes(ENV["CSV_SFTP_FILES"])


# p CSV_COMBINED_FILES
# p CSV_ARCHIVE
# p USER_PATH
# p CSV_ONEDRIVE
# p CSV_DAILY_ACTUALS
# p CSV_ACTUALS