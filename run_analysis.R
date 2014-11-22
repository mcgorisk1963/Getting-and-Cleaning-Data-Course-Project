# this is run_analysis.r,  the script file for the getting and cleaning data course project.
# merge the training and the test sets to create one data set.
# these are fixed width files.
# using read table

#1) Merge the data sets

  #Prepare data sets for merging.

  #Prepare the test set by 
  #loading the test data set from x_test.txt
  #loading the activity data set column by using y_test.txt
  #loading the subject data set by using column by using "subject_text.txt"
  #loading the variable names data set by using "features.txt"

  #transform the features.txt so that its 563 rows become the header of the test data set
  #then bolt on the activity column and the subject column , give the columns those names.
  #You now have 86 variables and your test data is ready for merging.
  
  #loading the test data set from x_test.txt
  #loading the activity data set column by using y_test.txt
  #loading the subject data set by using column by using "subject_text.txt"
  #loading the variable names data set by using "features.txt"
  #then bolt on the activity column and the subject column , give the columns those names.

  #merge the two data sets using rbind.  The test data is on top  as it has the header row.

  #Why do it like this?
  #2)
  #using grep extract out all the columns that have either mean, Mean, std or Std included in their data name
  #and take the activity column and subject column as well.

  #This gives a data set of 86 variables with xxxx observations.
  #3)
  #change the values in the activity columns to test_labels 
  ##  where 1 =  "walking"
  #  where 2 = "walking upstairs"
  #  where 3 = "walking downstairs"
  #  where 4 = "sitting"
  #  where 5 = "standing"
  ##  where 6 = "laying"
  #  as described in the activity_labels file.
  
  # Is there a file with the subject names anywhere?, we can just leave the subject column with
  # values 1 = 10.
 # 4)
 ## Next, You have now got 84 variable names that are required to turn into suitable variable names
#  To my mind the variable names are sufficiently descriptive if they could be tidied up
 # using sone string manipulation with gsub. I have removed the characters that do not normally appear
 # in variable names such as "(", ")" and replaced commas with underscoreds, and the variable name list
 # is below.  I think it is fine.  There is no need to change these any further.  As I dont know what they mean
 ## there is no guarantee that the nanes that I would give them would be any more meaningful
 # Below is a list of the variable names after above transformation.
 # 
 # 5) comes when 4 is finished.
  

  

  
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



#column bind complete subject to relevant data
relevant_data <- cbind(relevant_data, complete_subject)
#column bind complete activity to conplete data
relevant_data <- cbind(relevant_data, complete_activity)
#have 10299 observations of 88 variables

#change the names of the last two variables
colnames(relevant_data)[87] = "Subject"
colnames(relevant_data)[88] = "Activity"



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

# Write the data frame to a csv.  "Combined_data.csv"
write.csv(relevant_data,"Combined_data.csv")

#class(colnames(grep_out))

#and onto step 5
# This is the same as a group by in sql

#using melt and dcast from the excellent reshape2 package, the last step is done.

relevant_data_melted <- melt(relevant_data, id.vars = c("Subject", "Activity"))  

#Then I used dcast as follows:   final.data.frame.hurray <- dcast(Molten, Subject + Activity ~ variable, fun = mean)


relevant_data_melted_casted <- dcast(relevant_data_melted, Subject + Activity ~ variable, fun = mean)

write.csv(relevant_data_melted_casted,"summarized_data.csv")

#and this gives 180 observations of 88 variables. ( 180 observations = 30 subjects, 6 activities)

