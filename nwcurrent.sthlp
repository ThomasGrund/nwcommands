{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##information:[NW-2.4] Information}
{marker top2}
{helpb nw_topical##utilities:[NW-2.7] Utilities}


{title:Title}

{p2colset 9 19 22 2}{...}
{p2col :nwcurrent {hline 2} Report and set current network}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwcurrent} 
[{it:{help netname}}]
[{cmd:,}
{opth id(int)}]

{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth id(int)}}network ID of the the network that should be made the current network{p_end}
{synoptline}
	
		
{title:Description}

{pstd}
Almost all nwcommands allow that a {help netname} or {help netlist} is optional. In case, no network 
is specified, by default, the nwcommands use the {it:current network}.

{pstd}
The {it:current network} is simply the last network that has been {help nwset:set},
{help nw_topical##import:imported}
or {help nw_topical##generators:generated}. This is a convenient way to way access the latest
network one worked with. 

{pstd}
{cmd:nwcurrent} changes the {it:current network}. It can be used either with {help netname} or with {bf:id()}.
The command also returns some information about the {it:current network}
in the r() vector. 


{title:Examples}

	{cmd: nwuse florentine}
	{cmd: nwcurrent flobusiness}


{title:Stored results}

	Scalars:
	  {bf:r(networks)}	number of networks
	
	Macros:
	  {bf:r(current)}	name of current network
	  

{title:Also see}

	{help nwname}, {help nwload}, {help nwset}
