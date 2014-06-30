{smcl}
{* *! version 1.0.6  16may2012}{...}
{cmd:help nwsvggraph}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwsvggraph{hline 2}} Plot network as scalable vector graphic{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwsvggraph} 
[{cmd:, }
{opt stub(stub)}
{opt fname(filename)}
{opt nsize(varname)}
{opt ncolor(varname)}
{opt nfactor(scalar)}
{opt efactor(scalar)}
{opt height(scalar)}
{opt width(scalar)}
{opt xstretch(scalar)}
{opt ystretch(scalar)}
{opt labeltext(varname)}
{opt labelsize(scalar)}
{opt labelcolor(string)}
{opt labelx(scalar)}
{opt labely(scalar)}
background1 background2
{opt animationspeed(scalar)}
{opt animationopacity(scalar)}
[random|mds|circle|lattice] 


{title:Description}

{pstd}
{cmd:nwgraph} Generates an svg file that contains a graph of the network. Tries to open svg file.

{title:Remarks}

{pstd}
More help will follow. All svg files can be post-processed with programs like Adobe Illustrator.

{title:Examples}

clear
nwrandom 20, prob(.2)

nwsvggraph


* Layout: 
* You can adjust the layout in the same way as you do for the nwgraph command. You can choose between
* (1) nothing (which means random), (2) circle, (3) lattice and (4) mds (multidimensional scaling)

nwsvggraph, circle
nwsvggraph, lattice
nwsvggraph, mds

* Background:
* The color of the background is changed in the following way. You can define rgb (red green blue) values for
* the center of the background and for the periphery of the background. Each rgb value consists of three numbers from 
* 0 to 255.

nwsvggraph, background1 (255 0 0)  mds
nwsvggraph, background1 (255 0 0)  background2 (120 255 255) mds

* Size:
* This is adjusted with width and height (in pixels).

nwsvggraph, width(600) height(300) background1 (255 0 0)  background2 (120 255 255) mds

* Stretching:
* Sometimes it is useful to stretch the graph. You do that with xstretch and ystretch. Both take a real number as an
* argument that indicates the stretching. This number can also be greater than 1.

nwsvggraph, background1 (255 0 0)  background2 (120 255 255) circle
nwsvggraph, background1 (255 0 0)  background2 (120 255 255) xstretch(.7) ystretch(.7) circle

* Title label:

nwsvggraph, background1 (255 0 0) labeltext("My network") mds
nwsvggraph, background1 (255 0 0) labeltext("My network") labelsize(15) labelx(10) labely(20) labelcolor(yellow) mds

* Node labels:

gen id = _n
nwsvggraph, background1 (255 0 0) labeltext("My network") nlabels(id) mds

* Edge Factor:
* This is a multiplier for the width of the edges.

replace var2 = 5 in 10
nwsvggraph, efactor(3)

* Node Factor: 
* This is a multiplier for the size of the nodes.

nwsvggraph, nfactor(3)

* Node Size:
* You can adjust the size of each node individually, but you can also combine this with nfactor.

gen size = int(uniform()*30) + 1
nwsvggraph, nsize(size) lattice

* Node Color:
* You can also give each node a different color. Color values range from 0 to 7 so far only.

gen color = int(uniform()*8)
nwsvggraph, ncolor(color) lattice

* The nwsvggraph command is very powerful and can animate your network as well. So far, you can animate
* the size of your nodes and their color. You can do this by putting a variable list in the argument
* of either the nsize or ncolor option. Let us create two variables color1 and color2.

clear
set more off
set obs 100

gen color1 = int(uniform()*3)
gen color2 = int(uniform()*3)
gen color3 = int(uniform()*3)

* Now the option ncolor takes a list of variables
nwsvggraph, ystretch(.7) lattice ncolor(color*)

* You can adjust the speed with animationspeed, default = 1
nwsvggraph, ystretch(.7) lattice ncolor(color1 color2 color3) labeltext("My animation: ") animationspeed(3)


{title:Author}
Thomas Grund
Institute for Futures Studies
Stockholm
thomas.grund@iffs.se


{title:Also see}
