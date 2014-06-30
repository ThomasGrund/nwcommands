{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwfilledge
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwfilledge {hline 2}}Converts an edgelist from the compact format to the fully populated format{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwfilledge} 
{cmd:,}
{opt nnodes(nodes)}
[{opt expandfrom(varlist)}
{opt toexpand(varlist)}
{opt fromid(varname)}
{opt toid(varname)}
{opt link(varname)}
noexpandfrom]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt n:nodes(nodes)}}specifies the number of nodes.{p_end}
{synopt:{opt exp:andfrom(varlist)}}Specifies which of the variables shall be filled in so that they become
constant within {it: fromid}.{p_end}
{synopt:{opt toexp:and}}Specifies if the new observations shall be filled in for any variables so that
the variables become constant within {it: toid}.{p_end}
{synopt:{opt fromid(varname)}}Variable name specifying {it: fromid}.{p_end}
{synopt:{opt toid(varname)}}Variable name specifying {it: toid}.{p_end}
{synopt:{opt link(varname)}}Variable name specifying link. {p_end}
{synopt:{opt noexp:andfrom}}Fills in the new observations with missing values for variables that start with
the prefix from_..{p_end}






{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:nwfilledge} Convert an edgelist from the compact format to the fully populated format. When the new 
observations are created, the user can choose whether or not to fill in the values
of the new observations for attribute variables. Default is to expand and fill in 
the values for all variables that start with the prefix {it: from_}, so that the values 
become constant within {it: fromid}. Default is to fill in the observations with missing values 
for all other variables. 

{title:Options}

{dlgtab:Main}

{phang}
{opt n:nodes(nodes)} specifies the number of nodes. This must be specified if the edgelist is not in full
format, that is, if it does not contain n*n observations.

{phang}
{opt exp:andfrom(varlist)}}Specifies which of the variables shall be filled in so that they become
constant within {it: fromid}.

{phang}
{opt unw:eighted} Specifies if the new observations shall be filled in for any variables so that
the variables become constant within {it: toid}.

{phang}
{opt noexp:andfrom}Fills in the new observations with missing values for variables that start with
the prefix from_.

{title:Remarks}

{pstd}
None. 


{title:Examples}
To be written.

{title:Also see}
