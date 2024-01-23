# NOTE: Environment variables must be created in your system to be able to use the program

def clean_var_slashes(variable)
  variable = variable.split('')
  variable.map! { |c| (c == "\\") ? '/' : c }
  variable.join
end

CSV_COMBINED_FILES = clean_var_slashes(ENV["CSV_COMBINED_FILES"])

CSV_ARCHIVE = clean_var_slashes(ENV["CSV_ARCHIVE"])

USER_PATH = clean_var_slashes(ENV["USERPROFILE"])

CSV_ONEDRIVE = clean_var_slashes(ENV["ONEDRIVE_DR"])

CSV_DAILY_ACTUALS = clean_var_slashes(ENV["CSV_DAILY_ACTUALS"])

CSV_ACTUALS = clean_var_slashes(ENV["CSV_ACTUALS"])

# def output_path > CSV_COMBINED_FILES
# def base_path > CSV_ARCHIVE
# def user_path > USER_PATH
# def get_onedrive_dr_env_var > CSV_ONEDRIVE
# def _daily_actuals_dir > CSV_DAILY_ACTUALS

