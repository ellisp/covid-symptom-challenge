
#-----------------Main survey by country-----------------
csvs <- list.files("raw-data/country", pattern = "country_full\\.csv$", full.names = TRUE)

raw_data_l <- lapply(csvs, read_csv)

raw_data_countries <- bind_rows(raw_data_l)


#-----------------Main survey by country-----------------
csvs <- list.files("raw-data/region", pattern = "reg_full\\.csv$", full.names = TRUE)

raw_data_l <- lapply(csvs, read_csv)

raw_data_regions <- bind_rows(raw_data_l)