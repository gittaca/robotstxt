#' function that checks if file is valid / parsable robots.txt file
#'
#' @param text content of a robots.txt file provides as character vector
#' @export
#'
is_valid_robotstxt <- function(text){
  text <- unlist(strsplit(text, "\n"))
  all(
    # allow :
      # - spaces followed by #
      grepl(
        pattern  = "^(\xef\xbb\xbf)*\\s*#",
        x        = text,
        useBytes = TRUE
      )   |
      # - spaces followed by letter(s) followed by a double dot (somewhere)
      grepl("^(\xef\xbb\xbf)*(\\s*\\w.*:)", text, useBytes = TRUE) |
      # - spaces only or empty line
      grepl("^(\xef\xbb\xbf)*(\\s)*$", text, useBytes = TRUE)
  )
}


