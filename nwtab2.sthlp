{smcl}
{* *! version 1.0.0  3sept2014}{...}

{title:Title}

{p2colset 9 20 23 2}{...}
{p2col :nwtabulate {hline 2} Two-way table of networks and attribute}
{p2colreset}{...}


{title:Syntax}

  Two networks
  
{p 8 17 2}
{cmdab: nwtab:ulate} 
{it:{help netname:netname1}}
{it:{help netname:netname2}}
[{cmd:,}
{opt plot}
{opt plotoptions}({it:{help tabplot:tabplot_options}})
{it:{help tabulate twoway:tabulate2_options}}]

  One network and one attribute
  
{p 8 17 2}
{cmdab: nwtab:ulate} 
[{it:{help netname:netname1}}]
{it:{help varname}}
[{cmd:,}
{opt plot}
{opt plotoptions}({it:{help tabplot:tabplot_options}})
{it:{help tabulate twoway:tabulate2_options}}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt plot}}makes a tabplot{p_end}


{title:Description}

{pstd}
This is the network version of {help tabulate twoway}.

{pstd}
{cmd:nwtabulate} produces a two-way table of either 1) two networks or 2) one network and one attribute 
variable. In the case of two networks, it shows the overlap of two networks. In the case of one
network and one attribute it shows the network ties by group membership of the nodes.

{pstd}
The command also calculates the E-I-index (Krackhardt and Stern 1988). The Krackhardt E/I Ratio
is a social network measure of the relative density of internal connections within a social group 
compared to the number of connections that group has to the external world. 

	{it:EI-index = (E - I) / (E + I)}

{pstd}
where I (internal) is the number of ties within a social group G and E is 
the number of ties to the external world (outside of group G). The EI-index ranges 
between -1 (only within-group ties exist) and 1 (only between-group ties exist). 

{pstd}
More intuitively, the EI-index simply calculates the number of 
ties off the diagonal (in the table produced by the command)
by the the total number of ties.

{pstd}
The command essentially generates temporary variables on the dyad-level and runs a normal {help tabulate twoway}, hence,
all {help tabulate twoway:tabulate2_options} can be used.  

{pstd}
The option {bf:plot} generates a {help tabplot}.

{title:Two networks}

{pstd}
When two networks are given, the command produces a two-way table that shows the overlap
of these two networks. 

{pstd}
For example, this loads the Glasgow {help netexamle:data} and shows the overlap between
wave1 and wave2. Technically, it creates a temporary dyad-level variable for each network
and runs a normal {help tabulate twoway}.


	{cmd}. webnwuse glasgow
	{com}. nwtabulate glasgow1 glasgow2
	{res}
	{txt}   Network 1:  {res}glasgow1{txt}{col 38}Directed: {res}true{txt}
	{txt}   Network 2:  {res}glasgow2{txt}{col 38}Directed: {res}true{txt}


		  {c |}       glasgow2
	 glasgow1 {c |}         0          1 {c |}     Total
	{hline 10}{c +}{hline 22}{c +}{hline 10}
	{txt}	     0 {c |}{res}     2,278         59 {txt}{c |}{res}     2,337 
	{txt}        1 {c |}{res}        56         57 {txt}{c |}{res}       113 
	{txt}{hline 10}{c +}{hline 22}{c +}{hline 10}
	    Total {c |}{res}     2,334        116 {txt}{c |}{res}     2,450 


	{txt}   E-I Index: {res}-.9061224489795918{txt}

{pstd}
This shows that 2278 possible ties do not exist in both wave1 ({it:glasgow1}) and wave2 ({it:glasgow2}) in the Glasgow
data. Furthermore, 56 ties do exist in wave1, but not in wave2. Similarly,
59 do not exist in wave1, but do exist in wave2; 57 ties exist in both wave1 and wave2. 


{title:One network and one attribute}

{pstd}
When one network and one attribute is given, the command
produces a two-way table that indicates the number of ties between
network nodes with certain attributes. This can be used to 
detect homophily in a network (the tendency for ties to exist between similar 
nodes).  

{pstd}
For example:

	{cmd}. webnwuse gang
	{cmd}. nwtabulate gang Birthplace

	{res}
	{txt}   Network:  {res}gang{txt}{col 36}Directed: {res}false{txt}
	{txt}   Attribute:  {res}Prison{txt}

		The network is undirected.
		The table shows two entries for each edge.


		   {c |}        Prison
	    Prison {c |}         0          1 {c |}     Total
	{hline 11}{c +}{hline 22}{c +}{hline 10}
	{txt}         0 {c |}{res}       170        155 {txt}{c |}{res}       325 
	{txt}         1 {c |}{res}       155        150 {txt}{c |}{res}       305 
	{txt}{hline 11}{c +}{hline 22}{c +}{hline 10}
	     Total {c |}{res}       325        305 {txt}{c |}{res}       630 

	 
{pstd}{txt}
This shows that out of 630 directed co-offending ties in the gang network, 170 ties
are between two gang members who were both not in prison before, 150 are between two gang
members who have both been in prison and 155 ties are between one gang member who has been
in prison and one who has not been in prison before. 

{pstd}
This example produces a plot and sends some options to {help tabplot}.

{pmore}
	{cmd:.nwtabulate gang Prison, plot plotoptions(xtitle(Alter was in prison, size(huge)) ytitle(Ego was in prison, size(huge)))}

	
{title:See also}

	{help one-way nwtabulate:nwtab1}, {help nwcorrelate}, {help nwqap}, {help tabulate}
