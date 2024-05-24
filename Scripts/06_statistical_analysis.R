#--------------------------------------------------------- Statystical analysis
rm(list = ls())
library(plotly)

data <- read.csv("Data/data-regression/final_table.csv")

# Perform linear regression
lm_model <- lm(casos ~ precipitation + temperature, data = data)

# Summary of the linear regression model
summary(lm_model)

# Scatter plot of total precipitation vs. dengue cases
plot_precipitation <- plot_ly(data, x = ~precipitation, y = ~casos, type = "scatter", mode = "markers",
                              marker = list(color = "blue")) %>%
  layout(title = "Total Precipitation vs. Dengue Cases",
         xaxis = list(title = "Total Precipitation"),
         yaxis = list(title = "Dengue Cases"))

# Scatter plot of temperature vs. dengue cases
plot_temperature <- plot_ly(data, x = ~temperature, y = ~casos, type = "scatter", mode = "markers",
                            marker = list(color = "orange")) %>%
  layout(title = "Temperature vs. Dengue Cases",
         xaxis = list(title = "Temperature"),
         yaxis = list(title = "Dengue Cases"))


# Display plots
plot_precipitation
plot_temperature

