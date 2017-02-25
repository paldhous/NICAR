# load required packages
library(readr)
library(dplyr)
library(htmlwidgets)
library(highcharter)
library(RColorBrewer)
library(leaflet)
library(rgdal)
library(dygraphs)
library(quantmod)
library(DT)

nations <- read_csv("nations.csv") 

gdp_regions <- nations %>%
  mutate(gdp = gdp_percap * population,
         gdp_tn = gdp/1000000000000) %>%
  group_by(region, year) %>%
  summarize(total_gdp_tn = sum(gdp_tn, na.rm = TRUE))


gdp_regions <- nations %>%
  mutate(gdp = gdp_percap * population,
         gdp_tn = gdp/1000000000000) %>%
  group_by(region,year) %>%
  summarize(total_gdp_tn = sum(gdp_tn, na.rm = TRUE))

gdp_regions_a <- highchart() %>%
  hc_add_series_df(data = gdp_regions,
                   type = "line",
                   x = year,
                   y = total_gdp_tn, 
                   group = region)

cols <- brewer.pal(7, "Set1")

saveWidget(gdp_regions_a, "gdp_regions_a.html", selfcontained = FALSE, libdir = "src", background = "white")

gdp_regions_b <- highchart() %>%
  hc_add_series_df(data = gdp_regions,
                   type = "line",
                   x = year,
                   y = total_gdp_tn, 
                   group = region) %>%
  hc_colors(cols) %>%
  hc_xAxis(title = list(text="Year")) %>%
  hc_yAxis(title = list(text="GDP ($ trillion)")) %>%
  hc_plotOptions(series = list(marker = list(symbol = "circle")))

saveWidget(gdp_regions_b, "gdp_regions_b.html", selfcontained = FALSE, libdir = "src", background = "white")


# make leaflet map centered on Jacksonville
jacksonville_a <- leaflet() %>% 
  setView(lng = -81.65, lat = 30.3, zoom = 11) %>%
  addTiles()

saveWidget(jacksonville_a, "jacksonville_a.html", selfcontained = FALSE, libdir = "src", background = "white")


# make leaflet map centered on Jacksonville with Carto tiles
jacksonville_b <- leaflet() %>% 
  setView(lng = -81.65, lat = 30.3, zoom = 11) %>%
  addProviderTiles("CartoDB.Positron") 

saveWidget(jacksonville_b, "jacksonville_b.html", selfcontained = FALSE, libdir = "src", background = "white")


# load seismic risk shapefile
seismic_risk <- readOGR("seismic_risk_clip", "seismic_risk_clip")

# load quakes data from USGS earthquakes API
quakes <- read_csv("http://earthquake.usgs.gov/fdsnws/event/1/query?starttime=1965-01-01T00:00:00&minmagnitude=6&format=csv&latitude=39.828175&longitude=-98.5795&maxradiuskm=6000&orderby=magnitude")


# view summary of seismic_risk data
summary(seismic_risk)


# set breaks for custom bins
breaks <- c(0,19,39,59,79,200)

# set palette
binpal <- colorBin("Reds", seismic_risk$ACC_VAL, breaks)

# make choropleth map of seismic risks
seismic_a <- leaflet() %>%
  setView(lng = -98.5795, lat = 39.828175, zoom = 4) %>%
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(
    data = seismic_risk,
    stroke = FALSE,
    fillOpacity = 0.7,
    smoothFactor = 0.1,
    color = ~binpal(ACC_VAL)
  )

saveWidget(seismic_a, "seismic_a.html", selfcontained = FALSE, libdir = "src", background = "white")


# make choropleth map of seismic hazards
seismic_b <- leaflet() %>%
  setView(lng = -98.5795, lat = 39.828175, zoom = 4) %>%
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(
    data = seismic_risk,
    stroke = FALSE,
    fillOpacity = 0.7,
    smoothFactor = 0.1,
    color = ~binpal(ACC_VAL)
  ) %>%
  # add historical earthquakes
  addCircles(
    data = quakes, 
    radius = sqrt(10^quakes$mag)*50, 
    color = "#000000",
    weight = 0.2,
    fillColor ="#ffffff",
    fillOpacity = 0.3,
    popup = paste0("<strong>Magnitude: </strong>", quakes$mag, "</br>",
                   "<strong>Date: </strong>", format(as.Date(quakes$time), "%b %d, %Y"))
  )

saveWidget(seismic_b, "seismic_b.html", selfcontained = FALSE, libdir = "src", background = "white")


# retrieve data for each company
google <- getSymbols("GOOG", src = "yahoo", auto.assign = FALSE)
facebook <- getSymbols("FB", src = "yahoo", auto.assign = FALSE)
amazon <- getSymbols("AMZN", src = "yahoo", auto.assign = FALSE)

# combine adjusted prices into a single xts object
companies <- cbind(google$GOOG.Adjusted, facebook$FB.Adjusted, amazon$AMZN.Adjusted)

names(companies) <- c("Google","Facebook","Amazon")

companies_a <- dygraph(companies)

saveWidget(companies_a, "companies_a.html", selfcontained = FALSE, libdir = "src", background = "white")

companies_b <- dygraph(companies, ylab = "Adjusted close") %>% 
  dyOptions(colors = brewer.pal(3, "Set1")) %>%
  dyRangeSelector() %>%
  dyAxis("x", drawGrid = FALSE)

saveWidget(companies_b, "companies_b.html", selfcontained = FALSE, libdir = "src", background = "white")

# filter data for 2014 only
longevity <- nations %>%
  filter(year == 2014 & !is.na(life_expect)) %>%
  mutate(life_expect = round(life_expect, 2)) %>%
  select(country, income, region, life_expect) %>%
  arrange(desc(life_expect))
          
# rename the variables for display in the table
names(longevity) <- c("Country","Income group","Region","Life expectancy")


longevity_a <- datatable(longevity)
saveWidget(longevity_a, "longevity_a.html", selfcontained = FALSE, libdir = "src", background = "white")


longevity_b <- datatable(longevity,  
          rownames = FALSE) %>% 
          formatStyle("Life expectancy",
                      color = "red",
                      fontWeight = "bold")

saveWidget(longevity_b, "longevity_b.html", selfcontained = FALSE, libdir = "src", background = "white")


