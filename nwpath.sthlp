{smcl}
{* *! version 1.0.1  17sept2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{marker top2}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwpath {hline 2} Calculate paths between nodes}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwpath} 
[{it:{help netname}}],
{opth ego(nodeid)}
{opth alter(nodeid)}
[{opth length(int)}
{opt sym}
{opth generate(newnetname)}]

{p 8 17 2}
{cmdab: nwpath} 
[{it:{help netname}}],
{opt ego}({it:{help nodeid:nodelab}})
{opt alter}({it:{help nodeid:nodelab}})
[{opth length(int)}
{opt sym}
{opth generate(newnetname)}]



{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth ego(nodeid)}}nodeid of network node {it:ego}{p_end}
{synopt:{opth alter(nodeid)}}nodeid of network node {it:alter}{p_end}
{synopt:{opt ego}({it:{help nodeid:nodelab}})}nodelab of network node {it:ego}{p_end}
{synopt:{opt alter}({it:{help nodeid:nodelab}})}nodelab of network node {it:alter}{p_end}
{synopt:{opth length(int)}}force length of paths{p_end}
{synopt:{opt sym}}calculate paths on symmetrized network{p_end}
{synopt:{opth generate(newnetname)}}save paths as networks{p_end}
{synoptline}
{p2colreset}{...}

		
{title:Description}

{pstd}
{cmd: nwpath} calculates paths between node {it:ego} and node {it:alter}, i.e. ways how the nodes
are connected with each other. By default, the shortest paths between the two nodes are returned. 
When option {opt length()} is specified, only paths of the specified length are returned.

{pstd}
With option {opth generate(newnetname)} the command produces one new network for each valid path that is found. 
For example, if three paths are found between nodes {it:ego} and {it:alter}, the networks {it:newnetname_1, newnetname_2, newnetname_2}
are produced.


{title:Options}

{p2col 5 30 30 30:{opth ego(nodeid)}}Must be specified and indicates the startpoint of a path.

{p2col 5 30 30 30:{opth alter(nodeid)}}Must be specified and indicates the endpoint of a path.

{p2col 5 30 30 30:{opth length(int)}}Defines the length of paths that should be returned. For example, 
with {bf:length(4)} only paths of length 4 are returned.{p_end}

{p2col 5 30 30 30:{opt sym}}Calculates everything on the symmetrized network.{p_end}

{p2col 5 30 30 30:{opth generate(newnetname)}}Save the paths as networks. This can be used to display 
paths using nwplot, see example.{p_end}


{title:Remarks}

{pstd}
It can be a good idea to save the paths by specifying {opth generate(newnetname)} for plotting.
For example, 

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwpath flobusiness, ego(9) alter(11) generate(shortest)}

{pstd}	
There are two shortest paths from node 9 to node 11, hence, the networks {it:shortest_1} and {it:shortest_2} are generated.
One can now use one of these new networks to represent the edgecolor when plotting the original network. 
	
	{cmd:. nwplot flobusiness, edgecolor(shortest_1) scheme(s2network)}


{title:Examples}

{pstd}
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
     {txt}  Path 2:  {res}medici{txt} => {res}ridolfi{txt} => {res}strozzi{txt} => {res}peruzzi{txt}
	

{title:Stores results}

	Scalars:
	  {bf:r(paths)}		 number of paths found
	  {bf:r(path_length)}	 length of path specified in {bf:length()}
	  {bf:r(path_shortest)}	 length of shortest path between nodes
	  {bf:r(ego)}		 nodeid of ego
	  {bf:r(alter)}		 nodeid of alter
	  
	Matrices:
	  {bf:r(paths_matrix)}	matrix with all paths


{title:Also see}

   {help nwgeodesic}
