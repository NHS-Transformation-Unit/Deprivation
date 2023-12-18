<img src="images/TU_logo_large.png" alt="TU logo" width="200" align="right"/>

# Deprivation Explorer Shiny App for ICBs
This repository contains the scripts to create an app to explore the 2019 Index of Multiple Deprivation (**IMD**) published by the [Ministry of Housing, Communities and Local Government](https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019) for Integrated Care Boards (**ICBs**).

A version of the app is currently deployed and available for viewing [here](https://nhs-tu-andy-wilson.shinyapps.io/ICB_Deprivation_Explorer/).

<br/>

## Using the Repo
To re-create the Shiny App, simply clone the repository from GitHub and run the script `app.R` to re-create the app locally. The section below shows the structure of the repository to explain the code used to create the app. All data is publicly available for access and analysis under the terms of the Open Government License ([OGL](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)).

<br>

## Repo Structure

At present the structure of the repository is:

``` plaintext

├───images
└───src
    ├───app
      ├───config
      ├───etl
      ├───requirements
      └───visualisation
      └───www
    
```

<br/>

### `images`

Images such as TU logos and branding to add to outputs.

### `src`

All code is stored in src within the `app` folder for deployment. This is subdivided into five modules:

1. `config`: Files for configuring the output such as the `theme.css`.
2. `etl`: Files for downloading and processing IMD dataset and linking to relevant geospatial files.
3. `requirements`: Requirements file for building the output html such as the `packages.R` script.
4. `visualisation`: Files for producing the visualisations (charts and maps) used within the outputs.
5. `www`: Image and css files for deployment.

## Contributors

This repository has been created and developed by:

-   [Andy Wilson](https://github.com/ASW-Analyst)