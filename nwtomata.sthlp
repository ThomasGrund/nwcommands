{smcl}
{* *! version 1.0.1  16may2012 author: Thomas Grund}{...}
{cmd:help nwtomata
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :nwtomata {hline 2}}Converts network to Mata{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: nwtomata} 
{it: varlist}
[{cmd:, }
{opt mat(matname)}
{opt copy}
]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt mat(matname)}}name of the Mata matrix{p_end}
{synopt:{opt copy}}create copy of Mata matrix and not just view{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
Most of the nw-commands described are programmed in Mata, which is Stata’s
built in matrix programming language, see help mata in Stata. You do not need to know
Mata to use the nw-commands, but sometimes it may be more convenient to use Mata instead
of Stata, as Mata is extremely fast. To make it easier to move back and forth between Mata and
Stata, there are two Stata commands nwtomata and nwtostata.{cmd: nwtomata} creates a matrix in Mata that is a so-called view onto the data contained in the
variables varlist. A view in Mata is a way of accessing the data stored in the current Stata
dataset, while using a minimum amount of extra memory, see help mata st_view. A view
makes it also possible to change the dataset from within Mata. The view in Mata will have as
many rows as there are observations in the current dataset, and as many columns as there are
variables in {it: varlist}. If you do not specify any {it: varlist}, the default varlist is {it: var*}, that is, the variables that make up
the adjacency matrix. By default, these variables are used to create a view called {it: nwadjview}
in Mata. When you use a view in Mata, you access it by its name followed by [.,.] (starting bracket, dot,
comma, dot, closing bracket), for example, you write {it: nwadjview [.,.]} instead of {it: nwadjview.} If
you omit the [.,.] and just write the name, you will automatically create and access a copy of
the view instead of the view itself.

{title:Options}


{dlgtab:Main}

{phang}
{opt mat(matname)} Used to specify the name for the new view that is created.

{phang}
{opt copy} Neads to be specified if, instead of a view, you prefer to create a matrix in Mata that is a
copy of the Stata dataset in memory. A copy consumes more memory, but this option is useful
when you want to change the content of the copy without changing the content of the Stata
dataset currently in memory.


{title:Remarks}

{pstd}
None. 


{title:Examples}
{cmd:. nwrandom 20, prob(.1)}
{cmd:. nwtomata}
{cmd:. mata: nwadjview}

{title:Also see}

{psee}
Online:  {help nwtostata}
{p_end}