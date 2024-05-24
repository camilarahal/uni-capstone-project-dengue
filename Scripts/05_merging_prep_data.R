#------------------------------------------------------- Identify discrespancies
data1 <- read.csv("Data/data-prep/aggregated_meteorology_data.csv")

# Read the second table
data2 <- read.csv("Data/data-prep/monthly_cases.csv")

# Check unique values of month_year column in each table
unique_months_data1 <- unique(data1$month_year)
unique_months_data2 <- unique(data2$month_year)

# Find discrepancies
discrepancies_data1 <- setdiff(unique_months_data1, unique_months_data2)
discrepancies_data2 <- setdiff(unique_months_data2, unique_months_data1)

# Print discrepancies
print("Discrepancies in data1:")
print(discrepancies_data1)

print("Discrepancies in data2:")
print(discrepancies_data2)

#------------------------------------------------------------------ Merge tables

# Perform a full outer join to merge the tables, filling missing values with NA
merged_data <- merge(data1, data2, by = "month_year", all = TRUE)

# View the merged data
View(merged_data)

# Remove or impute missing values
merged_data <- na.omit(merged_data)

# Write the merged data to a new CSV file
write.csv(merged_data, "Data/data-regression/final_table.csv", row.names = FALSE)

print(merged_data)

