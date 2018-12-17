
#' rt_request_handler
#'
#' A helper function for get_robotstxt() that will extract the robots.txt file
#' from the HTTP request result object. furthermore it will inform
#' get_robotstxt() if the request should be cached and which problems occured.
#'
#'
#'
#' @param request result of an HTTP request (e.g. httr::GET())
#'
#'
#'
#'
#' @param warn suppress warnings
#' @param encoding The text encoding to assume if no encoding is provided in the
#'   headers of the response
#'
#' @param rt_event_handler a list of lists determining the interpretation of robotstxts in case of specific evetns and triggers, see \link{default_event_handler}
#'
#' @return a list with three items following the following schema: \cr \code{
#'   list( rtxt = "", problems = list( "redirect" = list( status_code = 301 ),
#'   "domain" = list(from_url = "...", to_url = "...") ) ) }
#'
#' @export
#'
#'
rt_request_handler <-
  function(
    request,
    rt_event_handler = robotstxt::default_event_handler,
    warn             = TRUE,
    encoding         = "UTF-8"
  ){
    # apply options to defaults
    rt_event_handler      <- list_merge(robotstxt::default_event_handler, rt_event_handler)


    if( "all" %in% names(rt_event_handler) ){

      on_server_error       <- list_merge(rt_event_handler$on_server_error, rt_event_handler$all)
      on_client_error       <- list_merge(rt_event_handler$on_client_error, rt_event_handler$all)
      on_not_found          <- list_merge(rt_event_handler$on_not_found, rt_event_handler$all)
      on_redirect           <- list_merge(rt_event_handler$on_redirect, rt_event_handler$all)
      on_domain_change      <- list_merge(rt_event_handler$on_domain_change, rt_event_handler$all)
      on_file_type_mismatch <- list_merge(rt_event_handler$on_file_type_mismatch, rt_event_handler$all)
      on_suspect_content    <- list_merge(rt_event_handler$on_suspect_content, rt_event_handler$all)

    } else {

      on_server_error       <- rt_event_handler$on_server_error
      on_client_error       <- rt_event_handler$on_client_error
      on_not_found          <- rt_event_handler$on_not_found
      on_redirect           <- rt_event_handler$on_redirect
      on_domain_change      <- rt_event_handler$on_domain_change
      on_file_type_mismatch <- rt_event_handler$on_file_type_mismatch
      on_suspect_content    <- rt_event_handler$on_suspect_content

    }



    # storage for output
    res <-
      list(
        rtxt      = NULL,
        problems  = list(),
        cache     = NULL,
        priority  = 0,
        rtxt_orig = character(0)
      )


    # encoding suplied or not
    encoding_supplied  <-
      grepl("charset", null_to_defeault(request$headers$`content-type`, ""))


    if ( encoding_supplied == TRUE ) {
      rtxt_not_handled <-
        httr::content(
          request,
          as       = "text"
        )
    } else {
      rtxt_not_handled <-
        httr::content(
          request,
          encoding = encoding,
          as       = "text"
        )
    }

    # store original rtxt
    res$rtxt_orig <- rtxt_not_handled



    ## server error
    server_error <-
      request$status_code >= 500

    if ( server_error == TRUE ){
      res <-
        request_handler_handler(
          request = request,
          handler = on_server_error,
          res     = res,
          info    = list(status_code = request$status_code),
          warn    = warn
        )
    }

    ## http 404 not found
    not_found <-
      request$status_code == 404

    if ( not_found == TRUE ){
      res <-
        request_handler_handler(
          request = request,
          handler = on_not_found,
          res     = res,
          info    = list(status_code = request$status_code),
          warn    = warn
        )
    }


    ## other client error
    client_error       <-
      request$status_code >= 400 &
      request$status_code != 404 &
      request$status_code < 500

    if ( client_error == TRUE ){
      res <-
        request_handler_handler(
          request = request,
          handler = on_client_error,
          res     = res,
          info    = list(status_code = request$status_code),
          warn    = warn
        )
    }


    ## redirect
    redirected <-
      http_was_redirected(request)

    ## domain change
    domain_change <-
      http_domain_changed(request)

    ## subdomain changed to www
    subdomain_changed_to_www <-
      subdomain_changed_to_www(request)


    if ( redirected == TRUE & !subdomain_changed_to_www ){
      res <-
        request_handler_handler(
          request = request,
          handler = on_redirect,
          res     = res,
          info    =
            {
              tmp <- list()
              for ( i in seq_along(request$all_headers)){
                tmp[[length(tmp)+1]] <-
                  list(
                    status   = request$all_headers[[i]]$status,
                    location = request$all_headers[[i]]$headers$location
                  )
              }
              tmp
            }
            ,
          warn    = warn
        )
    }


    if ( domain_change == TRUE & !subdomain_changed_to_www ){
      res <-
        request_handler_handler(
          request = request,
          handler = on_domain_change,
          res     = res,
          info    =
            list(
              orig_url = request$request$url,
              last_url = request$url,
              orig_domain = urltools::domain(request$request$url),
              last_url    = urltools::domain(request$url)
            ),
          warn    = warn
        )
    }

    ## file type mismatch
    file_type_mismatch <-
      !(grepl("text/plain", null_to_defeault(request$headers$`content-type`)))

    if ( file_type_mismatch == TRUE ){
      res <-
        request_handler_handler(
          request = request,
          handler = on_file_type_mismatch,
          res     = res,
          info    = list(content_type = request$headers$`content-type`),
          warn    = warn
        )
    }


    ## content suspect
    parsable           <- is_valid_robotstxt(rtxt_not_handled)
    content_suspect    <- is_suspect_robotstxt(rtxt_not_handled)

    if ( parsable == FALSE | content_suspect == TRUE  ){
      res <-
        request_handler_handler(
          request = request,
          handler = on_suspect_content,
          res     = res,
          info    = list(parsable = parsable, content_suspect = content_suspect),
          warn    = warn
        )
    }


    # return
    res
  }
