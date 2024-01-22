# NOTE: that some of the paths should be updated in case my user is removed.
# I tried to keep in this file contain all the paths
# If you are using your computer to test this program, the paths will be probably different, that's why
# to save time you only have to set the @environment = to TEST or PROD
# In case you need another environment, it can be added switching the IF to CASE in the functions.

# CHOOSE THE ENVIRONMENT
# USE HERE "TEST" for local computer or "PROD" for the server
@environment = "TEST"
def output_path
  @environment == "PROD" ? "d:/data_exchange/archive/combined_files/" : "C:/data_exchange/archive/combined_files/"
end
def base_path
  @environment == "PROD" ? "d:/data_exchange/archive/" : "C:/data_exchange/archive/"
end

# Get userprofile path in Windows example: "C:/users/MY_USER_NAME/"
def user_path
  user_path = ENV["USERPROFILE"]
  user_path = user_path.split('')
  user_path.map! { |c| (c == "\\") ? '/' : c }
  user_path.join
end

# Get the system variable created in Windows for my main onedrive folder
def get_onedrive_dr_env_var
  one_path = ENV["ONEDRIVE_DR"]
  one_path = one_path.split('')
  one_path.map! { |c| (c == "\\") ? '/' : c }
  one_path.join
end

# Get path variables
def _daily_actuals_dir
  @environment == "PROD" ? get_onedrive_dr_env_var + "/Documents/_Daily_Actuals/" : "C:/data_exchange/archive/_Daily_Actuals/"
end
def actuals_dir
  @environment == "PROD" ? "D:/data_exchange/actuals/" : "C:/data_exchange/actuals/"
end
