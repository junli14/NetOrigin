#' Compute Mu and Lambda for Source Detection Function
#'
#' \code{compute_mu_lambda} computes 'mu' and 'lambda' from training data and 
#' selected observers, for Gaussian source estimation with prior information
#'
#' @rdname compute_mu_lambda
#'
#' @param train.data training data for 'mu' and 'lambda' list computation
#'        format-list, length-number of cities/nodes
#'        format of train.data[[i]]- number of simulated scenarios x number of cities/nodes, each entry is minimum arrival time
#' @param obs.vec list of cities ids used as observers
#' @param candidate.thres threshold to determine if a node/city could be a candidate for source
#'        e.g. if we set this number to be 0.2, if in [x] simulated scenarios, there are only 10 percent
#'        scenarios a node [a] is infected, we do not think [a] is a potential source
#' @param print.setpara print notifying message every how many iterations
#'
#' @return a list, consisting of 3 variables: mu.mat, lambda.list, poss.candidate.vec
#'         mu.mat: matrix- number of cities/nodes x number of observers, each row represents- 
#'         if this node is the source, the mean of arrival time vector;
#'         lambda.list: a length-number of cities/nodes list, each element is a number of observers x number of observers matrix-
#'         if a node is the source, the covariance matrix for arrival time vector;
#'         poss.candidate.vec: a boolean vector indicating if a node has the potential to be the source
#' 
#' @import corpcor
#'
#' @examples
#' # fake training data, indicating format
#' nnodes <- 10
#' max.day <- 20
#' nsimu <- 10
#' train.data.fake <- list()
#' for (j in 1:nnodes) {
#'   train.data.fake[[j]] <- matrix(sample.int(max.day, 
#'     size = nsimu*nnodes, replace = TRUE), nrow = nsimu, ncol = nnodes)
#' }
#' train.data.fake[[1]][1,1] <- NA
#' obs.vec <- (1:9)
#' candidate.thres <- 0.9
#' mu.lambda.list <- compute_mu_lambda(train.data.fake, obs.vec, candidate.thres, 5)
#' @export


compute_mu_lambda <- function(train.data, obs.vec, candidate.thres, 
  print.setpara){  
  ## constant parameters
  nreal <- dim(train.data[[1]])[1]
  nnodes <- dim(train.data[[1]])[2]
  nodes851.id <- 1:nnodes
  total.obs.num <- length(obs.vec)
  
  ## output values
  mu.mat <- matrix(NA, nnodes, total.obs.num)
  lambda.list <- list()
  
  ## make 'poss.candidate.vec'
  train.data.obs.list <- list()
  for (j in 1:nnodes){
    train.data.obs.list[[j]] <- train.data[[j]][, obs.vec]
  }
  train.use.sample.vec <- rep(NA, nnodes)
  test.use.sample.vec <- rep(NA, nnodes)
  for (j in 1:nnodes) {
    indicator.train <- !is.na(rowSums(train.data.obs.list[[j]]))
    indicator.test <- !is.na(rowSums(train.data.obs.list[[j]]))
    train.use.sample.vec[j] <- sum(indicator.train)
    test.use.sample.vec[j] <- sum(indicator.test)
  }
  poss.candidate.vec <- ((train.use.sample.vec > candidate.thres * nreal) & 
                           (test.use.sample.vec > candidate.thres * nreal))
  
  ## compute 'mu' and 'lambda'
  for (j in 1:nnodes) {
    if (poss.candidate.vec[j]) {
      indicator <- !is.na(rowSums(train.data.obs.list[[j]]))
      curr.mat <- train.data.obs.list[[j]][indicator, ]
      mu.mat[j, ] <- colMeans(curr.mat)
      ##
      curr.cov <- cov.shrink(curr.mat, verbose = FALSE)
      class(curr.cov) <- NULL
      lambda.list[[j]] <- curr.cov
    } else {
      lambda.list[[j]] <- NA
    }
    if (j %% print.setpara == 0) {
      cat(paste0("This is loop: ", toString(j), "\n"))
    }
  } # end of for loop
  
  ## return
  result.list <- list(mu.mat = mu.mat,
                      lambda.list = lambda.list,
                      poss.candidate.vec = poss.candidate.vec)
  return(result.list)
}









