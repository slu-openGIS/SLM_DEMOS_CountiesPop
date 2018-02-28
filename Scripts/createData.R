# Create STL_HOUSING_MedianAge

## Introduction
## This script creates the shapefile STL_HOUSING_MedianAge

## Dependencies
library(dplyr)
library(here)
library(sf)
library(tidycensus)
library(tigris)

## Create combined census tract object
### download St. Louis census tracts
tracts <- tracts(state = "MO", county = "510")

### convert to sf object
tracts <- st_as_sf(tracts)

### download census tract data
housing <- get_acs(geography = "tract",  state = "MO", county = "510", output = "wide", table = "B25035")


### clean names
housing %>%
  rename(
    ESTIMATE = B25035_001E,
    MOE = B25035_001M
  ) %>%
  select(-NAME) -> housing

### combine spatial and geometric data
medianAge <- left_join(tracts, housing, by = "GEOID")

### re-project from NAD 1983 to Missouri State Plane East
medianAge <- st_transform(medianAge, 102696)

### write shapefile
st_write(medianAge, here("Shapefile", "STL_HOUSING_MedianAge.shp"), delete_dsn = TRUE)
