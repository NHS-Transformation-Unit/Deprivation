
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
