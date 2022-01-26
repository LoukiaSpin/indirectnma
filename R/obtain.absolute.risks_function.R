#' Obtain absolute risks from published NMA results
#' 
#' @param data A data-frame with the NMA effect sizes of comparisons with the
#'   reference intervention of the network. The data-frame has \code{T-1} rows 
#'   (\code{T} is the number of interventions in the network) and four columns 
#'   that contain the name of the non-reference interventions, the point 
#'   estimate, the lower and upper bound of the 95% (confidence or credible) 
#'   interval of the corresponding comparison with the reference intervention.
#' @param ref Character string with the name of the reference intervention.
#' @param base_risk A number in the interval (0, 1) that indicates the baseline
#'   risk for the selected reference intervention. 
#' @param measure Character string indicating the effect measure of \code{data}. 
#'   For a binary outcome, the following can be considered: \code{"OR"}, 
#'   \code{"RR"} or \code{"RD"} for the odds ratio, relative risk, and risk 
#'   difference, respectively. 
#' @param log Logical to indicate whether to export the tabulated results
#'   to an 'xlsx' file (via the \code{\link[writexl:write_xlsx]{write_xlsx}}
#'   function of the R-package
#'   \href{https://CRAN.R-project.org/package=writexl}{writexl}) at the working
#'   directory of the user. 
#'
#' @return A data-frame with same dimensions as \code{data} that contains the
#'  names of the non-reference interventions (first column), and the 
#'  corresponding absolute risk (second column), lower and upper 95% confidence
#'  interval (third and fourth columns, respectively) per 1,000 participants.
#'
#' @details The absolute risks have been estimated based on the transitive
#'   risks framework, namely, an intervention has the same absolute risk 
#'   regardless of the control intervention in the comparison 
#'   (Spineli et al., 2017).
#'   The absolute risks are a function of \code{data} and the selected
#'   baseline risk for the reference intervention \code{base_risk}. The formulas
#'   in Walter (2000) have been considered to obtain the absolute risk for each
#'   non-reference intervention when \code{measure = "OR}, \code{measure = "RR},
#'   or \code{measure = "RD}.
#'
#' @author {Loukia M. Spineli}
#'
#' @references 
#' Spineli LM, Brignardello-Petersen R, Heen AF, Achille F, Brandt L,
#' Guyatt GH, et al. Obtaining absolute effect estimates to facilitate shared
#' decision making in the context of multiple-treatment comparisons.
#' Abstracts of the Global Evidence Summit, Cape Town, South Africa.
#' \emph{Cochrane Database of Systematic Reviews} 2017;\bold{9}(Suppl 1):18911.
#' 
#' Walter SD. Choice of effect measure for epidemiological data. 
#' \emph{J Clin Epidemiol} 2000;\bold{53}(9):931-9. 
#' \doi{10.1016/s0895-4356(00)00210-9} 

absolute_risk <- function (data, ref, base_risk, measure, log) {
  
 
  # Missing and default arguments
  ref <- if (missing(ref)) {
    stop("The argument 'ref' needs to be defined", call. = FALSE)
  } else {
    ref
  }
  base_risk <- if (missing(base_risk)) {
    stop("The argument 'base_risk' needs to be defined", call. = FALSE)
  } else {
    base_risk
  }
  measure <- if (missing(measure)) {
    stop("The argument 'measure' needs to be defined", call. = FALSE)
  } else if (!is.element(measure, c("OR", "RR", "RD"))) {
    stop("Insert 'OR', 'RR', or 'RD'", call. = FALSE)
  } else {
    measure
  }
  log <- if (missing(log)) {
    stop("The argument 'log' needs to be defined. Insert 'TRUE' or 'FALSE'", call. = FALSE)
  } else {
    log
  }
  
  dataset <- if (log == TRUE & !is.element(measure, "RD")) {
   exp(data[, 2:4])
  } else if (log == FALSE || measure == "RD") {
    data[, 2:4]
  }
  
  absol_risk0 <- if (measure == "OR") {
    round((dataset * base_risk) / (1 + base_risk * (dataset - 1)) * 1000, 0)
  } else if (measure == "RR") {
    round(dataset * base_risk * 1000, 0)
  } else {
    round((base_risk - dataset) * 1000, 0)
  }
  
  absol_risk <- data.frame(data[, 1], absol_risk0)
  colnames(absol_risk) <- c(paste("versus", ref), names(absol_risk0))
  
  writexl::write_xlsx(absol_risk, paste0("Table absolute risks", ".xlsx"))
  
  return(absol_risk)
}

