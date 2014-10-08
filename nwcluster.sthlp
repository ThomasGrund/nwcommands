{smcl}
{* *! version 1.0.1  3oct2014 author: Thomas Grund}{...}
{cmd: help nwcluster}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwcluster {hline 2}}Clustering coefficient{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcluster} 
[{it:{help netname}}]

{title:Description}

{pstd}
{cmd:nwcluster} calculates the local clustering coefficient for each node and saves it 
in the variable {it:_cluster}. The {it:local clustering coefficient} of node i in the graph g is defined as the share
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
