{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwkeep {hline 2} Keep a network (or only certain nodes)}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwkeep} 
[{it:{help netlist}}]
[{ifin}]
[{cmd:,}
{opth attr:ibutes(varlist)}
{opt netonly}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth attr:ibutes(varlist)}}Attribute variables that are included in the keep{p_end}
{synopt:{opt netonly}}Only keep the network, but leave all Stata variables untouched{p_end}

{synoptline}
{p2colreset}{...}
	
	
{title:Description}

{pstd}
Keeps a network or a list of networks. The command is the network version of {help keep} and mirrors {help nwdrop}.

{pstd}
It can also be used together with {help if} or {help in}. In this case, the command operates on the node-level
and keeps only certain nodes from a network or network list. Another way to keep certain nodes of a network is using
{help nwkeepnodes}, which mirrors {help nwdropnodes}.

{title:Options}

{phang}
{opt attributes}({help varlist}) Attributes variables that are included in the keep. This option becomes relevant
when only certain nodes of a network are kept. Node attributes are stored in normal Stata variables. Hence, when 
nodes are dropped/kept the attribute variable need to be updated accordingly to correspond to the reduced network.{p_end}

{phang}
{opt netonly} Only keep the network, but leave the Stata variables that represent the adjacency matrix of the network untouched.


{title:Examples}

{pstd}
The following command loads data from the internet and keeps networks {it:glasgow1} and {it:glasgow3}.

	{cmd: . webnwuse glasgow}
	{res}
	{txt}{it:Loading successful}
	{res}{txt}(3 networks)
	{hline 20}
		{res}glasgow1
		{res}glasgow2
		{res}glasgow3

	{com}. nwkeep glasgow1 glasgow3
	{res}
	{com}. nwds
	{res}{txt}{col 1}glasgow1{col 20}glasgow3

{pstd}
The next command keeps the first ten nodes of network {it:glasgow1}.
	
	{cmd:. nwkeep glasgow1 if _n <= 10}

{pstd}
One can also keep the first ten nodes of a network like this:

	{cmd:. nwkeepnodes glasgow1, nodes(1-10)}

{pstd}
Whenever a command allows a {help netlist}, all familiar usage known from {help varlist} can be used. For example,

	{cmd:. nwkeep gl*}


{title:Also see}
   
   {help nwclear}, {help nwdrop}, {help nwkeepnodes}, {help nwdropnodes}
