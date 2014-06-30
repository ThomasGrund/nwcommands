{smcl}
{* *! version 1.0.6  16may2012}{...}
{cmd:help nwcloseness}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwcloseness} {hline 2}
Calculate local and global closeness coefficients{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab:: nwcloseness }
[{it: varlist}
{cmd:,}
{opt generate(newvar)}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt:{opt generate(newvar)}}stores local closeness scores{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}
{cmd:nwclosenss} {it: Varlist} defines the network. By default {it: var*} is assumed. 
In graphs there is a natural distance metric between all pairs of nodes, defined by the 
length of their shortest paths. The farness of a node s is defined as the sum of its 
distances to all other nodes, and its closeness is defined as the inverse of the farness. 
Thus, a node is the more central the lower its total distance to all other nodes. 
Closeness can be regarded as a measure of how long it will take on average for information 
to spread from from node i to node j. Stores local closeness scores in matrix {it: r(closeness)}. 
Also calculate global closeness score for the  whole network, which is defined as average of 
the local closeness scores. This is stored in {it: r(C)}
{pstd}



{title:Remarks}

{pstd}
Treats network as undirected and binary.


{title:Examples}

{cmd:. nwrandom 20, prob(.4)}
{cmd:. nwcloseness, gen(close)}

{title:Also see}
