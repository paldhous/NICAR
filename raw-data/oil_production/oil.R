# load required packages
library(tidyr)
library(dplyr)

# load "wide" oil production data
oil_production <- read.csv("~/Dropbox/kdmc-workshops/2015/dataviz/data/oil_production/oil_production.csv", stringsAsFactors=FALSE)

# convert to "long" format
oil <- gather(oil_production, year, production, -region)

# edit year to numeric
oil <- mutate(oil, year=as.numeric(substring(year, 2, 5)))

# export data
write.csv(oil, "~/Dropbox/kdmc-workshops/2015/dataviz/data/oil_production/oil.csv", row.names = FALSE, na = "")




