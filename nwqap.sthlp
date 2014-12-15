{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwqap  {hline 2} Multivariate QAP regression}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwqap} 
{it:{help netname:depnet}}
[{it:{help nwqap##independentvariables:indepvars}}]
, 
{opth permutations(int)}
{opt mode}({it:{help nwexpand##expand_mode:mode}})
{opt type(regcmd)}
{opt typeoptions(regoptions)}
{opt detail}
{opt save}({it:{help filename}})



{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth permutations(int}}number of QAP permutations; default = 500{p_end}
{synopt:{opt mode}({it:{help nwexpand##expand_mode:mode}})}modes for expanding variables to networks{p_end}
{synopt:{opt type}({it:{help nwqap##regcmd:regcmd}})}regression command to be used for dyad dataset; default = {it:logit}{p_end}
{synopt:{opt typeoptions(regoptions)}}options to be passed on to the regression command{p_end}
{synopt:{opt detail}}display details of regression results{p_end}
{synopt:{opt save}({it:{help filename}})}save coefficients from permutations in file{p_end}


{title:Description}

{pstd}
MR-QAP is a multiple regression procedure used to assess the impact of independent variables 
upon a dependent variable. In standard regression techniques, the typical “unit of analysis” 
is an individual observation. In MR-QAP analysis, the unit of analysis is a dyad, a pair of individuals 
who may or may not have some sort of relation connecting them to one another.

{pstd}
{cmd:nwqap} reshapes a network to a dataset of edges/arcs. For example, a directed network with 10 nodes is 
transformed in a dataset with 90 dyads (selfloops are not permitted).

{pstd}
The dependent variable is {it:y_ij}, indicating the network relationship between nodes
{it:i} and {it:j}.{p_end} 
{marker independentvariables}{...}
{pstd}Independent variables can be other {help netname:networks} or normal {help varname:variables}.  
Normal variables are expanded to networks of the same size as the dependent network using 
{help nwexpand}. The default {bf:mode} is {bf:"same"} (see {help nwexpand##mode:here} for other modes.
When more than one {help varname} is specified as independent variable, different modes can be 
selected for each variable, e.g. {bf:mode(same dist invdist)} chooses mode {bf:"dist"} for the 
second {help varname} that appears as independent variable.{p_end}   
{marker regcmd}{...}
{pstd}
{cmd:nwqap} performs the regression specified in {bf:type()}, by default {help logit} regression
is choosen. But notice that any other type of regression can be used (e.g. {help probit}, {help xtmixed}).
Furthermore, options are passed on to the selected regression command with {bf:typeoptions()}.
This gives a lot of flexibility to perform dyad-level regression. For example instead of logistic 
regression one can use probit regression with option {it:asis}:

	{bf:nwqap glasgow2 glasgow1, type(probit) typeoptions(asis)} 

{pstd}
The raw output of this dyad-level regression is displayed with option {bf:detail}.

{pstd}
Once a dataset is assembled and a regression is carried out, the resulting coefficients indicate 
the direction of the effect of independent variables upon the dependent variable. However, calculating 
the standard error of these coefficients has been shown to lead to biased results when autocorrelation 
exists – which occurs, for instance, when interpersonal relations determine individual behavior 
(Krackhardt 1988). 

{pstd}
Since this method is employed to test hypotheses that suggest interpersonal relations 
matter, a different significance test is needed. The second step of QAP regression, therefore, is to repeatedly permute rows and columns of the matrix representing the dependent variable and after each permutation to re-compute
regression coefficients. Indicators of statistical significance report the proportion of results from randomly altered matrices with 
regression coefficients as high as those from the unaltered dependent variable matrix (Krackhardt 1987).

{pstd}
In this second step, {cmd:nwqap} randomly permutes rows and columns (together) of the dependent 
matrix (dependent network) and recomputes the regression, storing all coefficients. By default this step 
is repeated 500 times. The number of permutations can be changed with the option {bf:permutations}.
The coefficients of all these permutations are saved with {opth save(filename)}. Based one the distribution
of coefficients, {cmd:nwqap} calculates adjusted p-values and saves them in {it:e(pvalues)}.


{pstd}
{it:References}

{pmore}
Krackhardt, David. 1987. “QAP Partialling as a Test of Spuriousness.” Social Networks 9: 171-186.

{pmore}
Krackhardt, David. 1988. “Predicting with Networks: Nonparametric Multiple Regression Analysis of Dyadic Data.” Social Networks 10: 359-381.


{title:Examples}
	
	{cmd:. webnwuse glasgow}
	{cmd:. nwqap glasgow2 glasgow1 smoke1 sport1}


	{txt}Multiple Regression Quadratic Assignment Procedure

	{txt}  Estimation{col 25}={res}  QAP
	{txt}  Regression{col 25}={res}  logit
	{txt}  Permutations{col 25}={res}  500
	{txt}  Number of vertices{col 25}=  {res}50
	{txt}  Number of arcs{col 25}=  {res}116

{txt}{hline 23}{c TT}{hline 25}
{col 2}{ralign 21:glasgow2}{col 24}{c |}{col 31}Coef.{col 40}P-value
{hline 23}{c +}{hline 25}
{txt}{col 2}{ralign 21:glasgow1}{col 24}{c |}{col 25}{ralign 11:{res}3.652579}{col 40}{ralign 5:0}
{txt}{txt}{col 2}{ralign 21:same_smoke1}{col 24}{c |}{col 25}{ralign 11:{res}.514058}{col 40}{ralign 5:.018}
{txt}{txt}{col 2}{ralign 21:same_sport1}{col 24}{c |}{col 25}{ralign 11:{res}.217359}{col 40}{ralign 5:.394}
{txt}{col 2}{ralign 21:_cons}{col 24}{c |}{col 25}{ralign 11:{res}-4.125208}
{txt}{hline 23}{c BT}{hline 25}
	
{pstd}
This example shows that two individuals are more likely to be friends at time2 (glasgow2) 
when they already were friends at time1 (glasgow1). Furthermore two individuals {it:i} and
{it:j} are more likely to be friends at time2 when they both scored the same on smoking at
time1 (smoke1). There is no effect for both having scored the same on sport1. 


{title:Stored results}

	Matrices
	  {bf:e(pvalues)}	matrix with QAP p-values
	
{title:See also}

	{help nwergm}, {help nwpermute}



