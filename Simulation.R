# Sample data
total_interest_payments <- c(100, 200, 300)
months_per_year <- 12
years <- 2000:2002

# Create monthly interest rates
set.seed(123)  # for reproducibility
monthly_interest_rates <- matrix(runif(length(total_interest_payments) * months_per_year), nrow = months_per_year)

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


#Checking the results:
# Calculate the sum of the first 12 observations
sum_first_12_obs <- sum(monthly_total_interest_payments[1:12])

# Print the result
print(sum_first_12_obs)

# Calculate the sum of observations 13 to 24
sum_months_13_to_24 <- sum(monthly_total_interest_payments[13:24])

# Print the result
print(sum_months_13_to_24)


