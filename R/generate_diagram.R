#' Create a diagram for a model
#'
#' This function takes as input a modelbuilder model
#' and creates a diagram using ggplot
#'
#' @description The model needs to adhere to the structure specified by the modelbuilder package
#' models built using the modelbuilder package automatically have the right structure
#' a user can also build a model list structure themselves following the specifications
#' if the user provides an Rdata file name, this file needs to contain an object called 'model'
#' and contain a valid modelbuilder model structure
#' @param model model structure, either as list object or Rdata file name
#' @return The function returns the diagram stored in a variable
#' @author Andreas Handel
#' @export

generate_diagram <- function(model) {

    #if the model is passed in as a string, it is assumed to be the
    #location/name of an Rdata file containing an model and we'll load it
    #otherwise, it is assumed that 'model' is already a list structure of the right type
    if(is.character(model)) {load(model)}

    nvars = length(model$var)  #number of variables/compartments in model

    varnames = unlist(sapply(model$var, '[', 1)) #extract variable names as vector
    vartext = unlist(sapply(model$var, '[', 2)) #extract variable text as vector
    allflows = sapply(model$var, '[', 4) #extract flows
    #turns flow list into matrix, adding NA, found it online, not sure how exactly it works
    flowmat = t(sapply(allflows, `length<-`, max(lengths(allflows))))
    flowmatred = sub("\\+|-","",flowmat)   #strip leading +/- from flows
    signmat =  gsub("(\\+|-).*","\\1",flowmat) #extract only the + or - signs from flows so we know the direction


    #compartments are organized on a grid with values between 0 and 1
    #we place a max of cmax compartments per row
    #if more, we start a new row
    cmax = 4

    yfull =  (nvars %/% cmax)     #number of full rows of compartments
    yfinal = (nvars %% cmax) #number of compartments in final row

    xmin = seq(0, ,length=cmax) #min coordinates for boxes
    xmax = xmin

    diagram::openplotmat(main = "")



    d=data.frame(xmin=, xmax=seq(0,1,length=nvars), y1=c(1,1,4,1,3), y2=c(2,2,5,3,5), t=c('a','a','a','b','b'), r=c(1,2,3,4,5))
    ggplot() +
        scale_x_continuous(name="x") +
        scale_y_continuous(name="y") +
        geom_rect(data=d, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), color="black", alpha=0.5) +  geom_text(data=d, aes(x=x1+(x2-x1)/2, y=y1+(y2-y1)/2, label=r), size=4) +

    plot1 <- ggplot2::ggplot()

    #loop over all compartments and plot them as boxes
    for (i in 1:nvars)
    {

        #plot1 <- plot1 +  ggplot2::geom_rect(aes(NULL, NULL), fill="yellow", alpha=0.1, xmin = log10(8.6), xmax = log10(259.2), ymin = log10(2.9e-7), ymax = log10(2.1e-4), data = exp1)


        #diagram::textrect(mid=elpos[i,],radx=0.05,shadow.size=0.01,lab=varnames[i],box.col='lightblue')
    }

    #add flow arrows to compartments
    #want to do flows before compartments so boxes cover part of arrows
    for (i in 1:nvars)
    {
        varflowsfull = flowmat[i,] #all flows with sign for current variable
        varflows = flowmatred[i,] #all flows for current variable
        varflowsigns = signmat[i,] #signs of flows for current variable
        varflows = varflows[!is.na(varflows)] #remove NA entries

        for (j in 1:length(varflows))
        {
            currentflowfull = varflowsfull[j] #loop through all flows for variable
            currentflow = varflows[j] #loop through all flows for variable
            currentsign = varflowsigns[j] #loop through all flows for variable

            #find which variables this flow shows up in
            connectvars = unname(which(flowmatred == currentflow, arr.ind = TRUE)[,1])
            #if no other variable, make a flow that goes from current compartment to nowhere
            if (length(connectvars) == 1 && currentsign == "+") #an inflow
            {
                xcords=10^log10( c(5,142,142,5));
                ycords=10^log10( c(2.1e-7, 2.1e-7, 2.5e-7, 2.5e-7))
                exp2=as.data.frame(cbind(xcords,ycords,rep(2,4)));
                names(exp2)=c("km","kp","Fitness")


                #plot1 <- plot1 +  ggplot2::
                diagram::straightarrow(from=elpos[i,]+c(0,0.1),to=elpos[i,])
                text(elpos[i,1],elpos[i,2]+0.12,currentflow)
            }
            if (length(connectvars) == 1 && currentsign == "-") #an outflow
            {
                diagram::straightarrow(from=elpos[i,],to=elpos[i,]-c(0,0.1), arr.pos = 1)
                text(elpos[i,1],elpos[i,2]-0.14,currentflow)
            }
            #if one other variable, connect with arrow
            if (length(connectvars) == 2 && currentsign == "+") #an inflow
            {
                linkvar = connectvars[which(connectvars != i)] #find number of variable to link to
                if (abs(linkvar-i)==1) #if the variables are neighbors, make straight arrow, otherwise curved
                {
                    diagram::straightarrow(from=elpos[linkvar,],to=elpos[i,])
                    #text(elpos[i,1]+0.1,elpos[i,2]+0.05,currentflow)
                }
                else
                {
                    curvedarrow(from=elpos[linkvar,],to=elpos[i,],curve=0.4)
                    #text(elpos[i,1]+0.1,elpos[i,2]+0.05,currentflow)
                }
            }
            if (length(connectvars) == 2 && currentsign == "-") #an outflow
            {
                linkvar = connectvars[which(connectvars != i)] #find number of variable to link to
                if (abs(linkvar-i)==1) #if the variables are neighbors, make straight arrow, otherwise curved
                {
                    diagram::straightarrow(from=elpos[i,], to=elpos[linkvar,])
                    text(elpos[i,1]+0.15,elpos[i,2]+0.05,currentflow)
                }
                else
                {
                    diagram::curvedarrow(from=elpos[i,], to=elpos[linkvar,],curve=0.4)
                    text(elpos[i,1]+0.1,elpos[i,2]+0.05,currentflow)
                }
            }
            #more than one variable, i.e. a splitting flow, is currently not allowed
            #could possibly be implemented using treearrow
        } #end loop over flows for each variable
    } #end loop over all variables
    #place all compartments sequentially


    modelplot <- recordPlot()

}
