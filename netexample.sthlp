{smcl}
{* *! version 1.0.2  17apr2009}
{marker topic}
{helpb nw_topical##concept:[NW-2.1] Concepts}
{hline}{...}
{bf:Example networks from http://nwcommands.org/data}
{pstd}The datasets listed are hosted on the nwcommands.org server.
{p_end}
{hline}

        gang{col 29}{stata "webnwuse gang":use} | {stata "sysdescribe gang.dta":describe}
        glasgow{col 29}{stata "webnwuse glasgow":use} | {stata "sysdescribe glasgow.dta":describe}
        florentine{col 29}{stata "webnwuse florentine":use} | {stata "sysdescribe florentine.dta":describe}
        stockholm{col 29}{stata "webnwuse stockholm":use} | {stata "sysdescribe stockholm.dta":describe}
			
{hline}
