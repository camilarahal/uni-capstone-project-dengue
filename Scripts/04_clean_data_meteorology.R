Sys.setlocale("LC_ALL", "pt_BR.UTF-8")
rm(list = ls())


#------------------------------------ 3 Cleaning and Merging tables 2010 - 2018


# Load the required library
library(data.table)

# Set the directory containing all the CSV files
directory <- "Data/data-orig/meteorology_data/bauru_data/"

# Get a list of all CSV files in the directory
file_list <- list.files(directory, pattern = ".CSV", full.names = TRUE)

# Initialize an empty list to store filtered data
filtered_data_list <- list()

# Loop through each file
for (file_path in file_list) {
  # Read the data
  data <- fread(file_path)
  
  # Filter out rows with "-9999" values or NA
  data_filtered <- data[!apply(data, 1, function(row) any(row == "-9999" | is.na(row))),]
  
  # Rename the columns
  setnames(data_filtered, c("Data YYYY-MM-DD" = "date",
                            "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)" = "precipitation",
                            "TEMPERATURA MÁXIMA NA HORA ANT. (AUT) (°C)" = "temperature"))
  
  # Store filtered data
  filtered_data_list[[file_path]] <- data_filtered
  
  # Write the filtered data to a new CSV file
  output_file_path <- sub(".CSV", "_filtered.csv", file_path)
  fwrite(data_filtered, output_file_path, na = "NA")
}

# Merge all filtered datasets
merged_data <- rbindlist(filtered_data_list, fill = TRUE)  # Using fill option to handle missing columns with NA

# Write the merged data to a new CSV file
merged_output_file_path <- "Data/data-orig/meteorology_data/bauru_data/INMET_SE_SP_A705_BAURU_merged.csv"
fwrite(merged_data, merged_output_file_path, na = "NA")


#-------------------------------- Aggregate by month and year
rm(list = ls())
library(dplyr)

# Read the CSV file
data <- read.csv("Data/data-orig/meteorology_data/bauru_data/INMET_SE_SP_A705_BAURU_merged.csv")

# Convert the date column to Date format
data$date <- as.Date(data$date, format = "%d/%m/%y")

# Convert precipitation column to numeric
data$precipitation <- as.numeric(data$precipitation)

# Convert temperature column to numeric after replacing comma with dot
data$temperature <- as.numeric(gsub(",", ".", data$temperature))

# Create a new column for month-year
data$month_year <- format(data$date, "%m-%Y")

# Aggregate data by month-year
aggregated_data <- data %>% 
  group_by(month_year) %>% 
  summarise(
    precipitation = sum(precipitation, na.rm = TRUE),
    temperature = mean(temperature, na.rm = TRUE)
  )

# View the aggregated data
View(aggregated_data)

# Save the aggregated data as a CSV file
write.csv(aggregated_data, "aggregated_meteorology_data.csv", row.names = FALSE)
