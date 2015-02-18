{smcl}
{* *! version 1.0.6  16may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##concept:[NW-2.1] Concepts}

{marker description}{...}
{title:Description}

{pstd}
A {it:newnetname} is the name of a network that does not exist yet. 
A {it:newnetname} is a new {it:{help netname}}, such as 

{p 8 34 2}{cmd:x}{p_end}
{p 8 34 2}{cmd:mynet}{p_end}
{p 8 34 2}{cmd:flobusiness}{p_end}
{p 8 34 2}{cmd:flomarriage}{p_end}
{p 8 34 2}{cmd:friendship}{p_end}
{p 8 34 2}{cmd:friendship_wave2}{p_end}
{p 8 34 2}{cmd:_advice}{p_end}
{p 8 34 2}{cmd:_1994}{p_end}


{marker examples}{...}
{title:Examples}

{phang}{cmd:. nwclear}{p_end}
{phang}{cmd:. nwrandom 10, prob(.2) name(mynet)}{p_end}


{title:See also}

   {help netname}
