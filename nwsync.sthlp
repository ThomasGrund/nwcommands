{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd: help nwsync}
{hline}

{title:Title}

{p2colset 5 16 22 2}{...}
{p2col :nwsync {hline 2}}Syncs Stata variables with a network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsync} 
[{it:{help netname}}]
[{cmd:,}
{opt fromstata}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt fromstata}}Changes the direction of the sync{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
Networks ultimately exist as Mata matrices. However, one can also load them
as Stata variables that represent the adjacency matrix of a network 
(see {help nwload}). Normally, when a network is changed through another {help nwcommands:nwcommand} the 
Stata variables (if they exist) are automatically synced. But one can also invoke such 
a sync explicitly. Furthermore, {help nwsync} can be used to sync the other way around, i.e.
one can change the values of the Stata variables that represent the network and sync the 
network (that lives in Mata).   
 
{pstd}


{title:Options}

{phang}
{opt fromstata} Changes the direction of the sync, i.e. the network us updated based on the
Stata variables that represent the network.

{title:Remarks}

{pstd}
One can use {help nwload} and {help nwsync: nwsync, fromstata} to replace tie values in a network. For example,
	
	{cmd:. nwuse florentine, nwclear}
	{cmd:. replace marriage_1 = 99 in 2}
	{cmd:. nwsync flomarriage, fromstata}	

    However, the preferred method to change the same tie value would be using {help nwreplace} instead:
 	{cmd:. nwuse florentine, nwclear}
	{cmd:. nwreplace flomarriage[1,2] = 99 }

{title:See also}

	{help nwload}, {help nwreplace}
