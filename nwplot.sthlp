{smcl}
{* *! version 2.0.0  2april2014}{...}
{marker topic}
{helpb nw_topical##visualization:[NW-2.8] Visualization}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwplot {hline 2} Plot a network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwplot}
[{it:{help netname}}] 
[{it:{help if}}]
[{cmd:,} {it:{help nwplot##node_options:node_options}}
{it:{help nwplot##label_options:label_options}}
{it:{help nwplot##edge_options:edge_options}}
{it:{help nwplot##arrow_options:arrow_options}}
{it:{help nwplot##layout_options:layout_options}}
{it:{help nwplot##other_options:other_options}}
{it:{help twoway_options}}]
	
{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{it:{help nwplot##node_options:node_options}}}change look of
       nodes (color, size, symbol, etc.){p_end}
{p2col:{it:{help nwplot##label_options:label_options}}}display and change look of
       node labels{p_end}
{p2col:{it:{help nwplot##edge_options:edge_options}}}change look of 
       edges (color, size, pattern, etc.){p_end}
{p2col:{it:{help nwplot##arrow_options:arrow_options}}}change look of
       arrows{p_end}
{p2col:{it:{help nwplot##layout_options:layout_options}}}change the layout,
	use existing coordinates, export coordinates{p_end}
{p2col:{it:{help nwplot##other_options:other_options}}}other network plot options
		{p_end}
{p2col:{it:{help twoway_options}}}normal twoway options for the whole plot
		{p_end}
	

{synoptset 35 tabbed}{...}
{p2col:{it:node_options}}Description{p_end}
{marker node_options}{...}
{p2line}
{synopt:{opt size}({it:{help varname}} [,{it:{help nwplot##node_sub:node_sub}}])}size of the nodes{p_end}
{p2col:{opt color}([{it:{help varname}}] [,{it:{help nwplot##node_sub:node_sub}}])}color of the nodes{p_end}
{p2col:{opt symbol}([{it:{help varname}}] [,{it:{help nwplot##node_sub:node_sub}}])}symbol of the nodes{p_end}
{p2col:{opth nodefactor(float)}}multiply all node sizes by a factor{p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:node_sub}}Description{p_end}
{marker node_sub}{...}
{p2line}
{p2col:{opt norescale}}no automatic rescale{p_end}
{p2col:{opt legendoff}}no legend for this attribute{p_end}
{p2col:{opt forcekeys}({it:{help int}}...)}list of keys to be used in the legend{p_end}
{p2col:{opt colorpalette}({it:{help colorstyle}}...)}list with colorstyles; change colorpalette{p_end}
{p2col:{opt symbolpalette}({it:{help symbolstyle}}...)}list with symbolstyles; change symbolpalette{p_end}
{p2col:{opth sizebin(int)}}finetune size of nodes{p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:label_options}}Description{p_end}
{marker label_options}{...}
{p2line}
{p2col:{opt lab}}display node labels saved with network{p_end}
{p2col:{opth label(varname)}}display node labels from variable{p_end}
{synopt:{opt labelopt}({it:{help scatter##marker_label_options:marker_label_options}})}options for look of node labels (e.g. size, color){p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:edge_options}}Description{p_end}
{marker edge_options}{...}
{p2line}
{p2col:{opt edgesize}({it:{help netname}} [,{it:{help nwplot##edge_sub:edge_sub}}])}use edge values of other network to change width of edges; network needs to have the right dimensions{p_end}
{p2col:{opt edgecolor}({it:{help netname}} [,{it:{help nwplot##edge_sub:edge_sub}}])}use edge values of other network to change color of edges; network needs to have the right dimensions{p_end}
{p2col:{opth edgefactor(float)}}multiply all edge sizes by a factor{p_end} 


{synoptset 35 tabbed}{...}
{p2col:{it:edgesub_sub}}Description{p_end}
{marker edge_sub}{...}
{p2line}
{p2col:{opt legendoff}}no legend for this attribute{p_end}
{p2col:{opt forcekeys}({it:{help int}}...)}list of keys to be used in the legend{p_end}
{p2col:{opt edgecolorpalette}({it:{help colorstyle}}...)}list with colorstyles; change edgecolorpalette{p_end}
{p2col:{opt edgepatternpalette}({it:{help linepatternstyle:pattern}}...)}list with linestyles; the same network as in edgecolor is used to display different line patterns{p_end}

	
{synoptset 35 tabbed}{...}
{p2col:{it:arrow_options}}Description{p_end}
{marker arrow_options}{...}
{p2line}
{p2col:{opt arcstyle}({it:{help nwplot##arcstyle:arcstyle}})}change the look of arcs (curved, straight){p_end}
{p2col:{opth arcbend(float)}}control the degree of bend for curved arcs; default = 2{p_end}
{p2col:{opth arcsplines(int)}}resolution for curved arcs{p_end}
{p2col:{opth arrowfactor(float)}}multiply arrowhead by a factor{p_end}
{p2col:{opth arrowgap(float)}}control gap between arrowhead and node{p_end}
{p2col:{opth arrowbarbfactor(float)}}control look of arrow{p_end}


{synoptset 35 tabbed}{...}
{marker arcstyle}{...}
{p2col:{it:arcstyle}}{p_end}
{p2line}
{p2col:{cmd: automatic}}plots arcs as curved lines, but only when they are not reciprocated; default
		{p_end}
{p2col:{cmd: curved}}plots all arcs as curved lines
		{p_end}
{p2col:{cmd: straight}}plots all arcs as straight lines
		{p_end}

		
{synoptset 35 tabbed}{...}
{p2col:{it:layout_options}}Description{p_end}
{marker layout_options}{...}
{p2line}
{p2col:{cmd: layout}([{it:{help nwplot##layoutstyle:layoutstyle}}] [,{it:{help nwplot##layout_sub:layout_sub}}])}change the overall layout/arrangement of nodes{p_end}
{p2col:{opt nodexy}({it:{help varname:xvar} {help varname:yvar}})}use variables to force coordinates of nodes{p_end}
{p2col:{opt generate}({it:{help newvarname:newxvar} {help newvarname:newyvar}})}export coordinates of nodes{p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:layout_sub}}Description{p_end}
{marker layout_sub}{...}
{p2line}
{p2col:{opt lgc}}only plot largest component{p_end}
{p2col:{opth iterations(int)}}only relevant for layout = mds; maximum number of iterations in the multidimensional scaling procedure, default = 1000{p_end}
{p2col:{opth columns(int)}}only relevant for layout = grid; number of columns to be plotted in grid layout {p_end}
{p2col:{opt norescale}}only relevant for layout = nodexy; do not rescale coordinates{p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:other_options}}Description{p_end}
{marker other_options}{...}
{p2line}
{p2col:{opth aspectratio(float)}}height/width ratio{p_end}
{p2col:{opt lineopt}({it:{help line:options}})}send options directly to all line plots used to display arcs{p_end}
{p2col:{opt scatteropt}({it:{help scatter:options}})}send options directly to all scatter plots used to display nodes {p_end}
{p2col:{opt legendopt}({it:{help legend_options:options}})}send options directly to the legend{p_end} 


{synoptset 35 tabbed}{...}
{marker layoutstyle}{...}
{p2col:{it:layoutstyle}}{p_end}
{p2line}
{p2col:{cmd: mds}}modern multidimensional scaling; default when nodes < 50{p_end}
{p2col:{cmd: mdsclassical}}classical multidimensional scaling; default when nodes > 50{p_end}
{p2col:{cmd: circle}}circle layout
		{p_end}
{p2col:{cmd: grid}}grid layout
		{p_end}
{p2col:{cmd: nodexy}}use coordinates given in {opt nodexy()}; only needed to send options.
		{p_end}
{p2col:{cmd: _layoutfunction}}advanced user-written layout function (see {help nwplot##layoutfunction:here}).
		{p_end}
		
		
{title:Description}

{pstd}
This command plots a network. It gives a lot of flexibility to control all elements in a network plot. Furthermore, it 
is compatible with {bf:schemes()} and accepts all {help twoway_options}.

{pstd}
This example generates a random network and plots it. Because no {help netname} is given, the command refers to the
{help nwcurrent:current network}.

	{cmd:. nwclear}
	{cmd:. nwrandom 20, prob(.2)}
	{cmd:. nwplot}

{pstd}
One can change the layout where nodes should be plotted:
	
	{cmd:. nwplot, layout(mds)}
	{cmd:. nwplot, layout(circle)}
	{cmd:. nwplot, layout(grid)}
	{cmd:. nwplot, layout(grid, columns(20))}

{pstd}
Or obtain coordinates from layout and plot with coordinates. The option {bf:nodexy} can be used to write your
own network layout functions, return coordinates and plot a network with these coordinates.

	{cmd:. nwplot, gen(xcoord ycoord)}
	{cmd:. replace xcoord = .2 if _n < 5}
	{cmd:. nwplot, nodexy(xcoord ycoord)}

{pstd}
Arrow heads are plotted when a network is directed. Furthermore, the command notices if a dyad is mutually or 
asymmetrically connected (see {help nwdyads}). By default, asymmetrically connected dyads are represented as a straight line, whereas
mutually connecetd dyads are represented as two curved lines. However, one can overwrite this and show all ties as 
curved lines.

	{cmd:. nwplot, arcstyle(automatic)}
	{cmd:. nwplot, arcstyle(straight)}
	{cmd:. nwplot, arcstyle(curved)}
	{cmd:. nwplot, arcbend(0.3) arcsplines(20)} 

{pstd}
Almost all elements in a network plot can be easily made bigger or smaller using factors:

	{cmd:. nwplot, nodefactor(2)}
	{cmd:. nwplot, edgefactor(2)} 
	{cmd:. nwplot, arrowfactor(4)}
	{cmd:. nwplot, arrowbarbfactor(.2)}
{phang2}	
	{cmd:. nwplot, nodefactor(2) edgefactor(4) arrowfactor(2) arrowbarbfactor(.2)}{p_end}

{pstd}
Colors, symbols and size of nodes can be changed accoring to a {help varname}. Furthermore, the palettes used for display
can be changed as well. 

	{cmd:. webnwuse glasgow, nwclear}
	{cmd:. nwplot glasgow1, color(smoke1)}
	{cmd:. nwplot, color(smoke1, colorpalette(red yellow cyan))}
 
	{cmd:. nwplot glasgow1, symbol(sport1)}
	{cmd:. nwplot glasgow1, symbol(sport1, symbolpalette(T S))}

	{cmd:. nwplot glasgow1, size(alcohol1)}
	{cmd:. nwplot, size(alcohol1, forcekeys1(1 5 10 20))}
 
	{cmd:. nwplot glasgow1, size(alcohol1) color(smoke1) symbol(sport1)}

{pstd}
The nwcommand come with two new schemes: s1network and s2network.

	{cmd:. nwplot, scheme(s1network)}
	{cmd:. nwplot, scheme(s2network)} 
	{cmd:. nwplot, scheme(s2mono)}
{phang2}
	{cmd:. nwplot, size(alcohol3) color(smoke3) symbol(sport3) scheme(s1network)}{p_end}
{phang2}	
	{cmd:. nwplot, size(alcohol3) color(smoke3) symbol(sport3) scheme(economist)}{p_end}
	{cmd:. set scheme s2network}

{pstd}
This example calculates the shortest path between two nodes (medici and peruzzi) and uses this path
to color the edges of the original network and change the size of the edges on this path. 

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwpath flomarriage, ego(medici) alter(peruzzi) generate(sp)}
{phang2}	
	{cmd:. nwplot flomarriage, label(_nodelab) edgecolor(sp_1, legendoff) edgesize(sp_1, legendoff) edgefactor(5)}
	
{pstd}
Another example that changes the size and color of edges.

	{cmd:. webnwuse gang, nwclear}
	{cmd:. nwplot}
	{cmd:. nwplot gang, edgesize(gang)} 
	{cmd:. nwgenerate blood = (gang==4)}
	{cmd:. nwplot blood}
	{cmd:. nwplot gang, edgesize(gang) edgecolor(blood)}

{pstd}
This is how to control the legend of the plot. All options that can be used for twoway legends are valid.{p_end}
	{phang2}
	{cmd:. nwplot gang, size(Arrests, forcekeys(5 10 20)) legendopt(on pos(3) cols(1))}

{pstd}
Because nwplot uses twoway plots one can  use all general twoway options to e.g. control the title of a plot.

{phang2}
{cmd:. webnwuse florentine, nwclear}{p_end}
{phang2}
{cmd:. nwplot flomarriage, edgecolor(flobusiness) title("Florentine Marriages", color(red) size(huge))}
{p_end}

{pstd}
Here, the nodes are plotted with the node labels saved with the network:
	
	{cmd:. nwplot flobusiness, lab}
	
{pstd}
More generally, one can use any {it:varname} as node labels. The next example, does the same as the previous command, 
but shows how one could use node labels stored elsewhere:

	{cmd:. nwplot flobusiness, label(_nodelab)}

{pstd}
The look and feel of node labels is changed with labelopt():

	{cmd:. nwplot flobusiness, label(_nodelab) labelopt(mlabsize(huge) mlabcolor(red))}
	
{pstd}
The command draws on normal scatter plots to plot nodes. Once can send all sorts of options directly to these
underlying scatter plots. Here, the color and symbol of nodes is overwritten.

	{cmd:. nwplot flomarriage, scatteropt(mfcolor(green) msymbol(D))}
	{cmd:. nwplot flomarriage, lineopt(lwidth(10) lcolor(green))}
	

{pstd}
The next example shows how to only plot the largest component of the network.	

	{cmd:. webnwuse glasgow, nwclear}
	{cmd:. nwgen large = lgc(glasgow1)}
	{cmd:. nwplot glasgow1 if large == 1}
	
{pstd}
Alternative to display the largest component only:

	{cmd:. webnsuse glasgow, nwclear}
	{cmd:. nwplot glasgow1, layout(,lgc)}
	

{marker layoutfunction}{...}
{title:Programming layout function}

{pstd}
One can use {bf:nwplot} together with user-written layout functions. In this way one can implement all sorts of network layout algorithms (e.g.
Fruchtermann-Reingold, Kamadai-Kawai, and so on). Probably the easiest way to do this is:

{pmore}
1. Obtain adjacency matrix {it:matamatrix} of network with {help nwtomata:nwtomata, mat(matamatrix)}{p_end}

{pmore}
2. Implement desired layout function/program that calculates node coordinates with argument {it:matamatrix} and saves node coordinates in Stata variables {it:_myxcoord, _myycoord}.
{p_end} 
{pmore}
3. Run nwplot with option {bf:nodexy(_myxcoord _myycoord) layout(nodexy)}

{pstd}
However, this method does not work together with {help nwmovie}. Here, network plots are generated for each frame in between network
waves. A more sophisticated advanced programming solution is the following:

{pmore}
1. Write and load mata function that takes as first argument the adjacency matrix of the network (after that all sorts of arguments can follow).
This function needs to return a matrix that has exactly {it:nodes} rows and two columns (one for x- and one for y-coordinate). 
	
		{com}capture mata : mata drop myrandom()
		mata:
		real matrix function myrandom(real matrix net) {
			return(runiform(rows(net), 2))
		}
		end{txt}
		
{pmore}
This little mata function returns random coordinates for each node.
		
{pmore}
2. Run nwplot with option {bf:layout(_layoutfunction) _layoutfunction(myrandom)}. 

{pstd}
This solution is compatible with {help nwmovie}. Notice that when {bf:_layoutfunction()} is used, all {help nwplot##layout_sub:layout_sub} options are ignored.



