{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd: help nwdegree}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwdegree {hline 2}}Calculates the network degree of each node{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdegree} 
[{it:{help netname}}]
[{cmd:,}
{opt isolates}
{opt unweighted}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt isolates}}Generate variable for network isolates{p_end}
{synopt:{opt unweighted}}Ignore tie weights/values{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwdegree} Calculates the in- and outdegree of each node, i.e., the sum of the links received
from other nodes (indegree) and the sum of the links sent to other nodes (outdegree). Generates the 
variables {it:_indegree} and {it:_outdegree}. When a network is undirected only degree is calculated. When a network
is valued the sum of incoming tie values and the sum of outgoing tie values is calculated for 
each node. The command can also be used to identify network isolates, i.e. nodes that are not connected to
any other node.

{title:Options}

{phang}
{opt isolates} Generate the variable {it:_isolates} that indicates whether a node is an isolate or not.

{phang}
{opt unweighted} Ignores all tie values.

{title:Remarks}

{pstd}
The command overwrites the Stata variables {it:_degree}, {it:_indegree}, {it:_outdegree}, and {it:_isolates}

{title:Examples}

{cmd:. nwrandom 50, prob(.1)}
{cmd:. nwdegree} 
{cmd:. return matrix r(outdegree)} 
{cmd:. nwdegree, outdegree(out)} 
