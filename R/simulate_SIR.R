modelode <- function(t, y, parms)
{
   with(
    as.list(c(y,parms)), #lets us access variables and parameters stored in y and parms by name
    {

      #the ordinary differential equations
  	  dS =  - b * S * I; #susceptibles
	  dI = b * S * I - g * I; #infected/infectious
	  dR = g * I; #recovered

	  list(c(dS, dI, dR))
    }
   ) #close with statement
} #end function specifying the ODEs


#' Simulation of a basic SIR model illustrating a single infectious disease outbreak
#' All of the documentation should be written automatically based on information in the model list structure
#' @author Andreas Handel
#' @export

simulate_SIR <- function(var = c(S = 1000, I = 1, R = 0), par = c(b = 0.01, g=0.1), tvec = c(0,100,0.1) )
{
    times=seq(tvec[1],tvec[2],by=tvec[3])
    odeoutput = deSolve::ode(y = var, parms= par, times = times,  func = modelode);

  return(odeoutput)
}
