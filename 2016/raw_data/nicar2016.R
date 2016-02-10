# load required packages
library(dplyr)
library(readr)
library(ggplot2)
library(scales)

# function to convert any text string into proper case
toproper <- function(x) {
  sapply(x, function(strn)
  { s <- strsplit(strn, "\\s")[[1]]
  paste0(toupper(substring(s, 1,1)), 
         tolower(substring(s, 2)),
         collapse=" ")}, USE.NAMES=FALSE)
}

# import CA kindergarten immunization data and calculate incomplete rate by county
immun <- read_tsv("kindergarten.tsv") %>%
  mutate(county=toproper(county),
         district=toproper(district),
         school=toproper(school),
         pub_priv=toproper(pub_priv),
         incomplete_pc=100-complete_pc,
         sch_code=as.character(sch_code),
         prejan_pbe=as.integer(prejan_pbe),
         prejan_pbe_pc=as.numeric(prejan_pbe_pc),
         doc_couns_pbe=as.integer(doc_couns_pbe),
         doc_couns_pbe_pc=as.numeric(doc_couns_pbe_pc),
         relig_pbe=as.integer(relig_pbe),
         relig_pbe_pc=as.numeric(relig_pbe_pc))

immun_2015 <- read_csv("kindergarten2015.csv") %>%
  mutate(county=toproper(county),
         district=toproper(district),
         school=toproper(school),
         pub_priv=toproper(pub_priv),
         incomplete_pc=100-complete_pc,
         year="2015-16",
         start_year=2015)

immun <- bind_rows(immun,immun_2015) 

write_csv(immun, "kindergarten.csv")

# identify counties with the largest enrollment
immun_counties <- immun %>%
  group_by(county) %>%
  summarize(enrolled=sum(enrollment, na.rm=TRUE)) %>%
  arrange(desc(enrolled)) 

top5 <- head(immun_counties,5) %>%
  select(county)

# percent incomplete, entire state, by year
immun_year <- immun %>%
  group_by(start_year) %>%
  summarize(enrolled=sum(enrollment, na.rm=TRUE),complete=sum(complete, na.rm=TRUE)) %>%
  mutate(pc_incomplete=round(((enrolled-complete)/enrolled),4))

# percent incomplete, by county, by year
immun_counties_year <- immun %>%
  group_by(county,start_year) %>%
  summarize(enrolled=sum(enrollment, na.rm=TRUE),complete=sum(complete, na.rm=TRUE)) %>%
  mutate(pc_incomplete=round(((enrolled-complete)/enrolled),4))

# percent incomplete, top 5 counties by enrollment, by year
immun_top5_year <- inner_join(immun_counties_year,top5)

# bar chart by year, entire state
ggplot(immun_year, aes(x=start_year, y=pc_incomplete)) %>%
  + geom_bar(stat="identity", fill="red", alpha=0.7) %>%
  + theme_minimal() %>%
  + scale_y_continuous(labels = scales::percent) %>%
  + scale_x_continuous(breaks = c(2002,2004,2006,2008,2010,2012,2014)) %>%
  + xlab("") %>%
  + ylab("Incomplete") %>%
  + ggtitle("Immunization in California kindergartens, entire state") %>%
  + theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          text=element_text(size=16))

# dot and line chart by year
ggplot(immun_year, aes(x=start_year, y=pc_incomplete)) %>%
  + geom_line(size=1, color="red") %>%
  + geom_point(size=3, color="red") %>%
  + theme_minimal() %>%
  + scale_y_continuous(labels = scales::percent, limits=c(0,0.1)) %>%
  + scale_x_continuous(breaks = c(2002,2004,2006,2008,2010,2012,2014)) %>%
  + xlab("") %>%
  + ylab("Incomplete") %>%
  + ggtitle("Immunization in California kindergartens, entire state") %>%
  + theme(text=element_text(size=16))

# line chart by year
ggplot(immun_year, aes(x=start_year, y=pc_incomplete)) %>%
  + geom_line(size=1.5, color="red") %>%
  + theme_minimal() %>%
  + scale_y_continuous(labels = scales::percent, limits=c(0.06,0.1)) %>%
  + scale_x_continuous(breaks = c(2002,2004,2006,2008,2010,2012,2014)) %>%
  + xlab("") %>%
  + ylab("Incomplete") %>%
  + ggtitle("Immunization in California kindergartens, entire state") %>%
  + theme(text=element_text(size=16))

# dot and line chart, top5 counties, by year
ggplot(immun_top5_year, aes(x=start_year, y=pc_incomplete, color=county)) %>%
  + scale_color_brewer(palette = "Set1", name = "") %>%
  + geom_line(size=1) %>%
  + geom_point(size=3) %>%
  + theme_minimal() %>%
  + scale_y_continuous(labels = scales::percent, limits = c(0,0.15)) %>%
  + scale_x_continuous(breaks = c(2002,2004,2006,2008,2010,2012,2014)) %>%
  + xlab("") %>% 
  + ylab("Incomplete") %>%
  + theme(legend.position="bottom") %>%
  + ggtitle("Immunization in California kindergartens\n(five largest counties)") %>%
  + theme(text=element_text(size=16))


# dot and line chart, all counties, by year
ggplot(immun_counties_year, aes(x=start_year, y=pc_incomplete, color=county)) %>%
  + geom_line(size=1) %>%
  + geom_point(size=3) %>%
  + theme_minimal() %>%
  + theme(legend.position="none") %>%
  + scale_y_continuous(labels = scales::percent) %>%
  + scale_x_continuous(breaks = c(2002,2004,2006,2008,2010,2012,2014)) %>%
  + xlab("") %>%
  + ylab("Incomplete") %>%
  + ggtitle("Immunization in California kindergartens, by county") %>%
  + theme(text=element_text(size=16))
  
# heat map, all counties, by year
ggplot(immun_counties_year, aes(x=start_year, y=county)) %>%
  + geom_tile(aes(fill = pc_incomplete), colour = "white") %>%
  + scale_fill_gradient(low = "white", 
                        high = "red", name="", 
                        labels = scales::percent) %>%
  + scale_x_continuous(breaks = c(2002,2004,2006,2008,2010,2012,2014)) %>%
  + theme_minimal() %>%
  + xlab("") %>%
  + ylab("County") %>%
  + theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.position="bottom",
          legend.key.height = unit(0.4, "cm"),
          text=element_text(size=14)) %>%
  + ggtitle("Immunization in California kindergartens, by county")

# show all schools, by year
ggplot(immun, aes(x=start_year, y=incomplete_pc/100)) %>%
  + geom_point(position="jitter", 
               color="red", 
               alpha=0.1, 
               aes(size=enrollment)) %>%
  + scale_color_gradient(low = "white", high = "red") %>%
  + scale_x_continuous(breaks = c(2002,2004,2006,2008,2010,2012,2014)) %>%
  + scale_y_continuous(labels = scales::percent) %>%
  + theme_minimal() %>%
  + xlab("") %>%
  + ylab("Incomplete") %>%
  + guides(size=guide_legend(title="Enrollment")) %>%
  + ggtitle("Immunization in California kindergartens") %>%
  + theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          legend.position="bottom",
          text=element_text(size=16))
