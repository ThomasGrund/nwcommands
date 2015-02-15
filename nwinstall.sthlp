{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.7] Utilities}

{title:Title}

{p2colset 9 20 23 2}{...}
{p2col :nwinstall {hline 2} Install Stata menu/dialogs}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwinstall} 
[,
{opt permanently}
{opt remove }]



{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt permanently}}install the menu/dialogs permanently on your Stata{p_end}
{synopt:{opt permutations(integer)}}remove the "Network Analysis" menu{p_end}


{title:Description}

{pstd}
This command loads Stata dialog boxes for the nwcommands and installs a menu "Network Analysis" inside the "User" menu. Almost
all nwcommands (and their functions) can be executed via dialog boxes. Notice, however, that some more 
advanced functions are only available through Stata syntax (see {help nwcommands}).


{title:Example}

{pstd}
This installs a menu for the nwcommands:

	{cmd:. nwinstall, permanently}


