#' @include distance.r
#' @include origin_methods.r
NULL

#' Public transportation network datasets from LinTim software (Integrated Optimization in Public Transportation)
#' 
#' @name ptn-data
#' @rdname ptn-data
#' @docType data
#' @keywords data
#' @author Juliane Manitz and Jonas Harbering
#' @seealso \code{\link{delay-data}}
#' 
#' @source Public transportation network datasets are extracted from LinTim software (Integrated Optimization in Public Transportation; \url{http://lintim.math.uni-goettingen.de/index.php?go=data&lang=en}). Special thanks to Anita Schoebel for making the data available. 
NULL

#' \code{ptnAth} The data of the Athens Metro, consisting of 51 nodes and 52 edges. 
#' \itemize{
#' \item Vertex attributes: station name, additonal station info. 
#' \item Edge attributes: track length (in meter), minimal and maximal time required to pass the track (in minutes).
#' }
#'
#' @name ptnAth
#' @rdname ptn-data
#' @docType data
#' @keywords data
#' @source The Athens Metro data was collected by Konstantinos Gkoumas.
#' 
#' @examples
#' # Athens metro system 
#' data(ptnAth)
#' plot_ptn(ptnAth)
#'
NULL

#' \code{ptnGoe} The data of the Goettingen bus network, consisting of 257 nodes and 548 edges. \itemize{
#' \item Vertex attributes: station name. 
#' \item Edge attributes:  track length (in meter), minimal and maximal time required to pass the track (in minutes).
#' }
#'
#' @name ptnGoe
#' @rdname ptn-data
#' @docType data
#' @keywords data
#' @source The Goettingen bus network data was collected by Barbara Michalski.
#' 
#' @examples
#' # Goettingen bus system 
#' data(ptnGoe)
#' plot_ptn(ptnGoe)
#'
NULL

#' Delay propagation data examples simulated by LinTim software
#' 
#' @name delay-data
#' @rdname delay-data
#' @docType data
#' @keywords data
#' @author Jonas Harbering
#' @seealso \code{\link{ptn-data}}
#' 
#' @references Manitz, J., J. Harbering, M. Schmidt, T. Kneib, and A. Schoebel (2017): Source Estimation for Propagation Processes on Complex Networks with an Application to Delays in Public Transportation Systems. Journal of Royal Statistical Society C (Applied Statistics), 66: 521-536.
#' 
#' @source Public transportation network datasets are generated by LinTim software (Integrated Optimization in Public Transportation; \url{http://lintim.math.uni-goettingen.de/index.php?go=data&lang=en}). 
NULL

#' \code{delayAth} Delay propagation data generated on the Athens metro network by LinTim software
#' 
#' @name delayAth
#' @rdname delay-data
#' @docType data
#' @keywords data
#' 
#' @details \code{delayAth} Delay data on the Athens metro network. Propagation simulation under consideration of secruity distances and fixed-waiting time delay management. 'data.frame' with 510 observations (10 sequential time pictures for delay spreading pattern from 51 stations) of 53 variables (\code{k0} true source, \code{time}, delays at 51 stations).
#'
#' @import igraph 
#'
#' @examples
#' \dontrun{ 
#' # compute effective distance
#' data(ptnAth)
#' athnet <- igraph::as_adjacency_matrix(ptnAth, sparse=FALSE)
#' p <- athnet/rowSums(athnet)
#' eff <- eff_dist(p)
#' # apply source estimation
#' if (requireNamespace("aplyr", quietly = TRUE)) {
#' data(delayAth)
#' res <- alply(.data=delayAth[,-c(1:2)], .margins=1, .fun=origin_edm, distance=eff,
#'              silent=TRUE, .progress='text')
#' perfAth <- ldply(Map(performance, x = res, start = as.list(delayAth$k0),  
#'                      list(graph = ptnAth)))
#' }
#' } 
NULL

#' \code{delayGoe} Delay propagation data generated on the Goettingen bus system by LinTim software
#' 
#' @name delayGoe
#' @rdname delay-data
#' @docType data
#' @keywords data
#' 
#' @details \code{delayGoe} Delay data on the directed Goettingen bus system. Progation simulation under consideration of secruity distances and fixed-waiting time delay management. 'data.frame' with 2570 observations (10 sequential time pictures for delay spreading pattern from 257 stations) of 259 variables (\code{k0} true source, \code{time}, delays at 257 stations).
#'
#' @import igraph 
#'
#' @examples
#' \dontrun{ 
#' # compute effective distance
#' data(ptnGoe)
#' goenet <- igraph::as_adjacency_matrix(ptnGoe, sparse=FALSE)
#' p <- goenet/rowSums(goenet)
#' eff <- eff_dist(p)
#' # apply source estimation
#' if (requireNamespace("aplyr", quietly = TRUE)) {
#' data(delayGoe)
#' res <- alply(.data=delayGoe[,-c(1:2)], .margins=1, .fun=origin_edm, distance=eff,
#'              silent=TRUE, .progress='text')
#' perfGoe <- ldply(Map(performance, x = res, start = as.list(delayGoe$k0), 
#'                      list(graph = ptnGoe)))
#' }
#' } 
NULL

#' \code{envirPara} Environment parameters for KwaZulu-Natal
#' 
#' @name envirPara
#' @rdname envirPara
#' @docType data
#' @keywords data
#' 
#' @details \code{envirPara} Environment parameters for KwaZulu-Natal
#'
#' @examples
#' data(envirPara)
#' y0 <- initial_condition_sib_model(popu, sigma, mu_B, theta, c(428))
NULL



