{smcl}
{* *! version 1.0.6  16may2012 author: Thomas Grund}{...}
{cmd:help nwcontext}
{hline}

{title:Title}

{p2colset 5 19 22 2}{...}
{p2col :nwcontext {hline 2}}Creates a context variable from an attribute variable and a network{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwcontext} 
[{it:{help netname}}]
[{cmd:,}
attribute({help varname})
stat({help nwcontext##statistic:statistic})
mode({help nwcontext##context:context})
generate({help newvar})
mat(string)
noweight]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt attr:ibute}({help varname})}attribute variable{p_end}
{synopt:{opt stat}({help nwcontext##statistic:statistic})}statistic that is used to calculate context variable for node i from attributes of network neighbors{p_end}
{synopt:{opt mode}({help nwcontext##context:context})}defines network neighbors of node i as either nodes j who receive ties from i, send ties to j or both{p_end}
{synopt:{opt gen:erate}({help newvar})}name of the context variable to be generated{p_end}
{synopt:{opt mat}}name of new mata matrix where context variable should be stored instead{p_end}
{synopt:{opt noweight}}ignores valued ties and treats all as binary{p_end}

{synoptline}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{marker statistic}{...}
{p2col:{it:statistic}}Description{p_end}
{p2line}
{p2col:{cmd: mean}}mean of {help varname} over network neighbors; default
		{p_end}
{p2col:{cmd: max}}maximum of {help varname} over network neighbors
		{p_end}
{p2col:{cmd: min}}minimum of {help varname} over network neighbors
		{p_end}
{p2col:{cmd: sum}}sum of {help varname} over network neighbors
		{p_end}

{p2colreset}{...}
{synoptset 20 tabbed}{...}
{marker context}{...}
{p2col:{it:context}}Description{p_end}
{p2line}
{p2col:{cmd: outgoing}}network neighbors of node i are all nodes j who receive a tie from i; default
		{p_end}
{p2col:{cmd: incoming}}network neighbors of node i are all nodes j who send a tie to i; default
		{p_end}
{p2col:{cmd: both}}network neighbors of node i are all nodes j who either send a tie to i or receive a tie from i
		{p_end}



{title:Description}

{pstd}
{cmd:nwcontext} generates a context variable, where {it:attribute} specifies the name of a
 variable that contains information about a relevant attribute of
the nodes in network {it:netname}. {it: newvar} is a 
variable created by {bf: nwcontext} which will contain either the mean, the max, the min or the sum of the attributes of 
each ego’s network neighbors; {it: stat} specifies which statistic should be used. The default is {it: mean}. A network neighborhood of
node i can be either 1) all nodes j to whom i has outgoing ties (default), 2) all nodes j from whom i receives incoming ties, or 3) both. The option
{it: mode} specifies which network neighborhood should be used. 


{title:Options}

{phang}
{opt attribute}({help varname}) Name of the variable that holds an attribute for the nodes of the network from which a context variable should be created. This option is required.

{phang}
{opt stat}({help nwcontext##statistic:statistic}) The statistic that should be used to calculate the context variable. The default is {it:mean}, i.e. the context variable 
for node i is calculated as the mean value of the {it:attribute} variable of node i's neighbors.{p_end}

{phang}
{opt mode}({help nwcontext##context:context}) Defines which nodes j should belong to the network neighborhood of node i. The default option is 
{it: outgoing}, i.e. all nodes j to whom node i has an outgoing tie. Alternatively, one can choose options 
{it: incoming} or {it:both}. Notice that in the latter case, nodes j will appear twice in the calculation when 
they both receive and send a tie from/to node i. 

{phang}
{opt generate}({help varname}) Name of the new context variable that is created. If this is not specified the context variable is called _context_attribute.

{phang}
{opt noweight}({help varname}) By default nwcontext weighs the attribute value of node j in the calculation of node i's context value with the strength of the tie between 
the two nodes. The option {it:noweight} ignores all tie values. 

{title:Remarks}

{pstd}
In the case of undirected networks, no {it: mode} option needs to be specified. 


{title:Examples}

{cmd: nwrandom 50, prob(.1)}
{cmd: gen age = round(100 * (uniform())}
{cmd: nwcontext, attribute(age)} 
{cmd: sum _context_age}

{title:Also see}
   {help nwneighbor}
