# load required libraries
library(dplyr)
library(Lahman)
library(ggplot2)

# convert Lahman tables to local data frames, with data for 2013 only for Teams and Salaries
Teams <- filter(Teams, yearID >= 2013)
Salaries <- filter(Salaries, yearID >= 2013)
Fielding <- filter(Fielding, yearID >= 2013)

# calculate payrolls for each Team, by year
Payrolls <- group_by(Salaries, teamID, yearID) %>%
  summarise(payroll=sum(salary)) %>%
  mutate(payroll_mil=payroll/1000000)

# join Payrolls to Teams, then extract required fields, rounding payroll in $ million to 2 decimal places
mlb_payrolls_2013 <- inner_join(Teams, Payrolls, by=c("teamID", "yearID")) %>%
  select(teamID, name, payroll_mil) %>%
  mutate(payroll_mil = round(payroll_mil, digits=2)) %>%
  rename(teamName=name)
  
# join to Master and Teams, select fields for export
mlb_salaries_2013 <- inner_join(Salaries, Master, by="playerID") %>%
  inner_join(Teams, by="teamID") %>%
  mutate(salary_mil=salary/1000000, nameFull=paste(nameFirst, nameLast, sep=" ")) %>%
  rename(teamName=name) %>%
  select(playerID, nameFirst, nameLast, nameFull, teamID, teamName, salary, salary_mil)

# export data 
write.csv(mlb_payrolls_2013, "/Users/paldhous/Dropbox/kdmc-workshops/2015/dataviz/data/mlb_payrolls_2013.csv", row.names = FALSE, na = "")
write.csv(mlb_salaries_2013, "/Users/paldhous/Dropbox/kdmc-workshops/2015/dataviz/data/mlb_salaries_2013.csv", row.names = FALSE, na = "")

# histogram of salaries
ggplot(mlb_salaries_2013, aes(x=salary_mil, y=..count..)) + geom_histogram(binwidth=.5) + ylab("Number of players") + xlab("Salary ($ million)")

# boxplot of salaries by team
ggplot(mlb_salaries_2013, aes(x=teamID, y=salary_mil, colour=teamID)) + geom_boxplot() + theme(legend.position="none", axis.text.x = element_text(angle=90)) + xlab("Team") + ylab("Salary ($ million)")






