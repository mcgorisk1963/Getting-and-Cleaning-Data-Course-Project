# this is run_analysis.r,  the script file for the getting and cleaning data course project.
# merge the training and the test sets to create one data set.
# these are fixed width files.
# using read table


  

  

  
#install the reshape paclage as it is needed for step 5 
install.packages("reshape2")
library(reshape2)  
  
  
#Load the test data
filename <- "X_test.txt"
filesDirectory <- paste(getwd(),"test", sep="\\")
filenamepath <- paste(filesDirectory,filename, sep="\\")
test_data <- read.table(filenamepath, stringsAsFactors = FALSE)

#Load the features.txt file so that a header row can be made
filename <- "features.txt"
filenamepath <- paste(getwd(),filename, sep="\\")
test_header <- read.table(filenamepath, stringsAsFactors = FALSE)

#Load the activity file
filename <- "y_test.txt"
filesDirectory <- paste(getwd(),"test", sep="\\")
filenamepath <- paste(filesDirectory,filename, sep="\\")
test_activity <- read.table(filenamepath)

#load the subject file.
filename <- "subject_test.txt"
filesDirectory <- paste(getwd(),"test", sep="\\")
filenamepath <- paste(filesDirectory,filename, sep="\\")
test_subject <- read.table(filenamepath)







#bind the activity column do the test_data
#test_data <- cbind(t_data_sub,test_labels)
#give the column a name
#colnames(test_data)[563] = "Activity"

# Prepare the Training data set.
#DO the same as the test data set but Do not add a header column

#Load the training data
filename <- "X_train.txt"
filesDirectory <- paste(getwd(),"train", sep="\\")
filenamepath <- paste(filesDirectory,filename, sep="\\")
train_data <- read.table(filenamepath, stringsAsFactors = FALSE)

#Load the training activity file
filename <- "y_train.txt"
filesDirectory <- paste(getwd(),"train", sep="\\")
filenamepath <- paste(filesDirectory,filename, sep="\\")
train_activity <- read.table(filenamepath)

#load the training subject file.
filename <- "subject_train.txt"
filesDirectory <- paste(getwd(),"train", sep="\\")
filenamepath <- paste(filesDirectory,filename, sep="\\")
train_subject <- read.table(filenamepath)

#bind the subject column do the test_data
#train_data <- cbind(train_data,train_subject) 
#bind the activity column do the test_data
#train_data <- cbind(train_data,train_activity)


# finally, merge the two data sets test ( test on top of train as test has header)

complete_data <- rbind(test_data, train_data)
#complete_data has 10299 observations of complete data.




# our complete data set has 561 columns.
# Change the variable names  to the names in the featurest.txt file.
for(i in 1:561){
  
  colnames(complete_data)[i] = test_header[i,2]
  
}

# extract out the relevant data using grep
relevant_data <- complete_data[grep("mean|Mean|std|Std",names(complete_data))]
# by estracting above, I have 10299 observations of 86 variables

# row bind the test subject and train subject
complete_subject <- rbind(test_subject, train_subject)
#row bind the test activity and the train activity
complete_activity <- rbind(test_activity, train_activity)


relevant_data <- cbind(complete_activity, relevant_data)
#column bind complete subject to relevant data
relevant_data <- cbind(complete_subject, relevant_data )
#column bind complete activity to conplete data

#have 10299 observations of 88 variables

#change the names of the last two variables
colnames(relevant_data)[1] = "Subject"
colnames(relevant_data)[2] = "Activity"



#change the values of the Activity Variable as per the "activity_labels.txt" file

#(1) "walking", (2) "walking upstairs", (3) "walking downstairs", (4) "sitting", (5) "standing", and (6) "laying".

relevant_data$Activity[relevant_data$Activity==1] <- "walking"
relevant_data$Activity[relevant_data$Activity==2] <- "walking upstairs"
relevant_data$Activity[relevant_data$Activity==3] <- "walking downstairs"
relevant_data$Activity[relevant_data$Activity==4] <- "sitting"
relevant_data$Activity[relevant_data$Activity==5] <- "standing"
relevant_data$Activity[relevant_data$Activity==6] <- "laying"



#Meaningful Variable names.  Best thing to dois to do whats there but clean it up
print(colnames(relevant_data))
# part 4.  use the fixed=TRUE parameter.
names(relevant_data) <- gsub("()", "", names(relevant_data), fixed=TRUE )
names(relevant_data) <- gsub(",", "_", names(relevant_data), fixed=TRUE )
names(relevant_data) <- gsub("(", "_", names(relevant_data), fixed=TRUE )
names(relevant_data) <- gsub(")", "", names(relevant_data), fixed=TRUE )
print(colnames(relevant_data))

# Write the data frame to a csv.  "tidydata.csv"
write.table(relevant_data,"tidydata.txt", row.name=FALSE)

#class(colnames(grep_out))

#and onto step 5
# This is the same as a group by in sql

#using melt and dcast from the excellent reshape2 package, the last step is done.

relevant_data_melted <- melt(relevant_data, id.vars = c("Subject", "Activity"))  

#Then I used dcast as follows:   final.data.frame.hurray <- dcast(Molten, Subject + Activity ~ variable, fun = mean)


relevant_data_melted_casted <- dcast(relevant_data_melted, Subject + Activity ~ variable, fun = mean)

write.table(relevant_data_melted_casted,"mean_tidydata.txt", row.name=FALSE)

#and this gives 180 observations of 88 variables. ( 180 observations = 30 subjects, 6 activities)

