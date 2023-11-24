
# LSOA Map ----------------------------------------------------------------

lsoa_map <- function(imd, geo_icb){
  
  pal_fac_imd<-colorFactor(palette = "Blues", levels = 10:1, domain = imd$Decile)
  
  leaflet(imd) %>%
    addPolygons(data = geo_icb, color = "black", weight = 3) %>%
    addPolygons(stroke = TRUE, weight = 0.4, opacity = 0.5, fillOpacity = 0.6, dashArray = "5, 10",
                color = "white", fillColor = ~pal_fac_imd(Decile),
                label = ~paste0(imd$LSOA11NM.y,": Decile - ", imd$Decile)
    ) %>%
    addProviderTiles(providers$CartoDB.Voyager) %>%
    addLegend(values = imd$Decile, pal = pal_fac_imd, title = "IMD Decile - 2019", position = "topright")
  
  
}
