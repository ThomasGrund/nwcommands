{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 18 22 2}{...}
{p2col :nwutility  {hline 2} Calculate utility scores according to Jackson and Wollinsky (1996)}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwutility} 
[{help netname}]
{cmd:,}
[{opth benefit(real)}
{opth cost(real)}
{opth value(netname)}
{it:{help nwgeodesic:geodesic_options}}]


{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth benefit(real)}}benefit from connected node{p_end}
{synopt:{opth cost(real)}}cost of connection{p_end}
{synopt:{opth value(netname)}}intrinsic values of connecetd nodes}


{title:Description}

{pstd}
{cmd:nwutility} calculates node-level utility scores according to the connections model in Jackson and Wollinsky (1996). The command generates the variables _benefit, _cost and _util.	
In this model of strategic network formation, each node i is assigned a utility score, which is calculated as:

{pmore}
		U(i) = w_ii + sum_j[benefit^(d_ij) * w_ij] - sum_j_n_Nj(g)[cost * y_ij]

{pstd}
{it:benefit} essentially defines the decay of benefit from non-direct (but connected) network neighbors. When benefit = 1, a node i gains
as much benefit from a directly connected node as from an indirectly connected node. 

{pstd}
{it:cost} defines the cost of node i for maintaining a network link (hence, only direct connections are considered). 

{pstd}
The command can also be used in more complicated ways using the intrinsic value w_ij a node i gives to a connection with node j. For example, one could
imagine that nodes only get benefit nodes who have a same attribute. To do that one would first 
generate a new network that holds information whether two nodes have the same value on an attribute (see {help nwexpand}).

	{cmd:. nwclear}
	{cmd:. nwrandom 20, prob(.2)}
	{cmd:. gen attr = round(uniform())}
	{cmd:. nwexpand attr, mode(same) name(same)}
	
{pstd}	
Then one can use the value option in nwutility
	
	{cmd:. nwutility network, benefit(.5) cost(.3) value(same)}


{title:Bibliography}

{pstd}
Jackson, M. and Wollinsky, A. (1996) A Strategic Model of Social and Economic Networks. {it:Journal of Exonomic Theory}, 71, pp. 44-74.
	
	
{title:Remarks}

{pstd}
When not specified otherwise, benefit = 1, cost = 1 and w_ij = 1 (for i != j) and w_ii = 0.

	
