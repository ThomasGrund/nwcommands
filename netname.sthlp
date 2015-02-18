{smcl}
{* *! version 1.0.6  16may2012 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##concept:[NW-2.1] Concepts}

{title:Description}

{pstd}
A {it:netname} is one network name, such as 

{p 8 34 2}{cmd:x}{p_end}
{p 8 34 2}{cmd:mynet}{p_end}
{p 8 34 2}{cmd:flobusiness}{p_end}
{p 8 34 2}{cmd:flomarriage}{p_end}
{p 8 34 2}{cmd:friendship}{p_end}
{p 8 34 2}{cmd:friendship_wave2}{p_end}
{p 8 34 2}{cmd:_advice}{p_end}
{p 8 34 2}{cmd:_1994}{p_end}

{pstd}
Network names may be 1 to 32 characters long and must start with 
{cmd:a}-{cmd:z}, {cmd:A}-{cmd:Z}, or {cmd:_}, and the remaining 
characters may be 
{cmd:a}-{cmd:z}, {cmd:A}-{cmd:Z}, {cmd:_}, or {cmd:0}-{cmd:9}.

{pstd}
When we use the term netname, we usually mean an existing netname -- a
network that already exists in Stata, i.e. it has been setted by {it: {help nwset}}, loaded or created by a {it: {help nwgenerator}}. The alternative would be a
{it:{help newnetname}}.

{pstd} 
When referring to an existing netname, we can abbreviate. We can use a {it: {help netlist}} notation, which is similar to the {it:{help varlist}} notation, but 
it must identify one network:

{pin}
{cmd:flob*} might uniquely identify {cmd:flobusiness}

{pin}
{cmd:friend*2} might uniquely identify
{cmd:friendship_wave2}.

{pstd}
In the netlist notation, 
{cmd:*} means that zero or more characters go here. Netnames are often specified inside options and then usually the netlist notation is allowed.

{pstd}
A list of all currently available networks is returned by {it: {help nwset}}. 

{pstd}
For most network commands a netname is optional. When no netname is explicitly specified the most current network is used. To find out which network is the current network and 
to change the current network use {it: {help nwcurrent}}.
 Furthermore, {it: {help nwload}} also changes the current network. 


{marker examples}{...}
{title:Examples}

{phang}{cmd:. nwuse florentine}{p_end}
{phang}{cmd:. nwset}{p_end}
{phang}{cmd:. nwdegree flobusiness}{p_end}
{phang}{cmd:. nwcomponents *marriage}{p_end}

