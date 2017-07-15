# load packages
library(data.table)
library(dplyr)


# activity labels, subject labels, feature labels
labels <- fread("UCI HAR Dataset/activity_labels.txt") 
features <- fread("UCI HAR Dataset/features.txt") 

# adjust feature labels before attaching to data
features <- gsub("-","_",features$V2)
features <- gsub("\\,","_",features)
features <- gsub("\\()","",features)
features <- gsub("\\(","",features)
features <- gsub("\\)","",features)
features

# training data import and format
trainx <- fread("UCI HAR Dataset/train/X_train.txt")
names(trainx) <- features
subsetFeatures <- names(trainx)[grepl("mean",names(trainx)) | grepl("std",names(trainx))]
trainx <- trainx[,!subsetFeatures,with=F]

trainy <- fread("UCI HAR Dataset/train/y_train.txt")
names(trainy) <- "activity"

trainSubj <- fread("UCI HAR Dataset/train/subject_train.txt")
names(trainSubj) <- "subject"



# test data import and format
testx <- fread("UCI HAR Dataset/test/X_test.txt")
names(testx) <- features
subsetFeatures <- names(testx)[grepl("mean",names(testx)) | grepl("std",names(testx))]
testx <- testx[,!subsetFeatures,with=F]

testy <- fread("UCI HAR Dataset/test/y_test.txt")
names(testy) <- "activity"

testSubj <- fread("UCI HAR Dataset/test/subject_test.txt")
names(testSubj) <- "subject"


# merge datasets
trainAll <- dplyr::bind_cols(trainSubj,trainy,trainx)
testAll <- dplyr::bind_cols(testSubj,testy,testx)
allDat <- rbind(trainAll,testAll)

names(labels) <- c("activity","activityLabel")
