{smcl}
{* *! version 1.0.0  3sept2014}{...}
{cmd:help nwtable}
{hline}

{title:Title}

{p2colset 5 17 23 2}{...}
{p2col :nwtable {hline 2}}Two-way table of two networks or network and attribute{p_end}
{p2colreset}{...}


{title:Syntax}

{p 5 17 2}
{cmdab: nwtable} 
[{help netname:netname1}]
{help netname:netname2}|
{help var}
]
[{cmd:,}
{opt plot}
{opt plotoptions}({help tabplot:tabplot_options})
{help tabulate twoway:tabulate_options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt plot}}makes a tabplot{p_end}


{title:Description}

{pstd}
Either {it:netname2} or {it:var} need to be specified. When two networks
are given, the command produces a twoway table of the dyads across the
two networks. When one network and one variable is given, the command
produces a twoway table of the variable from the sender to the receiver
of network ties.  


{title:Example}
	
	// Two networks
	{cmd:. nwuse glasgow}
	{cmd:. nwtable glasgow1 glasgow2}
	
	// One network and one attribute
	{cmd:. nwtable glasgow1 sport1}
	
{title:See also}

	{help nwtabulate}
