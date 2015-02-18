{smcl}
{* *! version 1.0.4  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##information:[NW-2.4] Information}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwissyemmtric {hline 2} Check if network is symmetric}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwissymmetric} 
[{it:{help netname}}]


{title:Description}

{pstd}
{cmd:nwissymmetric} simply checks if the underlying adjacency matrix of network {help netname} is symmetric, regardless
of whether the network is assigned to be directed or undirected (see {help nwname}). An adjacency matrix
{it:M} is symmetric when {it:M_ij == M_ji}. Returns
{it:r(issymmetric)} in the return vector. 

{pstd}
This command can be useful for programming, when one wants to detect if a network should be undirected.

{pstd}
For example, {help nwimport} automatically checks if a network (e.g. Ucinet fullmatrix) is symmetric and if yes, 
imports the network as undirected.
 
 
{title:Examples}

	{cmd:. webnwuse florentine}
	{cmd:. nwissymmetric flomarrige}
	{cmd:. return list}
	
	{txt}scalars:
		r(issymmetric) = {res}1{txt}


{title:See also}

	{help nwsym}, {help nwname}
