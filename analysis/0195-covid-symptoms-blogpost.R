# This script is for producing static images for a blog post on Free Range Statistics
#
# Peter Ellis 4 October 2020

# In partnership with Facebook Data for Good, the Delphi Group at Carnegie
# Mellon University (CMU), the Joint Program on Survey Methodology at the
# University of Maryland (UMD), the Duke Margolis Center for Health Policy, and
# Resolve to Save Lives, an initiative of Vital Strategies Organized by Catalyst
# @Health 2.0

the_caption <- "UMD Global Symptom Survey of Facebook users, analysed at http://freerangestats.info"
the_countries <- c("Australia", "Brazil", "Singapore", "Italy", "New Zealand", "United Kingdom")

# colours for male and female used by Washington Post 2017; see https://blog.datawrapper.de/gendercolor/
sex_cols <- c(Male = "#F4BA3B", Female =  "#730B6D")

#==============Australia==========
oz_regions_5 <- raw_data_regions %>%
  filter(country_agg == "Australia" & gender == "overall" & age_bucket == "overall") %>%
  mutate(state = fct_lump(region_agg, 5,w = total_responses)) %>%
  group_by(state, date) %>%
  # aggregate, weighted by total responses, to combine Tasmania and ACT:
  summarise(pct_cli_weighted = weighted.mean(pct_cli_weighted, w = total_responses) / 100,
            pct_feel_depressed_none_time_weighted = weighted.mean(
              pct_feel_depressed_none_time_weighted, w = total_responses) / 100,
            pct_wear_mask_none_time_weighted = weighted.mean(
              pct_wear_mask_none_time_weighted, w = total_responses, na.rm = TRUE) / 100,
            total_responses = sum(total_responses)
            ) %>%
  ungroup() %>%
  mutate(state = fct_reorder(state, -total_responses, .fun = sum)) 

#-----------------Symptoms by state and time--------
p1 <- oz_regions_5 %>%
  ggplot(aes(x = date, y = pct_cli_weighted)) +
  geom_point(aes(size = total_responses)) +
  geom_smooth(se = FALSE, span = 1/4, method = "loess", formula = "y ~ x") +
  labs(subtitle = str_wrap("Percentage of population showing Covid-like illness symptoms. Victoria
       is not higher than other states; nor is there a spike in Victoria in July or August,
       even though in both cases there should be two orders of magnitude of variation.", 120),
       title = "Survey-reported Covid-like symptoms in Australia **do not** follow known spatial or temporal trends",
       y = "'Have symptoms of Covid-like illness'",
       x = "Date in 2020",
       size = "Sample size:",
       caption = the_caption) + 
  coord_cartesian(ylim = c(0, 0.08)) +
  scale_size_area(max_size = 5, label = comma) +
  scale_y_continuous(label = percent_format(accuracy = 1)) +
  facet_wrap(~state, scales = "fixed") 

#---------------------Mask usage------------------
p2 <- oz_regions_5 %>%
  ggplot(aes(x = date, y = pct_wear_mask_none_time_weighted)) +
  geom_point(aes(size = total_responses)) +
  geom_smooth(se = FALSE, span = 1/4, method = "loess", formula = "y ~ x") +
  labs(subtitle = str_wrap("Percentage of population reporting they never wear a mask in Victoria
       declined rapidly to zero when mask-wearing became mandatory. Other states with lesser
       or no outbreak report much less mask wearing, reflecting what we know to be reality.", 120),
       title = "Survey-reported wearing of masks **does** follow known spatial and temporal trends",
       y = "'Never wear a mask'",
       x = "Date in 2020",
       size = "Sample size:",
       caption = the_caption) + 
  coord_cartesian(ylim = c(0, 1)) +
  scale_size_area(max_size = 5, label = comma) +
  scale_y_continuous(label = percent_format(accuracy = 1)) +
  facet_wrap(~state, scales = "fixed") 

#---------------------Depression------------------
p3 <- oz_regions_5 %>%
  ggplot(aes(x = date, y = pct_feel_depressed_none_time_weighted)) +
  geom_point(aes(size = total_responses)) +
  geom_smooth(se = FALSE, span = 1/4, method = "loess", formula = "y ~ x") +
  labs(subtitle = str_wrap("Percentage of population reporting they feel depressed none of the time
       markedly drops in the period of the serious Covid-19 outbreak and response from June 
                           to September.", 120),
       title = "Survey-reported levels of depression **are** related to Covid-19 incidence and response",
       y = "'Feel depressed none of the time'",
       x = "Date in 2020",
       size = "Sample size:",
       caption = the_caption) + 
  scale_size_area(max_size = 5, label = comma) +
  scale_y_continuous(label = percent_format(accuracy = 1)) +
  facet_wrap(~state, scales = "fixed") 

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
       subtitle = str_wrap("Brazil has relatively high level of reported symptoms as might
       be expected giving Covid prevalence, but so does New Zealand. UK has seen a recent 
       increase, which
       is as expected (perhaps). Australia's trend in reported symptoms does not follow
       trend in incidence.", 120),
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
       subtitle = str_wrap("Reported mask wearing follows clear, well-defined patterns
                           that fit with expectations of reality. The response to outbreaks
                           in Australia and New Zealand are clear, as is the gradual
                           adoption over time in the United Kingdom.", 120),
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
  labs(subtitle = str_wrap("Italians' self-reported depression is improving over time,
                           while in Australia it took a hit around July. In New Zealand,
                           women rather than men reported more depression at the time
                           of the outbreak around August.", 120),
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

svg_png(p1, "output/0195-states-cli", w = w, h = h)
svg_png(p2, "output/0195-states-masks", w = w, h = h)
svg_png(p3, "output/0195-states-dep", w = w, h = h)
svg_png(p4, "output/0195-countries-cli", w = w, h = h)
svg_png(p5, "output/0195-countries-masks", w = w, h = h)
svg_png(p6, "output/0195-countries-dep", w = w, h = h)

#---------Copy files over-----------
files <- list.files("output", pattern = "0195")
file.copy(glue("output/{files}"),
          glue("~/blog/ellisp.github.io/img/{files}"),
          overwrite = TRUE)
