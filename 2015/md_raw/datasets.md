# Datasets

Click on the title links to download the data for each session. Unzip the folders and place them on your desktop.

### [Basic principles/geocoding](data/starting.zip)

- `sf_test_addresses.tsv` Text file containing a list of 100 addresses in San Francisco, derived by ["reverse geocoding"](http://en.wikipedia.org/wiki/Reverse_geocoding) from a sample of San Francisco reported crime incidents. Note that these are not the exact locations of crimes, as the original locations were not precisely mapped to address, see [here](https://data.sfgov.org/data?category=Public%20Safety) for details. (The file has been given the extension `.tsv`, for "tab-separated values," so that the commas in the addresses will not be interpreted as separators between fields in the data by the software we will use to geocode it.)
- `sf_addresses_short.tsv` The first 10 addresses from the previous file.
- `CA_counties_medicare.xls` Data on Medicare reimbursements per enrollee by county in California in 2012, from the [Dartmouth Atlas of Health Care](http://www.dartmouthatlas.org/), in "wide" format. Contains the following fields:
 - `state` "CA" in all cases
 - `state_code` Two digit numeric [FIPS code](https://www.census.gov/geo/reference/codes/cou.html) for California; "06" in all cases.
 - `county_code` Three digit FIPS county code.
 - `county` "Alameda County" etc.
 - `county_name` "Alameda" etc.
 - Plus six fields detailing medicare reimbursements per enrollee, in various categories.
- `gdp_pc_2013.csv` CSV file with [World Bank data](http://data.worldbank.org/indicator/NY.GDP.PCAP.PP.CD) on GDP per capita for the world's nations in 2013, in current international dollars, corrected for purchasing power in different terrorities.

### [QGIS](data/qgis.zip)

##### Medicare

- `CA_counties_medicare` Shapefile with data on Medicare reimbursement per enrollee by California county in 2012, from the [Dartmouth Atlas of Healthcare](http://www.dartmouthatlas.org). Includes the following fields:
 - `enrollees` Medicare enrollees in 2012.
 - `total` Total Medicare reimbursements per enrollee.
 - `hospital` Hospital & skilled nursing facility reimbursements per enrollee.
 - `physician` Physician reimbursements per enrollee.
 - `outpatient` Outpatient facility reimbursements per enrollee.
 - `homehealth` Home health agency reimbursements per enrollee.
 - `hospice` Hospice reimbursements per enrollee.
 - `medequip` Durable medical equipment reimbursements per enrollee.
- `ca_counties.zip` Zipped shapefile with boundary data for counties in California, edited from [national U.S. Census Bureau shapefile](http://www.census.gov/cgi-bin/geo/shapefiles2014/main).
- `CA_counties_medicare.csv` `CA_counties_medicare.csvt` Data on Medicare reimbursement per enrollee by California county in 2012, broadly as described above, also including `state_code` and `county_code` -- [FIPS codes](https://www.census.gov/geo/reference/codes/cou.html) that will allow the data to be joined to the boundaries shapefile.
- `Healthcare_Facility_Locations.csv` Locations of hospitals and other healthcare facilities in California, from the [California Department of Public Health](https://cdph.data.ca.gov/Facilities-and-Services/Healthcare-Facility-Locations/tjeb-68c7).

##### Prostate

- `HRR.kml` Boundaries for  "hospital referral regions," defined by the Dartmouth Atlas project as "regional health care markets for tertiary medical care," generally requiring the services of a major referral center.

- `prostate_cancer_hrr.csv` Data on prostate cancer screening, incidence and treatment by hospital referral region, [from the Dartmouth Atlas](http://www.dartmouthatlas.org/tools/downloads.aspx) project. Includes the following fields:
 - `pc_psa` Percent of male enrollees age 68-74 having PSA test (2010). 
 - `incidence` Incidence of prostate cancer per 1,000 male Medicare beneficiaries.
 - `prostatectomy` Prostatectomy per 1,000 male Medicare beneficiaries with prostate cancer (75 and under).
 - `radiation` Radiation treatment per 1,000 male Medicare beneficiaries over age 75 with prostate cancer.
 - `hormone` Hormone therapy per 1,000 male Medicare beneficiaries over age 75 with prostate cancer.
 - `no_treat` No treatment/delayed treatment  per 1,000 male Medicare beneficiaries over age 75 with prostate cancer.

These two files can be joined in QGIS using the common field `HRR_BDRY_I`, a code for hospital referral region.

##### General

- `ne_50m_admin_0_countries` `ne_50m_lakes` Global shapefiles from [Natural Earth](http://www.naturalearthdata.com/) giving boundaries for nations and lakes respectively.

- `tl_2014_us_county` `tl_2014_us_state` County and State boundary shapefiles form the [U.S. Census Bureau](http://www.census.gov/cgi-bin/geo/shapefiles2014/main).

These shapefiles may prove useful if you want to make and style basemap layers for any of your maps.

### [Tableau Public](data/tableau.zip)

##### Healthcare

- `CA_counties_medicare_long.csv` Data on Medicare reimbursements per enrollee by county in California in 2012, in "long" format. Fields as described above, except the following:
 - `type` Groups medicare reimbursements by type, including hospitals and skilled nursing facilities, physician payments, hospices, and so on.
 - `cost` Medicare reimbursement per enrollee, adjusted for variations in age, sex, race and regional pricing of medical goods and services.
- `Healthcare_Facility_Locations.csv` Locations of hospitals and other healthcare facilities in California, as described above.


##### Nations

- `wealth_life.csv` [World Bank data](http://data.worldbank.org/indicator/all), containing the following fields for the world's nations, from 1990 onwards:
 - `iso_a3` [Three-letter code](http://unstats.un.org/unsd/tradekb/Knowledgebase/Country-Code) for each country, assigned by the [International Organization for Standardization](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=63545).
 - `country` Country name.
 - `year`
 - `region` `income_group` World Bank [regions and current income groups](http://siteresources.worldbank.org/DATASTATISTICS/Resources/CLASS.XLS), explained [here](http://data.worldbank.org/about/country-and-lending-groups).
 - `gdp_pc` [Gross Domestic Product per capita](http://data.worldbank.org/indicator/NY.GDP.PCAP.PP.CD) in current international dollars, corrected for purchasing power in different territories.
 - `life_expect` [Life expectancy](http://data.worldbank.org/indicator/SP.DYN.LE00.IN) in years for a child born in the year in question, if prevailing patterns were to stay the same throughout its life.
 - `population` Estimated [total population](http://data.worldbank.org/indicator/SP.POP.TOTL) at mid-year, including all residents apart from refugees.


### [Fusion Tables](data/fusion.zip)

- `HRR.kml` Boundaries for Dartmouth Atlas of Health Care hospital referral regions, as described above
- `prostate_cancer_hrr.xlsx` Spreadsheet with Dartmouth Atlas data on prostate cancer screening, incidence and treatment by hospital referral region.
- `Healthcare_Facility_Locations.csv` Locations of hospitals and other healthcare facilities in California, as described above.
- `CA_counties_medicare.csv` Data on Medicare reimbursements per enrollee in 2012, by California county, as described above.
- `ca_counties.zip` Zipped shapefile with boundary data for counties in California, as described above.

The Tableau Public and Fusion Tables folders also contain a template web page, `test.html`, for embedding maps.






