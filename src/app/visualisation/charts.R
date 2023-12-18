
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
  
  plot_title <- paste0("Proportion of LSOAs in each deprivation decile for ", dep_deciles[[1,2]])
  
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
    plot_ly(x = ~`Decile`, y = ~Prop, type = "bar", color = ~ICB22NM, colors = c("#407EC9", "#F68D2E"),
            hoverinfo = 'text', text = ~paste0("Decile ", `Decile`, ": ",
                                               round(`Prop`*100,2), "%"), textposition = "none") %>%
    layout(shapes = list(hline(0.1)),
           title = list(text = plot_title),
           xaxis = list(title = list(text = "IMD Decile")),
           yaxis = list(title = list(text = "Proportion of LSOAs"),
                        tickformat = ".0%"),
           margin = list(t = 50),
           legend = list(
             orientation = 'h',
             x = 0.5,
             y = -0.2
           ))
  
  
  
}


# Domain Comparison -------------------------------------------------------

lsoa_decile_domain_comp_plot <- function(imd) {
  
  dep_domains <- imd %>%
    st_drop_geometry() %>%
    filter(Metric_Short != "IMD") %>%
    group_by(Metric_Short, Metric_Tidy, Decile) %>%
    summarise(LSOAs = n()) %>%
    mutate(Total = sum(LSOAs),
           Prop = LSOAs/Total) %>%
    mutate(Decile = factor(Decile, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)))
  
  
  domain_plot <- . %>% 
    plot_ly(x = ~Decile, y = ~Prop, fill = ~Metric_Tidy, type = "bar",
            hoverinfo = 'text', text = ~paste0(Metric_Tidy, " - Decile ", Decile, ": ",
                                               round(Prop*100,2), "%"), textposition = "none"
    ) %>%
    add_annotations(
      text = ~unique(Metric_Tidy),
      x = 0.25,
      y = 1.05,
      yref = "paper",
      xref = "paper",
      xanchor = "left",
      yanchor = "top",
      showarrow = FALSE,
      font = list(size = 10)
    ) %>%
    layout(shapes = list(hline(0.1)),
           title = list(text = "IMD Domains"),
           xaxis = list(title = list(text = "IMD Decile", standoff = 1)),
           yaxis = list(title = list(text = "Proportion of LSOAs"),
                        tickformat = ".0%"),
           showlegend = FALSE,
           margin = list( t= 40))

  dep_domains %>%
  group_by(Metric_Tidy) %>%
  do(p = domain_plot(.)) %>%
  subplot(nrows = 2, shareX = FALSE, shareY = TRUE, titleX = TRUE, margin = 0.05)

}
