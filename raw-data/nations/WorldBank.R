# load required packages
library(dplyr)
library(WDI)
library(ggplot2)
library(scales)

# import World Bank data

# create list of indicators to be imported
indic_list <- c("NY.GDP.PCAP.PP.CD","SP.DYN.LE00.IN", "SP.POP.TOTL")

# import indicators into single data frame and rename fields
indicators <- WDI(indicator=indic_list, country="all", start=1990, end=2013) %>%
  rename(gdp_pc=NY.GDP.PCAP.PP.CD, life_expect=SP.DYN.LE00.IN, population=SP.POP.TOTL, iso_a2=iso2c)

# import nations join table
nations_join <- read.csv("~/Dropbox/kdmc-workshops/raw-data/nations/nations_join.csv", stringsAsFactors=FALSE)

# import regions/income group data
groups <- read.csv("~/Dropbox/kdmc-workshops/raw-data/nations/groups.csv", stringsAsFactors=FALSE)

# join to income group data and select desired fields
indicators2 <- inner_join(indicators, nations_join) %>%
  inner_join(groups) %>%
  select(iso_a3, country, year, region, income_group, gdp_pc, life_expect, population)

# join for namibia
namibia <- inner_join(indicators, nations_join, c("country"="iso_country")) %>%  
  inner_join(groups) %>%
  filter(country=="Namibia") %>%
  select(iso_a3, country, year, region, income_group, gdp_pc, life_expect, population)

# combine
wealth_life <- rbind(indicators2, namibia) %>%
  arrange(iso_a3)

# filter for 2013 data, for gdp_pc histogram
wealth_life_2013 <- filter(wealth_life, year==2013)

# filter for 2012 data, for gdp_pc scatterplot
wealth_life_2012 <- filter(wealth_life, year==2012) %>%
  mutate(region=as.factor(region))

# select 2013 gdp_pc data for join to world shapefile
gdp_pc_2013 <- select(wealth_life_2013, iso_a3, country, gdp_pc)

#export data
write.csv(wealth_life, "~/Dropbox/kdmc-workshops/raw-data/nations/wealth_life.csv", row.names = FALSE, na = "")
write.csv(wealth_life_2013, "~/Dropbox/kdmc-workshops/raw-data/nations/wealth_life_2013.csv", row.names = FALSE, na = "")
write.csv(gdp_pc_2013, "~/Dropbox/kdmc-workshops/raw-data/qgis/gdp_pc/gdp_pc_2013.csv", row.names = FALSE, na = "-99")
write.csv(gdp_pc_2013, "~/Dropbox/kdmc-workshops/raw-data/map_principles/gdp_pc_2013.csv", row.names = FALSE, na = "")

# histogram of gdp_pc in 2013
ggplot(wealth_life_2013, aes(x=gdp_pc, y=..count..)) + geom_histogram(binwidth=2500) + ylab("Number of countries") + xlab("GDP per capita (2013)") + scale_x_continuous(labels = dollar)

# scatterplot of gdp_pc vs life_expect in 2012
#linear
ggplot(wealth_life_2012, aes(x=gdp_pc, y=life_expect)) + geom_point(size=4, alpha=0.5) + scale_x_continuous(labels = dollar) + stat_smooth(formula=y~log(x), se=FALSE) + xlab("GDP per capita") + ylab("Life expectancy at birth")
#logarithmic
ggplot(wealth_life_2012, aes(x=gdp_pc, y=life_expect)) + geom_point(size=4, alpha=0.5) + scale_x_log10(labels = dollar) + geom_smooth(se=FALSE, method="lm") + xlab("GDP per capita") + ylab("Life expectancy at birth")




