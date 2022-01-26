#' Obtain indirect absolute effects 
#' 
#' @description Provides the indirect absolute effects via the back-calculation 
#'   method (Dias et al., 2010). 
#'
#' @param data_nma A data-frame with the effect sizes of all possible 
#'   comparisons in the network after performing network meta-analysis. 
#'   The data-frame has \code{T(T-1)/2} rows (\code{T} is the number of 
#'   interventions in the network) and three columns that contain the point 
#'   estimate, the lower and upper bound of the 95\% (confidence or credible) 
#'   interval of the corresponding comparison. 
#' @param data_dir A data-frame with the direct effect sizes of the observed 
#'   comparisons in the network. \code{data_dir} has the same dimension with
#'   \code{data_nma}. For comparisons with no direct effect, replace the 
#'   corresponding rows with \code{NA} to indicate the unavailability of these
#'   comparisons.
#' @param abs_risk A numeric vector with the absolute risks of the interventions
#'   in the network. The first number corresponds to the baseline risk. 
#'   The numbers are in the interval (0, 1) and sorted by the order of the 
#'   interventions in the first \code{T-1} rows of \code{compar}.
#' @param compar A data-frame with the possible pairwise comparisons in the 
#'   network. The data-frame has \code{T(T-1)/2} rows (\code{T} is the number 
#'   of interventions in the network) and two columns that refer to the
#'   experimental and control interventions of the corresponding comparison.
#'   In each row, the experimental ar should correspond to a higher identifier
#'   than the control arm. The elements can be numbers (in descending order 
#'   within each row) or character strings.
#'   
#' @return The three data-frames with the same number of rows and columns as 
#'   \code{data_nma} (and\code{data_dir}) plus two columns to indicate the 
#'   comparisons for the corresponding rows:
#'   \tabular{ll}{
#'    \strong{$risk_diff_nma} \tab The network meta-analysis absolute effects 
#'    and 95\% confidence intervals for all possible comparisons (as indicated 
#'    in \code{compar}).\cr
#'    \tab \cr
#'    \strong{$risk_diff_dir} \tab The direct absolute effects and 95\% 
#'    confidence intervals for the observed comparisons in the network.\cr
#'    \tab \cr
#'    \strong{$risk_diff_ind} \tab The indirect absolute effects and 95\% 
#'    confidence intervals via the back-calculation approach.\cr
#'    \tab \cr
#'   }
#'   
#' @details 
#'   \code{absolute_effects} is applicable for frequentist and Bayesian results.
#'   In the case of a frequentist analysis, \code{data_nma} and \code{data_dir} 
#'   comprise the estimated mean and 95\% confidence intervals. 
#'   In the case of a Bayesian analysis, \code{data_nma} and \code{data_dir} 
#'   comprise the posterior mean and 95\% credible intervals.
#'   
#'   The indirect absolute effects are obtained via the back-calculation method
#'   as proposed by Dias et al. (2010). Namely, the indirect absolute effects 
#'   are a function of the network meta-analysis and direct absolute effects
#'   (see equation (5) in Dias et al. (2010)). The following paragraph 
#'   delineates how the \code{absolute_effects} function calculates the network 
#'   meta-analysis and direct absolute effects. 
#'   
#'   The transitive risks framework has been used to obtain the network
#'   meta-analysis absolute effects. The transitive risks framework advocates
#'   that an intervention has the same absolute risk regardless of the 
#'   control intervention in the comparison (Spineli et al., 2017). 
#'   Both network meta-analysis and direct absolute effects have been obtained 
#'   as a function of the \code{abs_risk} and odds ratio (via \code{data_nma} 
#'   for the case of network meta-analysis and \code{data_dir} for the case of 
#'   direct effects, respectively). 
#'   
#'   Back-calculation is appropriate only when there are \bold{no} multi-arm 
#'   trials in the network; otherwise, the independence between the indirect 
#'   and corresponding direct absolute effects cannot be defended 
#'   (Dias et al., 2010). In the presence of multi-arm trials, back-calculation
#'   will give different results from the node-splitting approach for nodes that
#'   are included in loops informed by multi-arm trials (Dias et al., 2010).
#'   In the case of random-effects analysis, the between-trial variance 
#'   estimated via network meta-analysis may not be the same with the 
#'   between-trial variances from the pairwise meta-analyses, and hence, the 
#'   95\% confidence interval of the indirect absolute effects may be affected.
#'   This may be partially tackled in the Bayesian framework, by performing the
#'   unrelated mean effects model with common between-trial variance (to obtain 
#'   the direct odds ratios), as only one between-trial variance will be 
#'   estimated by borrowing strength from comparisons with more trials 
#'   (Dias et al., 2013; Spineli, 2021) .
#'   
#'   \code{data_nma} and \code{data_dir} should contain results in the odds 
#'   ratio scale. We advocate using the odds ratio as an effect measure to 
#'   perform pairwise and network meta-analysis for its desired mathematical 
#'   properties. Then, the risk difference (absolute effects) can be obtained 
#'   as a function of \code{abs_risk}. 
#' 
#'   For comparisons with no direct effect, the indirect effect size 
#'   coincides with the network meta-analysis effect size.
#'   
#' @author {Loukia M. Spineli}
#'   
#' @references 
#' Dias S, Welton NJ, Sutton AJ, Caldwell DM, Lu G, Ades AE. 
#' Evidence synthesis for decision making 4: inconsistency in networks of 
#' evidence based on randomized controlled trials. 
#' \emph{Med Decis Making} 2013;\bold{33}(5):641-56. 
#' \doi{10.1177/0272989X12455847}
#' 
#' Dias S, Welton NJ, Caldwell DM, Ades AE. Checking consistency in mixed 
#' treatment comparison meta-analysis. 
#' \emph{Stat Med} 2010;\bold{29}(7-8):932-44. 
#' \doi{10.1002/sim.3767}
#' 
#' Spineli LM. A Revised Framework to Evaluate the Consistency Assumption 
#' Globally in a Network of Interventions. \emph{Med Decis Making} 2021. 
#' \doi{10.1177/0272989X211068005}
#' 
#' Spineli LM, Brignardello-Petersen R, Heen AF, Achille F, Brandt L,
#' Guyatt GH, et al. Obtaining absolute effect estimates to facilitate shared
#' decision making in the context of multiple-treatment comparisons.
#' Abstracts of the Global Evidence Summit, Cape Town, South Africa.
#' \emph{Cochrane Database of Systematic Reviews} 2017;\bold{9}(Suppl 1):18911.

