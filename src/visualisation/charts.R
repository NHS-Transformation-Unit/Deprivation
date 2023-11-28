
# LSOA Decile Plot --------------------------------------------------------

lsoa_decile_plot <- function(imd){
  
  dep_deciles <- imd %>%
    st_drop_geometry() %>%
    group_by(ICB22NM, Metric_Tidy, Metric_Short, Decile) %>%
    summarise("LSOAs" = n()) %>%
    mutate("Prop" = LSOAs/sum(LSOAs)) %>%
    mutate(Decile = factor(Decile, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)))
  
  plot_title <- paste0("Proportion of ", dep_deciles[[1,1]], "<br>", "LSOAs in each deprivation decile for ", dep_deciles[[1,2]])
  
  hline <- function(y = 0, color = "black") {
    list(
      type = "line", 
      x0 = 0, 
      x1 = 1, 
      xref = "paper",
      y0 = y, 
      y1 = y, 
      line = list(color = color),
      style = "dashed"
    )
  }
  
  dep_deciles %>%
    plot_ly(x = ~`Decile`, y = ~Prop, type = "bar",
            hoverinfo = 'text', text = ~paste0("Decile ", `Decile`, ": ",
                                               round(`Prop`*100,2), "%"), textposition = "none") %>%
    layout(shapes = list(hline(0.1)),
           title = list(text = plot_title),
           xaxis = list(title = list(text = "IMD Decile")),
           yaxis = list(title = list(text = "Proportion of LSOAs"),
                        tickformat = ".0%"),
           margin = list(t = 50))
  
  
  
}


# LSOA Decile Plot - ICB Comparison ---------------------------------------

lsoa_decile_icb_comp_plot <- function(imd){
  
  dep_deciles <- imd %>%
    st_drop_geometry() %>%
    group_by(ICB22NM, Metric_Tidy, Metric_Short, Decile) %>%
    summarise("LSOAs" = n()) %>%
    mutate("Prop" = LSOAs/sum(LSOAs)) %>%
    mutate(Decile = factor(Decile, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)))
  
  plot_title <- paste0("Proportion of ", dep_deciles[[1,1]], "<br>", "LSOAs in each deprivation decile for ", dep_deciles[[1,2]])
  
  hline <- function(y = 0, color = "black") {
    list(
      type = "line", 
      x0 = 0, 
      x1 = 1, 
      xref = "paper",
      y0 = y, 
      y1 = y, 
      line = list(color = color),
      style = "dashed"
    )
  }
  
  dep_deciles %>%
    plot_ly(x = ~`Decile`, y = ~Prop, type = "bar", color = ~ICB22NM, colors = c("#407EC9", "#8A1538"),
            hoverinfo = 'text', text = ~paste0("Decile ", `Decile`, ": ",
                                               round(`Prop`*100,2), "%"), textposition = "none") %>%
    layout(shapes = list(hline(0.1)),
           title = list(text = plot_title),
           xaxis = list(title = list(text = "IMD Decile")),
           yaxis = list(title = list(text = "Proportion of LSOAs"),
                        tickformat = ".0%"),
           margin = list(t = 50),
           legend = list(x = 0.5, y = -0.3))
  
  
  
}

test_imd <- imd_geo %>%
  filter(ICB22NM %in% c("NHS North East London Integrated Care Board", "NHS North East and North Cumbria Integrated Care Board")) %>%
  filter(Metric_Tidy == "Crime")


lsoa_decile_icb_comp_plot(test_imd)
