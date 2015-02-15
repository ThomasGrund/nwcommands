{smcl}
{* *! version 1.0.1  3sept2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 19 22 2}{...}
{p2col :nwfromedge {hline 2} Imports network data from edgelist}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwfromedge} 
{it:{help varname: fromid}}
{it:{help varname: toid}}
[{it:{help varname:tievalue}}]
[{it:{help if}}]
[{cmd:,}
{opth name(newnetname)}
{opt xvars}
{opth vars(newvarlist)}
{opt labs}({it:lab1 lab2 ...})
{opt undirected}
{opt directed}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth name(newnetname)}}name of the new network; default = {it:network}{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}
{synopt:{opth vars(newvarlist)}}overwrite Stata variables{p_end}
{synopt:{opt labs}({it:lab1 lab2 ...})}overwrite node labels{p_end}
{synopt:{opt undirected}}force the network to be undirected{p_end}
{synopt:{opt directed}}force the network to be directed{p_end}

{p2colreset}{...}

{title:Description}

{pstd}
{cmd:nwfromedge} imports a network from a dataset in edgelist format. 

{marker edgelist}{...}
{pstd}
An edgelist or arclist is a set of two (or three in the case of a valued network) variables representing
relations. Nodes are identified by entries in the cells.  For example, the data

                 {c TLC}{hline 14}{c -}{c TRC}
                 {c |} {res} fromid  toid {txt}{c |}
                 {c LT}{hline 14}{c -}{c RT}
              1. {c |} {res} 1       2    {txt}{c |}
              2. {c |} {res} 2       3    {txt}{c |}
              3. {c |} {res} 4       2    {txt}{c |}
                 {c BLC}{hline 14}{c -}{c BRC}

{pstd}
stores information about three {it:ties} (1=>2), (2=>3) and (4=>2) among four unique network nodes. The
variables defining the edges can also be {help string} variables. 

                 {c TLC}{hline 25}{c -}{c TRC}
                 {c |} {res} fromid    toid     value{txt}{c |}
                 {c LT}{hline 25}{c -}{c RT}
              1. {c |} {res} Peter     Thomas   1    {txt}{c |}
              2. {c |} {res} Tim       Peter    3    {txt}{c |}
              3. {c |} {res} Mathilde  Thomas   2    {txt}{c |}
                 {c BLC}{hline 25}{c -}{c BRC}

{pstd}
Here, there are also three relationships: (Peter => Thomas), (Tim => Peter) and (Mathilde => Thomas).

{pstd}
The following command declares such data as network data:

	{cmd:. nwfromedge fromid toid value, name(mynet)}
					
{pstd}
This automatically generates the relevant meta-information for the network and makes it available for other programs under the {help netname} {it:mynet}. In case no {bf:name()}
is specified, the command tries to come up with a suitable name for the new network. By default, it tries {it:network}, however, when a network with this name already exists, it comes
up with an alternative name {it:network_1} and so on (see {help nwvalidate}).

{pstd}
After a network has been declared, one can refer to it by its {help netname}, just as if one would refer to a {help varname}. For example, this {help nwplot:makes a network plot} of {it:mynet}.

	{cmd:. nwplot mynet}

{pstd}
Or alternatively, this calculates the {help nwbetween:betweenness centrality} of the nodes in {it:mynet}.

	{cmd:. nwbetween mynet}			
			 
{pstd}
By default, {bf:nwfromedge} recognizes if a network is directed or undirected, i.e. for each 
dyad entry (i,j) there is also a dyad entry (j,i). However, this automatic detection
can be overwritten with the options {opt undirected} and {opt directed}.

{pstd}
One can also transfrom any network that exists in memory into such an edgelist with {help nwtoedge}.


{title:Examples}

{pstd}
This loads a network dataset from the internet and transforms the network {it:glasgow1} into an edgelist.

	{cmd:. webnwuse glasgow, nwclear}
	{cmd:. nwtoedge glasgow1}

{pstd}
Afterwards, it can be loaded as a network object again:

	{cmd:. nwfromedge _fromid _toid _link, name(mynet)}

	
	
{title:Also see}
	
	{help nwtoedge}, {help nwuse}, {help nwsave}, {help webnwuse}, {help nwset}, {help nwimport}
