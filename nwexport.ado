*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwexport
program nwexport
	version 9
	syntax [anything(name=netname)],[FName(string asis) replace]	
	
	_nwsyntax , max(1)
	
	if ("" != ""){
		local last = substr("", -1, .)
		if ("" != "/" | "" != "\"){
			local path = "/"
		}
	}
	
	di `""'
	
	scalar onevars = ""
	local vars marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
	
	if (`""' == "") {
		local fname ".net"
	}

	di `"{txt}Exporting network: "'
	di `"file open expfile using , write "'
	
	file open expfile using `""', write 
	file write expfile "*Vertices " _newline
	forvalues i = 1/ {
		file write expfile ()
		file write expfile (" ")
		file write expfile (char(34))
		local onevar : word  of 
		file write expfile ("")
		file write expfile (char(34)) _newline	
	}
	if ("" == "true"){
		file write expfile "*Arcs"
	}
	else {
		file write expfile "*Edges"
	}
	
	preserve
	nwtoedge 
	local ties = _N
	forvalues i = 1/ {
		if [] != 0 {
			local value = []
			local k = _fromid[]
			local l = _toid[]
			file write expfile _newline
			file write expfile ()
			file write expfile " "
			file write expfile ()
			file write expfile " " 	
		}
	
	}
	file write expfile "" _n
	file close expfile	
	restore
end
