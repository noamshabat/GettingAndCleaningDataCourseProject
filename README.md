# GettingAndCleaningDataCourseProject
The course project for Coursera's getting and cleaning data course

## Files and folders:

* **./data/UCI HAR Dataset** - the input data set extracted from the zip file in the original task description. for further information on the files and organization of this folder, see the internal files ./data/UCI HAR Dataset/README.txt

* **CodeBook.md** - a code book that contains the following:
  + An explanation on the process performed for analyzing the "UCI HAR Dataset" and reaching the output datasets
  + A description of the output from this process - the 2 datasets required by the project.

* **README.md** - this file. contains general information about the project structure - files and folders included.

* **run_analysis.R** - The script containing all the code required to analyze the input data set and transform the data in it to the output datasets. Generally, the functions in the script are organized in a bottom up order. I.e. the most basic utility functions are top-most in the file, and as we scroll down each function can use the functions that were defined above it, but doesn't know the functions below it. Here's a description of the function - top to bottom:
  + `fread <- function(file)` - receives as input a string representing a file name, and returns a data frame with the contents of the file. The function assumes the data in the file is 1 record per row, and columns are separated by white space (1 or more). No headers. This approach fits all the files in the input folder.
  + `get_data_file <- function(type, name)` - retrieves data from a file in the input folder. the 'type' argument can be either 'test' or 'train' - as these are the data types in the input folder. the 'name' argument can be one of ['subject', 'X', 'y'] - as these are the file prefixes of input files in the different data type folders. The function returns data frame with the contents of the relevant file, or throws an error for wrong input.
  + `index_to_activity <- function(activity)` - there are 6 available activity types, as is described in the input file './data/HCI HAR Dataset/activity_labels.txt'. This function translates an activity identifier (number 1-6) to the corresponding label (name of activity)
  + `merge_data_by_type <- function(type)` - receives a data type (one of ['test', 'train']) and merges all relevant data from the input files of the requested type to a single dataset. i.e. it will contain the 'X' data, the 'y' data, and the 'subject' data.
  + `get_mean_and_std <- function(in_df)` - given an input dataset, returns a subset with only columns with the names 'subject_id', 'activity', or any column that includes the string 'mean(' or the string 'std('.
  + `project_dataset_a <- function()` - when run - this function uses the above functions to create the first dataset of the project (as described in points 1-4 of the task description).
  + `project_dataset_b <- function(in_df)` - expects to get as input the first dataset of the project (as returned from `project_dataset_a`) and returns the second dataset of the project, as described in point 5 of the project description.
  + The script ends with running the `project_dataset_b` function on the output of `project_dataset_a` to create the tidy dataset, and then store the tidy dataset to file.