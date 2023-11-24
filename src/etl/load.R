
# Data URLs ---------------------------------------------------------------

imd_domains_2019_url <- "https://assets.publishing.service.gov.uk/media/5d8b3ade40f0b60999a23330/File_2_-_IoD2019_Domains_of_Deprivation.xlsx"


# Load raw files and process ----------------------------------------------------------

imd_domains_2019 <- read.xlsx(imd_domains_2019_url, sheet = 2) %>%
  rename("LSOA_Code_2011" = 1,
         "LSOA_Name_2011" = 2,
         "LA_District_Code_2019" = 3,
         "LA_District_Name_2019" = 4,
         "IMD_Rank" = 5,
         "IMD_Decile" = 6,
         "Income_Rank" = 7,
         "Income_Decile" = 8,
         "Employment_Rank" = 9,
         "Employment_Decile" = 10,
         "Edu_Skills_Train_Rank" = 11,
         "Edu_Skills_Train_Decile" = 12,
         "Health_Disability_Rank" = 13,
         "Health_Disability_Decile" = 14,
         "Crime_Rank" = 15,
         "Crime_Decile" = 16,
         "Housing_Barriers_Rank" = 17,
         "Housing_Barriers_Decile" = 18,
         "Living_Environment_Rank" = 19,
         "Living_Environment_Decile" = 20)

imd_domains_2019_long <- imd_domains_2019 %>%
  gather(Metric, Value, -c(1:4)) %>%
  mutate(Metric_Type = case_when(grepl("Rank", Metric) ~ "Rank",
                                 TRUE ~ "Decile"),
         Metric_Short = case_when(Metric_Type == "Rank" ~ str_sub(Metric, start = 1, end = nchar(Metric) - 5),
                                   TRUE ~ str_sub(Metric, start = 1, end = nchar(Metric) - 7)),
         Metric_Tidy = case_when(Metric_Short == "IMD" ~ "Overall IMD",
                                 Metric_Short == "Income" ~ "Income",
                                 Metric_Short == "Employment" ~ "Employment",
                                 Metric_Short == "Edu_Skills_Train" ~ "Education, Skills and Training",
                                 Metric_Short == "Health_Disability" ~ "Health Deprivation and Disability",
                                 Metric_Short == "Crime" ~ "Crime",
                                 Metric_Short == "Housing_Barriers" ~ "Barriers to Housing and Services",
                                 Metric_Short == "Living_Environment" ~ "Living Environment",
                                 TRUE ~ Metric_Short)
  ) %>%
  select(-c(Metric)) %>%
  spread(Metric_Type, Value)


