{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{cmd:help nwkeep}
{hline}

{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwkeep {hline 2}}Keeps a network or only keeps certain nodes of a network{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwkeep} 
[{it:{help netlist}}]
[{help if}]
[{help in}]
[{cmd:,}
{cmdab:attr:ibutes}({help varlist})

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt attributes}({help varlist})}Attribute variables that are included in the keep{p_end}
{synopt:{opt netonly}}Only keeps the network, but leaves all Stata variables untouched{p_end}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Keeps a network or a list of networks. Can also be used with {help if} or {help in} to keep only certain nodes
from a network or network list. Also keeps the Stata variables that represent the adjacency matrix of the network.
{p_end}

{title:Options}
{dlgtab:Main}

{phang}
{opt attributes}({help varlist}) Attributes variables that are included in the keep. This option becomes relevant
when only certain nodes of a network are kept. Node attributes are stored in normal Stata variables. Hence, when 
nodes are dropped/kept the attribute variable need to be updated accordingly to correspond to the reduced network.{p_end}

{phang}
{opt netonly} Only keeps the network, but leaves the Stata variables that represent the adjacency matrix of the network untouched.

{title:Examples}

{cmd: nwuse glasgow}
{cmd: nwset}
{cmd: nwkeep glasgow2 glasgow3}
{cmd: nwkeep glasgow3 if smoke == 1, attributes(smoke)}
{cmd: nwset}

{title:Also see}
   
   {help nwclear}, {help nwdrop}
