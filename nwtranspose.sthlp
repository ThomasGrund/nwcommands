{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwtranspose}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwtranspose {hline 2}}Transposes a network{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwtranspose} 
[{it:{help netname}}]
[{cmd:,}
{cmd:name}({it:new}{it:{help netname}})
{cmd:noreplace}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt name}({it:new}{it:{help netname}})}Name of the new transposed network{p_end}
{synopt:{opt noreplace}}Creates a new network instead of changing it{p_end}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Simply transposes a network, i.e. a directed tie from node i to node j is transformed in a 
directed tie from node j to node i. By defauly, {cmd:nwtranspose} replaces a network, but you 
can specify that it should create a new network instead. The command is a {help nwgenerator}
and can be used whenever such an element is allowed. 

{title:Options}
{dlgtab:Main}

{phang}
{opt name}({it:new}{it:{help netname}})} Name of the new transposed network. This option 
becomes only relevant when used together with {it:noreplace}. Notice that when a network
name already exists, all {help nwcommands} suggest another {help nwvalidate:unique netname}.{p_end}

{phang}
{opt noreplace} Creates a new network instead of replacing the old one. When no {it:name} is 
specified, by default the transposed network is called {it:_transp_{help netname}}.

{title:Examples}

  {cmd:. nwrandom 10, prob(.3)}
  {cmd:. nwtranspose, noreplace}
  {cmd:. nwset}
