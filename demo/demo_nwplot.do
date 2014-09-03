nwuse glasgow

// Simple plot
nwplot
nwplot glasgow

// Layout
nwplot, layout(mds, components(1))
nwplot, layout(circle)
nwplot, layout(grid)
nwplot, layout(grid, columns(20))

// Obtain coordinates from layout and plot with coordinates
nwplot, gen(coord)
replace coord_x = .2 if _n < 20
nwplot, nodexy(coord_x coord_y)

// Arcs
nwplot, arcstyle(automatic)
nwplot, arcstyle(straight)
nwplot, arcstyle(curved)
nwplot, arcbend(0.3) arcsplines(20) 

// Factors
nwplot, nodefactor(2)
nwplot, edgefactor(2) 
nwplot, arrowfactor(4)
nwplot, arrowbarbfactor(.2)
nwplot, nodefactor(2) edgefactor(4) arrowfactor(2) arrowbarbfactor(.2)
 
// Coloring of nodes 
nwplot, color(smoke)
nwplot, color(smoke) colorpalette(red yellow cyan)
 
// Symbol of nodes
nwplot, symbol(sport)
nwplot, symbol(sport) symbolpalette(T S)

// Size of nodes
nwplot, size(alcohol)
nwplot, size(alcohol, forcekeys(1 5 10 20))
 
// All three 
nwplot, size(alcohol) color(smoke) symbol(sport) 

// Schemes
nwplot, scheme(s1network) 
nwplot, scheme(s3network) 
nwplot, scheme(s2mono) 

nwplot, size(alcohol) color(smoke) symbol(sport) scheme(s1network)
nwplot, size(alcohol) color(smoke) symbol(sport) scheme(s2network)
nwplot, size(alcohol) color(smoke) symbol(sport) scheme(economist)

set scheme s1network

// Change the size and color of edges 
nwuse gang
nwplot
nwplot gang, edgesize(gang) 
nwgenerate blood = (gang==4)
nwplot blood
nwplot gang, size(Arrests) color(Birthplace) edgesize(gang) edgecolor(blood) edgepatternpalette(dot) 

// Control the legend - legendopt()
nwplot gang, size(Arrests, forcekeys(5 10 20)) color(Birthplace, legendoff) edgesize(gang, legendoff) edgecolor(blood) legendopt(on pos(3) cols(1)) 

// Control title and labels - twowayoptions
nwuse florentine
nwplot flobusiness, label(_label1)
nwplot flomarriage, label(_label1) 
nwplot flomarriage, edgecolor(flobusiness) title("Florentine Marriages", color(red) size(huge))

// Control all plots - scatteropt() lineopt()
nwplot flomarriage, scatteropt(mfcolor(green) msize(ehuge) msymbol(D))

nwplot flomarriage, lineopt(lwidth(10) lcolor(green))


// Make animations 
nwuse glasgow
nwmovie _all, titles((time 1) (time 2) (time 3), color(red))





