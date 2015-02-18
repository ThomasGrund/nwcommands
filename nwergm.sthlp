{smcl}
{* *! version 1.0.0  3sept2014}{...}
{marker topic}
{helpb nw_topical##analysis:[NW-2.6] Analysis}

{title:Title}

{p2colset 9 15 22 2}{...}
{p2col :nwergm  {hline 2} Exponential Random Graph Model}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwergm} 
[{it:{help netname:depnet}}]
, 
{opt formula}({it:ergmformula})
{opt rpath}({it:rpath})
{opt ergmoptions}({it:ergmoptions})
{opt ergmdetail}
{opt gof}
{opt gofoptions}({it:gofoptions})
{opt mcmc}
{opt mcmcoptions}({it:mcmcoptions})
{opt detail}
{opt keepfiles}
{it:{help twoway_options}}]



{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt formula(ergmformula)}}ERGM formula as specified in R {p_end}//(http://statnet.csde.washington.edu/EpiModel/nme/2014/d2-tut1.html:see this tutorial){p_end}
{synopt:{opt rpath}({it:rpath})}Location or R on your computers{p_end}
{synopt:{opt ergmoptions}({it:ergmoptions})}Options that are sent to {it:control=control.ergm}{p_end}
{synopt:{opt ergmdetail}}Show details of ERGM estimation{p_end}
{synopt:{opt gof}}Run Goodness-of-fit test and plot results{p_end}
{synopt:{opt gofoptions}({it:gofoptions})}Options for Goodness-of-fit test{p_end}
{synopt:{opt mcmc}}Run MCMC test and plot results{p_end}
{synopt:{opt mcmcoptions}({it:mcmcoptions})}Options for MCMC test{p_end}
{synopt:{opt detail}}Show details in output{p_end}
{synopt:{opt keepfiles}}Keep all intermediary files (e.g. R script, data, results){p_end}




{title:Description}

{pstd}
Basically, in ERGMs we simulate lots and lots of networks using certain 
network motifs (specified by the researcher) and then try to estimate 
parameters for these motifs (similar like logistic regression coefficients) 
in such a way that the observed network is most likely to to be drawn from the 
simulated distribution of networks (estimates are derived using Markov Chain 
Monte Carlo Maximum Likelihood Estimation). ERGMs are specifically designed 
to consider multiple network motifs and effects (for example, several homophily
effects) simultaneously. Furthermore, ERGMs can be specified to include structural 
effects like triadic closure, balance, and so on. One unique feature of ERGMs is 
that essentially the presence of a network tie is modeled conditional on other 
network configurations. At the core of an ERGM is the Markov assumption, i.e. 
network ties are modeled conditional on the present network in continuous time.
Hence, a generative process is modeled and MLE is performed based on this process. 
 
{pstd} 
One distinguishing feature of ERG models, in contrast to earlier attempts in modeling
networks is their ability to accommodate dependencies between the random variables. 
Earlier, so called p1 models (Holland and Leinhardt 1981) have long been popular and
implied the highly unrealistic assumption of dyadic independence, i.e. the probability 
for existence of a tie is independent from the existence of any other tie. An extension 
has been the introduction of p2 models (Lazega and van Duijn 1997), which also assume
dyadic independence, but conditional on node-level attribute effects. Most prominently
in p2 models, sender and receiver are included as random effects. Some nodes are more 
and others less likely to send/receive ties. Together with actor and dyadic effects 
(e.g. similarity of nodes) this yields more complex, but also more realistic models. 
ERG models (in this tradition also sometimes referred to as p* models), generalize these
previous attempts, but do not require the assumption of dyadic independence anymore. In 
networks, the probability for a tie to exist most often depends on the presence of other 
ties in the network. 

{pstd}
In ERGM's ties are endogenous to the estimation process. That means each tie is estimated
in a way that considers that this tie affects the presence of others ties and so on. This
is why we also call these models dyadic dependence models.

{pstd}
This command does not natively run in Stata. Instead, it produced R code and runs the model in R
using the statnet package (Handcock et al. 2003). The command is experimental and not fully tested. It also
does not give you all the flexibility of R.  


{pstd}
{bf:References}

{pmore}
Mark S. Handcock, David R. Hunter, Carter T. Butts, Steven M. Goodreau, and Martina Morris (2003).
statnet: Software tools for the Statistical Modeling of Network Data. URL.

{pmore}


{title:Examples}
	
	{cmd:. webnwuse gang}
	{cmd:. nwergm gang, formula(edges +  gwesp(alpha=.5, fixed=TRUE) + nodematch("Birthplace"))}


{pstd}
This produces a goodness-of-fit plot
	
	{cmd:. nwergm gang, formula(edges + nodematch("Birthplace") + nodematch("Prison") + absdiff("Age")) gof }
	
{pstd}
Notice that MCMC plots are only created for dyad-dependent models.	
	
{title:Stored results}

	ereturn list
	
	
{title:See also}

	{help nwqap}



