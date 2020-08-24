## ---- tourism-shared
library(tsibbletalk)
tourism_shared <- tourism_monthly %>% 
  as_shared_tsibble(spec = (State / Region) * Purpose)

## ---- load-other-pkgs
library(feasts)
library(plotly)
library(ggplot2)
library(tsibble)

## ---- plotly-key-tree
tourism_feat <- tourism_shared %>%
  features(Trips, feat_stl)

p0 <- plotly_key_tree(tourism_shared, height = 1100, width = 800)
p1 <- tourism_shared %>%
  ggplot(aes(x = Month, y = Trips)) +
  geom_line(aes(group = Region), alpha = .5, size = .4) +
  facet_wrap(~ Purpose, scales = "free_y") +
  scale_x_yearmonth(date_breaks = "5 years", date_labels = "%Y")
p2 <- tourism_feat %>%
  ggplot(aes(x = trend_strength, y = seasonal_strength_year)) +
  geom_point(aes(group = Region))

subplot(p0,
  subplot(
    ggplotly(p1, tooltip = "Region", width = 1100),
    ggplotly(p2, tooltip = "Region", width = 1100),
    nrows = 2),
  widths = c(.4, .6)) %>%
  highlight(dynamic = TRUE)
