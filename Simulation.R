### Packages--------------------------------------------------------------------

## tidyverse--------------------------------------------------------------------
# install.packages("tidyverse")
library(tidyverse)

## haven------------------------------------------------------------------------
# install.packages("haven")
library(haven)

## data.table------------------------------------------------------------------- 
# install.packages("data.table")
library(data.table)

## dplyr------------------------------------------------------------------------
# install.packages("dplyr")
library(dplyr)

### Opening relevant data ------------------------------------------------------

## Setting work directory-------------------------------------------------------
setwd("C:\\Users\\lauro\\Documents\\GitHub\\NPE-Multiplicadores")

## Checking whether files of interest exist in work directory-------------------
file.exists("Anual_Subsídio implícito BNDES.csv")
file.exists("Orair_Gobetti_Subsídio implícito BNDES.csv")

## Reading relevant files ------------------------------------------------------
subsidio_bndes <- read.csv("Anual_Subsídio implícito BNDES.csv", 
                           header = TRUE, dec = ",", row.names = 1)

subsidio_bndes_mensal <- read.csv("Orair_Gobetti_Subsídio implícito BNDES.csv", 
                                  header = TRUE, dec = ",", row.names = 1)

## Checking data class----------------------------------------------------------
class(subsidio_bndes$X2018)
class(subsidio_bndes$X2019)
class(subsidio_bndes$X2020)
class(subsidio_bndes$X2021)
class(subsidio_bndes$X2022)
class(subsidio_bndes$X2023)

### Analysis--------------------------------------------------------------------

# Extracting relevant row from data frame
total_interest_payments <- as.numeric(subsidio_bndes[1, -ncol(subsidio_bndes)])

# Not including 2023, total is partial

# Creating vector of months per year

months_per_year <- 12

# Years of reference
years <- 2018:2022

# Create monthly interest rates
set.seed(123)  # for reproducibility
monthly_interest_rates <- matrix(runif(length(total_interest_payments) * 
                                         months_per_year), 
                                 nrow = months_per_year)

# Calculate total interest payments per year
total_interest_per_year <- rep(total_interest_payments, each = months_per_year)

# Distribute total interest payments proportionally across months
monthly_total_interest_payments <- rep(NA, length(total_interest_per_year))
for (i in 1:length(total_interest_payments)) {
  start_index <- (i - 1) * months_per_year + 1
  end_index <- i * months_per_year
  total_interest_for_year <- total_interest_per_year[start_index:end_index]
  monthly_interest_rates_for_year <- monthly_interest_rates[, i]
  monthly_total_interest_payments[start_index:end_index] <- total_interest_for_year * monthly_interest_rates_for_year / sum(monthly_interest_rates_for_year)
}

# Result
monthly_total_interest_payments


## Checking results-------------------------------------------------------------
# Calculate the sum of the first 12 observations
sum_first_12_obs <- sum(monthly_total_interest_payments[1:12])

# Print the result
print(sum_first_12_obs)

# Calculate the sum of observations 13 to 24
sum_months_13_to_24 <- sum(monthly_total_interest_payments[13:24])

# Print the result
print(sum_months_13_to_24)

# Calculate the sum of observations 25 to 36
sum_months_25_to_36 <- sum(monthly_total_interest_payments[25:36])

# Print the result
print(sum_months_25_to_36)

# Calculate the sum of observations 13 to 24
sum_months_37_to_48 <- sum(monthly_total_interest_payments[37:48])

# Print the result
print(sum_months_37_to_48)


# Calculate the sum of observations 13 to 24
sum_months_49_to_60 <- sum(monthly_total_interest_payments[49:60])

# Print the result
print(sum_months_49_to_60)


## Adapting to 2023 partial values----------------------------------------------

total_interest_payments_2023 <- as.numeric(subsidio_bndes$X2023)

# Creating vector of months per year

months_2023 <- 2

# Years of reference
year_2023 <- 2023

# Create monthly interest rates
set.seed(123)  # for reproducibility
monthly_interest_rates_2023 <- matrix(runif(length(total_interest_payments_2023) * 
                                         months_2023), 
                                 nrow = months_2023)


# Calculate total interest payments for 2023
total_interest_2023 <- rep(total_interest_payments_2023, each = months_2023)

# Distribute total interest payments proportionally across months
monthly_total_interest_payments_2023 <- rep(NA, length(total_interest_2023))
for (i in 1:length(total_interest_payments_2023)) {
  start_index <- (i - 1) * months_2023 + 1
  end_index <- i * months_2023
  total_interest_2023 <- total_interest_2023[start_index:end_index]
  monthly_interest_rates_2023 <- monthly_interest_rates_2023[, i]
  monthly_total_interest_payments_2023[start_index:end_index] <- total_interest_2023 * monthly_interest_rates_2023 / sum(monthly_interest_rates_2023)
}

# Result
monthly_total_interest_payments_2023


## Checking results-------------------------------------------------------------
# Calculate the sum of the first 2 observations
sum_first_2_obs <- sum(monthly_total_interest_payments_2023[1:2])

# Print the result
print(sum_first_2_obs)


## Joining data frames----------------------------------------------------------

dataframe1 <- data.frame(monthly_total_interest_payments)

dataframe2 <- data.frame(monthly_total_interest_payments_2023)

dataframe2 <- dataframe2 %>% 
  rename(monthly_total_interest_payments=monthly_total_interest_payments_2023)

rownames(dataframe2) = c("61", "62")

final_dataframe <- bind_rows(dataframe1, dataframe2)


## Excel file-------------------------------------------------------------------

install.packages("writexl")     
library("writexl")    

write_xlsx(final_dataframe, 
           "C:\\Users\\lauro\\Documents\\GitHub\\NPE-Multiplicadores\\subsidios.xlsx")
