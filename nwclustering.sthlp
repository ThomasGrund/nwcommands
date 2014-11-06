{smcl}
{* *! version 1.0.1  3oct2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}
{cmd: help nwclustering}
{hline}

{title:Title}

{p2colset 5 21 22 2}{...}
{p2col :nwclustering {hline 2}}Clustering coefficient{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcluster} 
[{it:{help netlist}}]
[, {opt gen}({help newvarname})]

{title:Description}

{pstd}
{cmd:nwclustering} calculates the local clustering coefficient for each node and saves it 
in the variable {it:_cluster} (unless the generate option is specified). The {it:local clustering coefficient} of node i in the graph g is defined as the share
of network contacts of i (N_i(g)) who are directly connected themselves.
{p_end}

{pstd}
	{it:Cluster_i(g) = # { kj in g | k,j in N_i(g)} / # { kj | k,j in N_i(g)}}

{pstd}
Furthermore, the {it:average clustering coefficient} for the whole network g with 
n nodes is calculated as:

{pstd}
	{it:Cluster_avg(g) = sum_i (Cluster_i(g)) / n}

{pstd}
Lastly, the command also calculates the {it:overall cluster coefficient} as:

{pstd}
	{it:Cluster_overall(g) = sum_i ( # {kj in g | k,j in N_i(g)} ) / sum_i ( # {kj | in N_i(g)} )}

 
{title:Examples}

  {cmd:. webnwuse florentine}
  {cmd:. nwcluster flomarriage} 
  
{title:See also}

   {help nwbetween}, {help nwcloseness},{help nwevcent}
