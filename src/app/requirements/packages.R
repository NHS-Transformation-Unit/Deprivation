packages <- c("here",
              "tidyverse",
              "openxlsx",
              "leaflet",
              "sf",
              "shiny",
              "plotly",
              "markdown",
              "knitr")


lapply(packages, library, character.only=TRUE)
