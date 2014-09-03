{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{cmd:help nwdrop}
{hline}

{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwdrop {hline 2}}Eliminates a whole network or only some nodes from a network{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwdrop} 
[{it:{help netlist}}]
[{help if}]
[{help in}]
[{cmd:,}
{cmdab:attr:ibutes}({help varlist})
{cmd:netonly}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt attributes}({help varlist})}Attribute variables that are included in the drop{p_end}
{synopt:{opt netonly}}Only drops the network, but keeps all Stata variables{p_end}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Drops a network or a list of networks. Can also be used with {help if} or {help in} to drop only certain nodes
from a network or network list. Also drops the Stata variables that represent the adjacency matrix of the network.
{p_end}

{title:Options}
{dlgtab:Main}

{phang}
{opt attributes}({help varlist}) Attributes variables that are included in the drop. This option becomes relevant
when only certain nodes of a network are dropped. Node attributes are stored in normal Stata variables. Hence, when 
nodes are dropped the attribute variable need to be updated accordingly to correspond to the reduced network.{p_end}

{phang}
{opt netonly} Only drops the network, but keeps the Stata variables that represent the adjacency matrix of the network.

{title:Examples}

{cmd: nwuse glasgow}
{cmd: nwset}
{cmd: nwdrop glasgow2}
{cmd: nwdrop glasgow3 if smoke == 2, attributes(smoke)}
{cmd: nwset}

{title:Also see}
   
   {help nwclear}, {help nwkeep}
