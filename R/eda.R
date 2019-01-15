library(tidyverse)
library(hrbrthemes)

cln_all <- read_csv("input/db_user_indonesia.csv")


# R package ---------------------------------------------------------------
pkgs <-
  cln_all %>%
  filter(!str_detect(paket, "belum|apriori|preparasi|tidak")) %>%
  mutate(
    paket = str_replace_all(paket, "ggplot|gglplot2|ggolot", "ggplot2"),
    paket = str_replace_all(paket, "ggplot22", "ggplot2"),
    paket = str_remove_all(paket, "dll|dan lain-lain|dsb|for lyfe|\\[|\\]"),
    paket = str_squish(paket),
    paket = str_remove_all(paket, ",$")
  ) %>%
  separate_rows(paket) %>%
  count(paket, sort = TRUE) %>%
  drop_na()

pkgs %>%
  top_n(20, n) %>%
  ggplot(aes(fct_reorder(paket, n), n)) +
  geom_col() +
  coord_flip() +
  labs(
    y = "count",
    x = "",
    title = "Top 20 packages used by useR! Indonesia",
    caption = "Source: database of useR! registered for meetup at Bandung and Jakarta"
  ) +
  theme_ipsum_ps()
ggsave("graphics/pkgs.png")
