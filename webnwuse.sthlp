{smcl}
{* *! version 1.0.4  20nov2014 author: Thomas Grund}{...}
{marker topic}
{helpb nw_topical##import:[NW-2.2] Import/Export}

{title:Title}

{p2colset 9 17 23 2}{...}
{p2col :webnwuse {hline 2} Load network data over the web}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Load network data over the web

{p 8 16 2}
{cmd:webnwuse} [{cmd:"}]{it:{help filename}}[{cmd:"}] [{cmd:,} {cmd:nwclear}]


{phang}
Report URL from which datasets will be obtained

{p 8 16 2}
{cmd:webnwuse} {cmd:query}


{phang}
Specify URL from which network dataset will be obtained

{p 8 16 2}
{cmd:webnwuse} {cmd:set} [{it:http://}]{it:url}[{cmd:/}]


{phang}
Reset URL to default

{p 8 16 2}
{cmd:webnwuse} {cmd:set}


{marker description}{...}
{title:Description}

{pstd}
{cmd:webnwuse} {it:filename} loads the specified network dataset, obtaining it
over the web and {help nwset:sets all networks} in this dataset. By default, datasets are obtained from
{it:http://nwcommands.org/data}. 

{pstd}
Several {help netexample:network datasets} are available from this source. If {it:filename} is specified without a suffix, {cmd:.dta} is assumed.

{pstd}
{cmd:webnwuse} {cmd:query} reports the URL from which network datasets will be obtained.

{pstd}
{cmd:webnwuse} {cmd:set} allows you to specify the URL to be used as the source
for network datasets.  

{pstd}
{cmd:webnwuse} {cmd:set} without arguments resets the source
to {it:http://nwcommands.org/data}.


{marker option}{...}
{title:Option}

{phang}
{cmd:nwclear} specifies that it is okay to replace all network data in memory, even
though the current network data have not been saved to disk.


{marker examples}{...}
{title:Examples}

{pstd}Report URL from which network datasets will be obtained{p_end}
{phang2}{cmd:. webnwuse query}

{pstd}Change URL from which datasets will be obtained{p_end}
{phang2}{cmd:. webnwuse set http://www.zzz.edu/users/~sue}

{pstd}Reset URL to the default{p_end}
{phang2}{cmd:. webnwuse set}

{pstd}Load the {help netexample:Florentine network dataset} that is stored at 
http://nwcommands.org/data{p_end}
{phang2}{cmd:. webnwuse florentine}

{pstd}Equivalent to above command{p_end}
{phang2}{cmd:. webnwuse http://nwcommands.org/data/florentine}{p_end}

{title:See also}

	{help nwuse}, {help nwimport}, {help webuse}
