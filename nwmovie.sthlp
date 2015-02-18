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

{pstd}
Because nodes and networks at different points can vary, all node- and edge-level
options are automatically invoked with the option {bf:norescale}.

	{cmd:. webnwuse klas12b}, nwclear
	{cmd:. nwmovie _all}

{pstd}
One can change the attributes of nodes per time point.
	
	{cmd:. nwmovie klas12b_wave1 klas12b_wave1, colors(delinq1 delin2)}

{pstd}
Notice that the normal, time-invariant options from {help nwplot} can be used as well.
	
	{cmd:. nwmovie klas12b_wave1 klas12b_wave1, color(sex)}

	
{title:See also}

	{help nwplot}
