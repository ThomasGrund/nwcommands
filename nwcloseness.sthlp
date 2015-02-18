{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwcloseness {hline 2} Calculate closeness centrality}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcloseness} 
[{it:{help netlist}}]
[{cmd:,}
{opth unconnected(int)}
{opt generate}({it:{help varname:var1 var2 var3}})
{opt nosym}]


{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth unconnected(int)}}defines the length of the (non-existent) path between two unconnected nodes{p_end}
{synopt:{opt generate}({it:{help varname:var1 var2 var3}})}variables names to save closeness, farness and nearness scores; default: 
{it:var1 = _closeness, var2 = _farness, var3 = _nearness}{p_end}
{synopt:{opt nosym}}do not symmetrize network before calculation of shortest paths{p_end}


{title:Description}

{pstd}
Calculates the closeness centrality (and farness and nearness score) for each node {it:i} in a network or network list and 
saves the result as Stata variables. 

{pstd}
The closeness centrality for node {it:i} is defined in the following way:
	
	{it:farness_i = sum(dist_ik), over all k}
	
	{it:nearness_i = 1 / farness_i}
	
	{it:closeness_i = nearness_i * (nodes - 1)}

{pmore}	
with: {it:dist_ik} being the length of the shortest path from node {it:i} to node {it:k} (see {help nwgeodesic})

{pstd}
Closeness centrality is not defined when the network is unconnected. However, scores can still be obtained when
option {bf:unconnected()} is specified. Any integer value can be choosen; {bf:unconnected(max)} assigns non-existent
paths a length based on the longest shortest path length observed in the network (plus one) (see {help nwgeodesic}).	

{pstd}
Already existing Stata variables {it:var1, var2, var3} are overwritten. In case, closeness centrality is calculated
for {it:z} networks at the same time (e.g. {bf: nwcloseness glasgow1 glasgow2}), the command generates the variables
{it:var1_z, var2_z, var3_z} for each network. 
	
{title:Examples}
	
	{cmd:. webnwuse gang, nwclear}
	{cmd:. nwclosenss gang}
	{cmd:. sum _closeness _farness _nearness}
	
	
{title:See also}

	{help nwgeodesic}, {help nwpath}, {help nwgeodesic}, {help nwbetween}, {help nwdegree}, {help nwevcent}, {help nwkatz}
