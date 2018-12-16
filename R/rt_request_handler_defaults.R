#' default HTTP request event handler
#'
#' List of list each containing 4 elements, e.g.: \code{on_server_error       =
#' list(
#' over_write_file_with = ...,
#' signal               = ...,
#' cache                = ...,
#' priority             = ...
#' )}. The first item (\code{over_write_file_with }) is the content which will
#' replace whatever content retrieved. \code{signal} is a string determining
#' how the event will be signaled, by error, warning, message, or no at all.
#' \code{cache} is either \code{TRUE} or \code{FALSE} and will determine if the
#' content retrieved will be cached or not. \code{priority} will determine which
#' event handlers decisions will take precedence - with higher number indicating
#' higher priority.
#'
#' @docType data
#' @rdname default_event_handler
#'
#' @field on_server_error request state handler for any 5xx status
#'
#' @field on_client_error request state handler for any 4xx HTTP status that is
#'   not 404
#'
#' @field on_not_found request state handler for HTTP status 404
#'
#' @field on_redirect request state handler for any 3xx HTTP status
#'
#' @field on_domain_change request state handler for any 3xx HTTP status where
#'   domain did change as well
#'
#' @field on_file_type_mismatch request state handler for content type other
#'   than 'text/plain'
#'
#' @field on_suspect_content request state handler for content that seems to be
#'   something else than a robots.txt file (usually a JSON, XML or HTML)
#'
#' @export
default_event_handler <-
  list(
    on_server_error       =
      list(
        over_write_file_with = "User-agent: *\nDisallow: /",
        signal               = "error",
        cache                = FALSE,
        priority             = 20
      ),

    on_client_error       =
      list(
        over_write_file_with = "User-agent: *\nAllow: /",
        signal               = "warning",
        cache                = TRUE,
        priority             = 19
      ),

    on_not_found          =
      list(
        over_write_file_with = "User-agent: *\nAllow: /",
        signal               = "warning",
        cache                = TRUE,
        priority             = 1
      ),

    on_redirect           =
      list(
        over_write_file_with = "User-agent: *\nAllow: /",
        signal               = "warning",
        cache                = TRUE,
        priority             = 3
      ),

    on_domain_change      =
      list(
        over_write_file_with = "User-agent: *\nAllow: /",
        signal               = "warning",
        cache                = TRUE,
        priority             = 4
      ),

    on_file_type_mismatch =
      list(
        over_write_file_with = "User-agent: *\nAllow: /",
        signal               = "warning",
        cache                = TRUE,
        priority             = 1
      ),

    on_suspect_content    =
      list(
        over_write_file_with = "User-agent: *\nAllow: /",
        signal               = "warning",
        cache                = TRUE,
        priority             = 2
      )
  )