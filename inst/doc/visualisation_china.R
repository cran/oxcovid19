## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  error = FALSE,
  collapse = TRUE,
  comment = "#>"
)

## ----example1, echo = TRUE, eval = TRUE---------------------------------------
library(oxcovid19)
library(magrittr)
library(dplyr)

connect_oxcovid19() %>%
  get_table(tbl_name = "epidemiology") %>%
  filter(source == "CHN_ICL",
         !is.na(adm_area_1)) %>%
  arrange(desc(date))

## ----example2a, echo = TRUE, eval = TRUE--------------------------------------
chn_recent_region <- connect_oxcovid19() %>%
  get_table(tbl_name = "epidemiology") %>%
  filter(source == "CHN_ICL",
         !is.na(adm_area_1)) %>%
  group_by(adm_area_1) %>%
  filter(as.Date(date) == max(as.Date(date), na.rm = TRUE)) %>%
  select(date, country, adm_area_1, confirmed, recovered, dead, gid) %>%
  collect()

## ----example2b, echo = FALSE, eval = TRUE-------------------------------------
chn_recent_region

## ----example3a, echo = TRUE, eval = TRUE--------------------------------------
chn_admin_1 <- connect_oxcovid19() %>%
  get_layer(ccode = "CHN", adm = 1) %>%
  collect()

## ----example3b, echo = FALSE, eval = TRUE-------------------------------------
chn_admin_1

## ----example4a, echo = TRUE, eval = TRUE--------------------------------------
## Load sf package for spatial objects
library(sf)

chn_recent_region <- chn_recent_region %>%
  mutate(gid = as.character(stringr::str_remove_all(string = gid, 
                                                    pattern = "\\{|\\}"))) %>%
  left_join(y = chn_admin_1, by = "gid") %>%
  st_as_sf()

## ----example4b, echo = FALSE, eval = TRUE-------------------------------------
chn_recent_region

## ----example5, echo = FALSE, eval = TRUE--------------------------------------
chn_recent_region <- chn_recent_region %>%
  mutate(confirmed_class = cut(chn_recent_region$confirmed, 
                               breaks = quantile(x = chn_recent_region$confirmed, 
                                                 probs = seq(from = 0, 
                                                             to = 1, 
                                                             by = 0.1)),
                               include.lowest = TRUE))

levels(chn_recent_region$confirmed_class) <- levels(chn_recent_region$confirmed_class) %>%
  stringr::str_replace_all(pattern = ",", replacement = " - ") %>%
  stringr::str_replace_all(pattern = "1.26e\\+03", replacement = "1257") %>%
  stringr::str_replace_all(pattern = "6.78e\\+04", replacement = "67802") %>%
  stringr::str_remove_all(pattern = "\\[|\\]|\\(")

## ----example5a, echo = TRUE, eval = FALSE, fig.width = 7, fig.align = "center"----
#  chn_recent_region <- chn_recent_region %>%
#    mutate(confirmed_class = cut(chn_recent_region$confirmed,
#                                 breaks = quantile(x = chn_recent_region$confirmed,
#                                                   probs = seq(from = 0,
#                                                               to = 1,
#                                                               by = 0.1)),
#                                 include.lowest = TRUE))
#  
#  levels(chn_recent_region$confirmed_class) <- levels(chn_recent_region$confirmed_class) %>%
#    stringr::str_replace_all(pattern = ",", replacement = " - ") %>%
#    stringr::str_replace_all(pattern = "1.26e\\+03", replacement = "1257") %>%
#    stringr::str_replace_all(pattern = "6.78e\\+04", replacement = "67802") %>%
#    stringr::str_remove_all(pattern = "\\[|\\]|\\(")
#  
#  plot(chn_recent_region["confirmed_class"],
#       main = "",
#       pal = colorRampPalette(colors = RColorBrewer::brewer.pal(n = 5,
#                                                                name = "Reds"))(10),
#       nbreaks = 10,
#       breaks = "quantile",
#       key.width = lcm(5))

## ----example5b, echo = FALSE, eval = TRUE, fig.align = "center", out.width = "75%"----
knitr::include_graphics("../man/figures/visualisation_china_1.png")

## ----example6, echo = FALSE, eval = TRUE--------------------------------------
chn_recent_region <- chn_recent_region %>%
  mutate(dead_class = cut(chn_recent_region$dead, 
                               breaks = unique(quantile(x = chn_recent_region$dead, 
                                                probs = seq(from = 0, 
                                                            to = 1, 
                                                            by = 0.1),
                                                 na.rm = TRUE)),
                               include.lowest = TRUE))

levels(chn_recent_region$dead_class) <- levels(chn_recent_region$dead_class) %>%
  stringr::str_replace_all(pattern = ",", replacement = " - ") %>%
  stringr::str_replace_all(pattern = "3.19e\\+03", replacement = "3193") %>%
  stringr::str_remove_all(pattern = "\\[|\\]|\\(")

