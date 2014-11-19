{smcl}
{* *! version 1.0.0  11aug2014}{...}
{marker topical}
{helpb nw_topical##visualization:[NW-2.8] Visualization}
{cmd:help animate}
{hline}

{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :animate {hline 2}}Animate graphs{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmdab: animate} 
{help filename}
{cmd:,}
{opt graphs(_all | g1 g2 g3...)}
[{opt imagickpath(path)} {opt delay(#)} {opt noloop} {opt showcommand} {opt keepeps}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt graphs(_all | g1 g2 g3...)}}graphs to be added to the movie{p_end}
{synoptline}
{syntab:Optional}
{synopt:{opt imagickpath(path)}}path of ImageMagick{p_end}
{synopt:{opt delay(#)}}milliseconds between frames{p_end}
{synopt:{opt noloop}}no loop of movie{p_end}
{synopt:{opt showcommand}}display ImageMagick command{p_end}
{synopt:{opt keepeps}}keep .eps files{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:animate} produces .eps files for each graph and adds them together to an animated-gif {help filename}. Command requires {net "http://www.imagemagick.org/":ImageMagick} to be installed on the computer.


{title:Examples}

{cmd:. webuse uslifeexp}
{cmd:. graph drop _all}
{cmd:. forvalues i = 1900(10)2000 {c -(}}
{cmd:        scatter le year if year <= `i', xscale(range(1900 2000)) name(le`i') }
{cmd:  {c )-}}
{cmd:. animate lifemovie, graphs(_all)}

