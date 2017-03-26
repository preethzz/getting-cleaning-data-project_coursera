# Clean up workspace
rm(list=ls())

setwd('C:/Users/preethi1/Downloads/UCI HAR Dataset');

# Read in the data from files
features     = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/features.txt',header=FALSE); #imports features.txt
activityType = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt',header=FALSE); #imports y_train.txt

# Assigin column names to the data imported above
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

# cCreate the final training set by merging yTrain, subjectTrain, and xTrain
trainingData = cbind(yTrain,subjectTrain,xTrain);

# Read in the test data
#imports subject_test.txt
subjectTest = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt',header=FALSE); 
#imports x_test.txt
xTest       = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/test/x_test.txt',header=FALSE); 
#imports y_test.txt
yTest       = read.table('C:/Users/preethi1/Downloads/UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt',header=FALSE);


# Assign column names to the test data imported above
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";

# Create the final test set by merging the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest);


# Combine training and test data to create a final data set
finalData = rbind(trainingData,testData);

# Create a vector for the column names from the finalData, which will be used
# to select the desired mean() & stddev() columns
colNames  = colnames(finalData); 


# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

# Subset finalData table based on the logicalVector to keep only desired columns
finalData = finalData[logicalVector==TRUE];



# Merge the finalData set with the acitivityType table to include descriptive activity names
finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
colNames  = colnames(finalData); 



# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassigning the new descriptive column names to the finalData set
colnames(finalData) = colNames;



# Create a new table, finalDataNoActivityType without the activityType column
finalDataNoActivityType  = finalData[,names(finalData) != 'activityType'];

# Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);


# Export the tidyData set 
write.table(tidyData, 'C:/Users/preethi1/Downloads/UCI HAR Dataset/tidyData.txt',row.names=TRUE,sep='\t');
