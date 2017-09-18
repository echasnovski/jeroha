library(jeroha)
library(dplyr)
library(tidyr)


# Setup -------------------------------------------------------------------
select_book_cols <- . %>% select(id, book, page, word)

books <- bind_rows(
  ads %>% select_book_cols(),
  edas %>% select_book_cols(),
  r4ds %>% select_book_cols()
) %>%
  mutate(stem = unlist(tokenizers::tokenize_word_stems(word)))

compute_fill <- function(x, max_id) {
  c(0, sort(x), max_id) %>% diff() %>% max() %>% `/`(max_id)
}

filter_appr_word <- . %>% filter(!(word %in% c("data", "analysis", "science")))


# Most frequent words within books ----------------------------------------
compute_tbl_freq <- function(tbl, col) {
  col_quo <- rlang::enquo(col)

  tbl %>%
    group_by(book, rlang::UQ(col_quo)) %>%
    summarise(n = n()) %>%
    mutate(freq = n / sum(n)) %>%
    ungroup() %>%
    arrange(desc(freq))
}

book_word_freq <- books %>%
  compute_tbl_freq(word)

book_stem_freq <- books %>%
  compute_tbl_freq(stem)


# Most filling words within books -----------------------------------------
compute_tbl_fill <- function(tbl, col) {
  col_quo <- rlang::enquo(col)

  tbl %>%
    select(book, id, rlang::UQ(col_quo)) %>%
    nest(-book) %>%
    mutate(
      tbl_fill = lapply(data, function(book_tbl) {
        n_total <- nrow(book_tbl)

        book_tbl %>%
          group_by(rlang::UQ(col_quo)) %>%
          summarise(
            fill = compute_fill(id, n_total)
          )
      })
    ) %>%
    unnest(tbl_fill) %>%
    arrange(fill)
}

book_word_fill <- books %>%
  compute_tbl_fill(word)

book_stem_fill <- books %>%
  compute_tbl_fill(stem)
