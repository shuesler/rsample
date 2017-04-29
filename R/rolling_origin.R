#' Rolling Origin Forecast Resampling
#'
#' @inheritParams vfold_cv
#' @param initial The number of samples used for analysis/modeling in the initial resample. 
#' @param assess The number of samples used for each assessment resample.
#' @param cumulative A logical. Should the analysis resample grow beyond the size specified by \code{initial} at each resample?.
#' @param skip A integer indicating how many (if any) resamples to skip to thin the total amount of data points int eh analysis resample. 
#' @export
#' @return  An object with classes \code{"rolling_origin"} and \code{"rset"}. The elements of the object include a tibble called \code{splits} that contains a column for the data split objects and a column called \code{id} that has a character string with the resample identifier.
#' @examples
#' set.seed(1131)
#' ex_data <- data.frame(row = 1:20, some_var = rnorm(20))
#' dim(rolling_origin(ex_data))
#' dim(rolling_origin(ex_data, skip = 2))
#' dim(rolling_origin(ex_data, skip = 2, cumulative = FALSE))
#' @export
rolling_origin <- function(data, initial = 5, assess = 1, cumulative = TRUE, skip = 0, ...) {
  n <- nrow(data)
  
  if(n <= initial + assess)
    stop("There should be at least ", initial + assess,
         " nrows in `data`", call. = FALSE)
  
  stops <- seq(initial, (n - assess), by = skip + 1)
  starts <- if (!cumulative) 
    stops - initial + 1 else
      starts <- rep(1, length(stops))
  
  in_ind <- mapply(seq, starts, stops, SIMPLIFY = FALSE)
  out_ind <- mapply(seq, stops + 1, stops + assess, SIMPLIFY = FALSE)
  indices <- mapply(merge_lists, in_ind, out_ind, SIMPLIFY = FALSE)
  split_objs <- purrr::map(indices, make_splits, data = data)
  split_objs <- tibble::tibble(splits = split_objs, 
                               id = names0(length(split_objs), "Slice"))
  structure(list(splits = split_objs, 
                 initial = initial, assess = assess, 
                 cumulative = cumulative,
                 skip = skip), 
            class = c("rolling_origin", "rset"))
}

#' @export
print.rolling_origin <- function(x, ...) {
  cat("Rolling origin forecast resampling\n")
  if(x$cumulative)
    cat(" ", x$initial, "rows initially with accumulation\n") else 
      cat(" ", x$initial, "rows for each resample\n")
  cat(" ", x$assess, "rows for assessment\n")
  if(x$skip > 0)
    cat("  skipping", x$skip, 
        if(x$skip > 1) "rows" else "row", 
        "per resample\n")
  cat("\n")
}