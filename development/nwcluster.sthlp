{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwcluster}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwcluster {hline 2}}Calculates local and global clustering coeffcients{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcluster} 
{it: varlist}
[{cmd:,}
{opt gen(newvar)}
{opt weights(weights)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt gen(newvar)}}stores clustering coeffcients in {it: newvar} {p_end}
{synopt:{opt weights(weights)}}specifies weights to be used for network clustering{p_end}


{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwcluster} Calculates local clustering and global clustering coefficients. Local
clustering is defined as {it: percentage of closed triads} a node is involved and is stored in
matrix {it: r(cluster)}. By default, the global clustering coeffcient is stored in {it: r(C)} and is defined as average 
of all local clustering coeffcients, unless {it: weights} are specified. 
  
{title:Options}

{dlgtab:Main}

{phang}
{opt gen(newvar)} Saves the local clustering coefficient in {it: newvar}.

{phang}
{opt weights(weights)}Uses {it: weights} of nodes to calculate global clustering coefficent.

{phang}
{opt unw:eighted}Converts all weights of the links, except 0 and missing, into the value 1.
Unweighted creates a link from node i to node j if a link exists from j to i.


{title:Remarks}
{pstd}
None. 


{title:Examples}
{cmd:. nwrandom 50, prob(.1)}
{cmd:. nwcluster}
{cmd:. return list}

{title:Also see}
