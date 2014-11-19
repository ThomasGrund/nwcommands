{smcl}
{* *! version 1.0.0  11nov2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwpref}
{hline}

{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwpref {hline 2}}Generates a preferential-attachment network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwpref} 
{it: nodes}
[{cmd:,}
{opt m0(integer)} 
{opt m(integer)} 
{opt prob(float)} 
{opt undirected}
{opt name}({it:{help newnetname}})
{opt vars}({it:{help newvarlist}})
{opt xvars}
{opt ntimes(integer)}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{it:nodes}}number of nodes{p_end}
{synopt:{opt m0}({it:integer})}number of connected nodes at start; default = 2{p_end}
{synopt:{opt m}({it:integer})}number of connections each new node forms; default = 2{p_end}
{synopt:{opt prob}({it:float})}probability that new node connects to existing nodes uniformly at random; default = 0{p_end}
{synopt:{opt undirected}}generate an undirected network; default = directed{p_end}
{synopt:{opt name}({it:{help newnetname}})}name of the new network{p_end}
{synopt:{opt vars}({it:{help newvarlist}})}new variables that are used for the network{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}
{synopt:{opt ntimes}({it:integer})}number of small-world networks to be generated; default = 1{p_end}

{title:Description}

{pstd}
{cmd:nwpref} generates a preferential-attachment network using the Barabasi-Albert (1999) model. The network 
begins with an initial connected network of {it:m_0} nodes. One new node is added 
to the network at each time {it:t}. The preferential attachment process is stated as follows:

{pstd}
With a probability {it:0 <= prob <= 1}, this new node connects to {it:m <= m_0} nodes
uniformly at random.

{pstd} 
With a probability {it:1 - prob}, this new node connects to {it:m} existing nodes with a 
probability proportonal to the (in-)degree of the node it will be connected to.


{pstd}
Barabasi, A-L.; Albert, R. (1999) "Emergence of scaling in random networks". Science 286 (54439): 509-512. 

{title:Examples}
	
	{cmd:. nwclear}
	{cmd:. nwpref 20, undirected}
	{cmd:. nwplot, layout(circle)}
	
	{cmd:. nwpref 20, prob(1) undirected}
	{cmd:. nwplot, layout(circle)}
	
{title:See also}

	{help nwsmall}, {help nwrandom}, {help nwlattice}, {help nwring}
