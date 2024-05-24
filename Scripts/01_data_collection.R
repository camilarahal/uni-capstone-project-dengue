rm(list = ls())

install.packages("rvest")
install.packages("readr")
install.packages("pdftools")

library(pdftools)
library(rvest)
library(readr)

# Define the URL of the webpage
url_dengue <- "https://www.gov.br/saude/pt-br/assuntos/saude-de-a-a-z/d/dengue/situacao-epidemiologica/serie-historica-casos-provaveis-de-dengue-2000-2023/view"

# Read the HTML content of the page
webpage <- read_html(url_dengue)

# Scrape the URL of the PDF file using XPath
pdf_link <- webpage %>%
  html_node(xpath = '//*[@id="content-core"]/p/a') %>%
  html_attr("href")

# Download the PDF file
download.file(pdf_link, "dengue_data.pdf", mode = "wb")

# Extract text from the PDF file
pdf_text <- pdf_text("dengue_data.pdf")

# Print the extracted text
cat(pdf_text)


#----- Scrape INMET website for annual meteorological data from Brasil - 2000 to 2024 

# !Important - it takes between 5 to 10 minutes, 6,9 GB, so be aware with disk space before running the code)


# URL of the page
url <- "https://portal.inmet.gov.br/dadoshistoricos"

# Read the HTML content of the page
page <- read_html(url)

# Extract all the links containing "ANO" from the page
links <- page %>%
  html_nodes(xpath = '//a[contains(text(), "ANO")]') %>%
  html_attr("href")

# Base URL for the files
base_url <- "https://portal.inmet.gov.br/uploads/dadoshistoricos/"

# Define a function to download and unzip files with error handling

# This can take between 5 to 10 minutes

download_and_unzip <- function(link) {
  # Extract the year from the link
  year <- sub('.*\\/(\\d{4})\\.zip', '\\1', link)
  
  # Construct the full download URL
  download_url <- paste0(base_url, year, ".zip")
  
  # Attempt to download the file with retry logic
  attempts <- 0
  success <- FALSE
  while (!success && attempts < 3) {  # Retry up to 3 times
    attempts <- attempts + 1
    tryCatch({
      download.file(download_url, destfile = paste0("ANO_", year, ".zip"))
      success <- TRUE
    }, error = function(e) {
      cat("Error downloading:", download_url, "\n")
      if (attempts < 3) {
        cat("Retrying...\n")
        Sys.sleep(5)  # Wait 5 seconds before retrying
      }
    })
  }
  
  # Check if download was successful
  if (success) {
    cat("Downloaded:", download_url, "\n")
    # Attempt to unzip the downloaded file
    tryCatch({
      unzip(paste0("ANO_", year, ".zip"), exdir = paste0("ANO_", year))
      cat("Unzipped:", paste0("ANO_", year, ".zip"), "\n")
    }, error = function(e) {
      cat("Error unzipping:", paste0("ANO_", year, ".zip"), "\n")
      file.remove(paste0("ANO_", year, ".zip"))  # Remove the zip file if there's an error
    })
  } else {
    cat("Failed to download:", download_url, "\n")
  }
} 

# Loop through each link and call the function to download and unzip
for (link in links) {
  download_and_unzip(link)
}
 
# Get a list of all zip files in the directory
zip_files <- list.files(pattern = "\\.zip$")

# Delete each zip file
for (file in zip_files) {
  file.remove(file)
}

# Confirm deletion
cat("Deleted", length(zip_files), "zip files.\n")
