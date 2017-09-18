#' The Art of Data Science
#'
#' Tidied version of the book "The Art of Data Science" by Roger D. Peng and
#' Elizabeth Matsui published in 2015 - 2017. This book is for sale at
#' [leanpub](http://leanpub.com/artofdatascience). It also has its own
#' [web page](https://bookdown.org/rdpeng/artofdatascience/).
#'
#' @format A [tibble][tibble::lst] representing the book in
#' [tidy text format](http://tidytextmining.com/tidytext.html) with single word
#' as token. [Stop words][tidytext::stop_words] are removed.
#'
#' Data has the following columns:
#' - __id__ <int> : Index of word inside the book.
#' - __book__ <chr> : Name of the book.
#' - __page__ <int> : Page number.
#' - __line__ <int> : Line number on page (empty lines are ignored).
#' - __word__ <chr> : Word.
"ads"

#' The Elements of Data Analytic Style
#'
#' Tidied version of the book "The Elements of Data Analytic Style" by Jeff Leek
#' published in 2014-2015. This book is for sale at
#' [leanpub](http://leanpub.com/datastyle).
#'
#' @format A [tibble][tibble::lst] representing the book in
#' [tidy text format](http://tidytextmining.com/tidytext.html) with single word
#' as token. [Stop words][tidytext::stop_words] are removed.
#'
#' Data has the following columns:
#' - __id__ <int> : Index of word inside the book.
#' - __book__ <chr> : Name of the book.
#' - __page__ <int> : Page number.
#' - __line__ <int> : Line number on page (empty lines are ignored).
#' - __word__ <chr> : Word.
"edas"

#' R for Data Science
#'
#' Tidied version of the book "R for Data Science" by Garrett Grolemund and
#' Hadley Wickham. This book has its own [web page](http://r4ds.had.co.nz/).
#' It is licensed under
#' [Creative Commons Attribution-NonCommercial-NoDerivs 3.0](http://creativecommons.org/licenses/by-nc-nd/3.0/us/)
#' United States License.
#'
#' @format A [tibble][tibble::lst] representing the book in
#' [tidy text format](http://tidytextmining.com/tidytext.html) with single word
#' as token. [Stop words][tidytext::stop_words] are removed.
#'
#' Data has the following columns:
#' - __id__ <int> : Index of word inside the book.
#' - __book__ <chr> : Name of the book.
#' - __page__ <int> : Page (which is actually a chapter) number.
#' - __pageName__ <int> : Name of page/chapter.
#' - __word__ <chr> : Word.
"r4ds"
