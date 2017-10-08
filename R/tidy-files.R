#' Tidy pdf file
#'
#' Parse words from __pdf__ file into
#' [tidy format](http://tidytextmining.com/tidytext.html). It uses
#' [pdftools::pdf_text()][pdftools::pdf_text] to parse pdf file and
#' [tidytext::unnest_tokens()][tidytext::unnest_tokens] to produce words from
#' parsed text.
#'
#' @param file Path to pdf file.
#'
#' @return A [tibble][tibble::lst] with the following columns:
#' - __page__ <int> : Word's page number.
#' - __line__ <int> : Words's line number on page (empty lines are ignored).
#' - __word__ <chr> : Word.
#'
#' @export
tidy_pdf <- function(file) {
  pages_list <- file %>%
    pdftools::pdf_text() %>%
    lapply(. %>% strsplit("\n") %>% `[[`(1))

  lapply(seq_along(pages_list), function(i) {
    page_lines <- pages_list[[i]]
    n_lines <- length(page_lines)

    dplyr::tibble(
      page = rep(i, n_lines),
      line = seq_len(n_lines),
      text = page_lines
    ) %>%
      tidytext::unnest_tokens(word, text, token = "words")
  }) %>%
    dplyr::bind_rows()
}

#' Tidy rmd file
#'
#' Parse words from __rmd__ file into
#' [tidy format](http://tidytextmining.com/tidytext.html). It reads raw file,
#' removes some chunks based on regular expressions and uses
#' [tidytext::unnest_tokens()][tidytext::unnest_tokens] to produce words.
#' __Note__ that regular expressions are design to handle common rmd formatting.
#' On complicated cases it can give undesired output.
#'
#' @param file Path to pdf file.
#' @param name Name of the document represented by file.
#'
#' @return A [tibble][tibble::lst] with the following columns:
#' - __name__ <int> : Document name.
#' - __word__ <chr> : Word.
#'
#' @export
tidy_rmd <- function(file, name = file_base_name(file)) {
  file_string <- file %>%
    readLines() %>%
    paste0(collapse = " ") %>%
    # Remove YAML header
    str_replace_all("^--- .*?--- ", "") %>%
    # Remove code
    str_replace_all("```.*?```", "") %>%
    str_replace_all("`.*?`", "") %>%
    # Remove LaTeX
    str_replace_all("[^\\\\]\\$\\$.*?[^\\\\]\\$\\$", "") %>%
    str_replace_all("[^\\\\]\\$.*?[^\\\\]\\$", "")

  dplyr::tibble(name = name, text = file_string) %>%
    tidytext::unnest_tokens(word, text, token = "words")
}

#' Get file base name
#'
#' Extract file's base name without extension (last three characters preceded by
#' '.').
#'
#' @param file Vector of paths to files.
#'
#' @examples
#' file_base_name(c("some/folder/path/end-file.rmd",
#'                  "some/folder/path/end-file.Rmd",
#'                  "some/folder/path/end-file.txt",
#'                  ".end-file", "end-file."))
#'
#' @export
file_base_name <- function(file) {
  file %>%
    basename() %>%
    str_replace_all("\\..*?$", "")
}

#' Remove markdown emphasis
#'
#' Function to remove emphasis from scraped markdown.
#'
#' @param x Character vector.
#'
#' @examples
#' remove_md_emphasis(c("_a", "__a", "*a", "_*a",
#'                      "a_", "a__", "a*", "a*_",
#'                      "_a_", "__a__", "*a*", "**a**"))
#'
#' @export
remove_md_emphasis <- function(x) {
  str_replace_all(x, "^[_*]+|[_*]+$", "")
}

#' Filter good words
#'
#' Remove from word table (data frame with 'word' column) rows with words 'bad'
#' for analysis, which are:
#' - 'Stop words'. The list of them is taken from
#'   [tidytext][tidytext::stop_words] version 0.1.3.
#' - Words containing not alphabetical characters.
#'
#' @param word_tbl Data frame with column 'word'.
#'
#' @export
filter_good_words <- function(word_tbl) {
  word_tbl %>%
    dplyr::anti_join(jeroha_stop_words, by = "word") %>%
    dplyr::filter(stringr::str_detect(word, pattern = "^[[:alpha:]]+$"))
}
