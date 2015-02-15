{smcl}
{* *! version 2.0.0  2april2014}{...}
{marker topic}
{helpb nw_topical##visualization:[NW-2.8] Visualization}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwmovie {hline 2} Animate a sequence of networks}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwmovie}
{it:{help netlist}}
[{cmd:,} 
{it:{help nwmovie##movie_options:movie_options}}
{it:{help nwmovie##switch_options:switch_options}}
{it:{help nwmovie##time_options:time_options}}
{it:{help nwplot:nwplot_options}}
{it:{help twoway_options}}]
	
{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{it:{help nwmovie##movie_options:movie_options}}}control movie, e.g. framerate, dealy, explosion{p_end}
{p2col:{it:{help nwmovie##switch_options:switch_options}}}change when to switch from time t to time t+1{p_end}
{p2col:{it:{help nwmovie##time_options:time_options}}}controll look of
       nodes (color, size, symbol, etc.), edges (edgecolor, edgesize), labels and titles for different points in time{p_end}
{p2col:{it:{help nwmovie##nwplot_options:nwplot_options}}}all normal options for plotting networks; they apply to all time points{p_end}
{p2col:{it:{help twoway_options}}}normal twoway options for the whole plot
		{p_end}
	

{synoptset 35 tabbed}{...}
{p2col:{it:movie_options}}Description{p_end}
{marker movie_options}{...}
{p2line}
{synopt:{opth fname(string)}}filename of Animated GIF{p_end}
{synopt:{opth frames(int)}}number of frames between time points{p_end}
{synopt:{opth delay(int)}}time delay between frames between in milliseconds{p_end}
{synopt:{opth explosion(real)}}explosion factor for change between time points; no explosion = 0, default = 50 {p_end}
{synopt:{opth imagick(string)}}alternative installation path for ImageMagick{p_end}
{synopt:{opt eps}}export network plots as .EPS and not as .PNG; requires GhostScript installation{p_end}
{synopt:{opt keepfiles}}keep the .PNG or .EPS files for each frame in the working directory{p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:switch_options}}Description{p_end}
{marker switch_options}{...}
{p2line}
{synopt:{opt switchnetwork}({it:{help nwmovie##switchstyle:switchstyle}})}control when to switch from network(t) to network(t+1){p_end}
{synopt:{opt switchcolor}({it:{help nwmovie##switchstyle:switchstyle}})}control when to switch from color(t) to color(t+1){p_end}
{synopt:{opt switchsymbol}({it:{help nwmovie##switchstyle:switchstyle}})}control when to switch from symbol(t) to symbol(t+1){p_end}
{synopt:{opt switchedgecolor}({it:{help nwmovie##switchstyle:switchstyle}})}control when to switch from edgecolor(t) to edgecolor(t+1){p_end}
{synopt:{opt switchtitle}({it:{help nwmovie##switchstyle:switchstyle}})}control when to switch from title(t) to title(t+1){p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:switchstyle}}Description{p_end}
{marker switchstyle}{...}
{p2line}
{p2col:{opt start}}switch display from time1 to time2 at the start of the spell{p_end}
{p2col:{opt half}}switch display from time1 to time2 in the middle of the spell{p_end}
{p2col:{opt end}}switch display from time1 to time2 at the end of the spell{p_end}


{synoptset 40 tabbed}{...}
{p2col:{it:time_options}}Description{p_end}
{marker node_options}{...}
{p2line}
{p2col:{opt titles}({it:tit1}|{it:tit2}|...)}one title per time point{p_end}
{p2col:{opt labels}({it:{help varlist}})}labels of the nodes; one variable per time point{p_end}
{synopt:{opt sizes}({it:{help varlist}} [,{it:{help nwplot##node_sub:node_sub}}])}sizes of the nodes; one variable per time point{p_end}
{p2col:{opt colors}({it:{help varlist}} [,{it:{help nwplot##node_sub:node_sub}}])}colors of the nodes; one variable per time point{p_end}
{p2col:{opt symbols}({it:{help varlist}} [,{it:{help nwplot##node_sub:node_sub}}])}symbols of the nodes; one variable per time point{p_end}
{p2col:{opt edgesizes}({it:{help netlist}})}use edge values of other networks to change width of edges; networks needs to have the right dimensions; one network per time point{p_end}
{p2col:{opt edgecolors}({it:{help netlist}} [,{it:{help nwplot##edge_sub:edge_sub}}])}use edge values of other networks to change color of edges; networks needs to have the right dimensions; one network per time point{p_end}
	
		
{title:Description}

{pstd}
This command animates a list of {it:t} networks and produces a movie in Animated-GIF format. It requires the third-party software {browse "http://www.imagemagick.org/":ImageMagick}. When
you run {cmd:nwmovie} for the first time you will get the appropriate download-link for your operating system.

{pstd}
{bf:nwmovie} basically generates one network plot (see {help nwplot}) for each {help netname:netname(t)} in the {help netlist}. Furthermore, it generates additional
frames to transition from network(t) to network(t+1). All network plots (plus the frames in between) are exported as either .PNG or .EPS. Finally, the third-party software {bf:ImageMagick}
is used to make an Animated-GIF out of the sequence of network plots. The Animated-GIF can be easily inserted in websites or presentations.

{pstd}
Basically, you can control the look of nodes, labels and edges just as with {help nwplot}, but also for different points in time. While, for example, the option
{opt size(varname)} changes the size of nodes for all points in time, you
can use {opt sizes(varlist)} to plot different node sizes for different points in time; {it:varlist} needs 
to have as many variables as there are networks you want to animate. 



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



