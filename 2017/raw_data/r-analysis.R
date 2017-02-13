# load required packages
library(readr)
library(dplyr)
library(ggplot2)

# load health and wealth of nations data
nations1 <- read_csv("nations_1.csv")
nations2 <- read_csv("nations_2.csv") 

# view structure of nations1 data
str(nations1)

# print values for population in the nations1 data
nations1$population

# convert population to integers
nations1$population <- as.integer(nations1$population)
str(nations1)

# summary of nations1 data
summary(nations1)

# filter data for 2015 only, sort by longevity
longevity <- nations1 %>%
  filter(year == 2015 & !is.na(life_expect)) 

longevity <- nations1 %>%
  filter(year == 2014 & !is.na(life_expect)) 

# filter the data to look at life expectancy in 2014
longevity <- nations1 %>%
  filter(year == 2014 & !is.na(life_expect)) %>%
  select(country, life_expect, income, region)

# find the ten high income countries with the lowest life expectancy
high_income_short_life <- longevity %>%
  filter(income == "High income") %>%
  arrange(life_expect) %>%
  head(10)

# find the 20 countries with the longest life expectancies, 
# plus the United States with its rank, if it's outside the top 20
long_life <- longevity %>%
  arrange(desc(life_expect)) %>%
  mutate(rank = c(1:195)) %>%
  filter(rank <= 20 | country == "United States")

# find the 20 countries with the longest life expectancies,
# plus the United States and Russia with their ranks
long_life <- longevity %>%
  arrange(desc(life_expect)) %>%
  mutate(rank = c(1:195)) %>%
  filter(rank <= 20 | grepl("United States|Russia", country))



# group and summarize data
longevity_summary <- nations1 %>%
  filter(!is.na(life_expect)) %>%
  group_by(year) %>%
  summarize(countries = n(),
            max_life_expect = max(life_expect),
            min_life_expect = min(life_expect)) %>%
  mutate(range_life_expect = max_life_expect - min_life_expect) %>%
  arrange(desc(year))

# join
nations <- inner_join(nations1,nations2)
nations <- inner_join(nations1,nations2, by = c("iso3c" = "iso3c", "year" = "year"))

# total GDP, in trillions, by region, over time
gdp_regions <- nations %>%
  mutate(gdp = gdp_percap * population,
         gdp_tn = gdp/1000000000000) %>%
  group_by(region,year) %>%
  summarize(total_gdp_tn = sum(gdp_tn, na.rm = TRUE))

# let's make some charts

ggplot(gdp_regions, aes(x=year, y=total_gdp_tn, color=region)) +
  geom_line(size=1) +
  xlab("") +
  ylab("Total GDP ($ trillions)") +
  theme_minimal(base_size = 12)
  
ggplot(high_income_short_life, aes(x=reorder(country,-life_expect), y=life_expect)) +
  geom_bar(stat="identity", fill = "red", alpha = 0.7) +
  xlab("") +
  ylab("Life expectancy at birth (2014)") + 
  ggtitle("Rich countries with low life expectancies") +
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank()) +
  coord_flip()

ggplot(high_income_short_life, aes(x=country, y=life_expect)) +
  geom_bar(stat="identity", fill = "red", alpha = 0.7) +
  xlab("") +
  ylab("Life expectancy at birth (2014)") + 
  ggtitle("Rich countries with low life expectancies") +
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank()) +
  coord_flip()




# now let's start grouping and summarizing at different levels in a dataset

# load data
immun <- read_csv("kindergarten.csv",  col_types = list(
  county = col_character(),
  district = col_character(),
  sch_code = col_character(),
  pub_priv = col_character(),
  school = col_character(),
  enrollment = col_integer(),
  complete  = col_integer(),
  start_year = col_integer()))

immun_2015 <- read_csv("kindergarten_2015.csv",  col_types = list(
  county = col_character(),
  district = col_character(),
  sch_code = col_character(),
  pub_priv = col_character(),
  school = col_character(),
  enrollment = col_integer(),
  complete  = col_integer(),
  start_year = col_integer()))

# bind rows
immun <- bind_rows(immun,immun_2015)

# percentage incomplete, entire state, by year
immun_year <- immun %>%
  group_by(start_year) %>%
  summarize(enrolled = sum(enrollment, na.rm=TRUE),
            completed = sum(complete, na.rm=TRUE)) %>%
  mutate(pc_incomplete = round(((enrolled-completed)/enrolled*100),2))

# percentage incomplete, by county, by year
immun_counties_year <- immun %>%
  group_by(county,start_year) %>%
  summarize(enrolled = sum(enrollment, na.rm = TRUE),
            completed = sum(complete, na.rm = TRUE)) %>%
  mutate(pc_incomplete = round(((enrolled-completed)/enrolled*100),2))

# identify five counties with the largest enrollment over all years
top5 <- immun %>%
  group_by(county) %>%
  summarize(enrolled = sum(enrollment, na.rm = TRUE)) %>%
  arrange(desc(enrolled)) %>%
  head(5) %>%
  select(county)

# proportion incomplete, top 5 counties by enrollment, by year
immun_top5_year <- semi_join(immun_counties_year, top5)

# column chart by year, entire state
ggplot(immun_year, aes(x = start_year, y = pc_incomplete)) + 
  geom_bar(stat = "identity", fill = "red", alpha = 0.7) +
  xlab("") +
  ylab("Percent incomplete") +
  ggtitle("Immunization in California kindergartens, entire state") + 
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())
        
        
# dot and line chart, top5 counties, by year
ggplot(immun_top5_year, aes(x = start_year, y = pc_incomplete, color = county)) + 
  geom_line(size=1) +
  geom_point(size=3) +
  xlab("") +
  ylab("Percent incomplete") +
  ggtitle("Immunization in California kindergartens\n(five largest counties)") +
  theme_minimal(base_size = 12)

# heat map, all counties, by year
ggplot(immun_counties_year, aes(x = start_year, y = county)) +
  geom_tile(aes(fill = pc_incomplete), colour = "white") +
  scale_fill_gradient(low = "white",
                      high = "red", 
                      name="") +
  xlab("") +
  ylab("County") +
  ggtitle("Immunization in California kindergartens, by county") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position="bottom",
        legend.key.height = unit(0.4, "cm"))




