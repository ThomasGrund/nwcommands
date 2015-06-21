{smcl}
{* *! version 2.0.0  2april2014}{...}
{marker topic}
{helpb nw_topical##visualization:[NW-2.8] Visualization}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwdendrogram {hline 2} Plot a wheel dendrogram}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwdendrogram}
[{it:clname}] 
[{cmd:,} {it:options} {it:{help twoway_options}}]

{synoptset 25}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{opth factor(float)}}zoom in or out{p_end} 
{p2col:{opth label(varname)}} label observations{p_end} 
{p2col:{opt colorpalette}({it:colstyle1 ...})} overwrite colorpalette{p_end} 
{p2col:{opt symbolpalette}({it:symbstyle1 ...})} overwrite symbolpalette{p_end} 
{p2col:{opt obsopt}({help scatter##marker_options:marker_options})} send options to markers for observations{p_end} 
{p2col:{opt nodeopt}({help scatter##marker_options:marker_options})} send options to markers for hubs{p_end} 
{p2col:{opt coreopt}({help scatter##marker_options:marker_options})} send options to markers for the core{p_end} 
{p2col:{opt ringopt}({help scatter##help connect_options:connect_options})} options for plotting the rings {p_end} 
{p2col:{opt beamopt}({help scatter##help connect_options:connect_options})} options for plotting the beams {p_end} 

{title:Description}
{pstd}
Displays results from hierarchical clustering (see {help nwhierarchy} or {help cluster}) as wheel dendrogram.
	
		
{title:Example}

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwhierarchy flomarriage}
	{cmd:. nwdendrogram _clus_1}


