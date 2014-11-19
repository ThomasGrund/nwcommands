*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwtabulate
program nwtabulate
	syntax [anything(name=something)] [, *]
	nwtab , 
end
