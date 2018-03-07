# this script organizes and analyzes a training and test set
# of data collected from the accelerometers from the Samsung Galaxy S smartphone
# created by shelby, 03.06.2018

# initialization
rm(list = ls())
library(data.table)
library(rprojroot)
library(dplyr)

# create function to get path to current directory
path <- function(x) find_root_file(x, criterion = has_file('getting-cleaning-data-project.Rproj'))
setwd(path(''))

# load data - training set
trainingDataSubject <- fread(path('train/subject_train.txt'))
trainingDataX <- fread(path('train/X_train.txt'))
trainingDataY <- fread(path('train/Y_train.txt'))
trainingData <- fread(path('train/Inertial Signals/*'))

trainingData <- tbl_df(NULL)
for (q in 1:length(list.files(path('train/Inertial Signals/')))) {
  fileName <- list.files(path('train/Inertial Signals/'))[q]
  trainingData[,q] <- fread()
}

# load data - test set

# merge training and test set to create one dataset

# 