## ----example6a, echo = TRUE, eval = FALSE, fig.width = 7, fig.align = "center"----
#  chn_recent_region <- chn_recent_region %>%
#    mutate(dead_class = cut(chn_recent_region$dead,
#                                 breaks = unique(quantile(x = chn_recent_region$dead,
#                                                  probs = seq(from = 0,
#                                                              to = 1,
#                                                              by = 0.1),
#                                                   na.rm = TRUE)),
#                                 include.lowest = TRUE))
#  
#  levels(chn_recent_region$dead_class) <- levels(chn_recent_region$dead_class) %>%
#    stringr::str_replace_all(pattern = ",", replacement = " - ") %>%
#    stringr::str_replace_all(pattern = "3.19e\\+03", replacement = "3193") %>%
#    stringr::str_remove_all(pattern = "\\[|\\]|\\(")
#  
#  plot(chn_recent_region["dead_class"],
#       main = "",
#       pal = colorRampPalette(colors = RColorBrewer::brewer.pal(n = 5,
#                                                                name = "Reds"))(7),
#       nbreaks = 7,
#       breaks = "quantile",
#       key.width = lcm(5))

## ----example6b, echo = FALSE, eval = TRUE, fig.align = "center", out.width = "75%"----
knitr::include_graphics("../man/figures/visualisation_china_2.png")

## ----example7a, echo = TRUE, eval = FALSE, fig.width = 10, fig.height = 8, fig.align = "center"----
#  library(ggplot2)
#  
#  connect_oxcovid19() %>%
#    get_table(tbl_name = "epidemiology") %>%
#    filter(source == "CHN_ICL",
#           !is.na(adm_area_1)) %>%
#    arrange(desc(date)) %>%
#    ggplot(mapping = aes(x = date, y = confirmed, colour = adm_area_1)) +
#    geom_line() +
#    geom_point() +
#    scale_colour_discrete(name = NULL) +
#    theme_minimal()

## ----example7aa, echo = FALSE, eval = TRUE, fig.align = "center", out.width = "75%"----
knitr::include_graphics("../man/figures/visualisation_china_3.png")

## ----example7b, echo = TRUE, eval = FALSE, fig.width = 10, fig.height = 17.5, fig.align = "center"----
#  connect_oxcovid19() %>%
#    get_table(tbl_name = "epidemiology") %>%
#    filter(source == "CHN_ICL",
#           !is.na(adm_area_1)) %>%
#    arrange(desc(date)) %>%
#    ggplot(mapping = aes(x = date, y = confirmed)) +
#    geom_line() +
#    facet_wrap( ~ adm_area_1, ncol = 4) +
#    theme_bw()

## ----example7bb, echo = FALSE, eval = TRUE, fig.align = "center", out.width = "75%"----
knitr::include_graphics("../man/figures/visualisation_china_4.png")

## ----example7c, echo = TRUE, eval = FALSE, fig.width = 10, fig.height = 17.5, fig.align = "center"----
#  connect_oxcovid19() %>%
#    get_table(tbl_name = "epidemiology") %>%
#    filter(source == "CHN_ICL",
#           !is.na(adm_area_1)) %>%
#    arrange(desc(date)) %>%
#    ggplot(mapping = aes(x = date, y = confirmed)) +
#    geom_line() +
#    facet_wrap( ~ adm_area_1, ncol = 4, scales = "free_y") +
#    theme_bw()

## ----example7cc, echo = FALSE, eval = TRUE, fig.align = "center", out.width = "75%"----
knitr::include_graphics("../man/figures/visualisation_china_5.png")

## ----example8a, echo = TRUE, eval = FALSE, fig.width = 10, fig.height = 17.5, fig.align = "center"----
#  connect_oxcovid19() %>%
#    get_table(tbl_name = "epidemiology") %>%
#    filter(source == "CHN_ICL",
#           !is.na(adm_area_1)) %>%
#    arrange(desc(date)) %>%
#    ggplot(mapping = aes(x = date, y = dead)) +
#    geom_line() +
#    facet_wrap( ~ adm_area_1, ncol = 4) +
#    theme_bw()

## ----example8aa, echo = FALSE, eval = TRUE, fig.align = "center", out.width = "75%"----
knitr::include_graphics("../man/figures/visualisation_china_6.png")

## ----example8b, echo = TRUE, eval = FALSE, fig.width = 10, fig.height = 17.5, fig.align = "center"----
#  connect_oxcovid19() %>%
#    get_table(tbl_name = "epidemiology") %>%
#    filter(source == "CHN_ICL",
#           !is.na(adm_area_1)) %>%
#    arrange(desc(date)) %>%
#    ggplot(mapping = aes(x = date, y = dead)) +
#    geom_line() +
#    facet_wrap( ~ adm_area_1, ncol = 4, scales = "free_y") +
#    theme_bw()

## ----example8bb, echo = FALSE, eval = TRUE, fig.align = "center", out.width = "75%"----
knitr::include_graphics("../man/figures/visualisation_china_7.png")

