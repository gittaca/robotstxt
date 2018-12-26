#' rt_clear_cache
#'
#' @return nothing, called for side effect on rt_cache - cache is cleared
#' @export
#'
rt_clear_cache <-
  function(){
  remove(
    list  = ls(envir = rt_cache),
    envir = rt_cache
  )
}
