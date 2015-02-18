{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 20 23 2}{...}
{p2col :nwcorrelate {hline 2} Correlate networks and variables}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwcorrelate} 
{it:{help netname:netname1}}
{it:{help netname:netname2}}
[
{opth permutations(int)}
{opth save(filename)}
{it:{help kdensity:kdensity_options}}]

{p 8 17 2}
{cmdab: nwcorrelate} 
{it:{help netname:netname}}
, 
{opth attribute(varname)}
[{opt mode}({it:{help nwexpand##expand_mode:expand_mode}})
{opth permutations(int)}
{opth save(filename)}
{it:{help kdensity:kdensity_options}}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt mode}({it:{help nwexpand##expand_mode:expand_mode})}}expand mode{p_end}
{synopt:{opt permutations(integer)}}number of QAP permuations{p_end}
{synopt:{opth save(filename)}}save QAP permuation results in file{p_end}


{title:Description}

{pstd}
This command is the network version of {help correlate}. It can be used in two different ways:

{pmore}
1) Correlate two networks with each other

{pmore}
2) Correlate one network and one variable

{pstd}
The option {bf:permutation()} creates {help nwqap:QAP permutations} of the first network and 
generates a distribution of correlation coefficients under the null-hypothesis that there is
no correlation. In practice, rows and columns of {help netname} are reshuffled and the correlation 
coefficient is calculated again and again. Based on this distribution a {it:p-value} and a confidence
interval is calculated. A plot is displayed and additional information is returned in the return vector. 


{title:Two networks}

{pstd}
When two networks {help netname:netname1} and {help netname:netname2} are given, 
the command calculates the element-by-element correlation of the underlying adjaceny matrices {it:M1}
and {it:M2} for the two networks. Notice, that the diagonal of the matrices is not considered. 

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


{title:Stored results}

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
