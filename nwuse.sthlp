{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{cmd:help nwuse}
{hline}

{title:Title}

{p2colset 5 14 22 2}{...}
{p2col :nwuse  {hline 2}}Use a saved network{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwuse} 
{it:{help file}}
[{cmd:,}
{cmd:nwclear}
{cmd:clear}]

{p 8 17 2}
{cmdab: webnwuse} 
{it:{help netexample}}
[{cmd:,}
{cmd:nwclear}
{cmd:clear}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt nwclear}}clears all variables and networks{p_end}
{synopt:{opt clear}}only clears variables, but keeps networks{p_end}

	
{title:Description}

{pstd}
Uses networks that have been saved using {it:nwsave}. When not specified otherwise, the command
searches for a file in the working directory. Can also be used to load network data from
the nwcommands.org Server.


{title:Examples}
	
	//Load from the nwcommands.org server
	{cmd:. webnwuse gang}
	{cmd:. nwset}
	
	//Create, save and load a network
	{cmd:. nwclear}
	{cmd:. nwrandom 20, ntimes(5) prob(.2)}
	{cmd:. nwsave mynets}
	{cmd:. nwclear}
	{cmd:. nwuse mynets}
	{cmd:. nwset}
	
