{smcl}
{* *! version 1.2.3  11feb2011}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}
{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwclear {hline 2}} Clear all networks and variables from memory{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmd:nwclear}

{title:Remarks}

{phang2}This command is equivalent to:{p_end}
{phang2}{cmd:. nwdrop _all}{p_end}
{phang2}{cmd:. clear}{p_end}

{marker examples}{...}
{title:Examples}

{phang2}{cmd:. nwuse glasgow}{p_end}
{phang2}{cmd:. nwclear}{p_end}

{title:See also}
  {help nwdrop}, {help clear}
