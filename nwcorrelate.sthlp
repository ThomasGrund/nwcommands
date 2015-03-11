{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 20 23 2}{...}
{p2col :nwcorrelate {hline 2} Correlate networks and variables}
{p2colreset}{...}


{title:Syntax}

     1) Correlate nodes of a network
		
{p 8 17 2}
{cmdab: nwcorrelate} 
{it:{help netname:netname}}
[{it:{help netexp:if}}]
[,
{opt context}({it:{help nwcontext##context:context}})
{opth name(newnetname)}]


     2) Correlate two networks with each other

{p 8 17 2}
{cmdab: nwcorrelate} 
{it:{help netname:netname1}}
{it:{help netname:netname2}}
[{it:{help netexp:if}}]
[,
{opth permutations(int)}
{opth save(filename)}
{it:{help kdensity:kdensity_options}}]


     3) Correlate one network and one variable
		
{p 8 17 2}
{cmdab: nwcorrelate} 
{it:{help netname:netname}}
[{it:{help netexp:if}}]
, 
{opth attribute(varname)}
[{opt mode}({it:{help nwexpand##expand_mode:expand_mode}})
{opth permutations(int)}
{opth save(filename)}
{it:{help kdensity:kdensity_options}}]


{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt context}({it:{help nwcontext##context:context})}}determines whether incoming or outgoing ties should be considered when correlating two nodes; default = {it:both}{p_end}
{synopt:{opth name(newnetname)}}name of new network with node correlations; default = {it:_corr}{p_end}
{synopt:{opt mode}({it:{help nwexpand##expand_mode:expand_mode})}}how to expand the attribute variable{p_end}
{synopt:{opt permutations(integer)}}number of QAP permuations{p_end}
{synopt:{opth save(filename)}}save QAP permuation results in file{p_end}


{title:Description}

{pstd}
This command is the network version of {help correlate}. It can be used in three different ways:

{pmore}
1) Correlate nodes of a network

{pmore}
2) Correlate two networks with each other

{pmore}
3) Correlate one network and one variable

{pstd}
The option {bf:permutation()} creates {help nwqap:QAP permutations} of the first network and 
generates a distribution of correlation coefficients under the null-hypothesis that there is
no correlation. In practice, rows and columns of {help netname} are reshuffled and the correlation 
coefficient is calculated again and again. Based on this distribution a {it:p-value} and a confidence
interval is calculated. A plot is displayed and additional information is returned in the return vector. 


{title:Nodes of one network}

{pstd}
When the command is used with one {help netname} and no {opt attribute()} option, it correlates the nodes of 
a network with each other. It takes the vector of outgoing, incoming (or both) ties of node {it:i} and correlates it 
with the vector of outgoing, incoming (or both) ties of node {it:j}. The context is specified in {opt context()}. 

{pstd}
The nodes {it:i} and {it:j} are excluded from the tie vectors when calculating the correlation between {it:i} and
{it:j}. For the network called {it: mynet} defined by the adjacency matrix in the following example, the command

{pmore}
{bf: nwcorrelate mynet, context(outgoing)}

{pstd}
produces the correlation matrix below (saved as a new network). In this
case only the outgoing ties are considered. For example, the score C[2,1] = 0.5 is the correlation of the two row
vectors for node 2 {it:(1,0,1,1) => (.,.,1,1)} and node 1 {it:(0,1,1,0) => (.,.,1,0)}. Notice that 
the nodes {it:i} and {it:j} are removed from the vectors.

{pstd}
The correlation {it:C_ij} between two nodes is 1 when the nodes {it:i} and {it:j} have exactly the same network
neighbors. The coefficient is -1 when the two nodes have no network neighbor in common.  

{pstd}
{bf:Adjacency matrix of network {it:mynet}}

{res}       {txt}1   2   3   4
    {c TLC}{hline 17}{c TRC}
  1 {c |}  {res}0   1   1   0{txt}  {c |}
  2 {c |}  {res}1   0   1   1{txt}  {c |}
  3 {c |}  {res}0   0   0   0{txt}  {c |}
  4 {c |}  {res}0   1   0   0{txt}  {c |}
    {c BLC}{hline 17}{c BRC}
	
{pstd}
{bf: Correlation between nodes}

        1    2    3    4
    {c TLC}{hline 21}{c TRC}
  1 {c |}  {res} 1               {txt}  {c |}
  2 {c |}  {res}.5    1          {txt}  {c |}
  3 {c |}  {res}-1   -1    1     {txt}  {c |}
  4 {c |}  {res}.5   -1   -1    1{txt}  {c |}
    {c BLC}{hline 21}{c BRC}

{pstd}
In this example, we first load the data from Zachary's Karate Club (saved in Ucinet format). These are 
data collected from the members of a university karate club by  Wayne Zachary (1977). The ZACHE network represents 
the presence or absence of ties among the members of the club; the ZACHC network indicates the relative
strength of the associations (number of situations in and outside the club in which interactions 
occurred).

{pmore}
{cmd:. nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/zachary.dat, type(ucinet)}

{pstd}
Next, let us calculate the correlation between nodes (which essentially gives us an idea about the overlap of 
ties between nodes). Remember that the correlation between two nodes is 1 when these two nodes share exactly
the same network neighbors. 

{pmore}
{cmd:. nwcorrelate ZACHE}

{pstd}
This generates the new network {it:_corr}, which holds the pair-wise node correlations. Now we can test
if ties between nodes are stronger when these nodes have many common network neighbors.

{pmore}
{cmd:. nwcorrelate ZACHC _corr if ZACHE != 0, permutations(200)}

{pstd}
Basically, we just proofed one part of Granovetter's (1973) strength of weak ties argument. It seems that ties
between two nodes are stronger when these nodes share many network neighbors. 



{title:Two networks}

{pstd}
When two networks {help netname:netname1} and {help netname:netname2} are given, 
the command calculates the correlation of the underlying adjaceny matrices {it:M1}
and {it:M2} for the two networks. Notice, that the diagonal of the matrices are not considered. 

{pstd}
The correlation coefficient for two networks indicates how much these two networks overlap. It is exactly
1 when the two networks completely overlap ({it:M1_ij == M2_ij}). It is -1 when the two networks are inverse
to each other ({it:M1_ij != M2_ij}).

{pstd}
This correlates two networks with each other:

	{cmd:. webnwuse glasgow}
	{cmd:. nwcorrelate glasgow1 glasgow2, permutations(50)}

	{res}{hline 40}
	{txt}  Network name: {res}glasgow1
	{txt}  Network2 name: {res}glasgow2
	{hline 40}
	{txt}    Correlation: {res}.4732457209617567{txt}
	
{pstd}
In this case, there is a moderate positive correlation between the two networks.

	
{title:One network and one attribute}

{pstd}
When the command is called with one {help netname} and one {help varname} (specified in {bf:attribute()})
it calculates the element-by-element correlation between the adjacency matrix {it:M} of {help netname} and 
an {help nwexpand:expanded network} based on {help varname}. 

{pstd}
Practically, it compares {it:M_ij} with {it:x_ij}, where

	{it:x_ij = mode(varname[i], varname[j])}

{pstd}	
By default, {it:mode} is set to {cmd:mode(same)}, which is (for other modes see {help nwexpand}):

	{it:same(x_ij) = (varname[i] == varname[j])}

{pstd}
Such dyad-level correlation between network ties and some artifically generated network based on some variable,
can be extremely useful to e.g. assess the level of homphily in a network. Homophily refers to the concept that
network ties might be more likely between similar individuals. 

{pstd}
The correlation coefficient between a network and a variable (with {it:mode=same}) is exactly 1 when ties 
only exist between individuals who are similar and -1 when ties only exist between individuals who are different
according to {help varname}. When an attribute is not categorical, but metric instead, it makes a lot of sense to 
use option {bf:mode(absdist)}.
	
{pstd}
This correlates one network and one attribute with each other:

	{cmd:. nwcorrelate glasgow1, attribute(sport1) permutations(50)}

	{res}{hline 40}
	{txt}  Network name: {res}glasgow1
	{txt}  Attribute: {res}same_sport1
	{hline 40}
	{txt}    Correlation: {res}.0253824782677835{txt}

	
{pstd}
There is hardly any correlation. Similarity on doing sports does not seem to matter for indivdiuals to have
friendship ties. Notice that the previous command is equivalent to:

	{cmd:. nwexpand sport1, mode(same) name(same_sport)}
	{cmd:. nwcorrelate glasgow1 same_sport, permutations(50)}	


	
{title:References}

{pstd}
Granovetter, M. (1973). The strength of weak ties. American Journal of Sociology, 78, 6, 1360-1380.

{pstd}
Zachary, W. (1977). An information flow model for conflict and fission in
small groups. Journal of Anthropological Research, 33, 452-473.


{title:Stored results}

{pstd}
{bf:Node correlations}

	Scalars:
	  {bf:r(avg_corr)}	average correlation coefficient between nodes

	Macros:
	  {bf:r(name)}	name of network
	  {bf:r(corrname)}	name of new network with coefficients

	  
{pstd}
{bf:Two networks or one network and one attribute}

	Scalars:
	  {bf:r(corr)}		correlation coefficient
	  {bf:r(pvalue)}	p-value of correlation coefficient
	  {bf:r(ub)}		upper bound, 95% confidence interval
	  {bf:r(lb)}		lower bound, 95% confidence interval

	Macros:
	  {bf:r(name_1)}	name of {it:netname1}
	  {bf:r(name_2)}	name of {it:netname2} or the expanded network 
	  

{title:See also}

	{help nwtabulate}, {help nwexpand}
