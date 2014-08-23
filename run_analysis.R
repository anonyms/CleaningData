## Loading necessary libraries
library(plyr)
library(reshape2)

## Extract data
test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_Y <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_Y <- read.table("./UCI HAR Dataset/train/y_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

##Only keep variables related to mean and std - excluding meanFreq()
names(test_X)[grep("*mean\\()|*std()",names(test_X))]

## Name variables
names(test_X) <- features[,2]
names(train_X) <- features[,2]
names(test_Y) <- "activity_id"
names(train_Y) <- "activity_id"
names(activity_labels) <- c("activity_id","activity_name")
names(test_subject) <- "subject_id"
names(train_subject) <- "subject_id"

## Only keep mean() and std()
test_X <- test_X[grep("*mean\\()|*std()",names(test_X))]
train_X <- train_X[grep("*mean\\()|*std()",names(train_X))]

## Create full sets
test_Y_2 <- merge(test_Y,activity_labels)
train_Y_2 <- merge(train_Y,activity_labels)

test_set <- cbind(test_subject,test_Y_2,test_X)
train_set <- cbind(train_subject,train_Y_2,train_X)

full_set <- rbind(test_set,train_set)

## Only keep activity name
full_set$activity_id <- NULL

## Summarize Data
melted_data <- melt(full_set,id=c("subject_id","activity_name"))
tidy_data <- dcast(melted_data, subject_id + activity_name ~ variable,mean)
names(tidy_data) <- paste("Avg",names(tidy_data),sep="_")
