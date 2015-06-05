{smcl}
{* *! version 1.0.0  11nov2014}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwcollapse {hline 2} Collapse a network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcollapse} 
[{opt (stat)}]
[{it:{help netname}}]
[{cmd:,}
{opth by(varlist)} 
{it:{help collapse##table_options:options}}]


{title:Description}

{pstd}
This command collapses a network, i.e. it merges network nodes. It works very similar as {help collapse}. With option {opth by(varname)} one specifies which nodes should
be merged. The rule for collapsing two nodes are specified with {it:stat}, by default {it:stat} = {bf:max} ({help collapse:see here for possible values}). For example, when nodes
A and B are collapsed to node Z, Z inherits all the ties from node A and B.   


{marker examples}{...}
{title:Examples}

{pstd}
This collapses the first and the second node of a random network. The collapsed node will have all ties that the original nodes had. 

	{cmd:. nwrandom 20, prob(.1) name(mynet)}
	{cmd:. gen att = _n}
	{cmd:. replace att = 1 in 2}
	{cmd:. nwcollapse mynet, by(att)}
	

	
	

