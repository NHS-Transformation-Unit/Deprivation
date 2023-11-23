
# Geojson urls ------------------------------------------------------------

geojson_lsoa_url <-"https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LSOA_Dec_2011_Boundaries_Generalised_Clipped_BGC_EW_V3/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"
geojson_la_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_May_2023_UK_BGC_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"
geojson_subicb_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Sub_Integrated_Care_Board_Locations_April_2023_EN_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"
geojson_icb_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Integrated_Care_Boards_April_2023_EN_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"
geojson_lsoa_lookup_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LSOA11_SICBL22_ICB22_LAD22_EN_LU/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"


# Load geojson urls -------------------------------------------------------

geojson_lsoa <- st_read(geojson_lsoa_url)
geojson_la <- st_read(geojson_la_url)
geojson_subicb <- st_read(geojson_subicb_url)
geojson_icb <- st_read(geojson_icb_url)
lsoa_lookup <- st_read(geojson_lsoa_lookup_url)
