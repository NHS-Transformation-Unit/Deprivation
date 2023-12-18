
# Setup -------------------------------------------------------------------

source("requirements/packages.R")
source("etl/geojson.R")
source("etl/load.R")
source("etl/geo_linkage.R")
source("visualisation/maps.R")
source("visualisation/charts.R")



# ui ----------------------------------------------------------------------

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "nhs_tu_theme.css"),
    tags$style(HTML("
      .title-with-image {
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: relative;
      }
      .title-image {
        max-width: 100%;
        height: 100%;
        position: absolute;
        top: 0;
        right: 0;
        margin: 10px;
      }
    ")),
    tags$script(HTML('
      $(document).ready(function(){
        // Set the height of the image to match the titlePanel
        var titlePanelHeight = $(".title-with-image").height();
        $(".title-image").height(titlePanelHeight);
      });
    '))
  ),
    
  titlePanel(
    div(
      h1("ICB Deprivation Dashboard"),
      img(src = "TU_logo_large.png", class = "title-image"),
      
      class = "title-with-image")

  ),

    tabsetPanel(
      tabPanel("Introduction",
               h2("Introduction to the ICB Deprivation Dashboard"),
               HTML("<hr/>"),
               HTML("<br/>
                    This dashboard has been created to provide an insight into the deprivation of the population of residents living within each ICB across England.
                    You can navigate through the different pages of this dashboard by clicking on the tabs at the top of the page. All of the data used to create this
                    dashboard is publicly available, please see the Metadata page for more information on all sources. The code for creating this dashboard is available
                    on the NHS Transformation Unit's GitHub page <a href = 'https://github.com/NHS-Transformation-Unit/Deprivation' target='_blank'>here</a>."),
               h3("How is deprivation measured?"),
               HTML("The deprivation of the resident population of an area is measured using the <b>Index of Multiple Deprivation</b>
                 (IMD). This index is constructed from the indicies of deprivation covering seven domains. These are:"),
               HTML("<ul>
                      <li>Income Deprivation</li>
                      <li>Employment Deprivation</li>
                      <li>Education, Skills and Training Deprivation</li>
                      <li>Health Deprivation and Disability</li>
                      <li>Crime</li>
                      <li>Barries to Housing and Services</li>
                      <li>Living Environment Deprivation</li>
                    </ul>
                    <br>
                    Each <b>Lower Super Output Area</b> (LSOA) in England is scored and ranked using the IMD from the least deprived to the most deprived. LSOAs are a geographic hierarchy used 
                    within England and Wales to improve the reporting of small area statistics. Each LSOA has a minimum resident population of 1,000 people and they have an average of 1,500.
                    More information on how the IMD is calculated can be found <a href = 'https://assets.publishing.service.gov.uk/media/5dfb3d7ce5274a3432700cf3/IoD2019_FAQ_v4.pdf' target='_blank'>here</a>.
                    Each LSOA is then ordered based on this ranking and assigned to a deprivation decile with 1 representing the most deprived and 10 representing the least deprived (or most affluent). The 
                    IMD was last calculated in 2019 for the LSOAs in England.
                    <br>
                    
                    "),
               h3("What is contained within the dashboard?"),
               HTML("This dashboard has been created to enable the user to explore the deprivation of residents within each ICB with a particular focus on:
                    <ul>
                      <li>Identifying areas of deprivation</li>
                      <li>Exploring the variation of deprivation across the ICB</li>
                      <li>Understanding how the domains of deprivation are driving the overall IMD for the LSOAs within the ICB</li>
                      <li>Comparing the domains of deprivation for different ICBs</li>
                    </ul>
                    <br>"),
               h3("Who are the NHS Transformation Unit?"),
               HTML("The NHS Transformation Unit (TU) is an <b>internal NHS team</b> of NHS consultants, working alongside health and care clients to deliver major change programmes since 2015. 
                    We work in partnership with our clients to transform care and health outcomes for people and communities, empowering change from within. Please see our
                    <a href = 'https://transformationunit.nhs.uk/' target='_blank'>website</a> to see more about the services we provide.")),
      
      tabPanel("ICB Overview",
     
    sidebarLayout(
        sidebarPanel(width = 3,
            selectInput("icb",
                        "Select ICB:",
                        choices = sort(unique(imd_geo$ICB22NM))),
            selectInput("metric",
                        "Select Deprivation Domain:",
                        choices = unique(imd_geo$Metric_Tidy))
        ),

        
        mainPanel(
           h2("ICB Overview"),
           HTML("<hr/>
                The map below shows the LSOAs for the selected ICB, with the hue of the LSOA based of their deprivation 
                decile for the selected domain of deprivation. You can use the map controls to move around the map and to 
                zoom in and out on areas. Hovering over an LSOA will show you the name of this location and the its decile.
                <br>
                "),
           leafletOutput("deprivation_map"),
           HTML("<br>
                The chart below shows the percentage of LSOAs within the ICB that reside within each of the deprivation deciles 
                for the selected deprivation domain. For reference a horizontal line representing 10% has been added to the chart 
                to help identify if the ICB has a disporportinately high or low percentage of LSOAs in any particular decile.
                <br>"),
           plotlyOutput("dep_deciles_plot")
        )
    )
      ),
    tabPanel(
      "Compare Deprivation Domains",
      sidebarLayout(
        sidebarPanel(width = 3,
                     selectInput("icb_domain",
                                 "Select ICB:",
                                 choices = sort(unique(imd_geo$ICB22NM)))
        ),
        mainPanel(
          h2("Compare Deprivation Domains"),
          HTML("<hr>
               Select an ICB from the dropdown to update the chart below and show a breakdown of the 
               number of LSOAs in each decile for the domains.
               <br>
               <br>"),
          plotlyOutput("domain_comp")
        ),
      )
    ),
    tabPanel(
      "Compare ICBs",
      sidebarLayout(
        sidebarPanel(width = 3,
                     selectInput("icb_comp1",
                                 "Select first ICB:",
                                 choices = sort(unique(imd_geo$ICB22NM))),
                     selectInput("icb_comp2",
                                 "Select second ICB:",
                                 choices = NULL),
                     selectInput("metric_icb_comp",
                                 "Select Deprivation Domain:",
                                 choices = unique(imd_geo$Metric_Tidy))
        ),
      
        mainPanel(
          h2("Compare ICBs Deprivation Domains"),
          HTML("<hr>
               Select two ICBs to compare using the dropdowns to the left to update the maps and the chart below.
               The deprivation domain can also be changed using the final dropdown menu.
               <br>
               <br>"),
          fluidRow(
          column(6, leafletOutput("deprivation_map_icb1")),
          column(6, leafletOutput("deprivation_map_icb2"))
          ),
          HTML("<br>
               <br>"),
          fluidRow(plotlyOutput("dep_deciles_icb_comp_plot")
          ),
          plotlyOutput("dep_deciles_plot_icb_comp")
        )
      )
    ),
    tabPanel(
      "Metadata",

        h2("Metadata"),
        HTML("<hr/>
             <br/>"),
        h3("Data Sources"),
        HTML("The following data sources have been used for the creation of this dashboard:
             <ul>
              <li>The 2019 IMD deprivation data which provides the data for the score, rank and decile that each
             LSOA is assigned to across each of the domains of deprivation is sourced from the <a href = 'https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019'
             target='_blank'>Minsitry of Housing, Communities and Local Government</a>.</li>
              <li>The geometries for the ICB and LSOA maps were sourced from the <a href = 'https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_HLT)'
             target = '_blank'>Open Geography Portal</a>.</li>
              <li>The mapping of LSOAs to ICBs has been sourced from the <a href = 'https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-created&tags=all(LUP_LSOA11_SICBL_ICB_LAD)'
             target = '_blank'>Open Geography Portal</a>.</li>
             </ul>
             <br>
             "),
        h3("GitHub Repository"),
        HTML("The code required to rebuild this dashboard using the R programming language and Shiny is available on 
             the <a href = 'https://github.com/NHS-Transformation-Unit/' target = '_blank'>NHS Transformation Unit's GitHub page</a> with the repository 
             available <a href = 'https://github.com/NHS-Transformation-Unit/Deprivation' target = 'blank'>here</a>. Please follow
             the instructions on cloning the repository within the <b>ReadMe</b> file.")
      )
    )
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {

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
  
  
  
  ##ICB Comparisons
  
  selected_items <- reactiveValues(first = NULL, second = NULL)
  
  observe({
    # Update the selected item in the reactiveValues
    selected_items$first <- input$icb_comp1
    
    # Preserve the selected item in the second dropdown
    selected_second <- isolate(input$second_dropdown)
    
    # Filter choices for the second dropdown based on the selected item in the first dropdown
    choices_second_dropdown <- sort(setdiff(unique(imd_geo$ICB22NM), selected_items$first))
    
    # Update choices in the second dropdown
    updateSelectInput(session, "icb_comp2", choices = choices_second_dropdown, selected = selected_second)
  })
  
  imd_geo_filtered_icb1 <- reactive({
    imd_geo %>%
      filter(ICB22NM == input$icb_comp1,
             Metric_Tidy == input$metric_icb_comp
      )
    
    
  })
  
  geo_icb_filtered_icb1 <- reactive({
    
    geojson_icb_linked %>%
      filter(ICB22NM == input$icb_comp1)
    
  })
  
  imd_geo_filtered_icb2 <- reactive({
    imd_geo %>%
      filter(ICB22NM == input$icb_comp2,
             Metric_Tidy == input$metric_icb_comp
      )
    
    
  })
  
  geo_icb_filtered_icb2 <- reactive({
    
    geojson_icb_linked %>%
      filter(ICB22NM == input$icb_comp2)
    
  })  
  
  
  imd_geo_filtered_icb_comp <- reactive({
    imd_geo %>%
      filter(ICB22NM %in%  c(input$icb_comp1, input$icb_comp2),
             Metric_Tidy == input$metric_icb_comp
      ) %>%
      mutate(ICB22NM = factor(ICB22NM, levels = c(input$icb_comp1, input$icb_comp2)))


  })
  
  imd_geo_filtered_domain_comp <- reactive({
    imd_geo %>%
      filter(ICB22NM == input$icb_domain)
    
  })
  
  
    output$deprivation_map <- renderLeaflet({
      
      lsoa_map(imd = imd_geo_filtered(), geo_icb = geo_icb_filtered(), pal = "Blues")
      
    })
    
    
    output$dep_deciles_plot <- renderPlotly(
      
      lsoa_decile_plot(imd = imd_geo_filtered())
      
    )
    
    
    output$deprivation_map_icb1 <- renderLeaflet({
      
      lsoa_map(imd = imd_geo_filtered_icb1(), geo_icb = geo_icb_filtered_icb1(), pal = "Blues")
      
    })
    
    output$deprivation_map_icb2 <- renderLeaflet({
      
      lsoa_map(imd = imd_geo_filtered_icb2(), geo_icb = geo_icb_filtered_icb2(), pal = "Oranges")
      
    })
    
    
    output$dep_deciles_icb_comp_plot <- renderPlotly(
      
      lsoa_decile_icb_comp_plot(imd = imd_geo_filtered_icb_comp())
    )
    
    output$domain_comp <- renderPlotly({
      
      lsoa_decile_domain_comp_plot(imd = imd_geo_filtered_domain_comp())
      
    })
    
}

# run ---------------------------------------------------------------------

shinyApp(ui = ui, server = server)