#----- Pre processing file "Historical Series of probable dengue cases (2000 - 2023*)"

# Using regular expressions to recreate structure from PDF to CSV file.

# Split the text into lines (pdf_text was collected in Script 01_data_collection)

# Load required libraries
library(dplyr)

lines <- strsplit(pdf_text, "\n")[[1]]

# Filter out lines containing the title and subtitle
filtered_lines <- lines[!grepl("Série Histórica de casos prováveis de dengue", lines) & 
                          !grepl("Dados até a Semana Epidemiológica 52, atualizado em", lines)]

# Preprocess the lines to join lines that belong together
preprocessed_lines <- c()
for (i in seq_along(filtered_lines)) {
  if (grepl("\\-$", filtered_lines[i])) {
    # Join this line with the next one
    preprocessed_lines[length(preprocessed_lines)] <- paste0(preprocessed_lines[length(preprocessed_lines)], gsub("\\-$", "", filtered_lines[i]))
  } else {
    preprocessed_lines <- c(preprocessed_lines, filtered_lines[i])
  }
}

# Split the preprocessed text into lines
lines <- preprocessed_lines

# Split each line into columns based on the delimiter (space between words and numbers, excluding hyphens)
data <- lapply(lines, function(line) {
  unlist(strsplit(line, "(?<=[a-zA-Z])\\s+(?!-)(?=\\d)|(?<=\\d)\\s+(?![a-zA-Z])|(?<=\\d)\\s+(?=\\d)", perl = TRUE))
})

# Find the maximum number of columns in any row
max_cols <- max(sapply(data, length))

# Pad shorter rows with NA values
data <- lapply(data, function(row) {
  c(row, rep(NA, max_cols - length(row)))
})

# Convert the data into a matrix
data_matrix <- do.call(rbind, data)

# Convert the matrix into a data frame
df <- as.data.frame(data_matrix, stringsAsFactors = FALSE)

# Drop NA values
df <- na.omit(df)

# Delete rows 1, 31, 33, and 38
df <- df[-c(1, 31, 33, 38), ]

# Modify cell 30A
df[25, 1] <- "Região Centro-Oeste"

# Modify cell 31A
df[26, 1] <- "Mato Grosso do Sul"

# Write the data frame to a CSV file
write.csv(df, "cases_states.csv", row.names = FALSE)

#---------------------------------- Dengue cases in Bauru city from 2010 to 2018
rm(list = ls())

# Define the file path
file_path <- "Data/data-orig/dengue/dengue_bauru.csv"

# Read the CSV file
dengue_bauru <- read.csv(file_path)

# Display the structure of the data
str(dengue_bauru)
summary(dengue_bauru)

# Convert data_iniSE column to Date format
dengue_bauru$data_iniSE <- as.Date(dengue_bauru$data_iniSE)

# Create a new column for month-year
dengue_bauru$month_year <- format(dengue_bauru$data_iniSE, "%m-%Y")

# Select data_iniSE and casos columns
selected_data <- dengue_bauru[, c("month_year", "casos")]

# Aggregate data by month-year
aggregated_data <- selected_data %>% 
  group_by(month_year) %>% 
  summarise(
    casos = sum(casos)
  )

# View the aggregated data
View(aggregated_data)
# Write aggregated data to CSV
write.csv(aggregated_data, "monthly_cases.csv", row.names = FALSE)
