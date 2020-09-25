# This script just looks at the basics of the data

dim(raw_data)

names(raw_data)

# grain of data is gender, age_bucket, date, country
raw_data[1:10, 1:10]

# The number of age buckets per country varies between 1 and 4 (note that
# 'overall' is an age bucket):
raw_data %>%
  count(country_agg, age_bucket) %>%
  count(country_agg, name = "number_age_buckets") %>%
  count(number_age_buckets)

# The number of genders varies between 1 and 4 (female, male, other,overall)
raw_data %>%
  count(country_agg, gender) %>%
  count(country_agg, name = "number_genders") %>%
  count(number_genders)

# The most responses are from Brazil, Mexico, Japan:
raw_data %>%
  filter(age_bucket == "overall" & gender == "overall") %>%
  count(country_agg, wt = total_responses, sort = TRUE) 
# Australia is 27 with 266,000 responses,  UK 12 with 400,000, USA is excluded?

raw_data %>%
  ggplot(aes(x = pct_cli, y = pct_cli_weighted)) +
  geom_point()

CairoPDF("output/lots-of-vars-6-countries.pdf", 11, 8)
for(j in 9:ncol(raw_data)){
  raw_data$tmp <- pull(raw_data, j)
  p0 <- raw_data %>%
    filter(country_agg %in% c("Australia", "Brazil", "United Kingdom", 
                              "Italy","New Zealand", "Iraq")) %>%
    filter(age_bucket == "overall") %>%
    filter(gender %in% c("female", "male")) %>%
    ggplot(aes(x = date, y = tmp, colour = gender)) +
    geom_point(size = 0.3) +
    geom_smooth(se = FALSE, span = 1/7, method = "loess", formula = "y ~ x") +
    labs(y = names(raw_data)[j],
         title = names(raw_data)[j],
         x = "Date in 2020")
  
  p1 <- p0 + 
    facet_wrap(~country_agg, scales = "free_y") +
    labs(subtitle = "Free vertical scales")
  
  p2 <- p0 + 
    facet_wrap(~country_agg, scales = "fixed") +
    labs(subtitle = "fixed vertical scales")
  
  print(p1)
  print(p2)
  
  raw_data$tmp <- NULL
}
dev.off()

