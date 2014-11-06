{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}
{cmd: help nwdegree}
{hline}

{title:Title}

{p2colset 5 17 22 2}{...}
{p2col :nwdegree {hline 2}}Degree centrality and distribution{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdegree} 
[{it:{help netlist}}]
[{cmd:,}
{opt isolates}
{opt unweighted}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt isolates}}Generate variable for network isolates{p_end}
{synopt:{opt unweighted}}Ignore tie weights/values{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwdegree} calculates the degree centrality for each node of a network or list of networks. Generates the 
Stata variables {it:_indegree} (the sum of the links received from other nodes) and {it:_outdegree} 
(the sum of the links sent to other nodes). The rows in Stata correspond to the{help nodeid: nodeids} of nodes. When a network is undirected only {it:_degree} is calculated. 
For weihgted networks the sum of incoming tie values and the sum of outgoing tie values are calculated. The command can also be used to identify network isolates, i.e. nodes that are not connected to
any other node. Returns additional information about network density in the return vector.

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
  {cmd:. return list}
  
{title:See also}

   {help nwbetween}, {help nwcloseness}, {help nwcluster}, {help nwevcent}
