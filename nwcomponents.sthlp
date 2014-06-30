{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwcomponents
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwcomponents {hline 2}}Connected components in the network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcomponents} 
[{it: varlist}
{cmd:, }
{opt gen(newvarname)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt gen(newvarname)}}name of variable to store component membership{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd: nwcomponents} calculates the number of components of the network specified by {it: varlist}. By default, 
{it: varlist} is assumed to be {it: var*}. A component is 
a subset of nodes, which are all connected with each other. Returns the scalar {it: r(compnum)},
which indicates the number of connected components found in the network. Returns the matrix 
{it: r(compmemb)}, which gives the component membership for each node.  

{title:Options}


{dlgtab:Main}

{phang}

{phang}
{opt gen(newvarlist)} Specifies the name of a new variable, where the component membership of each node is stored.

{title:Remarks}

{pstd}
All ties are treated as undirected. Runs with BFS algorithm.  


{title:Examples}
{cmd:. nwrandom 200, prob(.01)}
{cmd:. nwcomponents, gen(comp)}
{cmd:. tab comp}
{cmd:. return list}

{title:Also see}

{psee}
Online: 
{p_end}