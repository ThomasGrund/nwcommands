{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{cmd:help nwsym}
{hline}

{title:Title}

{p2colset 5 14 22 2}{...}
{p2col :nwsym  {hline 2}}Symmetrizes a network{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwsym} 
[{it:{help netname}}]
[{cmd:,}
{cmd:name}({it:new}{it:{help netname}})
{cmd:noreplace}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mode}({it:{help nwsym##mode:mode}})}Logic for creating an undirected tie{p_end}
{synopt:{opt name}({it:new}{it:{help netname}})}Name of the new symmetrized network{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}New variables that are used for the network{p_end}
{synopt:{opt noreplace}}Creates a new network instead of changing it{p_end}

{p2colreset}{...}
{synoptset 20 tabbed}{...}
{marker mode}{...}
{p2col:{it:mode}}Description{p_end}
{p2line}
{p2col:{cmd: max}}maximum of ties values (i,j) and (j,i); default
		{p_end}
{p2col:{cmd: min}}minimum of ties values (i,j) and (j,i)
		{p_end}
{p2col:{cmd: mean}}mean of ties values (i,j) and (j,i)
		{p_end}
{p2col:{cmd: sum}}sum of ties values (i,j) and (j,i)
		{p_end}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Symmetrizes a network, i.e. it transforms a directed network in an undirected network. By default, 
an undirected tie is formed when there is either a tie from node i to node j or a tie from node j to 
node i. Other rules can be applied (see {help nwsym##mode:mode}). When option {it:check} is specified 
the command can also be used to find out if a network is symmetric or not.  In this case, the result
is stored in {it:r(is_symmetric)}. 


{title:Options}
{dlgtab:Main}

{phang}
{opt mode}({help nwsym##mode:mode}) The logic that is used to symmetrize a network.{p_end}

{phang}
{opt name}({it:new}{it:{help netname}}) Name of the new symmetrized network. This option 
becomes only relevant when used together with {it:noreplace}. Notice that when a network
name already exists, all {help nwcommands} suggest another {help nwvalidate:unique netname}.{p_end}

{phang}
{opt noreplace} Creates a new network instead of replacing the old one. When no {it:name} is 
specified, by default the symmetrized network is called {it:_sym_{help netname}}.

{phang}
{opt check} Tests if a network is symmetric or not. Result is stored in the return vector.

{title:Examples}

  {cmd:. nwuse glasgow, nwclear}
  {cmd:. nwsym glasgow1, check}
  {cmd:. return list}
  {cmd:. nwsym glasgow1}
  {cmd:. nwsym glasgow1, check}
  {cmd:. return list}
