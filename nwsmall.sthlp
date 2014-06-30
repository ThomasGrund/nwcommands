{smcl}
{* *! version 1.0.6  16may2012}{...}
{cmd:help nwsmall}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwsmall {hline 2}}Generate small-world network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsmall} 
{it: nodes}
[{cmd:,}
{opt neighb(k)}
{opt shortc(s)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt ne:igh(k)}}number of initial neighbors per node on ring lattice{p_end}
{synopt:{opt s:hortc(s)}}number of additional shortcuts{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwsmall} Generates a small-world network with {it: nodes} number of nodes. All agents
are signed {it: k} network neighbors, {it: k / 2} neighbors to each side on a {it: ring lattice}. Then, {it: s} 
shortcuts are added to the network. Small-world networks have the property to be high
clustering, bit low on average shortest path length. Many real world networks, look like
the small-world network. 


{title:Options}

{dlgtab:Main}

{phang}
{opt ne:igh(k)} Specifies the number of neighbors to which the focal agent is initially linked.
 Each agent is linked to {it: k/2} of its neighbors to the left and {it: k/2} to 
the right n a ring lattice. Default is k = 2.

{phang}
{opt s:hortc(s)} Specifies the number of shortscuts that are added to the network. By default
s = 0.


{title:Remarks}

{pstd}
Note that nwsmall does not delete local ties when shortcuts are added.


{title:Examples}

{phang}{cmd:. nwsmall 40, neigh(4) s(10)}

{phang}{cmd:. nwgraph, circle}



{title:Also see}
