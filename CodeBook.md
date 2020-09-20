---
title: "CodeBook"
author: "Noam Shabat"
date: "9/19/2020"
output:
  pdf_document: default
  html_document: default
---

# Getting And Cleaning Data Course Project
This files contains the code book of the getting and cleaning data course project.
The data included is a description of the process requires to transform the input data into the output dataset, and a description of the variables in the output dataset.

## Analysis process.
### The input
Before i can describe the analysis process, I have to describe the structure of the input.
The input data is divided into 2 similar folders containing similar files (with different data) from a structure perspective.
The folders are the 'train' folder and the 'test' folder. Each of these contains 3 relevant files - 'X', 'y', and 'subjects'.
* The 'subjects' file contains identifiers of subjects included in the data set.
* The 'X' file contains a lot of measurements data - the input from wearable devices.
* the 'y' file - the labels (activity types).
Similar line numbers in all 3 files are related. so the first line in the 'X' file contains measurements done by the subject described in the first line of the 'subjects' file while doing an activity described in the first line of the 'y' file.

### First dataset
In order to create a tidy dataset, we need to merge all this data to a single dataset (it has a 1-1 relationship, just requires ordering). Also, as the task describes - we want to merge the test and train data (ignoring the origin - i.e. we don't care if a specific record comes from the test or train data)

So - the analysis process is as follows:
1. Get the 'X' test data into a dataframe.
2. get the 'y' test data into a vector and merge it with the 'X' test data frame matching the lines.
3. get the 'subjects' test data into a vector and merge it with the 'X' test data frame mathing the lines.
4. Get the 'X' train data into a dataframe.
5. get the 'y' train data into a vector and merge it with the 'X' train data frame matching the lines.
6. get the 'subjects' train data into a vector and merge it with the 'X' train data frame mathing the lines.
7. merge both data frames (from point 3 and from point 6) into one big data frame.

The above gives us the first dataset required by the project as defined in the project description.
This can be automatically performed using the function `project_dataset_a()` from the file `run_analysis.R`.

Here's a description of the columns:
* Most columns are directly derived from the input dataset and a description of them can be found in `./data/UCI HAR Dataset/features_info.txt`
* **subject_id** - Contains the id of the subject who performed the activity, and whose measurements are described in the current record. This is a numeric identifier (integer)
* **activity** - Character column. the name of the activity performed when taking the measurements described in this record. Available options: ['WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING','STANDING','LAYING']

---------------------------------------------
### Second dataset
The next step was to create the second dataset described in the project - based on the first dataset.
The process here is as follows:
1. Create a tibble of the first dataset using the `tbl_df` function of the `dplyr` package.in order to allow grouping.
2. use the `group_by` function so that we can perform aggregations by group - as defined by the project requirements. Group by subject_id, activity, variable.
3. run the 'mean' function on the grouped table and return the result - this is the output dataset as required.

Here's a description of the output dataset columns:
1. **subject_id** - int - an identifier representing the subject this record relates to.
2. **activitiy** - character - one of the activity types. the measurement in this record relate to this activity.
**rest** - the rest of the columns are based on the columns defined by `./data/UCI HAR Dataset/features_info.txt`. However, there is only one entry per subject and activity. The value is the mean of all records for the same subject_id and activity. 

