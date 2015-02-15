{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nworder {hline 2} Reorder networks in dataset}
{p2colreset}{...}


{title:Syntax}

{p 8 13 2}
{opt nworder}
{it:{help netlist}}
[{cmd:,} 
{it:options}]


{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt :{opt last}}move {help netlist} to end of dataset; the default{p_end}
{synopt :{opt first}}move {help netlist} to beginning of dataset{p_end}
{synopt :{opth b:efore(netname)}}move {help netlist} before {it:netname}{p_end}
{synopt :{opth a:fter(netname)}}move {help netlist} after {it:netname}{p_end}
{synopt :{opt alpha:betic}}alphabetize {help netlist} and move it to beginning of dataset{p_end}
{synopt :{opt seq:uential}}alphabetize {help netlist} keeping numbers sequential and move it to beginning of dataset{p_end
> }
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{opt nworder} relocates {help netlist} to a position depending on
which option you specify. If no option is specified, {cmd:order} relocates
{it:netlist} to the end of the dataset in the order in which the
variables are specified.

{pstd}
The command is useful when one wants to do bulk-operations with networks and when 
the network order matters (e.g. when making a movie out of _all networks, see {help nwmovie}).


{marker options}{...}
{title:Options}

{phang}
{opt last} shifts {help netlist} to the end of the dataset.  This
is the default.

{phang}
{opt first} shifts {help netlist} to the beginning of the dataset. 

{phang}
{opth before(netname)} shifts {varlist} before {it:netname}.

{phang}
{opth after(netname)} shifts {varlist} after {it:netname}.

{phang}
{opt alphabetic} alphabetizes {help netlist} and moves it to the beginning of the
dataset.  For example, here is a netlist in {cmd:alphabetic} order:
{cmd:a x7 x70 x8 x80 z}.  If combined with another option, {opt alphabetic}
just alphabetizes {it:varlist}, and the movement of {it:netlist} is controlled
by the other option.

{phang}
{opt sequential} alphabetizes {help netlist}, keeping netnames with the same
ordered letters but with differing appended numbers in sequential order. 
{it:netlist} is moved to the beginning of the dataset.  For example, here
is a netlist in {cmd:sequential} order: {cmd:a x7 x8 x70 x80 z}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hpotter}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. nwds}

{pstd}Move {cmd:hpbook5} and {cmd:hpbook4} to the beginning of the dataset{p_end}
{phang2}{cmd:. nworder hpbook5 hpbook4}

{pstd}Describe the networks{p_end}
{phang2}{cmd:. nwds}

{pstd}Make {cmd:hpboo3} be the last network in the dataset{p_end}
{phang2}{cmd:. nworder hpbook3, last}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. nds}

{pstd}Alphabetize the networks{p_end}
{phang2}{cmd:. nworder _all, alphabetic}

{pstd}Describe the networks{p_end}
{phang2}{cmd:. nwds}{p_end}


{title:See also}

	{help nwds}, {help nwsort}, {help order}, {help netlist}
