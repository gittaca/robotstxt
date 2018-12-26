context("HTTP evenet handling")

test_that("www redirects are handled silently", {
  expect_silent({
    rt_clear_cache()
    www_redirect <- readRDS(system.file("http_requests/http_redirect_www.rds", package = "robotstxt"))
    get_robotstxt(
      "http://google.com",
      rt_robotstxt_http_getter = function(...){www_redirect}
    )
  })
})

test_that("non www redirects are handled non silently", {
  expect_warning({
    rt_clear_cache()
    domain_change <- readRDS(system.file("http_requests/http_domain_change.rds", package = "robotstxt"))
    get_robotstxt(
      "http://google.com",
      rt_robotstxt_http_getter = function(...){domain_change}
    )
  })
})

test_that("warn = FALSE does silences warnings", {
  expect_silent({
    rt_clear_cache()
    domain_change <- readRDS(system.file("http_requests/http_domain_change.rds", package = "robotstxt"))
    get_robotstxt(
      "github.io",
      rt_robotstxt_http_getter = function(...){domain_change},
      warn = FALSE
    )
  })
})


test_that("suspect content", {
  expect_true({
    suppressWarnings({
      rt_clear_cache()
      suspect_content <- readRDS(system.file("http_requests/http_html_content.rds", package = "robotstxt"))
      rtxt <-
        get_robotstxt(
          "pages.github.com",
          rt_robotstxt_http_getter = function(...){suspect_content}
        )
      problems <- attr(rtxt, "problems")
    })

    !is.null(problems$on_file_type_mismatch) & problems$on_suspect_content$content_suspect
  })
})





test_that("all ok", {
  expect_silent({
    rt_clear_cache()
    http_ok <- readRDS(system.file("http_requests/http_ok_1.rds", package = "robotstxt"))
    get_robotstxt(
      "google.com",
      rt_robotstxt_http_getter = function(...){http_ok}
    )
  })

  expect_silent({
    rt_clear_cache()
    http_ok <- readRDS(system.file("http_requests/http_ok_2.rds", package = "robotstxt"))
    get_robotstxt(
      "google.com",
      rt_robotstxt_http_getter = function(...){http_ok}
    )
  })

  expect_silent({
    rt_clear_cache()
    http_ok <- readRDS(system.file("http_requests/http_ok_3.rds", package = "robotstxt"))
    get_robotstxt(
      "google.com",
      rt_robotstxt_http_getter = function(...){http_ok}
    )
  })

  expect_silent({
    rt_clear_cache()
    if ( Sys.getenv("rpkg_use_internet_for_testing") == "TRUE"  ){
      get_robotstxt(
        "google.com"
      )
    }else{
      skip("Shall not use internet.")
    }
  })


  expect_silent({
    rt_clear_cache()
    if ( Sys.getenv("rpkg_use_internet_for_testing") == "TRUE"  ){
      get_robotstxt(
        "google.com",
        force = TRUE
      )
    }else{
      skip("Shall not use internet.")
    }
  })
})




test_that("client error", {
  expect_warning({
    rt_clear_cache()
    http_client_error <- readRDS(system.file("http_requests/http_client_error.rds", package = "robotstxt"))
    get_robotstxt(
      "httpbin.org",
      rt_robotstxt_http_getter = function(...){http_client_error}
    )
  })

  expect_true({
    rt_clear_cache()
    http_client_error <- readRDS(system.file("http_requests/http_client_error.rds", package = "robotstxt"))
    res <-
      get_robotstxt(
      "httpbin.org",
      rt_robotstxt_http_getter = function(...){http_client_error},
      warn = FALSE
    )
    problems <- attr(res, "problems")
    problems$on_client_error$status_code == 400
  })

  expect_true({
    rt_clear_cache()
    http_client_error <- readRDS(system.file("http_requests/http_client_error.rds", package = "robotstxt"))
    res <-
    paths_allowed(
        paths = c("", "/", "here/I/stand/chopping/lops"),
        domain = "httpbin.org",
        rt_robotstxt_http_getter = function(...){http_client_error},
        warn = FALSE
      )
    all(res)
  })
})


test_that("server error", {
  expect_error({
    rt_clear_cache()
    http_server_error <- readRDS(system.file("http_requests/http_server_error.rds", package = "robotstxt"))
    get_robotstxt(
      "httpbin.org",
      rt_robotstxt_http_getter = function(...){http_server_error}
    )
  })

  expect_warning({
    rt_clear_cache()
    http_server_error <- readRDS(system.file("http_requests/http_server_error.rds", package = "robotstxt"))
    res <-
      get_robotstxt(
        "httpbin.org",
        rt_robotstxt_http_getter = function(...){http_server_error},
        rt_event_handler         = list(on_server_error = list(signal = "warning"))
      )
  })

  expect_true({
    rt_clear_cache()
    http_server_error <- readRDS(system.file("http_requests/http_server_error.rds", package = "robotstxt"))
    res <-
      paths_allowed(
        paths                    = c("", "/", "here/I/stand/chopping/lops"),
        domain                   = "httpbin.org",
        rt_robotstxt_http_getter = function(...){readRDS(system.file("http_requests/http_server_error.rds", package = "robotstxt"))},
        rt_event_handler         = list(on_server_error = list(signal = "nothing")),
        warn                     = FALSE
      )
    all(!res)
  })
})








