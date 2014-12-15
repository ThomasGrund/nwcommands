{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 16 22 2}{...}
{p2col :nwkatz {hline 2} Calculate Katz centrality}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwkatz} 
[{it:{help netlist}}]
{opt alpha(real)}
[{cmd:,}
{opt generate}({it:{help varname}})
{opt nosym}]


{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt alpha(real)}}penalization factor for calculation of weights{p_end}
{synopt:{opt generate}({it:{help varname}})}variable name for Katz centrality scores; default: 
{it:varname = _katz}{p_end}
{synopt:{opt nosym}}do not symmetrize network before calculation of centrality{p_end}


{title:Description}

{pstd}
Calculates the Katz (1953) centrality for each node {it:i} in a network or network list and 
saves the result as Stata variables. Katz centrality is an extension of degree centrality (see {help nwdegree}).
Degree centrality measures the number of direct neighbors, and Katz centrality measures the number of all 
nodes that can be connected through a path, while the contributions of distant nodes are penalized. 

{pstd}
It assigns weights to each pair of nodes {it:(i,j)} based on their distance {it:dist_ij(g)} (see {help nwgeodesic}) 
and a penalization factor {bf:alpha()}.

{pstd}
Formally, Katz centrality is defined as:

{pmore}
{it:Katz_i(g) = sum( alpha ^ dist_ij(g) ), over all j connected to i}

{pstd}
The Stata variable {it:varname} is overwritten. In case, eigenvector centrality is calculated
for {it:z} networks at the same time (e.g. {bf:nwkatz glasgow1 glasgow2}), the command generates the variables
{it:varname_z} for each network. 


{title:References}

{pstd}
Katz, L. (1953). A New Status Index Derived from Sociometric Index. Psychometrika, 39-43.

	
{title:Examples}
	
	{cmd:. webnwuse gang, nwclear}
	{cmd:. nwkatz gang}
	{cmd:. sum _katz}

	
{title:See also}

	{help nwcloseness}, {help nwbetweenness}, {help nwdegree}, {help nwcloseness}, {help nwevcent}
