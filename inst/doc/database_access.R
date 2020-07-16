## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  error = FALSE,
  collapse = TRUE,
  comment = "#>"
)

## ----example1, echo = TRUE, eval = TRUE---------------------------------------
library(oxcovid19)
library(magrittr)
library(dplyr)

connect_oxcovid19() %>%                      ## Connect to PostgreSQL server
  get_table(tbl_name = "epidemiology") %>%   ## Retrieve epidemiology table
  arrange(source) %>%                        ## Sort the table by source
  select(source) %>%                         ## Select the source column
  distinct() %>%                             ## Get only unique sources
  pull(source)                                 

## ----example2, echo = TRUE, eval = TRUE---------------------------------------
connect_oxcovid19() %>%                      ## Connect to PostgreSQL server
  get_table(tbl_name = "epidemiology") %>%   ## Retrieve epidemiology table
  filter(source == "GBR_PHTW") %>%           ## Select specific source
  arrange(desc(date))                        ## Sort by date

## ----example3, echo = TRUE, eval = TRUE---------------------------------------
connect_oxcovid19() %>%                      ## Connect to PostgreSQL server
  get_table(tbl_name = "mobility") %>%       ## Retrieve mobility table
  filter(source == "GOOGLE_MOBILITY",        ## Get only data from `Google`
         countrycode == "GBR") %>%           ## Get only data from `GBR`
  arrange(desc(date))                        ## Sort by date

