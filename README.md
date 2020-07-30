# MonteCarloInputs

An R package to facilitate creating inputs for a Monte Carlo Simulation.

# Background

This package simplifies creating rudimentary Monte Carlo simulation inputs. Monte Carlo analysis was an early computational analysis which was used in the Manhattan project during World War II. At the time major operations had code names, so the code name for the Monte Carlo analysis came from the Monte Carlo Casino. Randoms inputs are generated to see how random variation in the inputs of a system propagate to the outputs.

This package is intended for quickly generating inputs for a simple analysis or simulation. It only supports normal or uniform symetrical distributions.
  

# Installation
To install this package the devtools package is required.

    install.packages("devtools")
    
    library(devtools)
    install_github("JerryHMartin/MonteCarloInputs")

**Function**

    Generate_Monte_Carlo_Inputs(base_values, deviations, n, distribution)

This function creates a list of n dataframes which are strutured like base_values in a distribution specified by the deviation parameter.

**parameters**

*base_values* - a dataframe which stores all the inputs of a Monte Carlo Simulation

*deviations* - a dataframe structured the same as base_values containing the deviations. The deviation is standard if the distribution is normal.  The deviation is absolute if the distribution is uniform.

*n* - the number of input iterations

*distribution* - defaults to "normal"; however, a "uniform" distribution is supported. 


# Example

## Finding π.

In this example the value of π is estimated by radomizing positions within a unit square, then testing each position to see if it is within a quarter unit circle inscribed in the square. 

**Generate randomly distributed points within a unit square**

    base_values <- list(
        position = c(0.5, 0.5)
    )

    deviations <- list(
        position = c(0.5, 0.5)
    )

    n <- 50000
    inputs <- Generate_Monte_Carlo_Inputs(base_values, deviations, n, "uniform")

**Get the inscribed fraction of inputs which are within one unit of the origin.**
 
    distance_from_origin <- function(value){
        return(sqrt(value$position[1] ^ 2 + value$position[2] ^ 2))
    }  
    distances_from_origin <- sapply(inputs, distance_from_origin)
    inscribed_fraction = 
       sum(distances_from_origin <= 1) /  length(distances_from_origin)

**Plotting the points**
 
    plot(sapply(inputs, function(x){x$position[1]}),
        sapply(inputs, function(x){x$position[2]}),
        col = (distances_from_origin <= 1) + 1,
        xlab = "x position",
        ylab = "y position",
        main = "randomized positions"
    )

### Calculating π

The area of a circle is πr². Using this formula a quarter unit circle = π/4. 

If the points are randomly distributed, then the fraction of points within the unit circle should be π/4.

    pi_estimate = inscribed_fraction * 4

Increasing the value of *n* will increase the accuracy of the estimate of π. 







