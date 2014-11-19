{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##information:[NW-2.4] Information}
{cmd:help nwdyads}
{hline}

{title:Title}

{p2colset 5 16 22 2}{...}
{p2col :nwdyads  {hline 2}}Dyad census of the network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdyads} 
[{help netname}]

{title:Description}

{pstd}
Returns the dyad census of the network. When the network is directed, each dyad 
(pair of nodes i and j) can be either 1) mutually connected, 2) asymmetrically connected, 
3) not connected at all. When the network is undirected, each dyad pair can be either 1)
connected or 2) not connected. Also returns results in the return vector. 


{title:Examples}
	
	// Undirected network
	{cmd:. webnwuse florentine}
	{cmd:. nwdyads}
	
	// Directed network
	{cmd:. webnwuse glasgow}
	{cmd:. nwdyads}

{title:See also}

	{help nwtriads}
