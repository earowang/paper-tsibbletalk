## ----setup, echo = FALSE, cache = FALSE, include = FALSE----------------------
options("knitr.graphics.auto_pdf" = TRUE)
library(knitr)
opts_chunk$set(
  echo = FALSE, warning = FALSE, message = FALSE, comment = "#>",
  fig.path = 'figure/', fig.align = 'center', fig.show = 'hold',
  cache = TRUE, cache.path = 'cache/',
  out.width = ifelse(is_html_output(), "100%", "\\textwidth")
)
opts_knit$set(root.dir = here::here())
read_chunk("scripts/demo.R")
read_chunk("scripts/tourism.R")


## ---- load-pkgs---------------------------------------------------------------
library(feasts)
library(tsibble)
library(tsibbledata)


## ---- print-retail------------------------------------------------------------
print(aus_retail, n = 5)


## ----highlight-retail, fig.height = 3.3, fig.cap = "ToDo"---------------------
library(tidyverse)
library(ggrepel)
library(gghighlight)
library(patchwork)

p_retail_ts <- aus_retail %>% 
  as_tibble() %>% # gghighlight issue for group_by() + filter()
  mutate(group = paste(State, ":", Industry)) %>% 
  ggplot(aes(x = Month, y = Turnover)) +
  geom_line(aes(group = group)) +
  gghighlight(
    State == "Queensland", Industry == "Department stores",
    label_params = list(vjust = -2)
  ) +
  scale_x_yearmonth(breaks = yearmonth(c("1990 Jan", "2000 Jan", "2010 Jan")))

p_retail_feat <- aus_retail %>% 
  features(Turnover, feat_stl) %>% 
  mutate(group = paste(State, ":", Industry)) %>% 
  ggplot(aes(x = trend_strength, y = seasonal_strength_year)) +
  geom_point(aes(group = group)) +
  labs(x = "Trend strength", y = "Seasonal strength") +
  gghighlight(
    State == "Queensland", Industry == "Department stores",
    use_direct_label = FALSE
  ) +
  geom_label_repel(aes(label = group), vjust = 2, nudge_x = -0.1)

p_retail_ts + p_retail_feat + plot_annotation(tag_levels = "a")


## ----tourism-shared, echo = TRUE----------------------------------------------
library(tsibbletalk)
tourism_shared <- tourism_monthly %>% 
  as_shared_tsibble(spec = (State / Region) * Purpose)


## ----load-other-pkgs----------------------------------------------------------
library(feasts)
library(plotly)
library(ggplot2)
library(tsibble)


## ----tourism-linking-fig, fig.cap = "ToDo"------------------------------------
include_graphics("img/tourism-linking.png")


## ----plotly-key-tree, echo = TRUE---------------------------------------------
p_l <- plotly_key_tree(tourism_shared, height = 1100, width = 800)


## ----tourism-series, echo = TRUE, eval = FALSE--------------------------------
#> p_tr <- tourism_shared %>%
#>   ggplot(aes(x = Month, y = Trips)) +
#>   geom_line(aes(group = Region), alpha = .5, size = .4) +
#>   facet_wrap(~ Purpose, scales = "free_y") +
#>   scale_x_yearmonth(date_breaks = "5 years", date_labels = "%Y")


## ----tourism-scatter, echo = TRUE, eval = FALSE-------------------------------
#> tourism_feat <- tourism_shared %>%
#>   features(Trips, feat_stl)
#> p_br <- tourism_feat %>%
#>   ggplot(aes(x = trend_strength, y = seasonal_strength_year)) +
#>   geom_point(aes(group = Region), alpha = .8, size = 2)


## ----tourism-multi, echo = TRUE, eval = FALSE---------------------------------
#> subplot(p_l,
#>   subplot(
#>     ggplotly(p_tr, tooltip = "Region", width = 1100),
#>     ggplotly(p_br, tooltip = "Region", width = 1100),
#>     nrows = 2),
#>   widths = c(.4, .6)) %>%
#>   highlight(dynamic = TRUE)

