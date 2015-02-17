
/*
Generate a distribution of 20 random networks with the same size and density
as the gang network. Then obtain the transitivity scores for each one
of these networks using "nwsummarize" and the options "detail" and 
"save()". Ultimately, plot the distribution of saved transitivity
scores using "kdensity" and add a line for the observed transitivity
of the gang network. 
*/


nwclear

local density = .0497959183673469
local transitivity = .1732522796352584
local nodes = 50
 
nwrandom `nodes', density(`density')  ntimes(20)

nwsummarize _all, detail save(myfile)

use myfile, clear
kdensity transitivity, xline(.1732522796352584) xscale(range(0 .2))



nwergm gang, formula(edges + gwesp() + nodematch("ethnicity") + nodematch("prison") + absdiff("age") + absdiff("rankrev"))



