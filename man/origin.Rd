% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/origin_helper.r, R/origin_methods.r
\name{origin}
\alias{origin}
\alias{origin_edm}
\alias{origin_backtracking}
\alias{origin_centrality}
\alias{origin_bayesian}
\title{Origin Estimation for Propagation Processes on Complex Networks}
\usage{
origin(events, type = c("edm", "backtracking", "centrality", "bayesian"), ...)

origin_edm(events, distance, silent = TRUE)

origin_backtracking(events, graph, start_with_event_node = TRUE, silent = TRUE)

origin_centrality(events, graph, silent = TRUE)

origin_bayesian(
  events,
  thres.vec,
  obs.vec,
  mu.mat,
  lambda.list,
  poss.candidate.vec,
  prior,
  use.prior = TRUE
)
}
\arguments{
\item{events}{numeric vector of event counts at a specific time point; if type is 'bayesian', 'events' is a matrix, number of nodes x time points; entries represent number of cases}

\item{type}{character specifying the method, \code{'edm'}, \code{'backtracking'}, \code{'centrality'} and \code{'bayesian'} are available.}

\item{...}{parameters to be passed to origin methods \code{\link{origin_edm}}, \code{\link{origin_backtracking}}, \code{\link{origin_centrality}} or \code{\link{origin_centrality}}}

\item{distance}{numeric matrix specifying the distance matrix (for \code{type='edm'})}

\item{silent}{locigal, should the messages be suppressed?}

\item{graph}{igraph object specifying the underlying network graph (for \code{type='backtracking'} and \code{type='centrality'})}

\item{start_with_event_node}{logical specifying whether backtracking only starts from nodes that experienced events (for \code{type='backtracking'})}

\item{thres.vec}{vector, length represents number of cities/nodes, representing
thresholds for cities/nodes that they are infected}

\item{obs.vec}{list of cities ids used as observers}

\item{mu.mat}{matrix- number of cities/nodes x number of observers, each row represents- 
if this node is the source, the mean of arrival time vector}

\item{lambda.list}{a length-number of cities/nodes list, each element is a number of observers x number of observers matrix-
if a node is the source, the covariance matrix for arrival time vector}

\item{poss.candidate.vec}{a boolean vector indicating if a node has the potential to be the source}

\item{prior}{vector, length - number of cities/nodes, prior for cities}

\item{use.prior}{boolean, TRUE or FALSE, if use prior, default TRUE}
}
\value{
\code{origin_edm} returns an object of class \code{origin}, list with 
\itemize{
 \item \code{est} origin estimate
 \item \code{aux} \code{data.frame} with auxiliary variables 
   \itemize{
      \item \code{id} as node identifier, 
      \item \code{events} for event magnitude, 
      \item \code{wmean} for weighted mean, 
      \item \code{wvar} for weighted variance, and 
      \item \code{mdist} mean distance from a node to all other nodes.
   }
 \item \code{type = 'edm'} effective distance median origin estimation
 }

\code{origin_backtracking} returns an object of class \code{origin}, list with 
\itemize{
 \item \code{est} origin estimate
 \item \code{aux} \code{data.frame} with auxiliary variables 
   \itemize{
      \item \code{id} as node identifier, 
      \item \code{events} for event magnitude, and
      \item \code{bcount} for backtracking counts, how often backtracking identifies this source node.
   }
 \item \code{type = 'backtracking'} backtracking origin estimation
 }

\code{origin_centrality} returns an object of class \code{origin}, list with 
\itemize{
 \item \code{est} origin estimate
 \item \code{aux} \code{data.frame} with auxiliary variables 
   \itemize{
      \item \code{id} as node identifier, 
      \item \code{events} for event magnitude, and
      \item \code{cent} for node centrality (betweenness divided degree).
   }
 \item \code{type = 'centrality'} centrality-based origin estimation
 }

a dataframe with columns 'nodes' and 'probab', indicating nodes indices and their posteriors
}
\description{
This is the main function for origin estimation for propagation processes on complex networks. Different methods are available: effective distance median (\code{'edm'}), recursive backtracking (\code{'backtracking'}), and centrality-based source estimation (\code{'centrality'}).
For details on the methodological background, we refer to the corresponding publications.

\code{origin_edm} for effective distance-median origin estimation (Manitz et al., 2016)
}
\examples{
data(delayGoe)

# compute effective distance
data(ptnGoe)
goenet <- igraph::as_adjacency_matrix(ptnGoe, sparse=FALSE)
p <- goenet/rowSums(goenet)
eff <- eff_dist(p)
# apply effective distance median source estimation
om <- origin(events=delayGoe[10,-c(1:2)], type='edm', distance=eff)
summary(om)
plot(om, 'mdist',start=1)
plot(om, 'wvar',start=1)
performance(om, start=1, graph=ptnGoe)

# backtracking origin estimation (Manitz et al., 2016)
ob <- origin(events=delayGoe[10,-c(1:2)], type='backtracking', graph=ptnGoe)
summary(ob)
plot(ob, start=1)
performance(ob, start=1, graph=ptnGoe)

# centrality-based origin estimation (Comin et al., 2011)
oc <- origin(events=delayGoe[10,-c(1:2)], type='centrality', graph=ptnGoe)
summary(oc)
plot(oc, start=1)
performance(oc, start=1, graph=ptnGoe)

# fake training data, indicating format
nnodes <- 10
max.day <- 20
nsimu <- 10
max.case.per.day <- 10
train.data.fake <- list()
for (j in 1:nnodes) {
  train.data.fake[[j]] <- matrix(sample.int(max.day, 
    size = nsimu*nnodes, replace = TRUE), nrow = nsimu, ncol = nnodes)
}
train.data.fake[[1]][1,1] <- NA
obs.vec <- (1:9)
candidate.thres <- 0.9
mu.lambda.list <- compute_mu_lambda(train.data.fake, obs.vec, candidate.thres, 5)
# matrix representing number of cases per node per day
cases.node.day <- matrix(sample.int(max.case.per.day, 
  size = nnodes*max.day, replace = TRUE), nrow = nnodes, ncol = max.day)
nnodes <- dim(cases.node.day)[1] # number of nodes
# fixed threshold for all nodes - 10 infected people
thres.vec <- rep(10, nnodes)
# flat/non-informative prior
prior <- rep(1, nnodes) 
# the following result shows potential sources with posterior probabilities
# in descending order, i.e., the first row indicates the potential source
# with largest probability
result2.df <- origin(events = cases.node.day, type = "bayesian",
                     thres.vec = thres.vec,
                     obs.vec = obs.vec,
                     mu.mat=mu.lambda.list$mu.mat, lambda.list = mu.lambda.list$lambda.list, 
                     poss.candidate.vec=mu.lambda.list$poss.candidate.vec,
                     prior=prior, use.prior=TRUE)

}
\references{
\itemize{
  \item Comin, C. H. and da Fontoura Costa, L. (2011). Identifying the starting point of a spreading process in complex networks. Physical Review E, 84. <DOI: 10.1103/PhysRevE.84.056105>
  \item Manitz, J., J. Harbering, M. Schmidt, T. Kneib, and A. Schoebel (2017): Source Estimation for Propagation Processes on Complex Networks with an Application to Delays in Public Transportation Systems. Journal of Royal Statistical Society C (Applied Statistics), 66: 521-536.
  \item Manitz, J. (2014). Statistical Inference for Propagation Processes on Complex Networks. Ph.D. thesis, Georg-August-University Goettingen. Verlag Dr.~Hut, ISBN 978-3-8439-1668-4. Available online: \url{http://ediss.uni-goettingen.de/handle/11858/00-1735-0000-0022-5F38-B}.
  \item Manitz, J., Kneib, T., Schlather, M., Helbing, D. and Brockmann, D. (2014). Origin detection during food-borne disease outbreaks - a case study of the 2011 EHEC/HUS outbreak in Germany. PLoS Currents Outbreaks, 1. <DOI: 10.1371/currents.outbreaks.f3fdeb08c5b9de7c09ed9cbcef5f01f2>
}
}
\seealso{
Other origin-est: 
\code{\link{origin_multiple}()}
}
\author{
Juliane Manitz with contributions by Jonas Harbering
}
\concept{origin-est}
