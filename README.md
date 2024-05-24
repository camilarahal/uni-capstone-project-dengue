# Investigating the Association Between Total Precipitation, Temperature, and Dengue Incidence
## Overview:
This repository contains scripts for data collection, preparation, cleaning, merging, and statistical analysis related to dengue and meteorological data. Each script serves a specific purpose in the data analysis pipeline.

## Data:
data-orig: contain 2 folders with the original data from dengue and from meteorology used in the codes.
data_prep: contain the preprocess files.
data-regression: contain 1 table used in the regression model in the script 06.

## Figures:
Contain 2 visualizations.

## Output:
Contain the Rmarkdown and html files, with the whole process of this work.

## Script Files:
01_data_collection.R: This script is responsible for collecting raw data related to dengue and meteorological variables from various sources.

02_prep_dengue.R: Prepares the collected dengue data for further analysis by cleaning, formatting, and transforming it as necessary.

03_prep_meteorology.R: Prepares the meteorological data collected in the first step. This involves data cleaning, formatting, and possibly aggregating it based on the requirements of the analysis.

04_clean_data_meteorology.R: Further cleaning and preprocessing steps specific to the meteorological data to ensure its quality and compatibility with the dengue data.

05_merging_prep_data.R: Merges the prepared dengue and meteorological datasets into a single dataset suitable for statistical analysis.

06_statistical_analysis.R: Performs the statistical analysis on the merged dataset to explore relationships between dengue incidence and meteorological variables.

07_visualizations.R: Contain the code to perform the visualization contained in "Figures" folder.

## Usage:
Run the scripts in numerical order (01 to 06) to ensure proper data processing flow.
Make sure to update file paths and settings within the scripts according to your local environment and data sources.
Detailed comments are provided within each script to guide you through the process.

## Requirements:
R programming language and necessary packages (e.g., dplyr, tidyr, ggplot2) installed.
Data source is public, no requirements to access the data.
