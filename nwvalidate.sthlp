{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwvalidate {hline 2} Validate network name}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwvalidate} 
{it:{help netname}}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Checks if a network {it:{help netname}} already exists. In case it does, 
the command makes a suggestion for an alternative name. Normally, 
the command returns {it:netname_1}.


{title:Examples}

	{cmd:. nwclear}
	{cmd:. nwuse florentine}
	{cmd:. nwvalidate flobusiness}
	{cmd:. return list}

	
{title:Stored results}

	{bf:r(exists)}		"true" when network name already exists, "false" otherwise
	{bf:r(tryname)}		network name that is validated
	{bf:r(validname)}	valid name in case the tryname already exists
 
 
{title:Also see}

   {help nwvalidvars}
