{smcl}
{* *! version  30nov2014}{...}
{phang}
{help nwcommands:NW-4 start}
{hline 2} Getting started

{title:Contents}	
			
{col 14}Section{col 31}Description
{col 14}{hline 46}
{help nw_intro##intro:{col 14}{bf:[NW-1.1]}{...}{col 31}{bf:Introduction}}

{help nw_start##gettingdata:{col 14}{bf:[NW-1.2]}{...}{col 31}{bf:Getting network data into Stata }}

{help nw_start##visualizing:{col 14}{bf:[NW-1.3]}{...}{col 31}{bf:Visualizing and animating networks}}

{help nw_start##simulation:{col 14}{bf:[NW-1.4]}{...}{col 31}{bf:Simulating networks}}

{help nw_start##manipulation:{col 14}{bf:[NW-1.5]}{...}{col 31}{bf:Handling and manipulating networks}}

{help nw_start##analysis:{col 14}{bf:[NW-1.6]}{...}{col 31}{bf:Analyzing networks}}


{marker intro}{...}
{title:Introduction}

{pstd}
A network G = (V,E) is a set of nodes {it:V} and relationships {it:E}. Relationships between nodes
are pairs (or dyads) of nodes {it:i} and {it:j}.

{pstd}
A simple way to think (and store) a network is the adjacency matrix. The adjaceny matrix {it:M} of a network has the dimensions {it:nodes x nodes}. The 
matrix cell {it:M_ij} = 0 when there is no tie between nodes {it:i} and {it:j}. In binary networks, {it:M_ij} = 1 when there is
a network relationship between nodes {it:i} and {it:j}. However, networks can also be valued, i.e. {it:M_ij} > 1. 

{pstd}
Networks exist as objects in Stata. Before one can work with a network in Stata it needs to be {help nwset:declared as a network}. This is very 
similar to how one declares data to be e.g. time-series data.

{pstd}
Once networks have been imported, generated or set, one can interact with
them by referring to their {help netname}, just as if one would interact with variables using their {help varname}. For example:

	{cmd:. webnwuse florentine}

{pstd}	
loads a network dataset on {help netexample##florentine:Florentine families} from the internet that includes two networks ({it:flobusiness, flomarriage}). After loading the data one can refer to these 
networks by their name (for a list of networks currently in memory see {help nwds} or {help nwset}):
	
	{cmd:. nwplot flomarriage}
	{cmd:. nwrecode flomarriage (1=2)}
	{cmd:. nwsummarize flomarriage}
	{cmd:. nwdegree flobusiness}

{pstd}
Networks have various meta-information, such as node labels (see
{help nwname}). Each network also has information about a set of Stata variables that should be created to represent the network as Stata
variables (see {help nwload}). The meta-information of a network can be examined and changed with {help nwname}.


{marker gettingdata}{...}
{title:Getting network data into Stata}

{pstd}
There are different ways to get network data into Stata.

{pmore}{help nwset:1. Declare data to be network data}

{pmore}{help webnwuse:2. Load network data from the internet}

{pmore}{help nwuse:3. Load network data one has saved before}

{pmore}{help nwfromedge:4. Import data from simple edgelist}

{pmore}{help nwimport:5. Import network data from other file formats}

{pstd}

{marker visualizing}{...}
{title:Visualizing and animating networks}

{pstd}
The nwcommands come with a very powerful {help nwplot:plotting engine for networks}. Once a network has been declared, loaded or imported one
can plot it directly with {help nwplot} by referring to its {help netname}. When plotting a network, all usual twoway-plot options 
are available. Furthermore, many aspects like 1) the size, color, shape of nodes, 2) the labels of nodes, 3) the color, width, pattern of network ties,
4) the look and feel of arrows, 5) the general layout of the network, and many other things can be changed. 

{pmore}
{cmd:. webnwuse florentine, nwclear}{p_end}
{pmore} 
{cmd:. nwplot flomarriage}

{pstd}
This plots the Florentine marriage network. The next example, plots the same network, but colors the edges according to 
the Florentine business network and displays node labels. 

{pmore}
{cmd:. nwplot flomarriage, edgecolor(flobusiness) lab}

{pstd}
Furthermore, the software also comes with three dedicated schemes for plotting networks: {it:s1network, s2network, s3network}. 
 
{pstd}
Besides normal network plots, the software can also {help nwmovie:animate networks and produce movies} out of a sequence of networks. The command
{help nwmovie} makes normal network plots, but also calculates the frames between differnet network panel observations. {cmd:nwmovie} is
a sophisticated program that requires the third-party software {bf:ImageMagick} to merge differnet network plots together and save the sequence
of network plots as an animated GIF file. This draws on the {help animate} command, which is a more general program written by the authors to 
make an animation out of different Stata .gph files.


{marker simulation}{...}
{title:Simulating networks}

{pstd}
There are several {help nw_topical##generator:network generators} that can be used to simulate networks. These network generators
create one (or more) new networks with certain attributes. Most network generators
allow the options {bf:name(), vars(), labs(), ntimes(), xvars}.

{center:{c TLC}{hline 14}{c TT}{hline 35}{c TRC}}
{center:{c |}   option     {c |}        Description                {c |}}
{center:{c LT}{hline 14}{c +}{hline 35}{c RT}}
{center:{c |} {bf:name()}       {c |} Name of the new network           {c |}}
{center:{c |} {bf:vars()}       {c |} Stata variables for this network  {c |}}
{center:{c |} {bf:labs()}       {c |} Node labels                       {c |}}
{center:{c |} {bf:ntimes()}     {c |} Number networks to simulate       {c |}}
{center:{c |} {bf:xvars}        {c |} Do not generate Stata variables   {c |}}
{center:{c BLC}{hline 14}{c BT}{hline 35}{c BRC}}

{pstd}
Probably, the simplest network generator is {help nwrandom}, which simulates random networks. It can be used either
with {opt prob()} or with {opt density()}. The first option generates a network where each tie has the same probability
to exist. The second option generates a random network with a pre-defined network density, where each tie has the same 
probability to exist as well.

{pmore}
{cmd:. nwrandom 50, prob(.1) name(mynet)}

{pstd}
This generates a new network called "mynet" with 50 nodes where each potential tie has the probability 0.1 to exist.

{pstd}
Other network generators exist to produce {help nwsmall:small-world networks}, {help nwpref:preferential attachment networks}, {help nwlattice:regular lattices},
or {help nwring:ring lattices}. Two more sophisticated network generators are: {help nwhomophily} and {help nwdyadprob}. The first one
generates {help nwhomophily:homophilious networks}, where ties are more or less likely to exist between nodes when they 
are similar/same/different on some other {help varname}. The second one is even more general and produces networks based on
tie probabilities for each potential tie, saved as a matrix or as another network. 
 
 
{marker manipulation}{...}
{title:Handling and manipulating networks}

{pstd}
Once a network has been declared, imported or generated, there are many different ways to
{help nw_topical##manipulation:manipulate networks}. Many of these features resemble what one is used from
normal Stata. One can {help nwaddnodes:add nodes to a network},
{help nwdropnodes:drop nodes from a network}, or {help nwkeepnodes:keep nodes of a network}. For example, this
load the Florentine data and drop two nodes:

{pmore}
{cmd:. webnwuse florentine, nwclear}{p_end}
{pmore} 
{cmd:. nwdropnodes flomarriage, nodes(medici pucci)}{p_end}

{pstd}
Furthermore, one can {help nwdrop:drop} or {help nwkeep:keep entire networks} as well, just like dropping or keeping
variables. In fact, all abbreviations one is used from Stata can be used as well. This drops all networks whose {help netname}
begins with "flom".

{pmore}
{cmd:. webnwuse florentine, nwclear}{p_end}
{pmore} 
{cmd:. nwdrop flom*}{p_end}

{pstd}
Networks have various meta-information, such as a {help netname}, whether or not they are directed, the labels of the nodes,
the Stata variables used to represent the adjacency matrix of the network. This
meta-information can be changed with {help nwrename} and {help nwname}.

{pstd}
With {help nwrecode} the tie values of a network can be recoded, just like when one recodes the values of a normal variable. The
command {help nwreplace} is very similar to {help replace}, but extremely powerful. It can be used, for example, to replace an entire
network with another network, replace certain ties of a network with another network, replace certain ties of a network with specific
tie values. One can also replace the underlying adjacency matrix of a network directly using {help nwreplacemat}.

{pstd}
A quick overview of all networks that are currently in memory can be obtained with {help nwds}, {help nwset} or {help nwsummarize:nwsummarize _all}.


{marker analysis}{...}
{title:Analyzing networks}

{pstd}
One can caluclate all sorts of network statistics with the nwcommands. There is a set of programs that calculate the centrality
of nodes in a network, e.g. {help nwdegree:degree centrality}, {help nwbetween:betweenness centrality}, {help nwevcent:eigenvector centrality},
{help nwcloseness:closeness centrality}, {help nwkatz:Katz centrality}. 

{pstd}
Another program calculates the {help nwclustering:clustering coefficient} for each node.

{pmore}
{cmd:. webnwuse florentine, nwclear}{p_end}
{pmore} 
{cmd:. nwbetween flomarriage, generate(bw)}{p_end}

{pstd}
This loads the Florentine data and calculates the betweenness centrality of each node in the marriage network and saves
coefficients in the new Stata variable {it:bw}.

{pstd}
There are some other commandsm such as {help nwutility}, that calculate node-level statistics. For example, {help nwcomponents}
calculates the number of components of the network and can also be used to generate a new variable that holds the membership of each node
to one of the components. 

{pstd}
{help nwcontext} is a clever program that can be used to get information about the attributes of network neighbors. For example, this loads
the Gang network and calculates for each node the number of network neighbors who have been to prison before:

{pmore}
{cmd:. webnwuse gang, nwclear}{p_end}
{pmore} 
{cmd:. nwcontext gang, attribute(Prison) generate(Prison_sum) stat(sum)}{p_end}

{pstd}
{help nwcorrelate} correlates two networks or, alternatively, one network and one variable with each other. The latter can
give a very quick overview about the ties that exist in the network between nodes with certain attributes (see also {help nwtabulate}). 

{pstd}
Some more sophisticated programs exist for the statistical modelling of networks: {help nwqap:MR-QAP regression} and {help nwergm:exponential random graph modeling}.

{pstd}
Another set of commands calculates {help nwpath:paths between network nodes} or the entire set of {help nwgeodesic:shortest paths between network nodes}.
