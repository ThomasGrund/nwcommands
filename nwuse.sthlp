{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 14 22 2}{...}
{p2col :nwuse  {hline 2} Load Stata-format networks}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwuse} 
{it:{help filename}}
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
{bf:nwuse} loads into memory a Stata-format network dataset previously saved with {help nwsave} and sets all networks. If {it:{help filename}}
is specified without an extension, {bf:.dta} is assumed. If your {it:filename} contains embedded spaces, remember to enclose
it in double quotes.

{pstd}	
The command automatically loads data with {help use}, but then also declares the data as network data with {help nwset} or {help nwfromedge}.

{pstd}
More about the internal file-format that is used to store network data in Stata on the disk as {bf:.dta} file see {help nwsave##fileformat:here}

	
{title:Examples}
	
{pstd}
This example creates 5 new random networks and {help nwsave:saves} them as {it:mynets}.	A new dataset called {it:mynets.dta} is created in the working director with the networks and the relevant meta-information.

	{cmd:. nwclear}
	{cmd:. nwrandom 20, ntimes(5) prob(.2)}
	{cmd:. nwsave mynets}

{pstd}
After this, one can easily load these 5 networks in a new Stata session. Just as if one would load a normal Stata dataset. The difference is that {help nwuse} automatically declares data 
to be network data with the meta-information it finds in the dataset.

	{cmd:. nwuse mynets}
	
	
{title:See also}

	{help webnwuse}, {help nwsave}, {help use}
