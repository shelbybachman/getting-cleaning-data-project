# Overview

This directory contains all files for the Getting & Cleaning Data Course Project.

# Description of files

The R script `run_analysis.R` performs the main analysis. This script performs the following steps to download, clean, and summarize data from accelerometers of Samsung Galaxy S smartphones:

- Downloads zipped data from the web
- Unzips data into `UCI HAR Dataset` directory
- Cleans and organizes subject info, activity labels, and variable values from the training and test sets separately
- Joins data from the training and test sets into a single dataframe
- Creates meaningful names for the variables and activities described in the composite dataframe
-

# Description of resulting datasets

The `run_analysis.R` script yields two dataframes of interest: `data` contains values of all variables for all subjects and activities, in tidy form. Note: in this "long" dataframe, a single `variable` column includes measurement name as a variable and the corresponding value in the `value` column. In a previous step, the script creates an equivalent "wide" dataframe where each measurement value is stored in its own column. Both forms of the dataframe are tidy. Variables in the "long" version of this dataframe `data` are described below:

- `subject`: number identifying subject
- `activity`: activity type
- `activityCode`: number reflecting activity type; see original included file `activity_labels.txt` for values
- `dataset`: was this subject in the test or training dataset?
- `variable`: measurement type (see `Description of measurements` below for full description), either mean or standard deviation
- `value`: value of measurement

The second dataframe of interest in `summary_data`, which contains the average value of each measurement for each subject and activity type. Variables in this dataframe are described below:

- `subject`: number identifying subject
- `activity`: activity type
- `variable`: measurement type (see `Description of measurements` below for full description), either mean or standard deviation
- `average`: average value of measurement

# Description of measurements

The values included in the dataframes described above include mean and standard deviation values of the following measurements.

Values below were captured in both the time and frequency domains. The `time_` prefix in a variable name reflects that is was derived in the time domain. The `freq_` prefix in a variable name reflects that it was derived in the frequency domain. Furthermore, `-XYZ` is used to denote 3-axial signals in the X, Y and Z directions.

The core measurements are described below:

- `BodyAcc`: raw bodily accelerometer signal
- `GravityAcc`: raw gravity acceleromater signal
- `BodyAccMag`: bodily linear acceleration signal
- `GravityAccMag`: gravity linear acceleration signal
- `BodyAccJerk`: bodily linear acceleration jerk signal
- `BodyAccJerkMag`: magnitude of bodily linear acceleration jerk signal
- `BodyGyro`: raw gyroscope signal
- `BodyGyroMag`: bodily angular velocity signal
- `BodyGyroJerk`: bodily angular velocity jerk signal
- `BodyGyroJerkMag`: magnitude of bodily angular velocity jerk signal

More information about specific filtering that was applied to these data can be found in the file `UCI HAR Dataset/features_info.txt`.

# Notes

- This script does not deal with any data contained in the `train` and `test` subdirectories, for the reason that these data have already been summarized for our purposes in the test and training set files contained within the `UCI HAR Dataset`
