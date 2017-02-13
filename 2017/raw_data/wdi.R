# load required packages
library(WDI)
library(dplyr)
library(readr)
library(stringr)

# get data

# create list of indicators to be imported
indic_list <- c("NY.GDP.PCAP.PP.CD", "SP.DYN.LE00.IN", "SP.POP.TOTL", "SP.DYN.CBRT.IN","SH.DYN.NMRT")

# import indicators into single data frame and rename fields
indicators <- WDI(indicator=indic_list, country="all", start=1990, end=2015, extra=T, cache=NULL) %>%
  rename(gdp_percap=NY.GDP.PCAP.PP.CD, life_expect=SP.DYN.LE00.IN, population=SP.POP.TOTL, birth_rate=SP.DYN.CBRT.IN, neonat_mortal_rate=SH.DYN.NMRT) %>%
  filter(income != "Aggregates")

# some text cleaning
indicators$region <- gsub("all income levels","", indicators$region)
indicators$region <- gsub("\\(|\\)","", indicators$region)
indicators$region <- str_trim(indicators$region)
indicators$income <- gsub(": nonOECD","", indicators$income)
indicators$income <- gsub(": OECD","", indicators$income)

# select fields for files
nations1 <- indicators %>%
  select(1,9,2,3,5:8,10,14)

nations2 <- indicators %>%
  select(9,3,4)

nations <- indicators %>%
  select(1,9,2,3,5:8,10,14,4)

# write to csv
write_csv(nations1, "nations_1.csv", na="")
write_csv(nations2, "nations_2.csv", na="")
write_csv(nations, "nations.csv", na="")
