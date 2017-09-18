library(dplyr)
library(jeroha)


# Setup -------------------------------------------------------------------
prepare_book <- function(book_name) {
  file.path("data-raw", paste0(book_name, ".pdf")) %>%
    tidy_pdf() %>%
    filter_good_words() %>%
    mutate(
      id = 1:n(),
      word = extract_alpha(word),
      book = rep(book_name, n())
    ) %>%
    select(id, book, everything())
}


# Tidy books --------------------------------------------------------------
# For file "ADS.pdf" go to https://leanpub.com/artofdatascience ,
# download the book, rename it to "ADS.pdf" and put into
# "data-raw" folder
ads <- prepare_book("ADS")

devtools::use_data(ads, overwrite = TRUE)

# For file "EDAS.pdf" go to https://leanpub.com/datastyle ,
# download the book, rename it to "EDAS.pdf" and put into
# "data-raw" folder
edas <- prepare_book("EDAS")

devtools::use_data(edas, overwrite = TRUE)
