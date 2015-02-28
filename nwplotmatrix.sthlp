{smcl}
{* *! version 2.0.0  2april2014}{...}
{marker topic}
{helpb nw_topical##visualization:[NW-2.8] Visualization}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwplotmatrix {hline 2} Plot a network as sociomatrix}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwplotmatrix}
[{it:{help netname}}] 
[{it:{help if}}]
[{cmd:,}
{opth sortby(varname)}
{opt group}({it:{help varname}}, [{it:{help connect_options}}])
{it:{help nwplotmatrix##label_options:label_options}}
{it:{help nwplotmatrix##patch_options:patch_options}}
{it:{help twoway_options}}]


	
{synoptset 35}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{opth sortby(varname)}}sort network nodes before plotting{p_end}
{p2col:{opt group}({it:{help varname}}, [{it:{help connect_options}}])}group nodes by categorical variable{p_end}
{p2col:{it:{help nwplotmatrix##label_options:label_options}}}display and change look of
       axis labels{p_end}
{p2col:{it:{help nwplotmatrix##patch_options:patch_options}}}change look of patches (e.g. color, tievalue){p_end}
{p2col:{it:{help nwplotmatrix##legend_options:legend_options}}}change look and feel of legend (e.g. color, size){p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:label_options}}Description{p_end}
{marker label_options}{...}
{p2line}
{p2col:{opt lab}}display node labels as axis labels{p_end}
{p2col:{opth label(varname)}}display axis labels from variable{p_end}
{synopt:{opt labelopt}({it:{help scatter##marker_label_options:marker_label_options}})}options for look of axis labels (e.g. size, color){p_end}


{synoptset 35 tabbed}{...}
{p2col:{it:patch_options}}Description{p_end}
{marker patch_options}{...}
{p2line}
{synopt:{opt nod:ichotomize}}do not dichotomize valued networks; by default, networks are dichotomized{p_end}
{p2col:{opt col:orpalette}({it:{help colstyle:colstyle...}})}list of colors for patches (representing tie values){p_end}
{p2col:{opth lcolor(colorstyle)}}overwrite color of lines between patches{p_end}
{p2col:{opth background(colorstyle)}}overwrite background color{p_end}
{synopt:{opt tievalue}}show tie values as text inside patches{p_end}
{p2col:{opt tievalueopt}({it:{help scatter##marker_label_options:marker_label_options}})}options for look and feel of tie value text{p_end}


		
{title:Description}

{pstd}
This command plots a network as a sociomatrix. It supports subnetworks specified by the {help if} condition. It gives a lot of flexibility to control all elements in a network plot. Furthermore, it 
is compatible with {bf:schemes()} and accepts all {help twoway_options}.

{pstd}
This loads the {help netexample:Florentine data} and makes a simple matrix plot.

	{cmd:. webnwuse florentine, nwclear}
	{cmd:. nwplotmatrix flomarriage}

{pstd}
One can display the {help nodeid:labels saved with a network} or labels saved in any other variable. Furthermore, one can control
the look and feel of the axis labels with {opt labelopt()}. 
	
	{cmd:. nwplotmatrix flomarriage, lab}
	{cmd:. nwplotmatrix flomarriage, label(wealth)}
	{cmd:. nwplotmatrix flomarriage, label(_nodeid) labelopt(labsize(tiny))}

{pstd}
Notice that one can also use normal {help twoway_options} to control the y-axis and the x-axis independently from each other. For example, the
following command produces the same output as the previous command:

 	{cmd:. nwplotmatrix flomarriage, label(_nodeid) ylabel(,labsize(tiny)) xlabel(,labsize(tiny))}

{pstd}
It can be useful to sort the nodes of the network before plotting a sociomatrix. This example sorts the nodes according
to the values in variable {it:wealth}.

	{cmd:. nwplotmatrix flomarriage, label(wealth) sortby(wealth)}

{pstd}
All options can be combined with {help if}. In this case, only subnetworks are plotted. For example: 

	{cmd:. nwplotmatrix flomarriage if wealth > 30, label(wealth) sortby(wealth)}

{pstd}
The command accepts all normal {help twoway_options}, e.g.

	{cmd:. nwplotmatrix flomarriage, lab scheme(s1mono) title("mynet")}

{pstd}
One can also overwrite the colors used for the plot:

	{cmd:. nwplotmatrix flomarriage, lab scheme(s1mono) colorpalette(black) background(yellow) lcolor(red)}

{pstd}
The command also allows to display the tie values inside the patches. The look and feel of these values is controlled with {bf: tievalueopt()}.

	{cmd:. nwplotmatrix flomarriage, tievalue}
	{cmd:. nwplotmatrix flomarriage, tievalue tievalueopt(mlabsize(tiny) mlabcolor(yellow))}

{pstd}
It can be useful to plot a legend for the tie values. This is done just using the {bf:legend()} option just as in normal twoway plots. By default,
the legend is filled with the tie values of the network, but one can also overwrite the entries.

	{cmd:. nwplotmatrix flomarriage, tievalue legend(on)}	
	{cmd:. nwplotmatrix flomarriage, tievalue legend(on order(1 "no_tie" 2 "tie"))}	

{pstd}
The option {opth group(varname)} sorts the nodes by {help varname} first and then adds lines
to the sociomatrix to separate groups from each other. The example generates the variable seat, 
which is one when a family had some seats in the council.

	{cmd:. gen seat = (priorates != 0)}
	{cmd:. nwplotmatrix flomarriage, group(seat)}	

{pstd}
All normal {help connect_options:options for lines} can be applied as well.

	{cmd:. nwplotmatrix flomarriage, group(seat, lcolor(green))}	
	
{pstd}
By default, networks are plotted dichotomized unless specified otherwise.

	{cmd:. webnwuse gang, nwclear}	
	{cmd:. nwplotmatrix gang, legend(on)}	
	{cmd:. nwplotmatrix gang, legend(on) nodichotomize}	

	
{title:See also}

	{help nwplot}, {help nwmovie}
