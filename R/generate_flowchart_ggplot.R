#' @title This function takes as input a modelbuilder model and creates a diagram using ggplot
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

generate_flowchart_ggplot <- function(model) {

    #if the model is passed in as a string, it is assumed to be the
    #location/name of an Rdata file containing an model and we'll load it
    #otherwise, it is assumed that 'model' is already a list structure of the right type
    if (is.character(model)) {load(model)}

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

    nrows = ceiling(nvars/cmax) #number of rows for grid

    xmin = rep(seq(0,1,by=1/(2*cmax-1))[c(TRUE,FALSE)], nrows) #min coordinates for boxes
    xmax = rep(seq(0,1,by=1/(2*cmax-1))[c(FALSE,TRUE)], nrows) #max coordinates for boxes

    yplotmin = 0.2
    yplotmax = 0.8 #max range for y - doesn't seem to make a difference
    ymin = sort(rep(seq(yplotmin,yplotmax,by=(yplotmax-yplotmin)/(2*nrows-1))[c(TRUE,FALSE)], cmax)) #sort gets the x and y values in the right configuration
    ymax = sort(rep(seq(yplotmin,yplotmax,by=(yplotmax-yplotmin)/(2*nrows-1))[c(FALSE,TRUE)], cmax))

    #data frame with all compartments and their positions
    d=data.frame(xmin=xmin[1:nvars], xmax=xmax[1:nvars], ymin=ymin[1:nvars], ymax=ymax[1:nvars], vartext=vartext)
    d <- dplyr::mutate(d, xcenter = xmin+(xmax-xmin)/2, ycenter = ymin+(ymax-ymin)/2)

    #plot compartments
    plot1 <- ggplot2::ggplot() + scale_x_continuous(name="",limits=c(0,1)) + scale_y_continuous(name="",limits=c(0,1))
    plot2 <- plot1 + geom_rect(data=d, mapping=aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax), fill = 'white',color = 'black')
    plot3 <- plot2 + geom_text(data=d, aes(x=xcenter, y=ycenter, label=vartext), size=4)
    plot4 <- plot3 + theme_void()

    #add flow arrows to compartments
    arrs=1.4; #arrowsize
    # connectvar_vector <- vector()
    # linkvar_vector <- vector()
    start_value <- vector()
    end_value <- vector()
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

            ###########################################################################################
            #make different connections for different flows
            #note that the only types of flows allowed are these:
            #* flows that enter/leave compartments from 'nowhere'
            #* flows that connect a compartment with itself (e.g. a growth term)
            #* flows that connect 2 compartments.
            #branched flows, e.g. -bSI leaving a compartment and fbSI arriving in one and (1-f)bSI in another
            #are not allowed. Those flows need during the model building stage be written as 2 independent flows
            #-bfSI/bfSI and -(1-f)bSI/(1-f)bSI


            ###########################################################################################
            #if flow shows up as single term
            #i.e. a variable has an inflow or outflow not leading to another variable
            #make a flow that goes from current compartment to nowhere
            if (length(connectvars) == 1 && currentsign == "+") #an inflow, coming from top
            {
                plot4 = plot4 + ggplot2::geom_segment(aes(x = d$xcenter[i], y = d$ymax[i]+0.1, xend = d$xcenter[i], yend = d$ymax[i] ), arrow = arrow(angle = 25, length=unit(0.1,"inches"), ends = "first", type = "closed"))
                browser()
            }
            if (length(connectvars) == 1 && currentsign == "-") #an outflow
            {
                plot4 = plot4 + ggplot2::geom_segment(aes(x = d$xcenter[i], y = d$ymin[i], xend = d$xcenter[i], yend = d$ymin[i]-0.1), arrow = arrow(angle = 25, length=unit(0.1,"inches"), ends = "first", type = "closed"))
                browser()
            }

            ###########################################################################################
            #if flow shows up twice
            #i.e. a variable has an inflow or outflow that leads to another variable
            #make a flow that goes from current compartment to nowhere

            #since every inflow is connected to an outflow, we only need to assign arrows
            #for outflows and connect them to the inflow variable
            if (length(connectvars) == 2 && currentsign == "-") #an outflow
            {
                linkvar = connectvars[which(connectvars != i)] #find number of variable to link to
                if (abs(linkvar-i)==1) #if the variables are neighbors, make straight arrow, otherwise curved
                {
                    start_value <- c(start_value, i)
                    end_value <- c(end_value, linkvar)
                }
                else
                {
                    #curvedarrow(from=elpos[linkvar,],to=elpos[i,],curve=0.4)
                }
            }
            #Note: flows connecting more than 2 variables, i.e. a splitting flow, is currently not allowed
            #could possibly be implemented using treearrow
        } #end loop over flows for each variable
    } #end loop over all variables
    #place all compartments sequentially

    # create dataframe for adding segments
    # inspired by user Taylor White's answer on this thread: https://stackoverflow.com/questions/24617414/enriching-a-ggplot2-plot-with-multiple-geom-segment-in-a-loop
    segment_dataframe <- data.frame(
        start_value = start_value,
        end_value = end_value
    )
    plot4 <- plot4 + geom_segment(data = segment_dataframe, aes(x = d$xmax[start_value], y = d$ycenter[start_value], xend = d$xmin[end_value], yend = d$ycenter[end_value] ), arrow = arrow(angle = 25, length=unit(0.1,"inches"), ends = "last", type = "closed"), linejoin='mitre')

    return(plot4)
}
