{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{marker top2}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 10 10 2}{...}
{p2col:nwgeodesic {hline 2} Calculate shortest paths between nodes}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmd:nwgeodesic} 
[{it:{help netname}}]
[{cmd:,}
{opth unconnected(int)}
{opt nosym}
{opth name(string)}
{opt xvars}]


{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth unconnected(int)}}defines the length of the path between two unconnected nodes{p_end}
{synopt:{opt nosym}}do not symmetrize network before calculation{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new random network; default = geodesic{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwgeodesic} calculates the shortest paths between all nodes {it:i} and {it:j}, average shortest path length
and diameter in a network. The matrix of distances between nodes
is saved in a new network called {it:{help newnetname}}. If nothing is specified the 
results are saved in a network called {it:geodesic}. By default, the command calculates
the distance between two nodes based on the unvalued, symmetrized network.

{pstd}
By default, the distance between two unconnected nodes {it:i} and {it:j} is set to -1. Non-existent paths are excluded from 
calculation of average shortest path length (unless option {bf:unconnected()} is specified). 

{pstd}
The option {bf:unconnected(max)} sets the distance of non-connected nodes to the maximum distance 
observed in the network plus 1.

{pstd}
The average shortest path length and the diameter are calculated for the largest component of the network.

{title:Example}
	
	{cmd:. webnwuse florentine}
	{cmd:. nwgeodesic flomarriage}
	{res}{hline 40}
	{txt}  Network name: {res}flomarriage
	{txt}  Network of shortest paths: {res}geodesic
	{hline 40}
	{txt}    Nodes: {res}16
	{txt}    Symmetrized : {res}1
	{hline 36}
	{txt}    Paths (largest component): {res}105
	{txt}    Diameter (largest component): {res}5
	{txt}    Average shortest path (largest component): {res}2.485714285714286

	
{pstd}
{txt}In this example, only 105 directed paths exist. One node is disconnected from all other nodes (hence, the maximum 
number of undirected paths (16 * 15)/2 = 120 is not reached). The average shortest path is calculated based on the 105 existent paths.


{title:Stored results}	

	Scalars
	  {bf:r(nodes)}		number of nodes
	  {bf:r(symmetrized)}	calculated on symmetrized network
	  {bf:r(numpaths)}	number of shortest paths
	  {bf:r(diameter)}	network diameter
	  {bf:r(avgpath)}	average shortest path length
		  
	Macros
	  {bf:r(netname)}	name of the original network
		  
		  
{title:See also}

	{help nwcloseness}, {help nwreach}, {help nwpath}, {help nwcomponents}
