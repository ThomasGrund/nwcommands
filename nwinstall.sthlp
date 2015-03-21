{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}

{title:Title}

{p2colset 9 20 23 2}{...}
{p2col :nwinstall {hline 2} Install Stata menu/dialogs}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwinstall} 
[,
{opt permanently}
{opt remove }
{opt help}
{opth path(string)]



{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt permanently}}install the menu/dialogs permanently on your Stata{p_end}
{synopt:{opt remove}}remove the "Network Analysis" menu from your Stata{p_end}
{synopt:{opt help}}download the help files{p_end}
{synopt:{opt all}}download the help files, dialog boxes, extensions and install them permanently{p_end}
{synopt:{opth path(string)}}directory where profile.do is installed; default SYSDIR_PERSONAL{p_end}


{title:Description}

{pstd}
This command loads Stata dialog boxes for the nwcommands and installs a menu "Network Analysis" inside the "User" menu. Almost
all nwcommands (and their functions) can be executed via dialog boxes. Notice, however, that some more 
advanced functions are only available through Stata syntax (see {help nwcommands}).


{title:Example}

{pstd}
I recommend you run this first after you installed the package "nwcommands-ado". It installs all help files and dialog boxes.

	{cmd:. nwinstall, all}
	

{pstd}
This installs a menu for the nwcommands:

	{cmd:. nwinstall, permanently}


