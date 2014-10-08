{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##generator:[NW-2.3] Generators}
{cmd:help nwassortmix}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwassortmix {hline 2}}Generate a homophilious network{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwassortmix} 
{help var}
{cmd:,}
{opt homophily(float)}
{opt density(float)}
[{opt mode}({help nwexpand##expand_mode:expand_mode})
{opt nodes(integer)}
{opt name(string)}
{opt stub(string)}
{opt xvars}
{opt undirected}


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt homophily}({it:float})}degree of homophily{help var} is used{p_end}
{synopt:{opt density}({it:float})}density of the new network{p_end}
{synopt:{opt mode}({help nwexpand##expand_mode:expand_mode})}mode used to generate probabilities for ties{p_end}
{synopt:{opt nodes}({it:integer})}number of nodes; if not specified the number of valid cases of {help var} is used{p_end}
{synopt:{opt name}({it:new}{it:{help netname}})}name of the new random network{p_end}
{synopt:{opt stub}(string)}stub used for variable names{p_end}
{synopt:{opt xvars}}do not generate Stata variables{p_end}


{title:Description}

{pstd}
{cmd:nwassortmix} generates a homophilious network using {help nwdyadprob}. Each 
possible tie has the probability p_ij to exist, where p_ij is derived from a weight w_ij and 
the values defined in {it:homophily} and {it:density}. The weight w_ij is calculated on the
basis of the identity/similarity of nodes i and j on variable {help var} (using {it:mode}; see also {help nwexpand}).

{pstd}
The default is w_ij = (var[i] == var[j]), i.e. node i and node j have the same value on {help var}.

{pstd}
With {cmd: mode(absdiff)}, w_ij = abs(var[i] - var[j]); see {help nwexpand}

{pstd}
The probability p_ij is defined as p_ij =  ((w_ij * homophily) / (sum (w_kl * homophily))) * density * 100

{pstd}
The command is a {help nwgenerator} and can be used whenever such an element is allowed. 


{title:Examples}
	
	{cmd:. nwclear}

	// Generate a variable gender
	{cmd:. set obs 20}
	{cmd:. gen gender = (_n > 10) + 2}
	{cmd:. gen genderlabel = "Name"}
	{cmd:. label define genderlabel 2 "male" 3 "female"}
	{cmd:. label values gender genderlabel}

	// Generate network with homophily = 0
	{cmd:. nwassortmix gender, density(0.05) homophily(0)}
	{cmd:. nwplot, color(gender) layout(circle) title("homophily = 0")}
	{cmd:. graph save g1, replace}
	
	// Generate network with homophily = 5
	{cmd:. nwassortmix gender, density(0.05) homophily(5)}
	{cmd:. nwplot, color(gender) layout(circle) title("homophily = 5")}
	{cmd:. graph save g2, replace}
	
	// Generate network with homophily = -5
	{cmd:. nwassortmix gender, density(0.05) homophily(-5)}
	{cmd:. nwplot, color(gender) layout(circle) title("homophily = -5")}
	{cmd:. graph save g3, replace}

	// Show result
	{cmd:. graph combine g1.gph g2.gph g3.gph}

{title:See also}
	{help nwdyadprob}
