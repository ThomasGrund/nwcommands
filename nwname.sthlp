{smcl}
{* *! version 1.0.4  23aug2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##information:[NW-2.4] Information}
{marker top2}
{helpb nw_topical##manipulation:[NW-2.5] Manipulation}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwname {hline 2} Check name and change meta-information of a network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwname} 
[{it:{help netname}}]
[,{opth id(int)}
{opth newname(newnetname)}
{opt newdirected(boolean)}
{opt newvars}({it:{help varname:var1 var2...})}
{opt newlabs}({it:lab1 lab2...})
{opth newlabsfromvar(varname)}
]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth id(int)}}network ID{p_end}
{synopt:{opt newname}({help newnetname})}new name of the network{p_end}
{synopt:{opt newdirected}(boolean)}force change: directed = {it:true}, not directed = {it:false}{p_end}
{synopt:{opt newvars}({it:{help varname:var1 var2...}})}new variables to represent network in Stata{p_end}
{synopt:{opt newlabs}({it:lab1 lab2...})}new node labels{p_end}
{synopt:{opth newlabsfromvar(varname)}}new node labels (saved in Stata variable){p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
{cmd:nwname} checks if a network exists and throws an error when it does not. 

{pstd}
The command also stores various meta-information in the return vector (see below). 

{pstd}
It can also be used to overwrite the meta-information of a network. When {bf:newvars()} or
{bf:newlabs()} are specified, there need to be as many arguments as there are {it:nodes}
in the network.

 
{title:Examples}

{pstd}
This loads the Florentine data and returns various information about the {it:flobusiness} network.
	
	{cmd:. webnwuse florentine}
	{cmd:. nwname flobusiness}
	{cmd:. return list}

{pstd}
This changes the name of the network {it:flobusiness} into {it:flob}. This could also be achieved with {help nwrename}.
	
	{cmd:. nwname flobusiness, newname(flob)}
	{cmd:. return list}  
  
{pstd}
This assigns new node labels to a network. In this case, it assigns the values of the existing variable {it:lab}.
	
	{cmd:. gen lab = _n}  
	{cmd:. nwname flobusiness, newlabsfromvar(lab)}

{pstd}
Here, node labels are assigned directly. 

	{cmd:. nwclear}
	{cmd:. nwrandom 5, prob(.3)}  
	{cmd:. nwname random, newlabs(Mathilde Susan Lindsey Claudia Francesca)}
	{cmd:. nwset, detail}
	
	{res}{txt}(1 network)
	{hline 50}
	{txt} 1) Current Network
	{hline 50}
	{txt}   Network name: {res}random
	{txt}   Directed: {res}true
	{txt}   Nodes: {res}5
	{txt}   Network id: {res}1
	{txt}   Variables: {res}net1 net2 net3 net4 net5
	{txt}   Labels: {res}Mathilde Susan Lindsey Claudia Francesca{txt}

  
 {title:Stored results}
 
	Scalars:
	  {bf:r(id)}	ID of the network
	  {bf:r(nodes)}	number of nodes
	  
	Macros:
	  {bf:r(name)}		name of the network
	  {bf:r(directed)}	ties directed
	  {bf:r(vars)}		Stata variables used to represent the network	  
	  {bf:r(labs)}		node labels
	  
 {title:See also}
 
	{help nwsummarize}, {help nwvalidate}, {help nwset}, {help nwload}
