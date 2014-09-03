{smcl}
{* *! version 1.0.6  23aug2014 author: Thomas Grund}{...}
{cmd:help nwvalidate}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwvalidate {hline 2}}Checks if a network already exists and proposes an alternative unique name {p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmdab: nwvalidate} 
{it:{help netname}}

{synoptline}
{p2colreset}{...}
	
{title:Description}

{pstd}
Checks if a network with a certain {it:{help netname}} already exists and returns this information
in the return vector {it:r(exists)}. If yes, it also returns an alternative valid name in {it:r(validname)},
i.e. a network name that has not been used so far. This command is mostly used for progamming.

{title:Examples}

  {cmd:. nwclear}
  {cmd:. nwuse florentine}
  {cmd:. nwvalidate flobusiness}
  {cmd:. return list}

  
{title:Also see}
   {help nwvalidvars}
