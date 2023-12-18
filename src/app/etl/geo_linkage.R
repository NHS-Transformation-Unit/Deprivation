
# Link geojson lsoa with deprivation --------------------------------------

imd_geo <- geojson_lsoa %>%
  filter(substr(LSOA11CD,1,1) == "E") %>%
  left_join(imd_domains_2019_long, by = c("LSOA11CD" = "LSOA_Code_2011")) %>%
  left_join(lsoa_lookup_df, by = c("LSOA11CD"))



# Link icb boundaries with NHS codes --------------------------------------

icb_code_lookup <- imd_geo %>%
  st_drop_geometry() %>%
  select(ICB22CD, ICB22CDH, ICB22NM) %>%
  group_by(ICB22CD, ICB22CDH, ICB22NM) %>%
  summarise()

geojson_icb_linked <- geojson_icb %>%
  left_join(icb_code_lookup, by = c("ICB23CD" = "ICB22CD"))
