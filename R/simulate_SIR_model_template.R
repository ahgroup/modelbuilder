SIR_model_ode <- function(t, y, parms) {
    with( as.list(c(y,parms)), { #lets us access variables and parameters stored in y and parms by name
        dS =  - b * S * I #susceptibles
        dI = b * S * I - g * I #infected
        dR = g * I #recovered
        list(c(dS, dI, dR))
    } ) } #close with statement, end ODE function

#' A basic SIR model with 3 compartments and infection and recovery processes
#'
#' @description USER CAN ADD MORE DETAILS HERE
#' @param S starting value for susceptible
#' @param I starting value for infected
#' @param R starting value for recovered
#' @param b infection rate
#' @param g recovery rate
#' @param tmax maximum simulation time, units depend on choice of units for your
#'   parameters
#' @return The function returns the output from the odesolver as a matrix,
#' with one column per compartment/variable. The first column is time.
#' @details USER CAN ADD MORE DETAILS HERE
#' @examples
#' # To run the simulation with default parameters just call the function:
#' result <- simulate_SIR_model()
#' @author Andreas Handel

simulate_SIR_model <- function(var = c(S = 1000, I = 1, R = 0), par = c(b = 0.01, g=0.1), tvec = c(t0 = 0, tf = 100, dt = 0.1) )
{
  times=seq(tvec[1],tvec[2],by=tvec[3])
  result = deSolve::ode(y = var, parms= par, times = times,  func = SIR_model_ode);
  result(odeoutput)
}
