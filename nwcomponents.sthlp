{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}
{cmd:help nwcomponents}
{hline}

{title:Title}

{p2colset 5 21 22 2}{...}
{p2col :nwcomponents {hline 2}}Calculates the largest component and the number of network components{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwcomponents} 
[{it:{help netname}}]
[, {opt lgc}
{opt generate}({help newvarname})]

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Calculates the components of the network. A component is a set of nodes that are
only connected among each other. Nodes can only belong to one component. Furthermore, 
additional information about the size of each component is returned in {it:r(comp_sizeid)}. 

{pstd}
By default, {cmd:nwcomponents} generates 
a new variable {it:_components} which stores the component membership.
When option {bf:lgc} is specified, the command generates a new variable 
{it:_lgc} which stores information about membership to the largest component.


{title:Options}

{phang}
{opt lgc} Calculate membership to the largest component.

{phang}
{opt generate}({help newvar}) Name of new variable for either _component or _lgc.

{title:Remarks}
  
    All ties are treated as undirected for the calculation of components.
  

  {title:Examples}

  {cmd:. nwuse glasgow}
  {cmd:. nwcomponents}
  {cmd:. nwcomponents, generate(mycomponent)} 
  {cmd:. nwcomponents, lgc} 
  {cmd:. nwcomponents, lgc generate(mylgc)} 
  
