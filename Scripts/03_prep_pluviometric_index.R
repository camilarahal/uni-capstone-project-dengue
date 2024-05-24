#---------------------------------------------------- Selecting important tables
rm(list = ls())

# Define the root directory where the ANO_ folders are located
root_directory <- "Data/data-orig/meteorology_data"

# Generate the list of ANO_ folders from 2000 to 2024
years <- 2000:2024
ano_folders <- paste0("ANO_", years)

# Initialize a list to store the output
file_list <- list()

# Loop through each ANO_ folder
for (year in years) {
  # Construct the path to the ANO_ folder
  ano_folder <- file.path(root_directory, paste0("ANO_", year))
  
  # Construct the path to the year subfolder within the ANO_ folder
  year_subfolder <- file.path(ano_folder, as.character(year))
  
  # List all .CSV files in the year subfolder
  csv_files <- list.files(path = year_subfolder, pattern = "\\.CSV$", full.names = TRUE)
  
  # Store the file names in the list
  file_list[[as.character(year)]] <- csv_files
}

# Print the list of files
for (year in names(file_list)) {
  cat("Files in year", year, ":\n")
  print(file_list[[year]])
  cat("\n")
}

#----- Test
rm(list = ls())
# Define the root directory where the ANO_ folders are located
root_directory <- "Data/data-orig/meteorology_data"

# Initialize an empty list to store file names for years 2000 to 2019
file_list_2000_to_2019 <- list()

# Loop through each year from 2000 to 2019
for (year in 2000:2019) {
  # Construct the path to the year subfolder
  year_subfolder <- file.path(root_directory, paste0("ANO_", year), as.character(year))
  
  # List all .CSV files in the year subfolder
  csv_files <- list.files(path = year_subfolder, pattern = "\\.CSV$", full.names = FALSE)
  
  # Store only the names of the CSV files in the list
  file_list_2000_to_2019[[as.character(year)]] <- csv_files
}

# Combine the lists into one for years 2000 to 2019
combined_list <- file_list_2000_to_2019

# Initialize an empty list to store file names for years 2020 to 2024
file_list_2020_to_2024 <- list()

# Loop through each year from 2020 to 2024
for (year in 2020:2024) {
  # Construct the path to the year folder (no subfolder)
  year_folder <- file.path(root_directory, paste0("ANO_", year))
  
  # List all .CSV files in the year folder
  csv_files <- list.files(path = year_folder, pattern = "\\.CSV$", full.names = FALSE)
  
  # Store only the names of the CSV files in the list
  file_list_2020_to_2024[[as.character(year)]] <- csv_files
}

# Combine the lists into one
combined_list <- c(combined_list, file_list_2020_to_2024)

# Extract only the file names without the path
for (year in names(combined_list)) {
  combined_list[[year]] <- lapply(combined_list[[year]], function(x) basename(x))
}

# Convert the list to a data frame
df <- as.data.frame(combined_list)

# Write the data frame to a CSV file
write.csv(df, file = "tables_list.csv", row.names = FALSE)

#----- Test 3

# Define the root directory where the ANO_ folders are located
root_directory <- "Data/data-orig/meteorology_data"

# Initialize an empty list to store file names
file_list <- list()

# Loop through each year from 2000 to 2019
for (year in 2000:2019) {
  # Construct the path to the year subfolder
  year_subfolder <- file.path(root_directory, paste0("ANO_", year), as.character(year))
  
  # List all .CSV files in the year subfolder
  csv_files <- list.files(path = year_subfolder, pattern = "\\.CSV$", full.names = FALSE)
  
  # Store only the names of the CSV files in the list
  file_list <- c(file_list, csv_files)
}

# Loop through each year from 2020 to 2024
for (year in 2020:2024) {
  # Construct the path to the year folder (no subfolder)
  year_folder <- file.path(root_directory, paste0("ANO_", year))
  
  # List all .CSV files in the year folder
  csv_files <- list.files(path = year_folder, pattern = "\\.CSV$", full.names = FALSE)
  
  # Store only the names of the CSV files in the list
  file_list <- c(file_list, csv_files)
}

# Convert the list to a data frame
df <- data.frame(File_Name = unlist(file_list))

# Write the data frame to a CSV file
write.csv(df, file = "tables_list.csv", row.names = FALSE)
