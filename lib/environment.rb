# NOTE: Environment variables must be created in your system to be able to use the program
# DON'T OVERWRITE THIS FILE ON PROD, KEEP DIFFERENT A COPY EVERYWHERE !!

CSV_COMBINED_FILES = ENV["CSV_COMBINED_FILES"]

CSV_ARCHIVE = ENV["CSV_ARCHIVE"]

USER_PATH = ENV["USERPROFILE"]

CSV_ONEDRIVE = ENV["ONEDRIVE_DR"]

CSV_DAILY_ACTUALS = ENV["CSV_DAILY_ACTUALS"]

CSV_ACTUALS = ENV["CSV_ACTUALS"]

# def output_path > CSV_COMBINED_FILES
# def base_path > CSV_ARCHIVE
# def user_path > USER_PATH
# def get_onedrive_dr_env_var > CSV_ONEDRIVE
# def _daily_actuals_dir > CSV_DAILY_ACTUALS


# user_path = user_path.split('')
# user_path.map! { |c| (c == "\\") ? '/' : c }
# user_path.join

