{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 17 22 2}{...}
{p2col :nwevcent {hline 2} Calculate eigenvector centrality}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwevcent} 
[{it:{help netlist}}]
[{cmd:,}
{opt generate}({it:{help varname}})
{opt nosym}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt generate}({it:{help varname}})}variable name for eigenvector centrality scores; default: 
{it:varname = _evcent}{p_end}
{synopt:{opt nosym}}do not symmetrize network before calculation{p_end}


{title:Description}

{pstd}
Calculates eigenvector centrality for each node {it:i} in a network or network list and 
saves the result as Stata variables. It assigns relative scores to all nodes in the network 
based on the concept that connections to high-scoring nodes contribute more to the score of 
the node in question than equal connections to low-scoring nodes.

{pstd}
Eigenvector centrality is only defined for connected networks.

{pstd}
The Stata variable {it:varname} is overwritten. In case, eigenvector centrality is calculated
for {it:z} networks at the same time (e.g. {bf:nwvcent glasgow1 glasgow2}), the command generates the variables
{it:varname_z} for each network. 

	
{title:Examples}
	
	{cmd:. webnwuse gang, nwclear}
	{cmd:. nwevcent gang}
	{cmd:. sum _evcent}

	
{title:See also}

	{help nwcloseness}, {help nwbetweenness}, {help nwdegree}, {help nwcloseness}
