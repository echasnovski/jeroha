context("tidy-files")


# Input data --------------------------------------------------------------
input_word_tbl <- dplyr::tibble(
  id = 1:16,
  word = c("a", "the", "used", "word", "output",
           "word1", "1word", "1word2",
           "word ", " word", " word ",
           "\nword", "\\word",
           "word_", "_word", "_word_")
)


# tidy_pdf ----------------------------------------------------------------
test_that("tidy_pdf works", {
  output <- tidy_pdf("tidy-pdf_test_input.pdf")
  output_ref <- readRDS("tidy-pdf_test_output.rds")

  expect_identical(output$page, output_ref$page)
  expect_true(is.integer(output$line))
  expect_identical(output$word, output_ref$word)
})


# tidy_rmd ----------------------------------------------------------------
test_that("tidy_rmd workd", {
  output <- tidy_rmd("tidy-rmd_test_input.Rmd")
  output_ref <- readRDS("tidy-rmd_test_output.rds")

  expect_identical(output, output_ref)
})


# file_base_name ----------------------------------------------------------
test_that("file_base_name works", {
  input <- c(
    "some/folder/path/end-file.rmd",
    "some/folder/path/end-file.Rmd",
    "some/folder/path/end-file.txt",
    "end-file", "end-file.", "end-file.gz",
    ".end-file"
  )
  output <- file_base_name(input)
  output_ref <- c(rep("end-file", 6), "")

  expect_identical(output, output_ref)
})


# remove_md_emphasisэ -----------------------------------------------------
test_that("remove_md_emphasis workd", {
  output <- remove_md_emphasis(c("_a", "__a", "*a", "_*a",
                                 "a_", "a__", "a*", "a*_",
                                 "_a_", "__a__", "*a*", "**a**"))
  output_ref <- rep("a", 12)

  expect_identical(output, output_ref)
})

# filter_good_words -------------------------------------------------------
test_that("filter_good_words works", {
  input <- input_word_tbl
  output <- filter_good_words(input)
  output_ref <- input[4:5, ]

  expect_identical(output, output_ref)
})

