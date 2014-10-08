{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}
{cmd:help nwtoedge}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwtoedge {hline 2}}Converts a network (or a list of networks) in an edgelist{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtoedge} 
[{help netlist}]
[{cmd:,}
{opt fromvars}({help varlist})
{opt tovars}({help varlist})
{opt fromid}({help newvar})
{opt toid}({help newvar})
{opt link}({help newvar})
{opt forceundirected}
{opt forcedirected}
{opt type}({help nwtoedge##compact_mode:compact_mode})]

{synoptset 20 tabbed}{...}
{marker compact_mode}{...}
{p2col:{it:compact_mode}}Description{p_end}
{p2line}
{p2col:{cmd: compact}}only generate entries for ties (and for isolates); default
		{p_end}
{p2col:{cmd: full}}generate entries for all dyads
		{p_end}
		
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt fr:omvars}({help varlist})}specifies which variables shall be kept to describe the sending nodes{p_end}
{synopt:{opt to:vars}({help varlist})}specifies which variables shall be kept to describe the receiving nodes {p_end}
{synopt:{opt fromid}({help newvar})}new variable name specifying {it: fromid}.{p_end}
{synopt:{opt toid}({help newvar})}new variable name specifying {it: toid}.{p_end}
{synopt:{opt link}({help newvar})}new variable name specifying link. {p_end}

{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwtoedge} makes an edgelist out of a network (or a list of networks). One can specify which 
attribute variables should be included in the new dataset as well. 

{title:Options}

{dlgtab:Main}


{phang}
{opt fr:omvars(varlist)}Needs to be specified if the user prefers to choose which attribute variables
of the sending node shall be included in the new dataset. 

{phang}
{opt to:vars(varlist)}Needs to be specified if the user prefers to choose which attribute variables
of the receiving node shall be included in the new dataset.



{dlgtab:compact_mode}

{phang}
{opt c:ompact} Is the default option. It is used to reduce the size of the dataset without losing any
relevant information, and is particularly useful for large and sparse matrices. A compact
edgelist includes all pairs of nodes that are directly linked to one another. In addition and in
order to preserve information about all nodes, it also retains observations where the sending
node is the same as the receiving node, if the sending node has no other outgoing links. In this
way there will be at least one observation retained per sending node. From the compact format
it is easy to convert the network back into adjacency matrix format and keep any attributes
variables for each node that may exist in the data. 

{phang}
{opt f:ull} Produces an edgelist with all dyads.

{title:Examples}

	{cmd:. nwuse glasgow}
	{cmd:. nwtoedge glasgow1, fromvars(smoke1) tovars(smoke1)}
	
	{cmd:. nwclear}
	{cmd:. nwuse glasgow}
	{cmd:. nwtoedge _all}
	

{title:Also see}
	
	{help nwfromedge}
