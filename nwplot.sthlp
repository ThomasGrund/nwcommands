{smcl}
{* *! version 2.0.0  2april2014}{...}
{marker topic}
{helpb nw_topical##visualization:[NW-2.8] Visualization}
{cmd:help nwassortmix}
{cmd:help nwplot}
{hline}

{title:Title}

{p2colset 5 15 22 2}{...}
{p2col :nwplot {hline 2}}Plot a network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwplot}
[{it:{help netname}}]
[{cmd:,} {it:{help nwplot##node_options:node_options}}
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
	

{synoptset 30 tabbed}{...}
{p2col:{it:node_options}}Description{p_end}
{marker node_options}{...}
{p2line}
{p2col:{opt size}({help var} [,{help nwplot##node_sub:node_sub}])}size of the nodes{p_end}
{p2col:{opt sizebin(integer)}}finetune size of nodes{p_end}
{p2col:{opt nodefactor(float)}}multiply all node sizes by a factor{p_end}
{p2col:{opt color}({help var} [,{help nwplot##node_sub:node_sub}])}color of the nodes{p_end}
{p2col:{opt colorpalette}({help colorstyle}...)}list with colorstyles; change colorpalette{p_end}
{p2col:{opt symbol}({help var} [,{help nwplot##node_sub:node_sub}])}symbol of the nodes{p_end}
{p2col:{opt symbolpalette}({help symbolstyle}...)}list with symbolstyles; change symbolpalette{p_end}
{p2col:{opt label}({help var})}use variable to display node labels{p_end}

{synoptset 30 tabbed}{...}
{p2col:{it:node_sub}}Description{p_end}
{marker node_options}{...}
{p2line}
{p2col:{opt norescale}}no automatic rescale{p_end}
{p2col:{opt legendoff}}no legend for this element{p_end}
{p2col:{opt forcekeys}(integer...)}list of keys to be used in the legend{p_end}

{synoptset 30 tabbed}{...}
{p2col:{it:edge_options}}Description{p_end}
{marker edge_options}{...}
{p2line}
{p2col:{opt edgesize}({help netname})}use edge values of other network to change width of edges; network needs to have the right dimensions{p_end}
{p2col:{opt edgefactor(float)}}multiply all edge sizes by a factor{p_end} 
{p2col:{opt edgecolor}({help netname})}use edge values of other network to change color of edges; network needs to have the right dimensions{p_end}
{p2col:{opt edgecolorpalette}({help colorstyle}...)}list with colorstyles; change edgecolorpalette{p_end}
{p2col:{opt edgepatternpalette}({help linepatternstyle}...)}list with linestyles; the same network as in edgecolor is used to display different line patterns{p_end}
	
{synoptset 30 tabbed}{...}
{p2col:{it:arrow_options}}Description{p_end}
{marker arrow_options}{...}
{p2line}
{p2col:{opt arcstyle}({help nwplot##arcstyle:arcstyle})}change the look of arcs (curved, straight){p_end}
{p2col:{opt arcbend(integer)}}control the degree of bend for curved arcs{p_end}
{p2col:{opt arcsplines(integer)}}resolution for curved arcs{p_end}
{p2col:{opt arrowfactor(float)}}multiply arrowhead by a factor{p_end}
{p2col:{opt arrowgap(float)}}control gap between arrowhead and node{p_end}
{p2col:{opt arrowbarbfactor(float)}}control look of arrow{p_end}

{synoptset 30 tabbed}{...}
{p2col:{it:layout_options}}Description{p_end}
{marker layout_options}{...}
{p2line}
{p2col:{cmd: layout}({help nwplot##layoutstyle:layoutstyle} [,{help nwplot##layout_sub:layout_sub}])}change the overall layout/arrangement of nodes{p_end}
{p2col:{opt nodexy}({help var:xvar} {help var:yvar})}use variables to force coordinates of nodes{p_end}
{p2col:{opt generate}({help newvar:newxvar} {help newvar:newyvar})}export coordinates of nodes{p_end}

{synoptset 30 tabbed}{...}
{p2col:{it:layout_sub}}Description{p_end}
{marker layout_sub}{...}
{p2line}
{p2col:{opt components(integer)}}number of components to be plotted; default = 3 {p_end}
{p2col:{opt columns(integer)}}number of columns to be plotted in grid layout {p_end}

{synoptset 30 tabbed}{...}
{p2col:{it:other_options}}Description{p_end}
{marker other_options}{...}
{p2line}
{p2col:{opt aspectratio(float)}}height/width ratio{p_end}
{p2col:{opt lineopt}({help line:options})}send options directly to all line plots used to display arcs{p_end}
{p2col:{opt scatteropt}({help scatter:options})}send options directly to all scatter plots used to display nodes {p_end}
{p2col:{opt legendopt}({help legend_options:options})}send options directly to the legend{p_end} 

{synoptset 30 tabbed}{...}
{marker layoutstyle}{...}
{p2col:{it:layoutstyle}}{p_end}
{p2line}
{p2col:{cmd: mds}}multidimensional scaling; default{p_end}
{p2col:{cmd: circle}}circle layout
		{p_end}
{p2col:{cmd: grid}}grid layout
		{p_end}
		
{synoptset 30 tabbed}{...}
{marker arcstyle}{...}
{p2col:{it:arcstyle}}{p_end}
{p2line}
{p2col:{cmd: automatic}}plots arcs as curved lines, but only when they are not reciprocated; default
		{p_end}
{p2col:{cmd: curved}}plots all arcs as curved lines
		{p_end}
{p2col:{cmd: straight}}plots all arcs as straight lines
		{p_end}
		
{title:Description}

{pstd}
Plots a network. 

{title:Examples}

	// Plot a random network
	{cmd:. nwclear}
	{cmd:. nwrandom 20, prob(.2)}
	{cmd:. nwplot}

	// Layout
	{cmd:. nwplot, layout(mds)}
	{cmd:. nwplot, layout(circle)}
	{cmd:. nwplot, layout(grid)}
	{cmd:. nwplot, layout(grid, columns(20))}

	// Obtain coordinates from layout and plot with coordinates
	{cmd:. nwplot, gen(xcoord ycoord)}
	{cmd:. replace xcoord = .2 if _n < 5}
	{cmd:. nwplot, nodexy(xcoord ycoord)}

	// Arcs
	{cmd:. nwplot, arcstyle(automatic)}
	{cmd:. nwplot, arcstyle(straight)}
	{cmd:. nwplot, arcstyle(curved)}
	{cmd:. nwplot, arcbend(0.3) arcsplines(20)} 

	// Factors
	{cmd:. nwplot, nodefactor(2)}
	{cmd:. nwplot, edgefactor(2)} 
	{cmd:. nwplot, arrowfactor(4)}
	{cmd:. nwplot, arrowbarbfactor(.2)}
	{cmd:. nwplot, nodefactor(2) edgefactor(4) arrowfactor(2) arrowbarbfactor(.2)}
 
	// Coloring of nodes 
	{cmd:. webnwuse glasgow, nwclear}
	{cmd:. nwplot glasgow1, color(smoke1)}
	{cmd:. nwplot, color(smoke1) colorpalette(red yellow cyan)}
 
	// Symbol of nodes
	{cmd:. nwplot glasgow1, symbol(sport1)}
	{cmd:. nwplot glasgow1, symbol(sport1) symbolpalette(T S)}

	// Size of nodes
	{cmd:. nwplot glasgow1, size(alcohol1)}
	{cmd:. nwplot, size(alcohol1, forcekeys1(1 5 10 20))}
 
	// All three 
	{cmd: nwplot glasgow1, size(alcohol1) color(smoke1) symbol(sport1)}

	// Schemes
	{cmd:. nwplot, scheme(s1network)}
	{cmd:. nwplot, scheme(s2network)} 
	{cmd:. nwplot, scheme(s2mono)} 
	{cmd:. nwplot, size(alcohol3) color(smoke3) symbol(sport3) scheme(s1network)}
	{cmd:. nwplot, size(alcohol3) color(smoke3) symbol(sport3) scheme(economist)}
	{cmd:. set scheme s2network}

	// Change the size and color of edges 
	{cmd:. webnwuse gang}
	{cmd:. nwplot}
	{cmd:. nwplot gang, edgesize(gang)} 
	{cmd:. nwgenerate blood = (gang==4)}
	{cmd:. nwplot blood}
	{cmd:. nwplot gang, edgesize(gang) edgecolor(blood)}

	// Control the legend - legendopt()
	{cmd:. nwplot gang, size(Arrests, forcekeys(5 10 20)) legendopt(on pos(3) cols(1))}

	// Control title and labels - twowayoptions
	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwplot flobusiness, label(_label1)}
	{cmd:. nwplot flomarriage, edgecolor(flobusiness) title("Florentine Marriages", color(red) size(huge))}

	// Control all plots - scatteropt() lineopt()
	{cmd:. nwplot flomarriage, scatteropt(mfcolor(green) msymbol(D))}
	{cmd:. nwplot flomarriage, lineopt(lwidth(10) lcolor(green))}

