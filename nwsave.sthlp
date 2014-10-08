{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}
{cmd:help nwsave}
{hline}

{title:Title}

{p2colset 5 14 22 2}{...}
{p2col :nsave  {hline 2}}Save networks in file{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwsave} 
{it:{help filename}}
[{cmd:,}
{cmd:format}({help nwsave##save_format:save_format})
{help save##save_options:save_options}
]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{cmd: format}({help nwsave##save_format:save_format})}saves network either as matrix or as edgelist{p_end}

{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}


{synoptset 20 tabbed}{...}
{marker save_format}{...}
{p2col:{it:save_format}}Description{p_end}
{p2line}
{p2col:{cmd: matrix}}saves networks as adjacency matrices; default
		{p_end}
{p2col:{cmd: edgelist}}saves networks as edgelists
		{p_end}

{title:Description}

{pstd}
Saves all networks in memory.


{title:Examples}
		
	//Create, save and load a network
	{cmd:. nwclear}
	{cmd:. nwrandom 20, ntimes(5) prob(.2)}
	{cmd:. nwsave mynets}
	{cmd:. nwclear}
	{cmd:. nwuse mynets}
	{cmd:. nwset}
	
