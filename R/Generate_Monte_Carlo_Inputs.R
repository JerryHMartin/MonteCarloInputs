#' Generate Monte Carlo Inputs
#'
#' Generates inputs for a Monte Carlo analysis.  
#' 
#' The inputs for a Monte Carlo Analysis are perturbed around a base value. 
#'  
#' This command accepts a base_value and a deviations dataframe then returns
#' a list of dataframes with elements perturbed according to deviations.
#' 
#' For a normal distribution the deviation is the standard deviation. 
#' For a uniform distribution the deviation is the absolute deviation.   
#'
#' @param base_values dataframe which holds Monte Carlo base values
#' @param deviations dataframe containing deviations analysis 
#' @param n number of iterations for analysis
#' @param distribution either "normal or "uniform"
#'
#' @return a list of dataframes with the purturbed values with the same
#'  structure as base_value 
#'
#' @examples
#' base_values = list(
#'    speed = c(10, 20),
#'    position = c(30, 40)
#' )
#' 
#' deviations = list(
#'   speed = c(0.5, 50),
#'   position = 2
#' )
#' 
#' Generate_Monte_Carlo_Inputs(base_values, deviations, 2)
#' 
#' @export
#' 
Generate_Monte_Carlo_Inputs <- function(base_values, 
                                        deviations, 
                                        n, 
                                        distribution = "normal"
) {

  len_bv = length(base_values)
  len_d = length(deviations)
  name_bv = names(base_values)
  name_d = names(deviations)

    
  # validate length of vector names
  if (len_bv != len_d){
    stop(paste("The number of vectors in the base values (",
               len_bv, ") and deviations (",  len_d,
               ") are required to be equal."))
  }  
 
   
  # validate vector names
  vecNameMatch = name_bv == name_d
  if (any(!vecNameMatch)){
    stop(paste(
      "The names", paste(name_bv[!vecNameMatch], collapse = ","),
      "and", paste(name_d[!vecNameMatch], collapse = ","),
      "should be the same."))
  }  
  
  
  # validate vector lengths
  vecLenMatch = (sapply(base_values, length) == sapply(deviations, length)) 
  vecOneMatch = sapply(deviations, function(x){length(x) == 1})
  
  if (any(!(vecLenMatch | vecOneMatch))){
    err_message = paste(
      "Check the vector lengths of the input parameters. \n The vector",
      paste(name_bv[!vecLenMatch], collapse = ","),
      "has an invalid length.\n",
      "Vector lengths in the base values and deviations parameters are",
      "required to match",
      "or the length of the deviations vector should equal one.") 
    stop(err_message)
  }  
  
  
  perturb_values = function(x){
    retVal = list()
    for(i in name_bv){
      bv = unname(unlist(base_values[i]))
      dv = unname(unlist(deviations[i]))
      
      if(distribution  == "normal") {
        retVec <- bv + stats::rnorm(length(bv)) * dv
      }
      if(distribution  == "uniform") {
        retVec <- bv + (stats::runif(length(bv)) * 2 - 1) * dv
      }
      
      retVal[[i]] <- retVec
      
    }
    return(retVal) 
  }
  
  return(lapply(seq(n), perturb_values) )
  
}
