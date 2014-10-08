{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}
{cmd:help nwexport}
{hline}

{title:Title}

{p2colset 5 18 22 2}{...}
{p2col :nwexport  {hline 2}}Export network as Pajek file{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwexport} 
[{it:{help netname}}]
[, {cmd:fname}({help filename})
{cmd:replace}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt fname}({help filename})}filename of the exported network{p_end}
{synopt:{opt replace}}overwrite exported file{p_end}

{title:Description}

{pstd}
Export the network as a Pajek .net file in edge/arc-list format.

{title:Examples}
	
   //Import/export pajek file
   {cmd:. nwclear}
   {cmd:. nwimport http://nwcommands.org/data/gang_pajek.net, type(pajek)}
   {cmd:. nwexport gang, fname(mygang.net)}
   {cmd:. nwclear}
   {cmd:. nwimport mygang.net, type(pajek)}

 {title:See also}
	{help nwimport}, {help nwuse}, {help nwsave}
	
