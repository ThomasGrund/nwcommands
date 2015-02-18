{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwsort {hline 2} Sort network nodes}
{p2colreset}{...}


{title:Syntax}

{p 8 13 2}
{opt nwsort}
{it:{help netname}}
{cmd:,} 
{cmd: by({varlist})}
[{opt stable}
{opth att:ribute(varlist)}]


{marker description}{...}
{title:Description}

{pstd}
{opt nwsort} permutes the nodes in network {it:{help netname}} into ascending order
based on the values in {opt by()}.  There is no limit to the
number of variables in the {it:varlist}.  Missing numeric values (see 
{help missing}) are interpreted as being larger than any other number, so they
are placed last with {cmd:. < .a < .b < ... < .z}.  When you sort on a string
variable, however, null strings are placed first. 

{pstd}
By default the variables in {opt by()} are incuded in the sort. Other variables can be included
with option {opt attribute()}.

{pstd}
All structural features of the network remain the same.

{marker option}{...}
{title:Options}

{phang}
{opth attribute(varlist)} includes additional node level attributes in the sort. For example:

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwsort flomarriage, by(wealth)}

{pmore}sorts the ordering of the nodes according to {it:wealth}, but it does not change the order of the 
other variables in the dataset. In contrast,

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwsort flomarriage, by(wealth) attributes(_all)}

{pmore}sorts the network {it:flomarriage}, but also all other variables in the dataset according to {it:wealth}.

{phang}
{opt stable} specifies that observations with the same values of the variables
in {varlist} keep the same relative order in the sorted data that
they had previously.  For instance, consider the following data:

{center:x  b}
{center:3  1}
{center:1  2}
{center:1  1}
{center:1  3}
{center:2  4}

{pmore}
Typing {cmd:sort x} without the {opt stable} option produces one of the
following 6 orderings.

{center:x  b  {c |}  x  b  {c |}  x  b  {c |}  x  b  {c |}  x  b  {c |}  x  b}
{center:1  2  {c |}  1  2  {c |}  1  1  {c |}  1  1  {c |}  1  3  {c |}  1  3}
{center:1  1  {c |}  1  3  {c |}  1  3  {c |}  1  2  {c |}  1  1  {c |}  1  2}
{center:1  3  {c |}  1  1  {c |}  1  2  {c |}  1  3  {c |}  1  2  {c |}  1  1}
{center:2  4  {c |}  2  4  {c |}  2  4  {c |}  2  4  {c |}  2  4  {c |}  2  4}
{center:3  1  {c |}  3  1  {c |}  3  1  {c |}  3  1  {c |}  3  1  {c |}  3  1}

{pmore}
Without the {opt stable} option, the ordering of observations with equal
values of {it:varlist} is randomized.  With {cmd:sort x, stable}, you will
always get the first ordering and never the other five.

{pmore}
If your intent is to have the observations sorted first on {opt x} and then
on {opt b} within tied values of {opt x} (the fourth ordering above), you
should type {opt sort x b} rather than {opt sort x, stable}.

{pmore}
{opt stable} is seldom used, and, when specified, causes {opt sort} to
execute more slowly.


{marker examples}{...}
{title:Examples}

{phang2}{cmd:. webnwuse florentine}{p_end}
{phang2}{cmd:. nwsort wealth}


{title:See also}

	{help nwpermute}, {help sort}

