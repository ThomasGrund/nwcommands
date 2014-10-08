{smcl}
{* *! version 1.0.1  17may2012 author: Thomas Grund}{...}
{helpb nw_topical##analysis:[NW-2.6] Analysis}
{cmd:help nwgeodesic}
{cmd:help nwneighbor}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwneighbor {hline 2}}Extracts the network neighbors of a node{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwneighbor} 
[{it:{help netname}}],
{opt ego}({help nodeid})
[{opt mode}({help nodeid})]

{p 8 17 2}
{cmdab: nwneighbor} 
[{it:{help netname}}],
{opt ego}({help nodelab})
[{opt mode}({help nwneighbor##context:context})]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt ego}({help nodeid})}nodeid of network node i{p_end}
{synopt:{opt ego}({help nodelab})}nodelab of network node i{p_end}
{synopt:{opt mode}({help nwneighbor##context:context})}defines network neighbors of node i as either nodes j who receive ties from i, send ties to j or both{p_end}
{synoptline}
{p2colreset}{...}
		
{synoptset 20 tabbed}{...}
{marker context}{...}
{p2col:{it:context}}{p_end}
{p2line}
{p2col:{cmd: outgoing}}network neighbors of node i are all nodes j who receive a tie from i; default
		{p_end}
{p2col:{cmd: incoming}}network neighbors of node i are all nodes j who send a tie to i; default
		{p_end}
{p2col:{cmd: both}}network neighbors of node i are all nodes j who either send a tie to i or receive a tie from i
		{p_end}

		
{title:Description}

{pstd}
{cmd: nwneighbor} retrieves one or more network neighbors for node with id {it: nodeid}. By default,
neighbors of  node i are drawn from outgoing ties, i.e. all nodes j with a tie (i,j). Returns the scalar {it: r(oneneighbor)}, which
stores the id of one randomly selected network neighbor. If node {it: nodeid} does not have any neighbors at all,
{it: r(oneneighbor)} stores a missing value. Also returns the Stata matrix 
{it: r(neighbors)} with a complete (shuffled) list of all network neighbors of node {it: nodeid}.   

{title:Options}

{phang}
{opt ego}({help nwneighbor##nodeid:nodeid}) Must be specified and indicates the node for whom network neighbors should be retrieved.

{phang}
{opt mode}({help nwneighbor##context:context}) Defines which nodes j should belong to the network neighborhood of node i. The default option is 
{it: outgoing}, i.e. all nodes j to whom node i has an outgoing tie. Alternatively, one can choose options 
{it: incoming} or {it:both}. Notice that in the latter case, nodes j will appear twice in the calculation when 
they both receive and send a tie from/to node i. 


{title:Remarks}

{pstd}
Tie values are ignored. 


{title:Examples}
     {cmd:. nwclear}
     {cmd:. nwrandom 20, prob(.1)}
     {cmd:. nwneighor, ego(1)}

   or
     {cmd:. nwneighbor, ego(net1)}

{title:Also see}

   {help nwcontext}, {help nwname}, {help nwinfo}
