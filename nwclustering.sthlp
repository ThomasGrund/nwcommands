{smcl}
{* *! version 1.0.1  3oct2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 21 22 2}{...}
{p2col :nwclustering {hline 2} Clustering coefficient}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcluster} 
[{it:{help netlist}}]
[, {opt generate}({it:{help newvarname}})]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt generate}({it:{help varname}})}variable name to save clustering coefficient; default: 
{it:varname = _clustering}{p_end}


{title:Description}

{pstd}
{cmd:nwclustering} calculates the local clustering coefficient for each node and saves it 
in the variable {it:_cluster} (unless {bf:generate()} is specified). The {it:local clustering coefficient} 
of node {it:i} in the graph {it:g} is defined as the share
of network contacts {it:N_i(g)} of {it:i} who are directly connected among themselves.
{p_end}


{pstd}
The clustering coefficient is calculated for the unvalued network.

{pmore}
	{it:Cluster_i(g) = # { kj in g | k,j in N_i(g)} / # { kj | k,j in N_i(g)}}

{pstd}
Furthermore, the {it:average clustering coefficient} for the whole network {it:g} with 
{it:n} nodes is calculated as:

{pmore}
	{it:Cluster_avg(g) = sum_i (Cluster_i(g)) / n}

{pstd}
Lastly, the command also calculates the {it:overall clustering coefficient} as:

{pmore}
	{it:Cluster_overall(g) = sum_i ( # {kj in g | k,j in N_i(g)} ) / sum_i ( # {kj | in N_i(g)} )}

 
{pstd}
When Stata variable {it:varname} already exists, it is overwritten. In case, clustering centrality is calculated
for {it:z} networks at the same time (e.g. {bf: nwclustering glasgow1 glasgow2}), the command generates the variables
{it:varname_z} for each network. 


{title:Examples}

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwclustering flomarriage} 
	{res}{hline 40}
	{txt}  Network name: {res}flomarriage
	{hline 40}
	{txt}    Average clustering coefficient: {res}.15
	{txt}    Overall clustering coefficient: {res}.1914893617021277{txt}

	{cmd:. sum _clustering}

	
{title:Stored results}	

	{bf:r(cluster_avg)}		Average clustering coefficient
	{bf:r(cluster_overall)}		Overall clustering coefficient	

  
{title:See also}

   {help nwdegree}, {help nwbetween}, {help nwcloseness}, {help nwevcent}
