#' Simple Training/Test Set Splitting
#'
#' \code{initial_split} creates a single binary split of the data 
#'  into a training set and testing set. \code{training} and
#'  \code{testing} are used to extract the resulting data.
#'
#' @details 
#' The \code{strata} argument causes the random sampling to be conducted \emph{within the stratification variable}. The can help ensure that the number of data points in the training data is equivalent to the proportions in the original data set.  
#'
#' @inheritParams vfold_cv
#' @param prop The proportion of data to be retained for modeling/analysis. 
#' @param strata A variable that is used to conduct stratified sampling to create the resamples. 
#' @export
#' @return  An \code{rset} object that can be used with the \code{training} and \code{testing} functions to extract the data in each split. 
#' @examples
#' set.seed(1353)
#' car_split <- mc_cv(mtcars)
#' train_data <- training(car_split)
#' test_data <- testing(car_split) 
#' @export
#' 
initial_split <- function(data, prop = 3/4, strata = NULL, ...) {
  res <-
    mc_cv(
      data = data,
      prop = prop,
      strata = strata,
      times = 1,
      ...
    )
  res$splits[[1]]
}

#' @rdname initial_split 
#' @export
#' @param x An \code{rsplit} object produced by \code{initial_split}
training <- function(x) analysis(x)
#' @rdname initial_split 
#' @export
testing <- function(x) assessment(x)

  