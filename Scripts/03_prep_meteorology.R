#---------------------------------------------------- Selecting important tables
#---- Pre processing:

#--------------------------------- 1. Identifying tables of interest using lists

rm(list = ls())
# Define the root directory where the ANO_ folders are located
root_directory <- "Data/data-orig/meteorology_data"

# Initialize an empty data frame to store file names and years
df <- data.frame(File_Name = character(), Year = integer(), stringsAsFactors = FALSE)

# Loop through each year from 2000 to 2019
for (year in 2000:2019) {
  # Construct the path to the year subfolder
  year_subfolder <- file.path(root_directory, paste0("ANO_", year), as.character(year))
  
  # List all .CSV files in the year subfolder
  csv_files <- list.files(path = year_subfolder, pattern = "\\.CSV$", full.names = TRUE)
  
  # Extract file names without the path
  csv_files <- basename(csv_files)
  
  # Create a data frame with the file names and year
  year_df <- data.frame(File_Name = csv_files, Year = year)
  
  # Append the data frame to df
  df <- rbind(df, year_df)
}

# Loop through each year from 2020 to 2024
for (year in 2020:2024) {
  # Construct the path to the year folder (no subfolder)
  year_folder <- file.path(root_directory, paste0("ANO_", year))
  
  # List all .CSV files in the year folder
  csv_files <- list.files(path = year_folder, pattern = "\\.CSV$", full.names = TRUE)
  
  # Extract file names without the path
  csv_files <- basename(csv_files)
  
  # Create a data frame with the file names and year
  year_df <- data.frame(File_Name = csv_files, Year = year)
  
  # Append the data frame to df
  df <- rbind(df, year_df)
}

# Write the data frame to a CSV file
write.csv(df, file = "tables_list.csv", row.names = FALSE)

rm(list = ls())

#---------------------------------- 2 - Selecting tables of interest: Bauru city

rm(list = ls())
# Define the root directory where the ANO_ folders are located
root_directory <- "Data/data-orig/meteorology_data"

# Define the directory for the new folder "bauru_data"
bauru_directory <- file.path(root_directory, "bauru_data")

# Create the "bauru_data" folder if it doesn't exist
if (!file.exists(bauru_directory)) {
  dir.create(bauru_directory)
}

# Loop through each year from 2000 to 2019
for (year in 2000:2019) {
  # Construct the path to the year subfolder
  year_subfolder <- file.path(root_directory, paste0("ANO_", year), as.character(year))
  
  # List all .CSV files in the year subfolder containing "BAURU" in their names
  csv_files <- list.files(path = year_subfolder, pattern = "BAURU", full.names = TRUE)
  
  # Copy the Bauru files to the "bauru_data" folder
  file.copy(csv_files, bauru_directory, overwrite = TRUE)
}

# Loop through each year from 2020 to 2024
for (year in 2020:2024) {
  # Construct the path to the year folder (no subfolder)
  year_folder <- file.path(root_directory, paste0("ANO_", year))
  
  # List all .CSV files in the year folder containing "BAURU" in their names
  csv_files <- list.files(path = year_folder, pattern = "BAURU", full.names = TRUE)
  
  # Copy the Bauru files to the "bauru_data" folder
  file.copy(csv_files, bauru_directory, overwrite = TRUE)
}

rm(list = ls())

#------------------------------------------------- 3 - Excluding useless folders

# Define the root directory where the ANO_ folders are located
root_directory <- "Data/data-orig/meteorology_data"

# Loop through each year from 2000 to 2024
for (year in 2000:2024) {
  # Construct the path to the year folder
  year_folder <- file.path(root_directory, paste0("ANO_", year))
  
  # Check if the folder exists and if it matches the pattern "ANO_2000" to "ANO_2024"
  if (file.exists(year_folder) && grepl("ANO_(2000|200[1-9]|20[1-9][0-9]|202[0-4])", year_folder)) {
    # Remove the folder
    unlink(year_folder, recursive = TRUE)
    cat("Folder", year_folder, "excluded.\n")
  }
}
