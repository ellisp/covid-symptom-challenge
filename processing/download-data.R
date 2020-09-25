# This script downloads data from the server set up for bulk downloads
#
# Peter Ellis 25 September 2020

baseurl <- "https://covidmap.umd.edu/umdcsvs/Full%20Survey%20Data/country/"
filelist <- readLines(baseurl)
csvs <- unlist(str_extract_all(filelist, '0.*?\\.csv'))

for(i in 1:length(csvs)){
  
  if(!csvs[i] %in% list.files(path = "raw-data", pattern = ".csv")){
    download.file(glue(baseurl, csvs[i]),
                  glue("raw-data/", csvs[i]))
  }
}
