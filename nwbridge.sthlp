{smcl}
{* *! version 1.0.4  8dec2015 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 17 23 2}{...}
{p2col :nwbridge {hline 2} Calculate global and local bridges}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab: nwbridge} 
[{it:{help netname}}]
[{cmd:,}
{opth generate(newnetname)}
{opt local}
{opt detail}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth generate(newnetname)}}Save bridges as new network{p_end}
{synopt:{opt local}}Calculate local bridges{p_end}
{synopt:{opt detail}}Display labels for bridges{p_end}

{title:Description}

{pstd}
This command calculates the bridges in a network. A bridge is a tie from node i to j, which if removed
makes it impossible to reach node j from node i. A bridge is therefore essential to connect two nodes
with each other.

{pstd} 
In contrast, an edge joining two nodes i and j
in a graph is a local bridge if its endpoints i and j have no friends in common — in other
words, if deleting the edge would increase the distance between i and j to a value strictly
more than two. We say that the span of a local bridge is the distance its endpoints would
be from each other if the edge were deleted.

{pstd}
The option {bf:generate()} saves the information about which tie is a bridge (or local bridge)
in a new network {help netname}. When used together with option {bf:local}, the new network saves
the span of the local bridges. 


{title:References}

{pstd}
Burt, R. S. 1992. Structural Holes: The social structure of competition. Cambridge: Harvard University Press.

{title:See also}

	{help nwburt}, {help nwpath}
