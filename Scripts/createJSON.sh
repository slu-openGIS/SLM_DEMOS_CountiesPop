#!/usr/bin/env bash

# create .geoJSON file
rm -f -- geoJSON/STL_HOUSING_MedianAge.geoJSON
ogr2ogr -f geoJSON -t_srs crs:84 geoJSON/STL_HOUSING_MedianAge.geoJSON Shapefile/STL_HOUSING_MedianAge.shp