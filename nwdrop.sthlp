{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwdrop {hline 2} Drop a network (or only some nodes)}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwdrop} 
[{it:{help netlist}}]
{ifin}
[{cmd:,}
{opth attr:ibutes(varlist)}
{cmd:netonly}]


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth attributes(varlist)}}Attribute variables that are included in the drop{p_end}
{synopt:{opt netonly}}Only drops the network, but keeps all Stata variables{p_end}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Drops a network or a list of networks. Also
drops the Stata variables that represent the adjacency matrix of the network, unless {bf:netonly} is specified. After
a nework has been dropped it cannot be referred to by its {help netname} again. The command mirros {help nwkeep}.

{pstd}
It can also be used with {help if} or {help in}. Then it only drops certain nodes. Another way to drop
nodes from a network is using {help nwdropnodes}, which mirrors {help nwkeepnodes}.
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

{pstd}
The following command loads data from the internet and drops one network.

	{cmd: . webnwuse glasgow}
	{res}
	{txt}{it:Loading successful}
	{res}{txt}(3 networks)
	{hline 20}
		{res}glasgow1
		{res}glasgow2
		{res}glasgow3

	{com}. nwdrop glasgow2
	{res}
	{com}. nwds
	{res}{txt}{col 1}glasgow1{col 20}glasgow3

{pstd}
The next command drops the first three nodes of network {it:glasgow1}.
	
	{cmd:. nwdrop glasgow1 if _n <= 3}

{pstd}
One can also drop the first three nodes of a network like this:

	{cmd:. nwdropnodes glasgow1, nodes(1 2 3)}

{pstd}
Whenever a command allows a {help netlist}, all familiar usage known from {help varlist} can be used. For example,

	{cmd:. nwdrop gl*}
	{cmd:. nwdrop _all}
		
	
{title:Also see}
   
   {help nwdropnodes}, {help nwclear}, {help nwkeep}, {help nwkeepnodes}
