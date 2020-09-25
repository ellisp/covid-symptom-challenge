

csvs <- list.files("raw-data", pattern = "country_full\\.csv$", full.names = TRUE)

raw_data_l <- lapply(csvs, read_csv)

raw_data <- bind_rows(raw_data_l)
