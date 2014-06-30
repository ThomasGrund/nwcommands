{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwdegree
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwdegree {hline 2}}Calculates in- and outdegree of each node{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdegree} 
{cmd:,}
[{opt outdegree(newvar)}
{opt indegree(newvar)}
unweighted]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt outdegree(newvar)}}name of outdegree variable{p_end}
{synopt:{opt indegree(newvar)}}name of indegree variable{p_end}
{synopt:{opt unw:eighted}}disregard tie weights/values{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwdegree} Calculates the in- and outdegree of each node, i.e., the sum of the links received
from other nodes and the sum of the links sent to other nodes. By default results are saved in 
{it: r(oudegree)} and {it: r(indegree)} as return value. Alternatively, the variables {it: outdegree} 
and {it: indegree} can specified where the information is stored as variables. 

{title:Options}

{dlgtab:Main}

{phang}
{opt outdegree(newvar)} Name of the variable where outdegree of nodes is saved.

{phang}
{opt indegree(newvar)} Name of the variable where indegree of nodes is saved.

{phang}
{opt unw:eighted} Specifies that weights in the adjacency matrix shall be disregarded
so that it is treated as if it were binary.


{title:Remarks}

{pstd}
None. 


{title:Examples}

{cmd:. nwrandom 50, prob(.1)}
{cmd:. nwdegree} 
{cmd:. return matrix r(outdegree)} 
{cmd:. nwdegree, outdegree(out)} 

{title:Also see}
