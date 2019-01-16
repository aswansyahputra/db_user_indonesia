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


# Shinyapps ---------------------------------------------------------------

shinyapps <- 
  cln_all %>% 
  select(lama_penggunaan, contains("shinyapps")) %>% 
  mutate(
    lama_penggunaan = factor(
      lama_penggunaan, 
      levels = c(
        "belum menggunakan",
        "kurang dari satu tahun",
        "antara satu hingga tiga tahun",
        "lebih dari tiga tahun"
      ),
      labels = c(
        "Never",
        "< 1 year",
        "1-3 years",
        "> 3 years"
      )
    ),
    mengetahui_shinyapps = factor(
      mengetahui_shinyapps,
      levels = c(
        "belum mengetahui",
        "mengetahui namun tidak menggunakan",
        "mengetahui dan menggunakan"
      ),
      labels = c(
        "No",
        "Yes, but not using it",
        "Yes, using it"
      )
    )
  ) %>%
  count(lama_penggunaan, mengetahui_shinyapps) %>% 
  group_by(lama_penggunaan) %>% 
  mutate(
    percent = n/sum(n)
  ) %>% 
  ungroup()

shinyapps %>% 
  ggplot(aes(x = lama_penggunaan, y = percent, fill = mengetahui_shinyapps)) +
  geom_col() +
  labs(
    x  = "Years using R",
    y = "",
    fill = "Know Shinyapps?",
    title = "useR! Indonesia Familiarity with Shinyapps",
    caption = "Source: database of useR! registered for meetups"
  ) +
  scale_y_percent() +
  scale_fill_brewer(type = "qual", palette = "Set2") +
  theme_ipsum_ps()
ggsave("graphics/shinyapps1.png")

shinyapps %>% 
  ggplot(aes(x = mengetahui_shinyapps, y = n, fill = lama_penggunaan)) +
  geom_col() +
  labs(
    x = "Know Shinyapps",
    y = "Count",
    fill  = "Years using R",
    title = "useR! Indonesia Familiarity with Shinyapps",
    caption = "Source: database of useR! registered for meetups"
  ) +
  scale_fill_brewer(type = "qual", palette = "Set2") +
  theme_ipsum_ps()
ggsave("graphics/shinyapps2.png")

shinyapps %>% 
  mutate(
    mengetahui_shinyapps = case_when(
      mengetahui_shinyapps == "No" ~ "No",
      TRUE ~ "Yes"
    )
  ) %>% 
  ggplot(aes(x = mengetahui_shinyapps, y = n, fill = lama_penggunaan)) +
  geom_col() +
  labs(
    x = "Know Shinyapps",
    y = "Count",
    fill  = "Years using R",
    title = "useR! Indonesia Familiarity with Shinyapps",
    caption = "Source: database of useR! registered for meetups"
  ) +
  scale_fill_brewer(type = "qual", palette = "Set2") +
  theme_ipsum_ps()
ggsave("graphics/shinyapps3.png")
  
  
