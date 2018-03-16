# main script for getting & cleaning data course project
# last updated 03.15.2018

# this script downloads, cleans, and summarizes data
# collected from accelerometers of the Samsung Galaxy S smartphones

# the two final dataframes of interest are: data, summary_data
# `data` contains all data for all subjects, activities, and variables
# `summary_data` contains averaged variables across all subject and activities

# see the README in the project parent directory for a full description of all variables 
# in each resulting dataframe

######### initialization

rm(list = ls())
library(data.table)
library(rprojroot)
library(dplyr)
library(tidyr)
library(stringr)

# create function to get path to current directory
path <- function(x) find_root_file(x, criterion = has_file('getting-cleaning-data-project.Rproj'))
setwd(path(''))

######### get data

# download data
download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
              destfile = path('allData.zip'))

# unzip data
unzip(zipfile = path('allData.zip'))

# load feature labels (common to test and training sets)
feature_labels <- fread(path('UCI HAR Dataset/features.txt')) %>%
  select(number=V1, label=V2)

######### load training data

# navigate to training data directory
setwd(path('UCI HAR Dataset/train/'))

# load subject info, training set, training labels
trainSubj <- fread('subject_train.txt') # load subject info
trainX <- fread('X_train.txt') # load training set, each col is a feature
trainY <- fread('Y_train.txt') # load training labels

# create a column indicating that these datapoints were in the test set
dataset <- rep('train', nrow(trainSubj))

# organize subject info, training set, and labels into a single dataframe
trainingDataSet <- as.data.frame(cbind(subject = trainSubj, activityCode = trainY, dataset, trainX)) %>%
  select(subject = subject.V1, activityCode = activityCode.V1, dataset, V1:V561)

# add feature labels to dataframe 
# such that feature labels are column names
names(trainingDataSet)[4:ncol(trainingDataSet)] <- feature_labels$label

######### load test data

# navigate to test data directory
setwd(path('UCI HAR Dataset/test/'))

# load subject info, test set, and test labels
testSubj <- fread('subject_test.txt') # load subject info
testX <- fread('X_test.txt') # load test set, each col is a feature
testY <- fread('Y_test.txt') # load test labels

# create a column indicating that these datapoints were in the test set
dataset <- rep('test', nrow(testSubj))

# organize subject info, test set, and labels into a single dataframe
testDataSet <- as_tibble(cbind(subject = testSubj, activityCode = testY, dataset, testX)) %>%
  select(subject = subject.V1, activityCode = activityCode.V1, dataset, V1:V561)

# add feature labels to dataframe 
# such that feature labels are column names
names(testDataSet)[4:ncol(testDataSet)] <- feature_labels$label

######### merge training and test sets to create one dataset

# join dataframes into one by binding rows
data <- rbind(trainingDataSet, testDataSet)

######### extract only mean and sd for each measurement

# find variable names containing "mean" and "std"
dataColNames <- names(data)
pattern1 <- '*.-[m][e][a][n][:(:]' # pattern for names containing "mean"
pattern2 <- '*.-[s][t][d][:(:]' # pattern for names containing "std"
colsToKeep <- union(grep(pattern1, dataColNames), grep(pattern2, dataColNames)) # find indices of columns containing these strings
colsToKeep <- c(c(1:3), colsToKeep) # also keep the first three columns (which contain subject, label, and dataset info)
colsToKeep <- sort(colsToKeep) # sort so column numbers are ascending

# keep only columns with mean and sd values
data <- data[,colsToKeep]

######### use descriptive activity names to name the activities in the dataset

# read activity label descriptions from file included in dataset
activity_labels <- fread(path('UCI HAR Dataset/activity_labels.txt')) %>%
  select(activityCode=V1, activity=V2) %>%
  mutate(activity = tolower(activity))

# use these descriptions to match each activity label in the main dataframe
# with the appropriate activity descriptions
data <- left_join(data, activity_labels, by = 'activityCode')

######### appropriately label dataset with descriptive names

# tidy the variable names
dataColNames <- names(data)
dataColNames <- gsub('[:(:][:):]', '', dataColNames) # remove unnnecessary parentheses
dataColNames <- gsub('-', '_', dataColNames) # replace hyphens with underscores
dataColNames <- gsub('^[t]', 'time_', dataColNames) # expand t in t... variable names
dataColNames <- gsub('^[f]', 'freq_', dataColNames) # expand f in f... variable names
names(data) <- dataColNames

######### make this a "long" dataset for the purposes of summarizing by subject, variable, and activity
# (this makes the data tidy, but it should be noted that the previous "wide" version of the dataset was also tidy)
data <- data %>%
  select(subject, activity, activityCode, dataset, time_BodyAcc_mean_X : freq_BodyBodyGyroJerkMag_std) %>%
  gather(key = variable, value = value, time_BodyAcc_mean_X : freq_BodyBodyGyroJerkMag_std, -subject, -activityCode, -dataset)

######### create a second, independent dataset with average of each variable for each subject
summary_data <- data %>%
  group_by(subject, activity, variable) %>%
  summarise(average = mean(value))

# write this table to .txt file (for submission)
write.table(summary_data, file = path('tidy_data.txt'), row.names = FALSE)

