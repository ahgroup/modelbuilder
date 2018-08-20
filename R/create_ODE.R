#a function that has as input a model following our structure and writes an R function based on this



create_ode <- function(model)
{


    neq = length(model$var$names) #number of variables/compartments in model

    odeskeleton = " modelode <- function(t, y, parms) { with( as.list(c(y,parms)), { ODEFIELD } ) }"

    eqs=list()

    for (n in 1:neq)
    {

    }
    eqs=c

    list(c(- b * S * I, b * S * I - g * I, g * I))


}
