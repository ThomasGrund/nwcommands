{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwbetween  {hline 2} Calculate betweenness centrality}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwbetween} 
[{it:{help netlist}}]
[{cmd:,}
{opt generate}({it:{help varname}})
{opt nosym}
{opt standardize}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt generate}({it:{help varname}})}variable name for betweenness centrality; default = {it:_between}{p_end}
{synopt:{opt nosym}}do not symmetrize network before calculation of shortest paths{p_end}
{synopt:{opt standardize}}standardize centrality scores{p_end}


{title:Description}

{pstd}
Calculates the betweenness centrality for each node {it:i} in a {help netname:network} or {help netlist:network list} and 
saves the result as a Stata variable. The command used the dichotomized network. 

{pstd}
The betweenness centrality for node {it:i} is equal to the number of shortest paths from all vertices to all 
others that pass through node {it:i}. A node with high betweenness centrality has a large influence on the 
transfer of items through the network, under the assumption that item transfer follows the shortest paths. 

{pstd}
When there is more than one shortest path from node {it:k} to node {it:l}, the betweenness scores of all nodes {it:i}
on these paths increases proportionally.  

{pstd}
Formally, betweenness centrality of node {it:i} on graph {it:g} is defined as:

{pmore}
{it:Between_i(g) = sum ( sigma_st(i) / sigma_st )}

{pstd}
where, {it:sigma_st} is the total number of shortest paths from node {it:s} to node {it:t} and {sigma_st(i)} is the number of those 
paths that pass through node {i}.

{pstd}
For the standardized betweenness centrality:

{pmore}
Directed network: {it:Between_i_std(g) = Between_i(g) / ((N-1)*(N-2))}

{pmore}
Undirected network: {it:Between_i_std(g) = Between_i(g) / ((N-1)*(N-2)/2)}

{pstd}
The Stata variable {it:varname} is overwritten. In case, betweenness centrality is calculated
for {it:z} networks at the same time (e.g. {bf:nwbetween glasgow1 glasgow2}), the command generates the variables
{it:varname_z}, one for each network. 

	
{title:Examples}
	
	{cmd:. webnwuse gang, nwclear}
	{cmd:. nwbetween gang}
	{cmd:. sum _between}

	
{title:See also}

	{help nwpath}, {help nwgeodesic}, {help nwcloseness}, {help nwkatz}, {help nwdegree}, {help nwcloseness}, {help nwevcent}

