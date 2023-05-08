############################## 
#R script to generate a modelbuilder model object with code. 
#This file was generated on 2023-05-08 15:16:21.979918 
############################## 
 
 mbmodel = list() #create empty list 
 
 #Model meta-information
 mbmodel$title = 'Stratified Inoculum Model'
 mbmodel$description = ''
 mbmodel$author = 'Andreas Handel'
 mbmodel$date = Sys.Date()
 mbmodel$details = '' 

 #Information for all variables
 var = vector('list',43)
 id = 0
 id = id + 1
 var[[id]]$varname = 'H1'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k1*A1*H1', '-c1*H1')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H2'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k2*A2*H2', '-c2*H2')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H3'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k3*A3*H3', '-c3*H3')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H4'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k4*A4*H4', '-c4*H4')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H5'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k5*A5*H5', '-c5*H5')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H6'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k6*A6*H6', '-c6*H6')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H7'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k7*A7*H7', '-c7*H7')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H8'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k8*A8*H8', '-c8*H8')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H9'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k9*A9*H9', '-c9*H9')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H10'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k10*A10*H10', '-c10*H10')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H11'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k11*A11*H11', '-c11*H11')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H12'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k12*A12*H12', '-c12*H12')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H13'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k13*A13*H13', '-c13*H13')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'H14'
 var[[id]]$vartext = 'antigen'
 var[[id]]$varval = 100
 var[[id]]$flows = c('+k14*A14*H14', '-c14*H14')
 var[[id]]$flownames = c('removal', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'F'
 var[[id]]$vartext = 'innate response'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+p', '-m*F', '+q*fmax*H1/(H1+n)', '-q*F*H1/(H1+n)')
 var[[id]]$flownames = c('growth', 'decay', 'max growth', 'decay from max')
 
 id = id + 1
 var[[id]]$varname = 'B1'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g1*B1*H1*F/(s1+H1*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B2'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g2*B2*H2*F/(s2+H2*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B3'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g3*B3*H3*F/(s3+H3*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B4'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g4*B4*H4*F/(s4+H4*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B5'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g5*B5*H5*F/(s5+H5*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B6'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g6*B6*H6*F/(s6+H6*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B7'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g7*B7*H7*F/(s7+H7*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B8'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g8*B8*H8*F/(s8+H8*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B9'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g9*B9*H9*F/(s9+H9*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B10'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g10*B10*H10*F/(s10+H10*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B11'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g11*B11*H11*F/(s11+H11*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B12'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g12*B12*H12*F/(s12+H12*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B13'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g13*B13*H13*F/(s13+H13*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'B14'
 var[[id]]$vartext = 'B cells'
 var[[id]]$varval = 1
 var[[id]]$flows = c('+g14*B14*H14*F/(s14+H14*F)')
 var[[id]]$flownames = c('induction')
 
 id = id + 1
 var[[id]]$varname = 'A1'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k1*A1*H1', '+r1*B1', '-d1*A1')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A2'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k2*A2*H2', '+r2*B2', '-d2*A2')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A3'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k3*A3*H3', '+r3*B3', '-d3*A3')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A4'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k4*A4*H4', '+r4*B4', '-d4*A4')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A5'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k5*A5*H5', '+r5*B5', '-d5*A5')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A6'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k6*A6*H6', '+r6*B6', '-d6*A6')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A7'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k7*A7*H7', '+r7*B7', '-d7*A7')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A8'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k8*A8*H8', '+r8*B8', '-d8*A8')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A9'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k9*A9*H9', '+r9*B9', '-d9*A9')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A10'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k10*A10*H10', '+r10*B10', '-d10*A10')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A11'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k11*A11*H11', '+r11*B11', '-d11*A11')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A12'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k12*A12*H12', '+r12*B12', '-d12*A12')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A13'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k13*A13*H13', '+r13*B13', '-d13*A13')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 id = id + 1
 var[[id]]$varname = 'A14'
 var[[id]]$vartext = 'antibodies'
 var[[id]]$varval = 1
 var[[id]]$flows = c('-k14*A14*H14', '+r14*B14', '-d14*A14')
 var[[id]]$flownames = c('removal', 'production of antibodies', 'decay')
 
 mbmodel$var = var
 
 #Information for all parameters
 par = vector('list',89)
 id = 0
 id = id + 1
 par[[id]]$parname = 'k1'
 par[[id]]$partext = 'killing rate 1'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k2'
 par[[id]]$partext = 'killing rate 2'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k3'
 par[[id]]$partext = 'killing rate 3'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k4'
 par[[id]]$partext = 'killing rate 4'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k5'
 par[[id]]$partext = 'killing rate 5'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k6'
 par[[id]]$partext = 'killing rate 6'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k7'
 par[[id]]$partext = 'killing rate 7'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k8'
 par[[id]]$partext = 'killing rate 8'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k9'
 par[[id]]$partext = 'killing rate 9'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k10'
 par[[id]]$partext = 'killing rate 10'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k11'
 par[[id]]$partext = 'killing rate 11'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k12'
 par[[id]]$partext = 'killing rate 12'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k13'
 par[[id]]$partext = 'killing rate 13'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'k14'
 par[[id]]$partext = 'killing rate 14'
 par[[id]]$parval = 1e-04
 
 id = id + 1
 par[[id]]$parname = 'c1'
 par[[id]]$partext = 'antigen decay 1'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c2'
 par[[id]]$partext = 'antigen decay 2'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c3'
 par[[id]]$partext = 'antigen decay 3'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c4'
 par[[id]]$partext = 'antigen decay 4'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c5'
 par[[id]]$partext = 'antigen decay 5'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c6'
 par[[id]]$partext = 'antigen decay 6'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c7'
 par[[id]]$partext = 'antigen decay 7'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c8'
 par[[id]]$partext = 'antigen decay 8'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c9'
 par[[id]]$partext = 'antigen decay 9'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c10'
 par[[id]]$partext = 'antigen decay 10'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c11'
 par[[id]]$partext = 'antigen decay 11'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c12'
 par[[id]]$partext = 'antigen decay 12'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c13'
 par[[id]]$partext = 'antigen decay 13'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'c14'
 par[[id]]$partext = 'antigen decay 14'
 par[[id]]$parval = 2
 
 id = id + 1
 par[[id]]$parname = 'p'
 par[[id]]$partext = 'innate growth'
 par[[id]]$parval = 4
 
 id = id + 1
 par[[id]]$parname = 'm'
 par[[id]]$partext = 'innate decay'
 par[[id]]$parval = 4
 
 id = id + 1
 par[[id]]$parname = 'q'
 par[[id]]$partext = 'innate induction'
 par[[id]]$parval = 3
 
 id = id + 1
 par[[id]]$parname = 'fmax'
 par[[id]]$partext = 'innate saturation'
 par[[id]]$parval = 1e+05
 
 id = id + 1
 par[[id]]$parname = 'n'
 par[[id]]$partext = 'antigen halfpoint'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'g1'
 par[[id]]$partext = 'B cell growth 1'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g2'
 par[[id]]$partext = 'B cell growth 2'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g3'
 par[[id]]$partext = 'B cell growth 3'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g4'
 par[[id]]$partext = 'B cell growth 4'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g5'
 par[[id]]$partext = 'B cell growth 5'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g6'
 par[[id]]$partext = 'B cell growth 6'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g7'
 par[[id]]$partext = 'B cell growth 7'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g8'
 par[[id]]$partext = 'B cell growth 8'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g9'
 par[[id]]$partext = 'B cell growth 9'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g10'
 par[[id]]$partext = 'B cell growth 10'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g11'
 par[[id]]$partext = 'B cell growth 11'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g12'
 par[[id]]$partext = 'B cell growth 12'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g13'
 par[[id]]$partext = 'B cell growth 13'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 'g14'
 par[[id]]$partext = 'B cell growth 14'
 par[[id]]$parval = 0.5
 
 id = id + 1
 par[[id]]$parname = 's1'
 par[[id]]$partext = 'b cell halfpoint 1'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's2'
 par[[id]]$partext = 'b cell halfpoint 2'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's3'
 par[[id]]$partext = 'b cell halfpoint 3'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's4'
 par[[id]]$partext = 'b cell halfpoint 4'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's5'
 par[[id]]$partext = 'b cell halfpoint 5'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's6'
 par[[id]]$partext = 'b cell halfpoint 6'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's7'
 par[[id]]$partext = 'b cell halfpoint 7'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's8'
 par[[id]]$partext = 'b cell halfpoint 8'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's9'
 par[[id]]$partext = 'b cell halfpoint 9'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's10'
 par[[id]]$partext = 'b cell halfpoint 10'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's11'
 par[[id]]$partext = 'b cell halfpoint 11'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's12'
 par[[id]]$partext = 'b cell halfpoint 12'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's13'
 par[[id]]$partext = 'b cell halfpoint 13'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 's14'
 par[[id]]$partext = 'b cell halfpoint 14'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'r1'
 par[[id]]$partext = 'antibody production 1'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r2'
 par[[id]]$partext = 'antibody production 2'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r3'
 par[[id]]$partext = 'antibody production 3'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r4'
 par[[id]]$partext = 'antibody production 4'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r5'
 par[[id]]$partext = 'antibody production 5'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r6'
 par[[id]]$partext = 'antibody production 6'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r7'
 par[[id]]$partext = 'antibody production 7'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r8'
 par[[id]]$partext = 'antibody production 8'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r9'
 par[[id]]$partext = 'antibody production 9'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r10'
 par[[id]]$partext = 'antibody production 10'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r11'
 par[[id]]$partext = 'antibody production 11'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r12'
 par[[id]]$partext = 'antibody production 12'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r13'
 par[[id]]$partext = 'antibody production 13'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'r14'
 par[[id]]$partext = 'antibody production 14'
 par[[id]]$parval = 100
 
 id = id + 1
 par[[id]]$parname = 'd1'
 par[[id]]$partext = 'antibody decay 1'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd2'
 par[[id]]$partext = 'antibody decay 2'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd3'
 par[[id]]$partext = 'antibody decay 3'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd4'
 par[[id]]$partext = 'antibody decay 4'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd5'
 par[[id]]$partext = 'antibody decay 5'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd6'
 par[[id]]$partext = 'antibody decay 6'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd7'
 par[[id]]$partext = 'antibody decay 7'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd8'
 par[[id]]$partext = 'antibody decay 8'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd9'
 par[[id]]$partext = 'antibody decay 9'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd10'
 par[[id]]$partext = 'antibody decay 10'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd11'
 par[[id]]$partext = 'antibody decay 11'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd12'
 par[[id]]$partext = 'antibody decay 12'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd13'
 par[[id]]$partext = 'antibody decay 13'
 par[[id]]$parval = 10
 
 id = id + 1
 par[[id]]$parname = 'd14'
 par[[id]]$partext = 'antibody decay 14'
 par[[id]]$parval = 10
 
 mbmodel$par = par
 
 #Information for time parameters
 time = vector('list',3)
 id = 0
 id = id + 1
 time[[id]]$timename = 'tstart'
 time[[id]]$timetext = 'Start time of simulation'
 time[[id]]$timeval = 0
 
 id = id + 1
 time[[id]]$timename = 'tfinal'
 time[[id]]$timetext = 'Final time of simulation'
 time[[id]]$timeval = 20
 
 id = id + 1
 time[[id]]$timename = 'dt'
 time[[id]]$timetext = 'Time step'
 time[[id]]$timeval = 0.1
 
 mbmodel$time = time