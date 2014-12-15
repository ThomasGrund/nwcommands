{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 17 22 2}{...}
{p2col :nwrecode {hline 2} Recode network}
{p2colreset}{...}


{title:Syntax}

{p 8 16 2}
{cmd:nwrecode} [{it:{help netlist}}] {cmd:(}{it:rule}{cmd:)} 
[{cmd:(}{it:rule}{cmd:)} {it:...}]
[{cmd:,} {opt generate}({it:{help newnetname:newnetlist}}) {opt prefix}({it:str}) {opt test}]


{phang}
where the most common forms for {it:rule} are

{center:{c TLC}{hline 16}{c TT}{hline 13}{c TT}{hline 27}{c TRC}}
{center:{c |} {it:rule}           {c |} Example     {c |} Meaning                   {c |}}
{center:{c LT}{hline 16}{c +}{hline 13}{c +}{hline 27}{c RT}}
{center:{c |} {it:#} {cmd:=} {it:#}          {c |} 3 = 1       {c |} 3 recoded to 1            {c |}}
{center:{c |} {it:#} {it:#} {cmd:=} {it:#}        {c |} 2 . = 9     {c |} 2 and . recoded to 9      {c |}}
{center:{c |} {it:#}{cmd:/}{it:#} {cmd:=} {it:#}        {c |} 1/5 = 4     {c |} 1 through 5 recoded to 4  {c |}}
{center:{c |} {opt nonm:issing} {cmd:=} {it:#} {c |} nonmiss = 8 {c |} all other nonmissing to 8 {c |}}
{center:{c |} {opt mis:sing} {cmd:=} {it:#}    {c |} miss = 9    {c |} all other missings to 9   {c |}} 
{center:{c |} {opt else}  {cmd:=} {it:#}      {c |} else = 44   {c |} all other to 44           {c |}}
{center:{c BLC}{hline 16}{c BT}{hline 13}{c BT}{hline 27}{c BRC}}

{phang}
The keyword rules {cmd:missing}, {cmd:nonmissing}, and {cmd:else} must be the
last rules specified.  {cmd:else} may not be combined with {cmd:missing} or 
{cmd:nonmissing}.


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth generate(newnetlist)}}nwgenerate {it:{help newnetname:newnetlist}} containing transformed
networks; default is to replace existing networks{p_end}
{synopt :{opt prefix(str)}}generate new networks with {it:str} prefix{p_end}
{synopt :{opt t:est}}test that rules are invoked and do not overlap{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nwrecode} changes the dyad values of networks according to
the specified rules. It works almost exactly as {help recode}, but for networks. Dyad
values that do not meet any of the conditions of the
rules are left unchanged, unless an {it:otherwise} rule is specified.

{pstd}
{cmd:min} and {cmd:max} provide a convenient way to refer to the minimum and
maximum for each dyad value in {help netlist} and may be used in both the from-value
and the to-value parts of the specification.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opt generate}({it:{help newnetname:newnetlist}}) specifies the names of the network(s) that will contain
the transformed dyads.  {opt into()} is a synonym for {opt generate()}.

{pmore}
If generate() is not specified, the input networks are overwritten;
Overwriting networks is dangerous (you cannot undo changes, so we strongly recommend specifying nwgenerate().

{phang}
{opt prefix(str)} specifies that the recoded networks be returned in new
networks formed by prefixing the names of the original networks with
{it:str}.

{phang}
{opt test} specifies that Stata test whether rules are ever invoked or that
rules overlap; for example, {cmd:(1/5=1) (3=2)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webnwuse gang}{p_end}
{phang2}{cmd:. webnwuse glasgow}

{pstd}List the network adjacency matrix{p_end}
{phang2}{cmd:. nwsummarize gang, mat}

{pstd}For {it:gang}, change 1 to 5, leave all other values unchanged, and store
the results in {cmd:nx}{p_end}
{phang2}{cmd:. nwrecode gang (1 = 5), generate(nx)}

{pstd}List the network adjacency matrix{p_end}
{phang2}{cmd:. nwsummarize gang nx, mat}

{pstd}For {it:gang}, swap 1 and 2, and store the results in {cmd:nx1}{p_end}
{phang2}{cmd:. nwrecode gang (1 = 2) (2 = 1), generate(nx1)}

{pstd}List the network adjacency matrix{p_end}
{phang2}{cmd:. nwsummarize gang nx1, mat}

{pstd}For {it:gang}, collapse 1 and 2 into 1, change 3 through 4
to 2, and store the results in {cmd:nx2}{p_end}
{phang2}{cmd:. nwrecode gang (1 2 = 1) (3/4 = 2), generate(nx2)}

{pstd}List the network adjacency matrix{p_end}
{phang2}{cmd:. nwsummarize gang nx2, mat}

{pstd}For {it:glasgow1}, {it:glasgow2}, and {it:glasgow3}, change dyad values 1 to 99 and store the
    transformed networks in {it:new_glasgow1}, {it:new_glasgow2}, and {it:new_glasgow3}.
{p_end}
{phang2}{cmd:. nwrecode glasgow1-glasgow3 (1=99) ,}
           {cmd:pre(new) test}{p_end}

{pstd}List the network adjacency matrices{p_end}
{phang2}{cmd:. nwsummarize glasgow1-3 new_glasgow1-3, mat}


{title:See also}

	{help nwreplace}, {help recode}

