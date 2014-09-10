{smcl}
{* *! version 1.0.6  6sept2014 author: Thomas Grund}{...}
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
{p 8 34 2}{cmd:my~net} {space 16} one network starting with {cmd:my} &
                ending with {cmd:net} with any number of other characters
                between{p_end}
{p 8 34 2}{cmd:my?var} {space 16} networks starting with {cmd:my} & endin
> g with
                {cmd:net} with one other character between{p_end}
{p 8 34 2}{cmd:mynet1-mynet6} {space 9} {cmd:mynet1}, {cmd:mynet2}, ...,
                {cmd:net6} (probably){p_end}
{p 8 34 2}{cmd:this-that} {space 13} networks {cmd:this} through {cmd:tha
> t},
                inclusive{p_end}
{p 8 34 2}{cmd:_all} {space 18} all networks{p_end}


{pstd}
The {cmd:*} character indicates to match one or more characters.  All
networks matching the pattern are returned.

{pstd}
The {cmd:~} character also indicates to match one or more characters, but
unlike {cmd:*}, only one network is allowed to match.  If more than one
network matches, an error message is presented.

{pstd}
The {cmd:?} character matches one character.  All networks matching
the pattern are returned.

{pstd}
The {cmd:-} character indicates that all networks in the dataset, startin
> g
with the network to the left of the {cmd:-} and ending with the network 
> to
the right of the {cmd:-} are to be returned.


{pstd}
Many commands understand the keyword {cmd:_all} to mean all networks.
Some commands default to using all networks if none are specified.



{marker examples}{...}
{title:Examples}

{phang}{cmd:. nwuse glasgow}{p_end}
{phang}{cmd:. nwset}

{pstd}These four commands are equivalent.{p_end}
{phang}{cmd:. nwinfo glasgow1 glasgow2 glasgow3}{p_end}
{phang}{cmd:. nwinfo glasgow1-glasgow3}{p_end}
{phang}{cmd:. nwinfo glasg*}{p_end}
{phang}{cmd:. nwinfo _all}{p_end}

{title:See also}
   {help netname}
