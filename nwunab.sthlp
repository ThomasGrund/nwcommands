{smcl}
{* *! version 1.0.0  9sept2014}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}

{p2colset 9 15 19 2}{...}
{p2col :{cmd:nwunab} {hline 2} Unabbreviate network list}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{pstd}
Expand and unabbreviate {help netlist:network lists}

{p 8 13 2}{cmd:nwunab} {it:lmacname} {cmd::} {it:{help netlist}} [{cmd:,}
        {cmd:min(}{it:#}{cmd:)} {cmd:max(}{it:#}{cmd:)}]


{marker description}{...}
{title:Description}

{pstd}
This is the network version of {help unab}. {cmd:nwunab} expands
and unabbreviates a {help netlist:netlist} of existing networks,
placing the results in the local macro {it:lmacname}.  {cmd:nwunab} is a
low-level parsing command and works in exactly the same way as {help unab}.  One can
also use {help nwds} to unabbreviate network lists. The 
{help _nwsyntax} command is a high-level parsing
command that, among other things, also unabbreviates network lists; see
{help _nwsyntax}. 


{marker options}{...}
{title:Options}

{phang}{cmd:min(}{it:#}{cmd:)} specifies the minimum number of networks
allowed. The default is {hi:min(1)}.

{phang}{cmd:max(}{it:#}{cmd:)} specifies the maximum number of networks
allowed. The system maximum is 9999.


{marker examples}{...}
{title:Examples}

	{cmd:. webnwuse glasgow, nwclear}
	{cmd:. nwunab nets : glasg*}
	{cmd:. di `nets'}
	     {txt}glasgow1 glasgow2 glasgow3
		

{title:See also}

	{help unab}, {help nwds}, {help _nwsyntax}
