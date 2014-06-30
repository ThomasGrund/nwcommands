{smcl}
{* *! version 1.0.6  16may2012 author: Thomas Grund}{...}
{cmd:help nwcontext}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwcontext {hline 2}}creates a context variable{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcontext} 
{it: varname}
[{cmd:,}
{opt gen(newvar)}
adjunweight attrunweight]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt gen(newvar)}}name of the context variable to be generated{p_end}
{synopt:{opt adjunw:eight}}disregard tie weights/values{p_end}
{synopt:{opt adjunw:eight}}treat attributes as binary{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwcontext} Generates a context variable, where {it:varname} is the name of a
 variable that contains information about a relevant attribute of
the agents, for example how each agent acted at previous round. {it: newvar} is a 
variable created by {bf: nwcontext} which will contain the sum of the attributes of 
each ego’s alters, weighted by the weights of the links in the adjacency matrix. 
If the adjacency matrix is unweighted and {it: varname} is coded 0 or 1 the variable 
created by {bf: nwcontext} will contain information about how many of each agent’s
alters have the attribute, for example, how many of the alters that acted. By default this
variable will be called {it: context}. In a directed network, an ‘alter’ is defined as a 
node from which ego receives a tie.  

{title:Options}

{dlgtab:Main}

{phang}
{opt gen(newvar)} Name of the context variable that is generated. By default this name is {it: context}.

{phang}
{opt adjunw:eight} Specifies that weights in the adjacency matrix shall be disregarded
so that it is treated as if it were binary.

{phang}
{opt attrunw:eight} Specifies that the attribute variable shall be treated as if it
 were binary, that is, all non-missing values other than 0 are treated as the value 1. 
As long as the adjacency matrix variables and the attribute variable are
binary or treated as binary, and the attribute variable indicates an action, the first
observation’s value on this variable will state how many of the first agent’s alters acted;
 the second observation’s value on this variable will state how many of the second agent’s alters
acted, and so on.

{title:Remarks}

{pstd}
None. 


{title:Examples}

{cmd:. nwrandom 50, prob(.1)}

{cmd:. gen act = round(uniform())}

{cmd:. nwcontext, gen(neighborsact)} 

{title:Also see}
