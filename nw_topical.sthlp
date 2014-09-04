{smcl}
{* *! version 1.0.0  3sept2014}{...}
{cmd:help nw_topical}
{hline}

{phang}
{manlink NW-2 intro} {hline 2} topical list of programs


{title:Contents}

{pstd}
An alphabetical index of all {it:nwcommands} is available in
{bf:{help nw_alphabetical:[NW-3] intro}}. There are some general
categories:

{pstd}
{bf:{help nw_topical##concepts:[NW-2] Concepts}}{p_end}
{pstd}
{bf:{help nw_topical##import:[NW-2] Import/Export}}{p_end}
{pstd}
{bf:{help nw_topical##generators:[NW-2] Generators}}{p_end}
{pstd}
{bf:{help nw_topical##information:[NW-2] Information}}{p_end}
{pstd}
{bf:{help nw_topical##manipulation:[NW-2] Manipulation}}{p_end}
{pstd}
{bf:{help nw_topical##analysis:[NW-2] Analysis}}{p_end}
{pstd}
{bf:{help nw_topical##utilities:[NW-2] Utilities}}{p_end}
{pstd}
{bf:{help nw_topical##visualization:[NW-2] Visualization}}{p_end}
{pstd}
{bf:{help nw_topical##helpers:[NW-2] Programming helpers}}{p_end}


{col 8}[NW-2] entry{col 28}Description
{col 8}{hline 61}

{marker concepts}{...}
{p2colset 12 35 36 2}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}        {it:Concepts}        {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help netexample}}}list of all example networks{p_end}
{p2col:{bf:{help netlist}}}concept similar to varlist{p_end}
{p2col:{bf:{help netname}}}concept similar to varname{p_end}

{marker import}{...}
{p2colset 12 35 34 2}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}     {it:Import/Export}      {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help nwexport}}}exports network to pajek{p_end}
{p2col:{bf:{help nwimport}}}imports network from other file-formats{p_end}
{p2col:{bf:{help nwsave}}}saves network dataset{p_end}
{p2col:{bf:{help nwuse}}}uses network dataset{p_end}
{p2col:{bf:{help nwfromedge}}}generates network from edgelist{p_end}
{p2col:{bf:{help nwtoedge}}}generates edgelist{p_end}

{marker generators}{...}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Generators}       {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help nwassortmix}}}produces a homophily network{p_end}
{p2col:{bf:{help nwdyadprob}}}generates network based on tie probabilities{p_end}
{p2col:{bf:{help nwexpand}}}expands attribute as a network{p_end}
{p2col:{bf:{help nwgenerate}}}generates network; similar to generate{p_end}
{p2col:{bf:{help nwgeodesic}}}calculates geodesic distances{p_end}
{p2col:{bf:{help nwrandom}}}generates random network{p_end}
{p2col:{bf:{help nwpermute}}}makes network permutation{p_end}
{p2col:{bf:{help nwset}}}sets a network; similar to e.g. stset{p_end}
{p2col:{bf:{help nwtranspose}}}transposes a network{p_end}

{marker information}{...}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Information}      {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help nwdyads}}}calculates dyad census{p_end}
{p2col:{bf:{help nwcurrent}}}gives information about the current network{p_end}
{p2col:{bf:{help nwinfo}}}display some network information{p_end}
{p2col:{bf:{help nwname}}}basic network information{p_end}
{p2col:{bf:{help nwsummary}}}some summary information{p_end}
{p2col:{bf:{help nwtable}}}two-way tabulate of two networks or network and attribute{p_end}
{p2col:{bf:{help nwtabulate}}}one-way tabulates tie values of a network{p_end}
{p2col:{bf:{help nwtriads}}}calculates triad census of network{p_end}

{marker manipulation}{...}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}      {it:Manipulation}      {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help nwaddnodes}}}adds nodes to a network{p_end}
{p2col:{bf:{help nwdrop}}}drops a network; similar to drop{p_end}
{p2col:{bf:{help nwdrop:nwdropnodes}}}drops nodes from a network{p_end}
{p2col:{bf:{help nwkeep}}}keeps certain networks{p_end}
{p2col:{bf:{help nwkeep:nwkeepnodes}}}keep certain nodes of a network{p_end}
{p2col:{bf:{help nwreplace}}}replaces tie values of a network; similar to replace{p_end}
{p2col:{bf:{help nwreplacemat}}}replaces tie values of a network with a Mata matrix{p_end}
{p2col:{bf:{help nwrecode}}}recodes tie values; similar to recode{p_end}
{p2col:{bf:{help nwsym}}}symmetrizes a network{p_end}

{marker analysis}{...}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}         {it:Analysis}       {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help nwcloseness}}}calculates closeness centrality{p_end}
{p2col:{bf:{help nwcomponents}}}calculates number and component memberships{p_end}
{p2col:{bf:{help nwcontext}}}derives attribute values from network neighbors{p_end}
{p2col:{bf:{help nwcorrelate}}}correlates two networks or network and attribute{p_end}
{p2col:{bf:{help nwdegree}}}calculates degree centrality{p_end}
{p2col:{bf:{help nwergm}}}runs exponentional random graph model{p_end}
{p2col:{bf:{help nwevcent}}}calculates eigenvector centrality{p_end}
{p2col:{bf:{help nwneighbor}}}derives list of network neighbors{p_end}
{p2col:{bf:{help nwqap}}}network quadratic assignment procedure{p_end}
{p2col:{bf:{help nwreach}}}calculates reach of a network{p_end}
{p2col:{bf:{help nwvalue}}}returns single tie value{p_end}

{marker utilities}{...}
{p2colset 12 35 34 2}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}       {it:Utilities}        {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help nwclear}}}clearls all networks; similar to clear{p_end}
{p2col:{bf:{help nwload}}}loads a network as Stata variables{p_end}
{p2col:{bf:{help nwrename}}}renames a network{p_end}
{p2col:{bf:{help nwsync}}}syncs a network with Stata variables{p_end}
{p2col:{bf:{help nwtomata}}}obtains Mata matrix of network{p_end}
{p2col:{bf:{help nwvalidate}}}validates a network name{p_end}
{p2col:{bf:{help nwvalidvars}}}validats Stata variables of a network{p_end}

{marker visualization}{...}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}     {it:Visualization}      {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help animate}}}produces animated-gifs{p_end}
{p2col:{bf:{help nwmovie}}}makes movie out of network sequence{p_end}
{p2col:{bf:{help nwplot}}}plots a network{p_end}
{p2col:{bf:{help scheme-s1network}}}network scheme1{p_end}
{p2col:{bf:{help scheme-s2network}}}network scheme2{p_end}
{p2col:{bf:{help scheme-s3network}}}network scheme3{p_end}

{marker helpers}{...}
{col 8}   {c TLC}{hline 24}{c TRC}
{col 8}{hline 3}{c RT}  {it:Programming helpers}   {c LT}{hline}
{col 8}   {c BLC}{hline 24}{c BRC}
{p2colset 12 35 36 2}
{p2col:{bf:{help _extract_valuelables}}}extract value labels{p_end}
{p2col:{bf:{help _nwevalnetexp}}}evaluates a network expression(length if complex){p_end}
{p2col:{bf:{help _nwsyntax}}}checks network syntax{p_end}
{p2col:{bf:{help _nwsyntax_other}}}checks other network syntax{p_end}
{p2col:{bf:{help _opt_oneof}}}small utility program for options{p_end}
{p2col:{bf:{help nwcompressobs}}}compresses observations{p_end}
