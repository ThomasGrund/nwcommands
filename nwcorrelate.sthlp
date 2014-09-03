{smcl}
{* *! version 1.0.0  3sept2014}{...}
{cmd:help nwcorrelate}
{hline}

{title:Title}

{p2colset 5 20 23 2}{...}
{p2col :nwcorrelate {hline 2}}Correlates either two networks or one network and an attribute{p_end}
{p2colreset}{...}


{title:Syntax}

{p 5 17 2}
{cmdab: nwcorrelate} 
{help netname:netname1}
{help netname:netname2}
[
{opt permutations(integer)}
{opt saving}
{help kdensity:kdensity_options}]

{p 5 17 2}
{cmdab: nwcorrelate} 
{help netname:netname}
, 
{opt attribute}({help var})
[{opt mode}({help nwexpand##expand_mode:expand_mode})
{opt permutations(integer)}
{opt saving}
{help kdensity:kdensity_options}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mode}({help nwexpand##expand_mode:expand_mode})}expand mode{p_end}
{synopt:{opt permutations(integer)}}number of QAP permuations{p_end}
{synopt:{opt saving}}saves QAP permuations{p_end}


{title:Description}

{pstd}
When two networks {help netname:netname1} and {help netname:netname2} are given, 
the command calculates the correlation between netname1_ij and netname2_ij. 

{pstd}
When one network {help netname} and one attribute {help var} are given, the command calculates
the correlation between netname_ij and x_ij, where x_ij is:

{pstd}	
	x_ij = var[i] == var[j]

{pstd}	
This is equivalent to specifying the option {cmd:mode(same)}.

{pstd}
Other modes can be specified as well, e.g. {cmd:mode(absdiff)} {help nwexpand:see also}.

{pstd}
The option {it:permuatation(integer)} creates QAP permutations of the first network and 
generates a distribution of correlation coefficients under the null-hypothesis that there is
no correlation. A plot is displayed and additional information is returned in the return vector. 

{title:Examples}
	
	// Two networks
	{cmd:. nwuse glasgow}
	{cmd:. nwcorrelate glasgow1 glasgow2, permutations(50)}
	
	// One network and one attribute
	{cmd:. nwcorrelate glasgow1 sport1, permutations(50)}
	
{title:See also}

	{help nwtable}, {help nwexpand}
