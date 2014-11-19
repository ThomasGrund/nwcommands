{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}
{cmd:help nwaddnodes}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwaddnodes {hline 2}}Adds isolate nodes to a network {p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwaddnodes} 
[{it:{help netname}}]
, {cmd:newnodes}(integer)
[{cmd:vars}({it:{help newvarlist}})]

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Adds nodes to an existing networks. All new nodes are isolates, i.e. there
are no ties added.


{title:Options}

{phang}
{opt newnodes(integer)} Number of nodes that should be added to the network.

{phang}
{opt vars}({help newvarlist}) Names of new Stata variables that should be used for the additional nodes.{p_end}


{title:Examples}

  {cmd:. nwrandom 10, prob(.1)}
  {cmd:. nwaddnodes, newnodes(3)}
  {cmd:. nwinfo}

