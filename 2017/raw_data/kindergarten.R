# load required packages
library(readr)
library(dplyr)

# load data
kindergarten <- read_tsv("kindergarten.tsv") %>%
  select(1,2,4:7,33)

kindergarten2015 <- read_csv("kindergarten2015.csv") %>%
  mutate(start_year=2015) %>%
  select(4,1,3,6:8,33) %>%
  mutate(start_year=as.integer(start_year))

# write to csv
write_csv(kindergarten, "kindergarten.csv", na="")
write_csv(kindergarten2015, "kindergarten_2015.csv", na="")
