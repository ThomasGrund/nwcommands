{smcl}
{* *! version 1.0.1  17may2012 author: Thomas Grund}{...}
{cmd:help nwneighbo}r
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwneighbor {hline 2}}Gets one ore more network neighbors{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwneighbor} 
{cmd:, }
{opt id(nodeid)}
[{opt stub(stub)}
{opt outgoing}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt id(nodeid)}}id of network node{p_end}
{synopt:{opt stub(stub)}}specfies the network stub{p_end}
{synopt:{opt outgoing}}draws neighbors from outgoing ties{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd: nwneighbor} retrieves one or more network neighbors for node with id {it: nodeid}. By default
neighbors of  node i are drawn from incoming ties, i.e. all nodes j with a tie (j,i). Returns the scalar {it: r(oneneighbor)}, which
stores the id of one randomly selected network neighbor. If node {it: nodeid} does not have any neighbors at all,
{it: r(oneneighbor)} stores the id of one randomly selected other node. It can be useful to get such a randomly selected
node in some situations. Returns the scalar {it: r(total)} which stores the total number of network neighbors of node {it: nodeid}. 
This can be used to determine whether {it: nodid} has any network neighbors. Returns the matrix 
{it: r(neighbors)} with a complete (shuffled) list of all network neighbors of node {it: nodeid}.   

{title:Options}

{dlgtab:Main}

{phang}
{opt id(nodeid)} Must be specified and indicates the node for whom network neighbors should be retrieved.

{phang}
{opt stub(stub)} Specifies the network. By default stub is set to {it: var*}.

{phang}
{opt outgoing} Uses outgoing ties to retrieve network neighbors.

{title:Remarks}

{pstd}
By default incominng ties are used. Tie values are disregarded. 


{title:Examples}
{cmd:. nwrandom 20, prob(.1)}
{cmd:. nwneighor, id(1)}
{cmd:. return list} 

{title:Also see}

{psee}
Online: 
{p_end}