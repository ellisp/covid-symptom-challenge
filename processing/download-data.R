# This script downloads data from the server set up for bulk downloads
#
# Peter Ellis 25 September 2020

#--------Main survey data by country---------------

baseurl <- "https://covidmap.umd.edu/umdcsvs/Full%20Survey%20Data/country/"
filelist <- readLines(baseurl)
csvs <- unlist(str_extract_all(filelist, '0.*?\\.csv'))

for(i in 1:length(csvs)){
  
  if(!csvs[i] %in% list.files(path = "raw-data/country", pattern = ".csv")){
    download.file(glue(baseurl, csvs[i]),
                  glue("raw-data/country/", csvs[i]))
  }
}

#--------------Main survey data by region-------------

baseurl <- "https://covidmap.umd.edu/umdcsvs/Full%20Survey%20Data/region/"
filelist <- readLines(baseurl)
csvs <- unique(unlist(str_extract_all(filelist, '0.*?\\.csv')))

for(i in 1:length(csvs)){
  
  if(!csvs[i] %in% list.files(path = "raw-data/region", pattern = ".csv")){
    download.file(glue(baseurl, csvs[i]),
                  glue("raw-data/region/", csvs[i]))
  }
}
