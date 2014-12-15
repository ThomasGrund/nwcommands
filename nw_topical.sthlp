{smcl}
{* *! version  15dec2014}{...}
{phang}
{help nwcommands:NW-2 topical} {hline 2} 
{hline 2} Topical list of network commands

{title:Contents}

{col 14}Section{col 31}Description
{col 14}{hline 46}
{help nw_topical##concept:{col 14}{bf:[NW-2.1]}{...}{col 31}{bf:Concepts}}

{help nw_topical##import:{col 14}{bf:[NW-2.2]}{...}{col 31}{bf:Import/Export}}

{help nw_topical##generator:{col 14}{bf:[NW-2.3]}{...}{col 31}{bf:Generators}}

{help nw_topical##information:{col 14}{bf:[NW-2.4]}{...}{col 31}{bf:Information}}

{help nw_topical##manipulation:{col 14}{bf:[NW-2.5]}{...}{col 31}{bf:Manipulation}}

{help nw_topical##analysis:{col 14}{bf:[NW-2.6]}{...}{col 31}{bf:Analysis}}

{help nw_topical##utilities:{col 14}{bf:[NW-2.7]}{...}{col 31}{bf:Utilities}}

{help nw_topical##visualizaion:{col 14}{bf:[NW-2.8]}{...}{col 31}{bf:Visualization}}

{help nw_topical##programming:{col 14}{bf:[NW-2.9]}{...}{col 31}{bf:Programming}}

{marker concept}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Concepts}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help netexp }}}Network expression and function{p_end}
{p2col:    {bf:{help netlist }}}{p_end}
{p2col:    {bf:{help netname }}}{p_end}
{p2col:    {bf:{help newnetname }}}{p_end}
{p2col:    {bf:{help nodeid }}}{p_end}
{marker import}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Import/Export}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help nwexport }}}Export network as Pajek file{p_end}
{p2col:    {bf:{help nwfromedge }}}Imports network data from edgelist{p_end}
{p2col:    {bf:{help nwimport }}}Import network{p_end}
{p2col:    {bf:{help nwsave }}}Save networks in file{p_end}
{p2col:    {bf:{help nwset }}}Declare data to be network data{p_end}
{p2col:    {bf:{help nwtoedge }}}Convert network into edgelist{p_end}
{p2col:    {bf:{help nwuse }}}Load Stata-format networks{p_end}
{p2col:    {bf:{help webnwuse }}}Load network data over the web{p_end}
{marker generator}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Generators}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help nwduplicate }}}Duplicate a network{p_end}
{p2col:    {bf:{help nwdyadprob }}}Generate a network based on tie probabilities{p_end}
{p2col:    {bf:{help nwexpand }}}Expand variable to network{p_end}
{p2col:    {bf:{help nwgen }}}Network extensions to generate{p_end}
{p2col:    {bf:{help nwgenerate }}}{p_end}
{p2col:    {bf:{help nwgeodesic }}}Calculate shortest paths between nodes{p_end}
{p2col:    {bf:{help nwhomophily }}}Generate a homophily network{p_end}
{p2col:    {bf:{help nwlattice }}}Generate a lattice network{p_end}
{p2col:    {bf:{help nwpath }}}Calculate paths between nodes{p_end}
{p2col:    {bf:{help nwpermute }}}Generate permutation of a network{p_end}
{p2col:    {bf:{help nwpref }}}Generate a preferential-attachment network{p_end}
{p2col:    {bf:{help nwrandom }}}Generate a random network{p_end}
{p2col:    {bf:{help nwreach }}}Calculate reachability network{p_end}
{p2col:    {bf:{help nwring }}}Generate a ring-lattice network{p_end}
{p2col:    {bf:{help nwsmall }}}Generate a small-world network{p_end}
{p2col:    {bf:{help nwtranspose }}}Transpose a network{p_end}
{marker information}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Information}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help nwcurrent }}}Report and set current network{p_end}
{p2col:    {bf:{help nwdyads }}}Dyad census{p_end}
{p2col:    {bf:{help nwissymmetric }}}Check if network is symmetric{p_end}
{p2col:    {bf:{help nwname }}}Check name and change meta-information of a network{p_end}
{p2col:    {bf:{help nwsummarize }}}Summarize a network{p_end}
{p2col:    {bf:{help nwtabulate }}}{p_end}
{marker manipulation}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Manipulation}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help nwaddnodes }}}Add nodes to network{p_end}
{p2col:    {bf:{help nwdrop }}}Drop a network (or only some nodes){p_end}
{p2col:    {bf:{help nwdropnodes }}}Drop nodes from a network{p_end}
{p2col:    {bf:{help nwkeep }}}Keep a network (or only certain nodes){p_end}
{p2col:    {bf:{help nwkeepnodes }}}Keep nodes of a network{p_end}
{p2col:    {bf:{help nwname }}}Check name and change meta-information of a network{p_end}
{p2col:    {bf:{help nwrecode }}}Recode network{p_end}
{p2col:    {bf:{help nwrename }}}Rename network{p_end}
{p2col:    {bf:{help nwreplace }}}Replace network{p_end}
{p2col:    {bf:{help nwreplacemat }}}Replace network with Mata matrix{p_end}
{marker analysis}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Analysis}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help nwbetween }}}Calculate betweenness centrality{p_end}
{p2col:    {bf:{help nwcloseness }}}Calculate closeness centrality{p_end}
{p2col:    {bf:{help nwclustering }}}Clustering coefficient{p_end}
{p2col:    {bf:{help nwcomponents }}}Calculate network components / largest component{p_end}
{p2col:    {bf:{help nwcontext }}}Create a context variable{p_end}
{p2col:    {bf:{help nwcorrelate }}}Correlate networks and variables{p_end}
{p2col:    {bf:{help nwdegree }}}Degree centrality and distribution{p_end}
{p2col:    {bf:{help nwevcent }}}Calculate eigenvector centrality{p_end}
{p2col:    {bf:{help nwgen }}}Network extensions to generate{p_end}
{p2col:    {bf:{help nwgenerate }}}{p_end}
{p2col:    {bf:{help nwgeodesic }}}Calculate shortest paths between nodes{p_end}
{p2col:    {bf:{help nwkatz }}}Calculate Katz centrality{p_end}
{p2col:    {bf:{help nwneighbor }}}Extract the network neighbors of a node{p_end}
{p2col:    {bf:{help nwpath }}}Calculate paths between nodes{p_end}
{p2col:    {bf:{help nwqap }}}Multivariate QAP regression{p_end}
{p2col:    {bf:{help nwreach }}}Calculate reachability network{p_end}
{p2col:    {bf:{help nwutility }}}Calculate utility scores according to Jackson and Wollinsky (1996){p_end}
{p2col:    {bf:{help nwvalue }}}Returns entries form the adjaceny matrix of a network{p_end}
{marker utilities}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Utilities}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help nwclear }}}Clear all networks and variables from memory{p_end}
{p2col:    {bf:{help nwcurrent }}}Report and set current network{p_end}
{p2col:    {bf:{help nwds }}}List networks matching name patterns{p_end}
{p2col:    {bf:{help nwload }}}Load a network as Stata variables{p_end}
{p2col:    {bf:{help nwsync }}}Sync network with Stata variables{p_end}
{p2col:    {bf:{help nwtomata }}}Return adjacency matrix of network{p_end}
{p2col:    {bf:{help nwunab }}}Unabbreviate network list{p_end}
{p2col:    {bf:{help nwvalidate }}}Validate network name{p_end}
{p2col:    {bf:{help nwvalidvars }}}Validate Stata variables for network{p_end}
{marker visualization}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Visualization}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help nwplot }}}Plot a network{p_end}
{marker programming}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Programming}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:    {bf:{help _nwnodeid }}}Returns the nodeid of a node given its node label{p_end}
{p2col:    {bf:{help _nwnodelab }}}Returns the nodelab of a node given its nodeid{p_end}
{p2col:    {bf:{help _nwsyntax }}}Parse network syntax{p_end}
{p2col:    {bf:{help nwcompressobs }}}Compresses observations in Stata{p_end}
{marker uncategorized}{...}

{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Uncategorized}{col 36}{c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help _extract_valuelabels }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help _nwdeploy }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help _nwevalnetexp }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help _nwsetobs }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help _nwsyntax_other }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help _opts_oneof }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help nwergm }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help nwmovie }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help nwsociomatrix }}}{err}no help file yet{txt}{p_end}
{p2col:{bf:{help nwtostata }}}{err}no help file yet{txt}{p_end}
