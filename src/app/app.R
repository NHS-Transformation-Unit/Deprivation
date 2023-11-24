
# Setup -------------------------------------------------------------------

source("../requirements/packages.R")
source("../etl/geojson.R")
source("../etl/load.R")
source("../etl/geo_linkage.R")
source("../visualisation/maps.R")




# ui ----------------------------------------------------------------------

ui <- fluidPage(

    # Application title
    titlePanel("ICB Deprivation Dashboard"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("icb",
                        "Select ICB:",
                        choices = sort(unique(imd_geo$ICB22NM))),
            selectInput("metric",
                        "Select Deprivation Domain:",
                        choices = unique(imd_geo$Metric_Tidy))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           leafletOutput("deprivation_map"),
           plotlyOutput("dep_deciles_plot")
        )
    )
)


# server ------------------------------------------------------------------

server <- function(input, output) {

  imd_geo_filtered <- reactive({
    imd_geo %>%
      filter(ICB22NM == input$icb,
             Metric_Tidy == input$metric
      )
    
    
  })
  
  geo_icb_filtered <- reactive({
    
    geojson_icb_linked %>%
      filter(ICB22NM == input$icb)
    
  })
  
  
    
    output$deprivation_map <- renderLeaflet({
      
      lsoa_map(imd = imd_geo_filtered(), geo_icb = geo_icb_filtered())
      
    })
    
    
    output$dep_deciles_plot <- renderPlotly(
      
      lsoa_decile_plot(imd = imd_geo_filtered())
      
    )
    
}

# run ---------------------------------------------------------------------

shinyApp(ui = ui, server = server)