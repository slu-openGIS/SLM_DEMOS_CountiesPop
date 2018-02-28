#!/usr/bin/env bash

# create .geoJSON file
rm -f -- geoJSON/SLM_DEMOS_CountiesPop.geoJSON
ogr2ogr -f geoJSON -t_srs crs:84 geoJSON/SLM_DEMOS_CountiesPop.geoJSON Shapefile/SLM_DEMOS_CountiesPop.shp