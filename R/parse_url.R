


#' parse_url
#'
#' @param url
#'
#' @return data.frame with columns protocol, domain, path
#'
#' @examples
#'
#' url <-
#' c(
#'   "google.com",
#'   "google.com/",
#'   "www.google.com",
#'   "http://google.com",
#'   "https://google.com",
#'   "sub.domain.whatever.de"
#' )
#'
#' parse_url(url)
#'
parse_url <- function(url){
  match <-
    stringr::str_match(url, "(^\\w+://)?([\\w.]+)?(/.*)?")[, -1, drop = FALSE]

  df        <- as.data.frame(match)
  names(df) <- c("protocol", "domain", "path")
  df$path[ is.na(df$path) ] <- ""

  # return
  df
}

