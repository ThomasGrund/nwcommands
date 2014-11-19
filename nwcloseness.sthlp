{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}
{cmd:help nwcloseness}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwcloseness  {hline 2}}Calculates the closeness centrality for each node{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcloseness} 
[{help netlist}]
[{cmd:,}
{opt unconnected(integer)}
{opt nosym}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt unconnected(integer)}}defines the length of the path between two unconnected nodes{p_end}
{synopt:{opt nosym}}do not symmetrize network before calculation of shortest paths{p_end}


{title:Description}

{pstd}
Calculates the closeness centrality for each node i in a network or network list and saves the result in a new variable {it:_closeness}.
The closeness centrality for node i is defined in the following way:
	
	farness_i = sum(geodesic_ik), over all k
	
	nearness_i = 1 / farness_i
	
	closeness_i = nearness_i * (nodes - 1) 


{title:Examples}
	
	{cmd:. webnwuse florentine}
	{cmd:. nwclosenss flomarriage}
	
{title:See also}
	{help nwgeodesic}
