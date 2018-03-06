# load packages to read and write csv files, process data, and work with dates
library(readr)
library(dplyr)
library(lubridate)

# load ca medical board disciplinary actions data
ca_discipline <- read_csv("ca_discipline.csv")

View(ca_discipline)

# view structure of data
glimpse(ca_discipline)

# print values for alert_date in the ca_discipline data
print(ca_discipline$alert_date)

# convert alert_date to text
ca_discipline$alert_date <- as.character(ca_discipline$alert_date)
glimpse(ca_discipline)

# convert alert_date to date using dplyr
ca_discipline <- ca_discipline %>%
  mutate(alert_date = as.Date(alert_date))

 # look at types of disciplinary actions
types <- ca_discipline %>%
  select(action_type) %>%
  unique()

 # filter for license revocations only
revoked <- ca_discipline %>%
  filter(action_type == "Revoked")

 # filter for license revocations by doctors based in California, and sort by city
revoked_ca <- ca_discipline %>%
  filter(action_type == "Revoked"
         & state == "CA") %>%
  arrange(city)

 # doctors in Berkeley or Oakland who have had their licenses revoked 
revoked_oak_berk <- ca_discipline %>%
  filter(action_type == "Revoked"
       & (city == "Oakland" | city == "Berkeley"))

# doctors in Berkeley who had their licenses revoked
revoked_berk <- ca_discipline %>%
  filter(action_type == "Revoked"
       & city == "Berkeley")

# doctors in Oakland who had their licenses revoked
revoked_oak <- ca_discipline %>%
  filter(action_type == "Revoked"
       & city == "Oakland")

# doctors in Berkeley or Oakland who have had their licenses revoked
revoked_oak_berk <- bind_rows(revoked_oak, revoked_berk)

# write data to CSV file
write_csv(revoked_oak_berk, "revoked_oak_berk.csv", na = "")

# extract year and month from action_date
ca_discipline <- ca_discipline %>%
  mutate(year = year(action_date),
         month = month(action_date))

# license revokations for doctors based in California, by year
revoked_ca_year <- ca_discipline %>%
  filter(action_type == "Revoked" 
         & state == "CA") %>%
  group_by(year) %>%
  summarize(revocations = n())

 # license revokations for doctors based in California, by month
revoked_ca_month <- ca_discipline %>%
  filter(action_type == "Revoked" 
         & state == "CA"
         & year >= 2009) %>%
  group_by(month) %>%
  summarize(revocations = n())

# license revokations for doctors based in California, by month
revoked_ca_month <- ca_discipline %>%
  filter(action_type == "Revoked" 
         & state == "CA"
         & year != 2008) %>%
  group_by(month) %>%
  summarize(revocations = n())

# disciplinary actions for doctors in California by year and month, from 2009 to 2017
actions_year_month <- ca_discipline %>%
  filter(state == "CA"
         & year >= 2009) %>%
  group_by(year, month) %>%
  summarize(actions = n()) %>%
  arrange(year, month)

# load opioid prescription data
ca_opioids <- read_csv("ca_medicare_opioids.csv")

# look at the data
View(ca_opioids)


# Create a summary, showing the number of opioid prescriptions written by each provider, the total cost of the opioids prescribed, and the cost per claim
provider_summary <- ca_opioids %>% 
  group_by(npi,
           nppes_provider_last_org_name,
           nppes_provider_first_name,
           nppes_provider_city,
           specialty_description) %>%
  summarize(prescriptions = sum(total_claim_count),
            cost = sum(total_drug_cost)) %>%
  mutate(cost_per_prescription = cost/prescriptions) %>%
  arrange(desc(prescriptions))

library(ggplot2)
library(scales)

# histogram of the costs data
ggplot(provider_summary, aes(x = prescriptions)) +
  geom_histogram()

ggplot(provider_summary, aes(x = prescriptions)) +
  geom_histogram(binwidth = 50) +
  theme_minimal() +
  scale_x_continuous(limits = c(0,3000),
                     labels = comma) +
  scale_y_continuous(labels = comma)

#### Make a scatterplot of prescriptions and costs data
ggplot(provider_summary, aes(x = prescriptions, y = cost)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = lm) +
  theme_minimal() +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = dollar)

# load data
npi_license <- read_csv("npi_license.csv")

# join those two data frames
ca_discipline_npi <- left_join(ca_discipline, npi_license)
 
# join disciplinary action data to the opioid prescription data
provider_summary_actions <- inner_join(provider_summary, ca_discipline_npi, by = "npi") %>%
  arrange(desc(prescriptions))

# change case of variables to be used in the join
ca_discipline_npi <- ca_discipline_npi %>%
  mutate(last_name = toupper(last_name),
         first_name = toupper(first_name),
         city = toupper(city))

# join disciplinary action data to the opioid prescription data
provider_summary_actions_2 <- inner_join(provider_summary, ca_discipline_npi, by = c("nppes_provider_last_org_name" = "last_name", 
                                                                                     "nppes_provider_first_name" = "first_name",
                                                                                     "nppes_provider_city" = "city")) %>%
  arrange(desc(prescriptions))

# join disciplinary action data to the opioid prescription data
provider_summary_actions_extra <- anti_join(provider_summary_actions_2, provider_summary_actions)




















