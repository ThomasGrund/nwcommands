*! Date        : 12oct2015
*! Version     : 2.0
*! Author      : Thomas Grund, University College Dublin
*! Email	   : thomas.u.grund@gmail.com

capture program drop nwtomata
program nwtomata
version 9
syntax [anything(name=netname)], mat(string)
	nw_tomata `netname', mat(`mat')
 end
