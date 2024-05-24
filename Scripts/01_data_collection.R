rm(list = ls())

install.packages("rvest")
install.packages("readr")
install.packages("pdftools")

library(pdftools)
library(rvest)
library(readr)

# Define the URL of the webpage
url <- "https://www.gov.br/saude/pt-br/assuntos/saude-de-a-a-z/d/dengue/situacao-epidemiologica/serie-historica-casos-provaveis-de-dengue-2000-2023/view"

# Read the HTML content of the page
webpage <- read_html(url)

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

#----- Scrape tables .csv file cases per city in the state of São Paulo from 2019 to 2024


# Define the base URL of the webpage
url <- "https://saude.sp.gov.br/cve-centro-de-vigilancia-epidemiologica-prof.-alexandre-vranjac/oldzoonoses/dengue/dados-estatisticos#"

# Read the webpage
webpage <- read_html(url)

# Extract all links from the webpage
all_links <- webpage %>%
  html_nodes("a") %>%
  html_attr("href")

# Filter links containing .csv
csv_links <- all_links[grep(".csv", all_links)]

# Download the specific links
for (link in csv_links) {
  # Check if the link is an absolute path
  if (!grepl("^https?://", link)) {
    # If not, construct the full URL
    link <- paste0(url, link)
  }
  download.file(link, basename(link))
  Sys.sleep(1) # Wait for 1 second
}

# Filter the .htm files using Selenium

install.packages("RSelenium")
remotes::install_github("ropensci/wdman")
wdman::install()


library(RSelenium)
library(rvest)

# Start a Selenium server
rD <- rsDriver(browser = c("chrome"))

# Connect to the remote Selenium server
remDr <- rD[["client"]]

# Define the URL of the webpage
base_url <- "https://saude.sp.gov.br/cve-centro-de-vigilancia-epidemiologica-prof.-alexandre-vranjac/oldzoonoses/dengue/dados-estatisticos#"

# Navigate to the webpage
remDr$navigate(base_url)

# Find all download buttons and click them
download_buttons <- remDr$findElements(using = "css selector", ".download")
for (button in download_buttons) {
  button$clickElement()
  Sys.sleep(5) # Wait for the file to download (adjust the sleep time as needed)
}

# Quit the Selenium server
rD[["server"]]$stop()

