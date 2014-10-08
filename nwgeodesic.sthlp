{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{marker top2}
{helpb nw_topical##analysis:[NW-2.6] Analysis}
{cmd:help nwgeodesic}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwgeodesic  {hline 2}}Calculates shortest paths between nodes{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwgeodesic} 
[{help netname}]
{cmd:,}
{opt unconnected(integer)}
{opt nosym}
{opt name(string)}
{opt xvars}


{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt unconnected(integer)}}defines the length of the path between two unconnected nodes{p_end}
{synopt:{opt nosym}}do not symmetrize network before calculation{p_end}
{synopt:{opt name}({it:new}{it:{help netname}})}name of the new random network; default = geodesic{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwgeodesic} calculates the shortest paths between all nodes i and j. The result
is saved in a a new network called {it:new{help netname}. If nothing is specified the 
the results are saved in a network called {it:geodesic}. By default, the command calculates
the distance between two nodes based on the unvalued, symmetrized network.


{title:Examples}
	
	{cmd:. webnwuse florentine}
	{cmd:. nwgeodesic flomarriage}
	{cmd:. nwset}
	
{title:See also}
	{help nwcloseness}
