{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{cmd:help nwcomponents}
{hline}

{title:Title}

{p2colset 5 22 22 2}{...}
{p2col :nwcomponents {hline 2}}Calculates the number of network components{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwcomponents} 
[{it:{help netname}}]
[, {cmdab:gen:erate}({it:{help newvar}})]

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Calculates the components of the network. A component is a set of nodes that are
only connected among each other. Nodes can only belong to one component. The 
number of distinct components is returned in {it:r(components)}. Furthermore, 
additional information about the size of each component is returned in {it:r(comp_sizeid)}. 
By default, {cmd:nwcomponents} generates 
a new variable {it:_components} which stores the component membership of each node. 


{title:Options}

{phang}
{opt generate}({help newvar}) New Stata variable where component membership of each node is stored.

{title:Remarks}
  
    All ties are treated as undirected for the calculation of components.
  

  {title:Examples}

  {cmd:. nwuse glasgow}
  {cmd:. nwcomponents}
  {cmd:. di r(components)}
  {cmd:. matrix list r(comp_sizeid)}
