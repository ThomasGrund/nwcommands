{smcl}
{* *! version 1.0.6  16may2014 author: Thomas Grund}{...}
{cmd:help netlist}
{hline}

{marker description}{...}
{title:Description}

{pstd}
A {it:netlist} is a list of {help netname:network names}. It can also just hold the name of a single network. 
A {it:netlist} exclusively refers to existing networks. 

{pstd}
Examples include

{p 8 34 2}{cmd:mynet} {space 17} just one network{p_end}
{p 8 34 2}{cmd:mynet1 mynet2 mynet3} {space 2} three networks{p_end}
{p 8 34 2}{cmd:mynet*} {space 16} all networks starting with {cmd:mynet}{p_end}
{p 8 34 2}{cmd:*net} {space 18} all networks ending with {cmd:net}{p_end}
{p 8 34 2}{cmd:my*t} {space 18} all networks starting with {cmd:my} & ending
                with {cmd:t} with any number of other characters
                between{p_end}
{p 8 34 2}{cmd:_all} {space 18} all networks{p_end}


{pstd}
The {cmd:*} character indicates to match one or more characters. All
networks matching the pattern are returned.

{pstd}
Many commands understand the keyword {cmd:_all} to mean all networks.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. nwuse glasgow}{p_end}
{phang}{cmd:. nwset}

{pstd}These four commands are equivalent.{p_end}
{phang}{cmd:. nwinfo glasgow1 glasgow2 glasgow3}{p_end}
{phang}{cmd:. nwinfo glasg*}{p_end}
{phang}{cmd:. nwinfo _all}{p_end}

{title:See also}
   {help netname}
