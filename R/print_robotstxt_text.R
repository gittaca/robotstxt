
#' printing robotstxt_text
#' @param x character vector aka robotstxt$text to be printed
#' @param ... goes down the sink
#' @export
print.robotstxt_text <- function(x, ...){

  # rpint part of the robots.txt file
  cat("[robots.txt]\n--------------------------------------\n\n")
  tmp <- unlist(strsplit(x, "\n"))
  cat(tmp[seq_len(min(length(tmp), 50))], sep ="\n")
  cat("\n\n\n")
  if(length(tmp) > 50){
    cat("[...]\n\n")
  }

  # print problems
  problems <- attr(x, "problems")
  if ( length(problems) > 0){
    cat("[problems]\n--------------------------------------\n\n")
    names_problems <- names(problems)
    for( i in seq_len(length(problems)) ){
      cat("-", names_problems[i], problems[[i]]$info_line, "\n")
    }
  }

  # print attributes
  cat("\n\n[attributes]\n--------------------------------------\n\n")
  overwrite <- attr(x, "overwrite")
  cat("* overwrite =", overwrite, "\n")

  overwrite <- attr(x, "cached")
  cat("* cached    =", overwrite, "\n")

  # return
  invisible(x)
}
