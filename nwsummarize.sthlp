{smcl}
{* *! version 1.0.4  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##information:[NW-2.4] Information}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwsummarize {hline 2} Summarize a network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsummarize} 
[{it:{help netlist}}]
[,{opt mat}
{opt matonly}
]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mat}}Display adjacency matrix of the network{p_end}
{synopt:{opt matonly}}Only display adjacency matrix of the network{p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
{cmd:nwsummarize} calculates and displays a variety of network summary statistics. 
 If no netlist is specified, summary statistics are calculated for 
 the current network.

 
{title:Examples}

	{cmd:. webnwuse florentine}
	{com}. nwsummarize flomarriage
	{res}{hline 50}
	{txt}   Network name: {res} flomarriage
	{txt}   Network id: {res} 12
	{txt}   Directed: {res}false
	{txt}   Nodes: {res}16
	{txt}   Edges: {res}20
	{txt}   Minimum value: {res} 0
	{txt}   Maximum value: {res} 1
	{txt}   Density: {res} .1666666666666667


	{com}. nwclear
	. nwrandom 5, prob(.2) name(mynet)
	. nwsummarize mynet, mat
	{res}{hline 50}
	{txt}   Network name: {res} mynet
	{txt}   Network id: {res} 1
	{txt}   Directed: {res}true
	{txt}   Nodes: {res}5
	{txt}   Arcs: {res}5
	{txt}   Minimum value: {res} 0
	{txt}   Maximum value: {res} 1
	{txt}   Density: {res} .25

             {txt}1   2   3   4   5
          {c TLC}{hline 21}{c TRC}
	1 {c |}  {res}0   0   0   0   1{txt}  {c |}
	2 {c |}  {res}0   0   0   0   0{txt}  {c |}
	3 {c |}  {res}0   0   0   0   1{txt}  {c |}
	4 {c |}  {res}0   0   0   0   0{txt}  {c |}
	5 {c |}  {res}1   1   0   1   0{txt}  {c |}
          {c BLC}{hline 21}{c BRC}

	
{title:Stored results}

	{bf:nwsummarize} stores the following in {bf:r()}:
	
	Scalars
	  {bf:r(id)}		internal ID of the network
	  {bf:r(nodes)}		number of nodes in the network
	  {bf:r(minval)}	minimum of tie values
	  {bf:r(maxval)}	maximum of tie values	
	  {bf:r(edges)}		number of edges (undirected network)
	  {bf:r(arcs)}		number of arcs (directed network)
	  {bf:r(edges_sum)}	sum of edge values (undirected network)	  
	  {bf:r(arcs_sum)}	sum of arc values (directed network)
	  {bf:r(denisty)}	network density

	Macros
	  {bf:r(directed)}	if network is directed or not (undirected)
	  {bf:r(name)}		name of the network
	  

{title:See also}

	{help nwname}, {help nwdyads}, {help nwtriads}
