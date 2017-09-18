library(dplyr)
library(tidyr)

jhu_hub <- bind_rows(ads, edas) %>%
  mutate(hub = rep("JHU", n())) %>%
  select(hub, book, id, word)

r_hub <- r4ds %>%
  mutate(hub = rep("R", n())) %>%
  select(hub, book, id, word)

hubs <- bind_rows(jhu_hub, r_hub)

# Unique words by hub
hubs %>%
  count(hub, word, sort = TRUE) %>%
  tidytext::bind_tf_idf(word, hub, n) %>%
  arrange(desc(tf_idf))

# Unique words by book
hubs %>%
  count(book, word, sort = TRUE) %>%
  tidytext::bind_tf_idf(word, book, n) %>%
  arrange(desc(tf_idf))

# Common words by hub
hubs %>%
  # Count frequencies
  group_by(hub, word) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  arrange(desc(freq)) %>%
  # Filtering most common words by hub
  filter(row_number() <= 100) %>%
  ungroup() %>%
  select(-n) %>%
  tidyr::spread(hub, freq) %>%
  filter(complete.cases(.)) %>%
  arrange(desc(JHU + R))

# Most equally spaced words
compute_fill_metric <- function(x, max_id) {
  c(0, sort(x), max_id) %>% diff() %>% max() %>% `/`(max_id)
}

hubs %>%
  select(-hub) %>%
  nest(-book) %>%
  mutate(wordFillMetric = lapply(
    data,
    . %>% group_by(word) %>%
      summarise(
        fillMetric = compute_fill_metric(id, nrow(.)),
        n = length(id)
        )
    )
  ) %>%
  unnest(wordFillMetric) %>%
  filter(n >= 10) %>%
  arrange(fillMetric) %>%
  group_by(book) %>%
  slice(1:10) %>%
  print(n = Inf)
