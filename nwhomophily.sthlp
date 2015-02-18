{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}

{title:Title}

{p2colset 9 20 22 2}{...}
{p2col :nwhomophily {hline 2} Generate a homophily network}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwhomophily} 
{it:{help varlist}}
{cmd:,}
{opt homophily}({it:{help float:h1 h2 ...}})
{opth density(float)}
[{opt mode}({it:{help nwexpand##expand_mode:expand_mode}})
{opth nodes(integer)}
{opth name(string)}
{opth stub(string)}
{opt xvars}
{opt undirected}


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt homophily}({it:{help float:h1 h2 ...}})}degree of homophily for each variable in {help varlist}{p_end}
{synopt:{opth density(float)}}density of the new network{p_end}
{synopt:{opt mode}({it:{help nwexpand##expand_mode:expand_mode}})}mode used to generate probabilities for ties{p_end}
{synopt:{opth nodes(integer)}}number of nodes; if not specified the number of valid cases of {it:{help varname}} is used{p_end}
{synopt:{opth name(newnetname)}}name of the new random network{p_end}
{synopt:{opth stub(string)}}stub used for variable names{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwhomophily} generates a homophily network - a network where ties between nodes {it:i} and {it:j} are 
more/less likely to exist when the two nodes have the same values on {help varlist}. Basically, this command 
is a convenience wrapper for {help nwdyadprob}. 

{pstd}
Each possible tie in the new network has the probability {it:p_ij} to exist. These proabilities are 
derived from a weight {it:w_ij} and the values defined in {bf:homophily()} and {bf:density()}. 

{pstd}
The weight {it:w_ij} is calculated on the basis of the identity/similarity of nodes {it:i} and {it:j} 
on variables in {help varlist} (see {help nwexpand}). By default, 

{pmore}
{it:w_ij = (varname[i] == varname[j])}, i.e. node {it:i} and node {it:j} have the same 
value on a variable.

{pstd}
Another way to calculate {it:w_ij} would be using {bf: mode(absdiff)}

{pmore}
{it:w_ij = abs(var[i] - var[j])}

{pstd}
For more information on how {it:w_ij} is calculated based on {bf:mode()} see {help nwexpand}.

{pstd}
The probability {it:p_ij} is defined as:

{pmore}
{it:p_ij =  ((w_ij * homophily) / (sum (w_kl * homophily))) * density * 100}

{pstd}
The following example generates a variable {it:gender} and creates networks where ties are more likely to
exist between nodes with the same gender.

	{cmd:. nwclear}
	{cmd:. set obs 20}
	{cmd:. gen gender = (_n > 10) + 2}
	{cmd:. gen genderlabel = "Name"}
	{cmd:. label define genderlabel 2 "male" 3 "female"}
	{cmd:. label values gender genderlabel}

{pstd}
So far, we just generated the variable {it:gender}. The next step produces the homophily network based on this 
variable and a positive {bf:homophily()} effect. The size of this effect can be interpreted just like a logistic
regression coefficient for homophilious ties to exist (conditioning on {bf:density()}).

	{cmd:. nwhomophily gender, density(0.05) homophily(5)}
	{cmd:. nwplot, color(gender) layout(circle) title("homophily = 5")}
	{cmd:. graph save g1, replace}
	
{pstd}
Next, we produce a network with a negative homophily parameter (heterophily). In this network, ties are more likely
between nodes of different gender.
	
	{cmd:. nwhomophily gender, density(0.05) homophily(-5)}
	{cmd:. nwplot, color(gender) layout(circle) title("homophily = -5")}
	{cmd:. graph save g2, replace}

{pstd}
Lastly, let us produce a network with no homohily effect at all.
	
	{cmd:. nwhomophily gender, density(0.05) homophily(0)}
	{cmd:. nwplot, color(gender) layout(circle) title("homophily = 0")}
	{cmd:. graph save g3, replace}
	
{pstd}
All three new networks can be displayed in comparison:

	{cmd:. graph combine g1.gph g2.gph g3.gph}

{pstd}
Notice that when {it:nwhomophily} is used together with {it:z} variables in {help varlist}, the option 
{bf:homophily()} also needs to have {it:z} entries. The next example also shows how the command works with
non-categorical variables. After generating a categorical variable {it:gender} and a metric variable {it:income},
this would generate a homophily network where ties are less likely to exist between individuals with the same gender
(effect size = -5) and more likely to exist between individuals who have similar (not the same) income (effect size = 3).

	{cmd:. nwhomophily gender income, density(0.05) homophily(-5 3) mode(same abdsdist)}

	
{title:Remarks}

{pstd}
The program requires some additional programs ({bf:gsample, moremata}) that it will automatically install with a working internet connection. 

	
{title:See also}

	{help nwdyadprob}
