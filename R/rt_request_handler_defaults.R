#' default HTTP request event handler
#'
#' @docType data
#' @rdname default_event_handler
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