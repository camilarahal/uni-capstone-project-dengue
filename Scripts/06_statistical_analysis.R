#--------------------------------------------------------- Statystical analysis
rm(list = ls())

data <- read.csv("Data/data-regression/final_table.csv")

# Perform linear regression
lm_model <- lm(casos ~ precipitation + temperature, data = data)

# Summary of the linear regression model
summary(lm_model)
