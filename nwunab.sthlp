{smcl}
{* *! version 1.0.4.1  18nov2014}{...}
{marker topic}
{helpb nw_topical##utilities:[NW-2.7] Utilities}
{p2colset 5 15 19 2}{...}
{p2col :{cmd:nwunab} {hline 2}}Unabbreviate network list{p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{pstd}
Expand and unabbreviate standard {help netlist:network lists}

{p 8 13 2}{cmd:nwunab} {it:lmacname} {cmd::} {help netlist} [{cmd:,}
        {cmd:min(}{it:#}{cmd:)} {cmd:max(}{it:#}{cmd:)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nwunab} expands and unabbreviates a {help netlist:netlist} of existing networks,
placing the results in the local macro {it:lmacname}.  {cmd:nwunab} is a
low-level parsing command and works in exactly the same way as {help unab}.  One can
also use {help nwds} to unabbreviate network lists. The 
{help _nwsyntax} command is a high-level parsing
command that, among other things, also unabbreviates network lists; see
{help _nwsyntax}. 

{marker options}{...}
{title:Options}

{phang}{cmd:min(}{it:#}{cmd:)} specifies the minimum number of networks
allowed.  The default is {hi:min(1)}.

{phang}{cmd:max(}{it:#}{cmd:)} specifies the maximum number of networks
allowed.  The default is {hi:max(9999)}.


{marker examples}{...}
{title:Examples}

{pstd}
Within a program low-level parsing of network lists might be needed.  For instance,

      {cmd:nwuse glasgow, nwclear}
      {cmd:nwunab nets : glasg*}
      {cmd:nwinfo }
		
{pstd}
The local macro {hi:nets} would then contain the unabbreviated network
list in standard form.

{title:See also}

	{help unab}, {help nwds}, {help _nwsyntax}
