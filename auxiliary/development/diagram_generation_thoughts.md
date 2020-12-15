# Thoughts for a possible diagram package/function

* Function takes as input information regarding a compartmental model
  * Input should input a list, each main list element is variable/compartment, for each variable, the flows are specified
  * Input could include other optional elements, e.g. title, index to specify if boxes should have letter only or name, indications if certain processes are flows or interactions (if not specified, can be deduced from model)


* Function generates full (ggplot) code that produces the figure, so users can further adapt/process
* Function returns a (ggplot) object that can be printed and further manipulated (if users don't want to look at code)


* Every compartment is a box
* Processes are either physical flows (e.g. S moving to I at rate g) or interactions (e.g. I producing environmental pathogen at rate pI or infecting susceptibles at bSI)
* Flows/interactions might show up multiple times and/or might be split


# What's currently not working

* For basic bacteria model (and in general): If a flow involves other variables, those should point to the flow. E.g. the kill term -kBI is an outflow from B but I should point to that arrow. Similarly, the growth term r*B*I should have B point to it.

* For basic virus model, I produces V, so the pI arrow should point from I to V (but it's not a flow, more of an interaction). the bVU and gbVU terms also need to show they belong together, not sure how to do that right.

* Cholera model: Interactions are not showing, same as for models above.
