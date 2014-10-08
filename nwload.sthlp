{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}
{cmd:help nwload}
{hline}

{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwload {hline 2}}Loads an available network as Stata variables{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwload} 
[{it:{help netname}}]
[{cmd:,}
{cmd:id}({help nwload##networkid:networkid})
{cmd:nocurrent}
{cmd:labelonly}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt id}({help nwload##networkid:networkid})}id of the the network that should be loaded{p_end}
{synopt:{opt nocurrent}}only loads network as Stata variables, but does not make it the {it:current network{p_end}
{synopt:{opt labelonly}}only load the node labels as Stata variable{p_end}

{synoptline}
{p2colreset}{...}

{synoptset 20 tabbed}{...}
{marker networkid}{...}
{p2col:{it:networkid}}{p_end}
{p2line}
{p2col:{cmd: #}}number between 1 and total number of networks
		{p_end}
		
		
{title:Description}

{pstd}
{cmd:nwload} creates Stata variables to represent a network as adjacency matrix. Most {help nwgenerator}s call this command by 
default. The actual network data, however, lives in Mata. Hence, all Stata variables can be deleted and the 
network loaded again. Notice that changing one of the Stata variables does not change the underlying network, unless
used in combination with {help nwsync}. To change values of the underlying network directly use {help nwvalue} or
{help nwreplace}. By default, {help nwload} also changes the {it:current network} and creates/overwrites a variable 
_label that holds the node labels.

{title:Options}

{dlgtab:Main}

{phang}
{opt id}({help nwload##networkid:networkid}) Number that specifies which network should be loaded as Stata variables.

{title:Remarks}

{pstd}
Notice that {cmd:nwload} does not import or create a network. Only networks that already do exist in Stata, i.e. have been
set by {help nwset} or imported by {help nwimport} or {help nwuse} or created by a {help nwgenerator}, can be loaded
 as Stata variables. If two different networks use the same variable names, the Stata variables are overwritten.

{title:Examples}

{cmd: nwuse florentine}
{cmd: clear}
{cmd: nwload flobusiness}
{cmd: nwload, id(1)}

{title:Also see}
   
   {help nwcurrent}, {help nwreplace}, {help nwsync}, {help nwvalue}, {help nwuse}, {help nwimport}
