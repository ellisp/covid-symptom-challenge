dim(raw_data_regions)

names(raw_data_regions)

raw_data_regions[1:10, 1:10]

# grain is country (g Zrgentina), region (eg Buenos Aires), gender, age_bucket

# The number of regions varies per country of course:
raw_data_regions %>%
  count(country_agg, region_agg) %>%
  count(country_agg, name = "number_regions") %>%
  count(number_regions)

# Its' not uncommon to lose some of the other categories when we go by region
# eg often only 'female' and 'overall' available for Australian states and territories:
raw_data_regions %>%
  filter(country_agg == "Australia") %>%
  count(region_agg, gender)


oz_regions <- raw_data_regions %>%
  filter(country_agg == "Australia" & gender == "overall" & age_bucket == "overall")

CairoPDF("output/lots-of-vars-oz-states.pdf", 11, 8)

for(j in 12:ncol(raw_data_regions)){
  oz_regions$tmp <- pull(oz_regions, j)
  if(sum(!is.na(oz_regions$tmp)) < 10){
    next()
  }

  p0 <- oz_regions %>%
    ggplot(aes(x = date, y = tmp)) +
    geom_point() +
    geom_smooth(se = FALSE, span = 1/7, method = "loess", formula = "y ~ x") +
    labs(y = names(oz_regions)[j],
         title = names(oz_regions)[j],
         x = "Date in 2020")
  
  p1 <- p0 + 
    facet_wrap(~region_agg, scales = "free_y") +
    labs(subtitle = "Free vertical scales")
  
  p2 <- p0 + 
    facet_wrap(~region_agg, scales = "fixed") +
    labs(subtitle = "fixed vertical scales")
  
  print(p1)
  print(p2)
  
  oz_regions$tmp <- NULL
}
dev.off()
