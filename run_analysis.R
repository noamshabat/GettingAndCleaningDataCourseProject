# Run Analysis
#
# Process description:
# 1. Merge the training and test data set
# 1.1 get the train data and add column names.
# 1.2. add subject train id's column
# 1.3. add activity type
# 1.4. extract only mean values
#
# 2 do the same (1,1 - 1.4) for test data set.
# 2.1 merge both data sets to a single large data set
#
# 3. from the dataset received in (1) - get only the mean and std measurements
# 
# 4. extract another dataset with averages per variable / activity / subject.

# simple helper function to aid with file read.
# all input files contain no header and have columns separated by spaces.
library(dplyr)
library(tidyr)

fread <- function(file) {
  read.table(file,sep="",header = FALSE)
}

# Global variables required in multiple functions
INPUT_PATH <- './data/UCI HAR Dataset'    # Location of the input files
DATA_TYPES <- c('train','test')           # Eligible data types

# Getting the activities map: index to activity name. 
ACTIVITIES <- fread(paste(INPUT_PATH,'/activity_labels.txt', sep=""))

# helper function to get data files.
# the input folder is organized properly by file name and type, so it's 
# easy to build a helper function to get them.
get_data_file <- function(type, name) {
  names <- c('subject','X','y')
  
  # verify input
  stopifnot(type %in% DATA_TYPES, name %in% names)
  
  filename = paste(INPUT_PATH,'/',type,'/',name,"_",type,'.txt', sep="")
  print(paste('Reading',filename))
  fread(filename)
}

# translates an activity index to activity name.
index_to_activity <- function(activity) {
  ACTIVITIES[activity,2]
}

# gets all data for a specific data type (test or train), and merges it
# into a single dataset.
merge_data_by_type <- function(type) {
  stopifnot(type %in% DATA_TYPES)
  
  # get the X data.
  df <- get_data_file(type,'X')
  
  # get the column names and assign to X
  feature_names <- fread(paste(INPUT_PATH,'/features.txt',sep=""))
  colnames(df) <- feature_names[,2]
  
  # get the subject identifier.
  subject_ids <- get_data_file(type, 'subject')
  df$subject_id <- subject_ids[,1]  # data frame of 1 col to vector.
  
  # get the activity types
  activity <- get_data_file(type, 'y')[,1]   # data frame of 1 col to vector.
  df$activity <- unlist(lapply(activity, index_to_activity))
  
  df
}

get_mean_and_std <- function(in_df) {
  in_df[,grep("(mean)|(std)|(activity)|(subject_id)",colnames(in_df))]
}

project_dataset_a <- function() {
  # get the test dataset
  test <- get_mean_and_std(merge_data_by_type('test'))
  # get the train data set
  train <- get_mean_and_std(merge_data_by_type('train'))
  
  # merge test and train to 1 big data set.
  dataset_a <- rbind(test,train)
  
  dataset_a
}

project_dataset_b <- function(in_df) {
  tbl_df(in_df) %>%
    group_by(subject_id, activity) %>%
    summarise_all(mean)
}

tidy <- project_dataset_b(project_dataset_a())

write.table(tidy,file='dataset_step_5.txt',row.name=FALSE)