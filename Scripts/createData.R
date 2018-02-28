# Create SLM_DEMOS_CountiesPop

## Introduction
## This script creates the shapefile SLM_DEMOS_CountiesPop

## Dependencies
library(dplyr)
library(here)
library(sf)
library(tidycensus)
library(tigris)

## Define list of counties
metroWestNames <- c("Franklin", "Jefferson", "Lincoln", "St. Charles", "St. Louis", "Warren")
metroWestNames2 <- c("Franklin County, Missouri", "Jefferson County, Missouri", 
                     "Lincoln County, Missouri", "St. Charles County, Missouri", 
                     "St. Louis County, Missouri", "St. Louis city, Missouri", 
                     "Warren County, Missouri")

## Create combined census tract object
### download missouri counties
moCounties <- counties(state = "MO")

### convert to sf object
moCounties <- st_as_sf(moCounties)

### subset counties
metroWest <- filter(moCounties, NAME %in% metroWestNames)

### download county population data
moPopulation <- get_acs(geography = "county",  state = "MO", output = "wide", variable = "B01001_001")

### subset counties
moPopulation %>%
  filter(NAME %in% metroWestNames2) %>%
  select(GEOID, B01001_001E) %>%
  rename(POP16 = B01001_001E) -> metroWestPop

### combine spatial and geometric data
metroWest <- left_join(metroWest, metroWestPop, by = "GEOID")

# ====================================================================

## Define list of counties
metroEastNames <- c("Clinton", "Jersey", "Madison", "Monroe", "St. Clair")
metroEastNames2 <- c("Clinton County, Illinois", "Jersey County, Illinois", 
                     "Madison County, Illinois", "Monroe County, Illinois", 
                     "St. Clair County, Illinois")

## Create combined census tract object
### download missouri counties
ilCounties <- counties(state = "IL")

### convert to sf object
ilCounties <- st_as_sf(ilCounties)

### subset counties
metroEast <- filter(ilCounties, NAME %in% metroEastNames)

### download county population data
ilPopulation <- get_acs(geography = "county",  state = "IL", output = "wide", variable = "B01001_001")

### subset counties
ilPopulation %>%
  filter(NAME %in% metroEastNames2) %>%
  select(GEOID, B01001_001E) %>%
  rename(POP16 = B01001_001E) -> metroEastPop

### combine spatial and geometric data
metroEast <- left_join(metroEast, metroEastPop, by = "GEOID")


# ====================================================================

### combine files
metroPop <- rbind(metroEast, metroWest)

# ====================================================================


### re-project from NAD 1983 to Missouri State Plane East
medianAge <- st_transform(medianAge, 102696)

### write shapefile
st_write(medianAge, here("Shapefile", "SLM_DEMOS_CountiesPop.shp"), delete_dsn = TRUE)
