library(jeroha)
library(dplyr)


# Get rmd files -----------------------------------------------------------
# For folder "r4ds" go to https://github.com/hadley/r4ds ,
# download the repository, unpack and rename it to "r4ds", put into
# "data-raw" folder

# Get files used to knit the book
r4ds_file_names <- readLines(
  file.path("data-raw", "r4ds", "_bookdown.yml")
  ) %>%
  paste0(collapse = " ") %>%
  stringr::str_extract_all('\\".*\\.[Rr]md\\"') %>%
  `[[`(1) %>%
  stringr::str_replace_all('"', '') %>%
  stringr::str_split(",[:space:]*") %>%
  `[[`(1)

r4ds_pages <- tibble(
  page = 1:length(r4ds_file_names),
  file = r4ds_file_names,
  pageName = file_base_name(r4ds_file_names)
)


# Tidy book ---------------------------------------------------------------
r4ds <- file.path("data-raw", "r4ds", r4ds_pages[["file"]]) %>%
  lapply(tidy_rmd) %>%
  bind_rows() %>%
  rename(pageName = name) %>%
  filter_good_words() %>%
  mutate(
    id = 1:n(),
    word = extract_alpha(word),
    book = rep("R4DS", n())
  ) %>%
  left_join(y = r4ds_pages %>% select(page, pageName),
            by = "pageName") %>%
  select(id, book, page, pageName, word)

devtools::use_data(r4ds, overwrite = TRUE)
