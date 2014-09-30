{smcl}
{* *! version 1.0.1  17sept2014 author: Thomas Grund}{...}
{cmd:help nwpath}
{hline}

{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwpath {hline 2}}Calculate paths between node {it:ego} and node {it:alter}{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwpath} 
[{it:{help netname}}],
{opt ego}({help nodeid})
{opt alter}({help nodeid})
[{opt length}(integer)
{opt sym}
{opt generate}({help newnetname})]

{p 8 17 2}
{cmdab: nwpath} 
[{it:{help netname}}],
{opt ego}({help nodelab})
{opt alter}({help nodelab})
[{opt length}(integer)
{opt sym}
{opt generate}({help newnetname})]


{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt ego}({help nodeid})}nodeid of network node {it:ego}{p_end}
{synopt:{opt alter}({help nodeid})}nodeid of network node {it:alter}{p_end}
{synopt:{opt length}(integer)}force length of paths{p_end}
{synopt:{opt sym}}calculate paths on symmetrized network{p_end}
{synopt:{opt generate}({help newnetname})}save paths as networks{p_end}
{synoptline}
{p2colreset}{...}

		
{title:Description}

{pstd}
{cmd: nwpath} calculates paths between node {it:ego} and node {it:alter}. By default, all
shortest paths between the two nodes are returned. When option {opt length} is specified, only
paths of the specified length are returned. Results are also stored in the 
return vector.


{title:Options}

{phang}
{opt ego}({help nodeid}) Must be specified and indicates the startpoint of a path.
{p_end}

{phang}
{opt alter}({help nodeid}) Must be specified and indicates the endpoint of a path.
{p_end}

{phang}
{opt length}(integer) Defines the length of paths that should be returned. For example, 
with {opt length(4)} only paths of length 4 are returned.
{p_end}

{phang}
{opt sym}(integer) Calculates everything on the symmetrized network.{p_end}

{phang}
{opt generate}({help newnetname}) Save the paths as networks. This can be used to display 
paths using nwplot, see example.{p_end}

{title:Remarks}

{pstd}
Paths are stored in matrix {it:r(paths_matrix)}, where each row represents one path from
node {it:ego} to node {it:alter}. Entries refer to {it:nodeid's}. 
{p_end}

{pstd}
It can be a good idea to save the paths by specifying {opt generate}({help newnetname}) for plotting.
For example, 

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwpath flobusiness, ego(9) alter(11) generate(shortest)}

{pstd}	
There are two shortest paths from node 9 to node 11, hence, the networks {it:shortest_1} and {it:shortest_2} are generated.
One can now use one of these new networks to represent the edgecolor when plotting the original network. 
	
	{cmd:. nwplot flobusiness, edgecolor(shortest_1) scheme(s2network)}


{title:Examples}

{txt}Instead of using {help nodeid:nodeids} one can also use {help nodelab:nodelabs} to identify nodes.

     {cmd:. webnwuse florentine}
     {cmd:. nwpath flobusiness, ego(medici) alter(albizzi)}
     {res}
     {hline 40}
     {txt}  Network: {res}flobusiness
     {hline 40}
     {txt}    Ego                  : {res}9 (medici)
     {txt}    Alter                : {res}11 (peruzzi)
     {txt}    Shortest path length : {res}3
     {txt}    Selected length      : {res}3
     {hline 40}

     {txt}  Path 1:  {res}medici{txt} => {res}barbadori{txt} => {res}castellani{txt} => {res}peruzzi
     {txt}  Path 2:  {res}medici{txt} => {res}ridolfi{txt} => {res}strozzi{txt} => {res}peruzzi
	
	

{title:Also see}

   {help nwcontext}, {help nwname}, {help nwinfo}
