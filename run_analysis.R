# clear workspace
rm(list=ls())

# load packages
library(data.table)

# activity labels, subject labels, feature labels
labels <- fread("UCI HAR Dataset/activity_labels.txt") 
features <- fread("UCI HAR Dataset/features.txt") 

# import feature space
trainx <- fread("UCI HAR Dataset/train/X_train.txt")
testx <- fread("UCI HAR Dataset/test/X_test.txt")
X <- rbindlist(list(trainx,testx))

# attach feature names
names(X) <- features[,V2]


# subset mean and std variables in features
index <- grep("\\b-mean\\b|\\b-std()\\b",names(X))
X <- X[,..index]


# import response
trainy <- fread("UCI HAR Dataset/train/y_train.txt")
testy <- fread("UCI HAR Dataset/test/y_test.txt")
Y <- rbindlist(list(trainy,testy))

# join features and response
data0 <- data.table(X,Y)

# attach activity names
data1 <- data0[labels, on=.(V1)]
data2 <- data1[,V1:=NULL] # remove original response

# output tidy dataset
fwrite(data2,"tidyData.csv")

