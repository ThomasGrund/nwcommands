capture program drop nwinfo
program nwinfo
	version 9
	syntax [anything(name=netname)]
	
	_nwsyntax `netname', max(9999)
	
	foreach onenet in `netname' {
		nwinf `onenet'
	}
	
end
	
	
	