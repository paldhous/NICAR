library(readr)
library(dplyr)

# load data
sou <- read_csv("sou_raw.csv")
presidents <- read_csv("presidents.csv")

sou <- sou %>%
  left_join(presidents)

write_csv(sou,"sou.csv", na="")
