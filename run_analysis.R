#---
#title: "Getting and Cleaning Data Project"
#author: "Kaushik Pushpavanam"
#date: "October 23, 2015"
#---
#Let's first install required packages
list.of.packages <- c("Hmisc", "plyr", "reshape2", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {
  install.packages(new.packages)
  library(new.packages)
}
#
#We are dealing with data from "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
#Abstract: Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
#We will use the abbreviation HARUS to stand for "Human Activity Recognition Using Smartphones"
#
#First, let's download the HARUS dataset zip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "./data/HARUS.zip"

setwd("C:/Users/iyer/Desktop/Learning/notes")
if (!file.exists("./data")) {
	dir.create("./data")
}
if (!file.exists(zipFile)) {
	download.file(url,destfile=zipFile)
}
#
#Now, let's unpack the files
zipFile <- "./data/HARUS.zip"
extractDir = "./HARUS"
if (!file.exists("./HARUS")) {
  unzip(zipFile, extractDir)
}
#This resulted in following files
#
#| Files extracted | Used or not used in this exercise |
#|-----------------|-----------------------------------|
#| ./data/HARUS/UCI HAR Dataset/activity_labels.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/features.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/features_info.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/README.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/test/subject_test.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/test/X_test.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/test/y_test.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/subject_train.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/train/X_train.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/train/y_train.txt | Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt | Not Used |
#| ./data/HARUS/UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt | Not Used |
#
#
#Let's load in the activities from /UCI HAR Dataset/activity_labels.txt
file <- "./data/HARUS/UCI HAR Dataset/activity_labels.txt"
activities <- read.table(file, 
                         sep=" ", 
                         col.names = c("ActivityID","ActivityName"), 
                         colClasses = c("numeric", "character"),
                         stringsAsFactors = FALSE)
summary(activities)
activities
#We noticed that there are no NA's - so no cleaning required.
#
#Next, let's read in the feature list from /UCI HAR Dataset/features.txt
file <- "./data/HARUS/UCI HAR Dataset/features.txt"
features <- read.table(file, 
                       sep=" ", 
                       col.names = c("FeatureID","FeatureName"), 
                       colClasses = c("numeric", "character"),
                       stringsAsFactors = FALSE)
summary(features)
head(features, n=3)
#We noticed that there are no NA's - so no cleaning required.
#
#Let's attach a FeatureType column to this list of features, we can use that when reading in test and training data
features$FeatureType = rep("numeric", length(features$FeatureID))
summary(features)
head(features, n=3)
#When we read the test and training data sets, these feature names will serve as column labels.
#
#Let's read in the test data set from /UCI HAR Dataset/test/X_test.txt
file <- "./data/HARUS/UCI HAR Dataset/test/X_test.txt"
testData <- read.table(file, 
                       #sep=" ", #I have no idea why putting this in would make it not work
                       header=FALSE,
                       col.names = features$FeatureName, 
                       colClasses = features$FeatureType,
                       stringsAsFactors = FALSE)
head(str(testData))
#
#Let's read in test Subjects and test labels and add them as columns into testData. We should also tag this as testData.
file <- "./data/HARUS/UCI HAR Dataset/test/subject_test.txt"
testSubjects <- read.table(file, 
                       #sep=" ", #I have no idea why putting this in would make it not work
                       header=FALSE,
                       col.names = c("Subjects"), 
                       colClasses = c("numeric"),
                       stringsAsFactors = FALSE)
summary(testSubjects)

file <- "./data/HARUS/UCI HAR Dataset/test/y_test.txt"
testLabels <- read.table(file, 
                       #sep=" ", #I have no idea why putting this in would make it not work
                       header=FALSE,
                       col.names = c("Labels"), 
                       colClasses = c("numeric"),
                       stringsAsFactors = FALSE)
summary(testLabels)

if (! (length(testLabels[,1]) == length(testSubjects[,1])) & (length(testData[,1]) == length(testSubjects[,1])) ) {
  print("Oops! Cannot do column bind since number of rows in test files do not match")
}
testLabels$TagName = rep("test", length(testLabels[,1])) #add a test tag - just in case we need to pull this data out later
testData <- cbind(testData,testSubjects,testLabels)
dim(testData)
#
#
#
#Let's read in the train data set from /UCI HAR Dataset/train/X_train.txt
file <- "./data/HARUS/UCI HAR Dataset/train/X_train.txt"
trainingData <- read.table(file, 
                        #sep=" ", #I have no idea why putting this in would make it not work
                        header=FALSE,
                        col.names = features$FeatureName, 
                        colClasses = features$FeatureType,
                        stringsAsFactors = FALSE)
head(str(trainingData))
#
#Let's read in training Subjects and training labels and add them as columns into trainingData
file <- "./data/HARUS/UCI HAR Dataset/train/subject_train.txt"
trainingSubjects <- read.table(file, 
                       #sep=" ", #I have no idea why putting this in would make it not work
                       header=FALSE,
                       col.names = c("Subjects"), 
                       colClasses = c("numeric"),
                       stringsAsFactors = FALSE)
summary(trainingSubjects)

file <- "./data/HARUS/UCI HAR Dataset/train/y_train.txt"
trainingLabels <- read.table(file, 
                       #sep=" ", #I have no idea why putting this in would make it not work
                       header=FALSE,
                       col.names = c("Labels"), 
                       colClasses = c("numeric"),
                       stringsAsFactors = FALSE)
summary(trainingLabels)

if (! (length(trainingLabels[,1]) == length(trainingSubjects[,1])) & (length(trainingData[,1]) == length(trainingSubjects[,1])) ) {
  print("Oops! Cannot do column bind since number of rows in train files do not match")
}
trainingLabels$TagName = rep("training", length(trainingLabels[,1])) #add a training tag - just in case we need to pull this data out later
trainingData <- cbind(trainingData,trainingSubjects,trainingLabels)
dim(trainingData)
#
###Step 1: Merges the training and the test sets to create one data set.
#
#We now have read all the data into 2 large data frames
#
#1. testData
#2. trainingData
#
#Let's merge these into a singleDataSet called completeData
#
if(length(testData) !=  length(trainingData)) {
  print ("Oops! Test and Training data have different number of columns!")
}
completeData <- rbind(testData, trainingData)
dim(testData)
dim(trainingData)
dim(completeData)
#
###Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#
#Now, let's remove the columns we don't need from the completeData dataset. We want to keep all columns containing the word mean and those that contain std. We also want to keep subject and labels. We will ignore the derived columns - the ones with Fast Fourier Transforms and the ones with angle. These can be derived again from our dataset if required.
#
columnsToExtract <- grepl("tBody.*mean|tGravity.*mean|tBody.*std|tGravity.*std|Subjects|Labels",colnames(completeData))
summary(columnsToExtract)
colnames(completeData)[columnsToExtract]
completeData <- completeData[,columnsToExtract]
dim(completeData)
#
#We now have about 10,000 rows and 42 columns, 
#
###Step 3: Uses descriptive activity names to name the activities in the data set
###Step 4: Appropriately labels the data set with descriptive variable names. 
#
#Let's rename the column Labels to ActivityName and let's change the value in the column from numerics to descriptive activity names (Words)
#
#
completeData <- dplyr:::rename(completeData, ActivityName=Labels)
completeData$ActivityName <- as.factor(completeData$ActivityName)

NamedCharVector <- setNames(as.character(activities$ActivityName), activities$ActivityID)

completeData$ActivityName <- plyr:::revalue(completeData$ActivityName, NamedCharVector)
completeData$ActivityName <- as.factor(completeData$ActivityName)
summary(completeData$ActivityName)
#
#We now have our complete data set and a code-book (via Rmd) to describe all transformations and assumptions we have made so far.
#
### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
require(dplyr)
completeData$Subjects <- as.factor(completeData$Subjects)
str(completeData$Subjects)
fitnessSummary <- completeData %>% group_by(Subjects,ActivityName) %>% summarise_each(funs(mean))
str(fitnessSummary)
dim(fitnessSummary)

#
#Now, let's write the table to a file called fitnessSummary.csv
#
write.table(fitnessSummary, file="./data/HARUS/fitnessSummary.txt", row.names = FALSE)
