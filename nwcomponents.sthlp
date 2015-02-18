{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 21 22 2}{...}
{p2col :nwcomponents {hline 2} Calculate network components / largest component}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwcomponents} 
[{it:{help netlist}}]
[, {opt lgc}
{opth generate(newvarname)}]


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth generate(newvarname)}}name of the Stata variable that stores information about components; default = {it:_component} or {it:_lgc}{p_end}
{synopt:{opt lgc}}calculate membership to largest component{p_end}

{p2colreset}{...}
	
{title:Description}

{pstd}
Calculate the components of a network or a list of networks. A component is a set of nodes that are
only connected among each other. All calculations are performed on the non-directed version of the networks. Nodes can only belong to one component. 

{pstd}
By default, {cmd:nwcomponents} generates 
a new variable {it:_components} which stores the component membership.
When option {bf:lgc} is specified, the command generates a new variable 
{it:_lgc} which stores information about membership to the largest component.


{title:Stores results}

	Scalars
	  {bf:r(components)}		number of components
	  
	Matrices
	  {bf:r(comp_sizeid)}		distribution over components
	  

{title:Examples}

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwcomponents flomarriage}

	{res}{hline 40}
	{txt}  Network name: {res}flomarriage
	{txt}  Components: {res}2

	 {txt}_component {c |}      Freq.     Percent        Cum.
	{hline 12}{c +}{hline 35}
	{txt}          1 {c |}{res}         15       93.75       93.75
	{txt}          2 {c |}{res}          1        6.25      100.00
	{txt}{hline 12}{c +}{hline 35}
	      Total {c |}{res}         16      100.00{txt}
  
 {pstd}
 This shows that there are two components in the Florentine marriage network. All except one node belong to the first
 components. Some alternative ways how the commands can be used.
 
	{cmd:. webnwuse glasgow}
	{cmd:. nwcomponents glasgow1, generate(mycomponent)} 
	{cmd:. nwcomponents _all, lgc} 
	{cmd:. nwcomponents _all, lgc generate(mylgc)} 
  

 {title:See also}
 
	{help nwgen}
