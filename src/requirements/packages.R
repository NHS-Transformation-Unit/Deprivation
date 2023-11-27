packages <- c("here",
              "tidyverse",
              "openxlsx",
              "leaflet",
              "sf",
              "shiny",
              "plotly",
              "markdown")


lapply(packages, library, character.only=TRUE)
