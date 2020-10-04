the_caption <- "University of Maryland Global Symptom Survey of Facebook users, analysed at http://freerangestats.info"
the_countries <- c("Hong Kong", "South Korea", "Singapore", "Japan", "Taiwan", "Malaysia")

# colours for male and female used by Washington Post 2017; see https://blog.datawrapper.de/gendercolor/
sex_cols <- c(Male = "#F4BA3B", Female =  "#730B6D")

#==============six countries==========



countries <- raw_data_countries %>%
  filter(country_agg %in% the_countries) %>%
  filter(age_bucket == "overall") %>%
  filter(gender %in% c("female", "male")) %>%
  mutate(gender = str_to_title(gender))


#-----------------Symptoms by state and time--------
p4 <- countries %>%
  ggplot(aes(x = date, y = pct_cli_weighted / 100, colour = gender)) +
  geom_point(aes(size = total_responses), alpha = 0.5) +
  geom_smooth(se = FALSE, span = 1/4, method = "loess", formula = "y ~ x") +
  labs(title = "Survey-reported Covid-like symptoms in selected countries",
       subtitle = str_wrap(" ", 120),
       y = "'Have symptoms of Covid-like illness'",
       x = "Date in 2020",
       size = "Sample size:",
       caption = the_caption,
       colour = "") + 
  scale_size_area(max_size = 5, label = comma) +
  scale_y_continuous(label = percent_format(accuracy = 1)) +
  scale_colour_manual(values = sex_cols) +
  facet_wrap(~country_agg, scales = "fixed") 

#---------------------Mask usage------------------
p5 <- countries %>%
  ggplot(aes(x = date, y = pct_wear_mask_none_time_weighted / 100, colour = gender)) +
  geom_point(aes(size = total_responses), alpha = 0.5) +
  geom_smooth(se = FALSE, span = 1/4, method = "loess", formula = "y ~ x") +
  labs(title = "Survey-reported wearing of masks in selected countries",
       subtitle = str_wrap(" ", 120),
       y = "'Never wear a mask'",
       x = "Date in 2020",
       size = "Sample size:",
       caption = the_caption,
       colour = "") + 
  coord_cartesian(ylim = c(0, 1)) +
  scale_size_area(max_size = 5, label = comma) +
  scale_y_continuous(label = percent_format(accuracy = 1)) +
  scale_colour_manual(values = sex_cols) +
  facet_wrap(~country_agg, scales = "fixed") 

#---------------------Depression------------------
p6 <- countries %>%
  ggplot(aes(x = date, y = pct_feel_depressed_none_time_weighted / 100, colour = gender)) +
  geom_point(aes(size = total_responses), alpha = 0.5) +
  geom_smooth(se = FALSE, span = 1/4, method = "loess", formula = "y ~ x") +
  labs(subtitle = str_wrap(" ", 120),
       title = "Survey-reported levels of depression in selected countries",
       y = "'Feel depressed none of the time'",
       x = "Date in 2020",
       size = "Sample size:",
       caption = the_caption,
       colour = "") + 
  scale_size_area(max_size = 5, label = comma) +
  scale_colour_manual(values = sex_cols) +
  scale_y_continuous(label = percent_format(accuracy = 1)) +
  facet_wrap(~country_agg, scales = "fixed") 



#===============saving===========
w <- 10
h <- 6

svg_png(p4, "output/japan-etc-cli", w = w, h = h)
svg_png(p5, "output/japan-etc-masks", w = w, h = h)
svg_png(p6, "output/japan-etc-dep", w = w, h = h)

