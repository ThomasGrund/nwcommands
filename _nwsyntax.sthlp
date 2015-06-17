{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##programming:[NW-2.9] Programming}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :_nwsyntax {hline 2} Parse network syntax}
{p2colreset}{...}


{title:Syntax}

{p 8 13 2}{cmd:_nwsyntax} 
{it:anything}
[,
{opth min(int)}
{opth max(int)}
{opt networks(local_macro1)} 
{opt name(local_macro2)}
{opt id(local_macro3)} 
{opt directed(local_macro4)} 
{opt nodes(local_macro5)} 


{synoptline}
{p2colreset}{...}
	
{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth min(int)}}minimum number of networks in unabbreviated {it:anything}; default = 1.{p_end}
{synopt:{opth max(int)}}maximum number of networks in unabbreviated {it:anything}; default = 1.{p_end}
{synopt:{opt networks(local_macro1)}}c_local for number of networks; default = {it:networks}{p_end}
{synopt:{opt name(local_macro2)}}c_local for unabbreviated {it:anything}; default = {it:netname}{p_end}
{synopt:{opt id(local_macro3)}}c_local for ID of last network in {it:anything}; default = {it:id}{p_end}
{synopt:{opt directed(local_macro4)}}c_local for direction of last network in {it:anhthing}; default = {it:directed}{p_end}
{synopt:{opt nodes(local_macro5)}}c_local for number of nodes of last network in {it:anything}; default = {it:nodes}{p_end}

	
{title:Description}

{pstd}
This is a command for advanced network programming. It is the network version of
{help syntax}. It is not as sophisticated as {help syntax}, but performs some basic 
checks and unabbreviates network lists. 

{pstd}
First, the command checks if whatever is given in {it:anything} corresponds to an existing 
{help netname} or {help netlist}. Next, it unabbreviates network lists and checks if
the conditions {bf:min()} and {bf:max()} are met; the minimum (default = 1) and maximum number (default = 1)
of (unabbreviated) networks {help anything} refers to. Lastly, the command uses the undocumented 
{bf:c_local} Stata feature to make several local macros available for other programs.

{pstd}
These locals exist after the program has been called:

	{bf:local local_macro1}		number of networks
	{bf:local local_macro2}		unabbreviated network list
	{bf:local local_macro3}		ID of last network in anything
	{bf:local local_macro4}		directed of last network in anything
	{bf:local local_macro5}		number of nodes in last network in anything
		
{pstd}
For example, the following code uses the defaults to generate the locals {bf:networks, netname, id, directed, nodes}, which
can be used in subsequent programming.

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. _nwsyntax flom*}
	
	{it:local networks} 	= 2
	{it:local netname}	= flomarriage
	{it:local id}		= 2
	{it:local directed}	= false
	{it:local nodes}	= 16
	
{pstd}
Notice that {bf:_nwsyntax} can overwrite existing local macros (which is why the feature should be used with caution). If one 
wants to use it nevertheless, one has to keep in mind that repeated use of _nwsyntax inside programs without changing the defaults
also overwrites the default names of the local macros. For this purpose, there exists the program {bf:_nwsyntax_other}, which is more or less the same as the 
current command, but has different defaults for {it:local_macro1-local_macro5}. Of course, one can also just specify the options
{bf:networks(), name(), id(), directed(), nodes()} to rectify this problem.
	
	