absolute_effects <- function (data_nma,
                              data_dir, 
                              abs_risk,
                              compar) {
  
  # Prepare the vector with the baseline risk and absolute risks
  prepare <- data.frame(unique(compar[, 2]), as.vector(table(compar[, 2])))
  colnames(prepare) <- c("name", "freq")
  absolute_risk <- rep(abs_risk[-length(unique(compar[, 2]))], prepare[, 2])
  
  # Network meta-analysis results 
  rd_nma <- (((1 - absolute_risk) * (data_nma - 1)) / 
               (1 + absolute_risk * (data_nma - 1))) * absolute_risk
  rd_nma_var <- ((rd_nma[, 3] - rd_nma[, 2]) / 3.92)^2
  
  # Pairwise meta-analysis results
  rd_dir <- (((1 - absolute_risk) * (data_dir - 1)) / 
               (1 + absolute_risk * (data_dir - 1))) * absolute_risk
  rd_dir_var <- ((rd_dir[, 3] - rd_dir[, 2]) / 3.92)^2
  
  # Apply back-calculation to obtain indirect absolute effects
  rd_ind_var <- (rd_dir_var * rd_nma_var) / (rd_dir_var - rd_nma_var)
  rd_ind <- ((rd_nma / rd_nma_var) - (rd_dir / rd_dir_var)) * rd_ind_var
  rd_ind[is.na(rd_dir)] <- rd_nma[is.na(rd_dir)]

  # Rename the columns to be the same for all data-frames
  colnames(rd_nma) <- c("mean", "lower", "upper")
  colnames(rd_dir) <- colnames(rd_ind) <- colnames(rd_nma)
  
  # Obtain the absolute risks per 1,000
  rd_nma_new <- cbind(compar, round(rd_nma*1000, 0))
  rd_dir_new <- cbind(compar, round(rd_dir*1000, 0))
  rd_ind_new <- cbind(compar, round(rd_ind*1000, 0))
  
  # Return the results
  return(list(risk_diff_nma = knitr::kable(rd_nma_new, 
                                           caption = 
                                             paste("NMA Absolute effects")),
              risk_diff_dir = knitr::kable(rd_dir_new, 
                                           caption = 
                                             paste("Direct absolute effects")),
              risk_diff_ind = knitr::kable(rd_ind_new, 
                                           caption = 
                                             paste("indirect absolute effects"))
              )
         )
}
