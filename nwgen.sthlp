{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{marker top2}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{cmd:help nwgen}
{hline}

{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwgen {hline 2}}Network extensions of generate{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:nwgen} {newvar} {cmd:=} {it:fcn}({it:arguments}) [{cmd:,} {it:options}]

	{cmd:nwgen} {it:{help newnetname}} {cmd:=} {it:{help netexp}} {ifin} [{cmd:,} {it:options}]

	
{phang}
where the {it:options} are also {it:fcn}
dependent. The number of an observation {help _n} in {help newvar} corresponds to the {help nodeid}
of a node in a network.

 and where {it:fcn} is
 
{phang2}{opth between(netname)} [, {opt sym}]
{p_end}
{pmore2}Calculates the betweenness centrality of network nodes (see {help nwbetween}).
 
{phang2}{opth closeness(netname)} [, {opth unconnected(integer)} {opt nosym}]
{p_end}
{pmore2}Calculates the closeness centrality of network nodes (see {help nwcloseness}).

{phang2}{opth clustering(netname)}
{p_end}
{pmore2}Calculates the clustering coefficient of network nodes (see {help nwclustering}).

{phang2}{opth components(netname)} 
{p_end}
{pmore2}Returns the component membership of nodes (see {help nwcomponents}).

{phang2}{opth context(netname)} [,
{opt attribute}({help varname})
{opt stat}({help nwcontext##statistic:statistic})
{opt mode}({help nwcontext##context:context})
{opt generate}({help newvar})
{opt mat}(string)
{opt noweight}]
{p_end}
{pmore2}Generates a context variable based on attributes of a node's neighbors (see {help nwcontext}).
				 
{phang2}{opth degree(netname)}
{p_end}
{pmore2}Calculates the degree centrality of network nodes. When the network is directed, the outdegree is returned (see {help nwdegree}).

{phang2}{opth evcent(netname)}
{p_end}
{pmore2}Calculates the eigenvector centrality of network nodes (see {help nwevcent}).

{phang2}{opth farness(netname)} 
{p_end}
{pmore2}Calculates the farness of network nodes (see {help nwcloseness}).

{phang2}{opth indegree(netname)}
{p_end}
{pmore2}Returns the indegree of network nodes. When the network is undirected, the degree is returned (see {help nwdegree}).

{phang2}{opth isolates(netname)}
{p_end}
{pmore2}Returns the isolates of a network (see {help nwdegree}). 

{phang2}{opth lgc(netname)} 
{p_end}
{pmore2}Calculates largest component of the network (see {help nwcomponents}).

{phang2}{opth nearness(netname)} 
{p_end}
{pmore2}Calculates the nearness of network nodes (see {help nwcloseness}).

{phang2}{opth outdegree(netname)}
{p_end}
{pmore2}Returns the outdegree of network nodes. When the network is undirected, the degree is returned (see {help nwdegree}).


