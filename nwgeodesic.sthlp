{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwgeodesic}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwgeodesic {hline 2}}Geodesic distances in the network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwgeodesic}
[{it: varlist}
{cmd:, }
{opt gen(newprefix)}
{opt unconnected(nopath)}
{opt distance symoff}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt gen(newprefix)}}prefix of variables to store distance matrix{p_end}
{synopt:{opt un:connected(nopath)}}distance for unconnected nodes{p_end}
{synopt:{opt distances}}generate Stata matrix with distances{p_end}
{synopt:{opt symoff}}calculate distance based on directed network{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd: nwgeodesic} calculates the geodesic shortest paths between all nodes i and j in the network specified by {it: varlist}. 
By default, {it: varlist} is assumed to be {it: var*}. The 
distance between two nodes i and j is defined as the number of ties one needs to cross to
get from node i to j (tie values are disregarded). Returns {it: r(L)}, which indicates the 
{it: average shortest path length} in the network.
{title:Options}


{dlgtab:Main}

{phang}
{opt gen(newprefix)} Specifies the prefix of new variables, in which the distance matrix is stored.

{phang}
{opt un:connected(nopath)} {it: nopath} indicates the value that will be given to the pair (i,j), when
no path exists from node i to j. By default, this value is set to: {it: longest shortest path in the network + 1}.
It can be useful to assign a high score to an unconnected pair of nodes. Alternatively, {it: nopath} can be 
assigned to be a {it: missing value}.

{phang}
{opt distance} Generates a Stata matrix {it: r(distances) with the distance matrix.

{phang}
{opt symoff} Considers directed ties.

{title:Remarks}

{pstd}
By default ties are treated as undirected and unweighted.


{title:Examples}
{cmd:. nwrandom 50, prob(.01)}
{cmd:. nwgeodesic, gen(dist) unconnected(.)}

{title:Also see}

{psee}
Online: 
{p_end}