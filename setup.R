library(tidyverse)
library(glue)
library(Cairo)
library(extrafont)
library(frs)
library(scales)
library(ggtext)

myfont <- "Roboto"
main_font <- "Roboto"
heading_font <- "Sarala"


my_theme <- theme_light(base_family = main_font) + 
  theme(legend.position = "bottom") +
  theme(plot.caption = element_text(colour = "grey50"),
        strip.text = element_text(size = rel(1), face = "bold"),
        plot.title = element_markdown(family = heading_font),
        plot.subtitle = element_text())

theme_set(my_theme)          
update_geom_defaults("text", list(family = main_font))
update_geom_defaults("label", list(family = main_font))
