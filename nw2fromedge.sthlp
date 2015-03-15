{smcl}
{* *! version 1.0.1  3sept2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 19 22 2}{...}
{p2col :nw2fromedge {hline 2} Import two-mode network data from edgelist}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nw2fromedge} 
{it:{help varname:level1}}
{it:{help varname:level2}}
[{it:{help varname:tievalue}}]
[{it:{help if}}]
[{cmd:,}
{opth generate(newvarname)}
{opt project}({it:{help nw2fromedge##project_level:project_level}})
{opt stat}({it:{help nw2fromedge##project_stat:project_stat}})
{it:{help nwfromedge:nwfromedge_options}}
]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth generate(newvarname)}}name of variable identifying two-mode membership; default = {it:_modeid}{p_end}
{synopt:{opt project}({it:{help nw2fromedge##project_level:project_level}})}make one-mode projection to either level {bf:1} or level {bf:2} {p_end}
{synopt:{opt stat}({it:{help nw2fromedge##project_stat:project_stat}})}logic for dealing with tie values in one-mode projection{p_end}


{p2colreset}{...}

{title:Description}

{pstd}
{cmd:nw2fromedge} imports a two-mode network from a dataset in edgelist format. It is very similar to {help nwfromedge}. 

{pstd} 
A two-mode network consists of two sets of units (e. g. people and events) and relations connect the two sets, e. g. participation
of people in social events. Some examples are: 

{pmore}
- Membership in institutions - people, institutions, is a member, e.g. directors and commissioners on the boards of corporations.

{pmore}
- Voting for suggestions - polititians, suggestions, votes for.

{pmore}
- Citation network, where first set consists of authors,
the second set consists of articles/papers,
connection is a relation author cites a paper.

{pmore}
- Co-autorship networks - authors, papers, is a (co)author.
A corresponding graph is called bipartite graph Ð lines
connect only vertices from one to vertices from another set Ð
inside sets there are no connections.


{marker edgelist}{...}
{pstd}
An edgelist is a set of two (or three in the case of a valued network) variables representing
relations. Nodes are identified by entries in the cells.  For example, the data

	{com}. use "http://nwcommands.org/data/institutions.dta", clear
	{com}. list _all
	{txt}
		{c TLC}{hline 10}{c -}{hline 11}{c -}{hline 7}{c TRC}
		{c |} {res}  person   institu~n   years {txt}{c |}
		{c LT}{hline 10}{c -}{hline 11}{c -}{hline 7}{c RT}
	     1. {c |} {res}  Thomas      Oxford       5 {txt}{c |}
	     2. {c |} {res}   Peter      Oxford       7 {txt}{c |}
	     3. {c |} {res}     Tim      Oxford       4 {txt}{c |}
	     4. {c |} {res}   Peter         LiU       1 {txt}{c |}
	     5. {c |} {res}     Tim         LiU       1 {txt}{c |}
		{c LT}{hline 10}{c -}{hline 11}{c -}{hline 7}{c RT}
	     6. {c |} {res}  Thomas         LiU       1 {txt}{c |}
	     7. {c |} {res}Mathilde        UdeM       5 {txt}{c |}
	     8. {c |} {res}  Thomas        UdeM       1 {txt}{c |}
	     9. {c |} {res} Michael         ETH       3 {txt}{c |}
	    10. {c |} {res} Michael   Groningen       5 {txt}{c |}
		{c LT}{hline 10}{c -}{hline 11}{c -}{hline 7}{c RT}
	    11. {c |} {res}  Thomas         ETH       1 {txt}{c |}
		{c BLC}{hline 10}{c -}{hline 11}{c -}{hline 7}{c BRC}

{pstd}
stores information about the affiliation of individual researchers.  

{pstd}
The following command declares such data as two-mode network data:

	{cmd:. nw2fromedge person institution, name(mynet)}
					
{pstd}
Essentially, this does exactly the same as {help nwfromedge}, but also generates a variable {it:_modeid}, which has the value 1 for persons (Peter, Tim,
Thomas, Michael, Mathilde) and value 2 for institutions (LiU, UdeM, Oxford, ETH, Groningen).

{pstd}
For example, one can plot this two-mode network and color the two levels differently:

	{cmd:. nwplot mynet, color(_modeid)}

{marker project_stat}{...}
{marker project_level}{...}
{title:One-mode projection}

{pstd}
Sometimes one wants to collapse a two-mode network to a one-mode network. This is called a one-mode projection. Such a projection is a simplification of the network to nodes
of one level only. For example, in our example one can either collapse to the level of persons or to the level of institutions. The level to which one wants to collapse is
specified in option {bf:project()}. 

{pstd}
For example, this loads the data above as a one-mode projection on level 1 (persons):

	{cmd: nw2fromedge person institution, project(1)}

{pstd}
It generates a network with five unique actors (Peter, Tim, Thomas, Michael and Mathilde). By default, a one-mode projection on one level generates ties between nodes (on this level) when they have at least one network neighbor on the other level in common. In our case, 
projecting to the level of persons creates ties between persons when they share at least one institution. 

{pstd}
When ties are valued there are several ways how the value of projected ties is generated. Option {opt stat()} can
be one of the following: {bf:min, max, minmax, sum, mean}. To illustrate what each one of them calculates tie values for
the projection, let us consider the relationship between Peter and Thomas. They share two institutions: Oxford and LiU.

{pmore}
Thomas - LiU    - 1 year
Peter  - LiU    - 1 year
Thomas - Oxford - 5 years
Peter  - Oxford - 7 years

{pstd}
The option {bf:stat(min)} takes the overall minimum from all these ties and generates the projection:

{pmore}
Peter - Thomas  - 1 year

{pstd}
The option {bf:stat(max)} takes the overall maximum from all these ties and generates the projection:

{pmore}
Peter - Thomas  - 7 years

{pstd}
The option {bf:stat(sum)} takes the sum over all these ties and generates the projection:

{pmore}
Peter - Thomas  - 14 years

{pstd}
The option {bf:stat(mean)} takes the sum over all these ties and generates the projection:

{pmore}
Peter - Thomas  - 3.5 years

{pstd}
The option {bf:stat(minmax)} takes for each institution Peter and Thomas share the minimum (Oxford = 5, LiU = 1) and 
and takes the maximum out of these scores as tie value. Substantially, this corresponds to the 
longest time that Peter and Thomas were at the same institution. This is the default option. 

{pmore}
Peter - Thomas  - 5 years
 

{pstd}	
In contrast, the next command generates a one-mode projection on level 2 (institutions). 
	
	{cmd: nw2fromedge person institution, project(2)}	

{pstd}
This projection
has only two nodes (LiU and UdeM). And there is exactly one undirected tie in this network (because Thomas went to both UdeM and LiU).
	
	LiU 	<=> 	UdeM	

	
{title:Also see}
	
	{help nwfromedge}
