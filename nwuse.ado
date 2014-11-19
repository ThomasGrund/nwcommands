*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwuse
program nwuse
	syntax anything [, nwclear clear *]
	local webname = subinstr("", ".dta","",99)
	
	
	

	if c(k) > 0 & _N > 0{
		local reloadExisting = "yes"
		gen _running = _n
		tempfile existing 
		qui save  
	}
	qui use , 
	
	capture {
		confirm variable _format _nets _name _size _directed _edgelabs
		local f = _format[1]
		local nets = _nets[1]
		forvalues i = 1/ {
			local s = _size[]
			confirm variable _nodevar
			confirm variable _nodelab
			if "" == "edgelist"{
				local nextname = _name[]
				confirm variable _
			}
			if "" == "matrix" {
				forvalues j = 1/ {
					local nodevar 
					confirm variable 
				}
			}

			if "" != "matrix" & "" != "edgelist" {
				di "{err}file {bf:.dta} has the wrong format."
				error 6702	
			}
		}
	}
	
	if _rc != 0 {
		di "{err}file {bf:.dta} has the wrong format."
		error 6702
	}

	local frmat = _format[1]
	local nets = _nets[1]
	local allnets ""
	local allnames ""
	forvalues i = 1 /  {
		local name = trim(_name[])
		local allnets " _"
		local allnames " "
		local size = _size[]
		local directed = _directed[]
		local edgelabs = _edgelabs[]
		local vars ""
		local labs ""
		forvalues j = 1 /  {
			local nextvar = _nodevar[] 
			local nextlab = _nodelab[]
			local labs " "
			local vars " "
		}
	
		if "" == "false" {
			local directed = ""
			local undirected = "undirected"
		}
		else {
			local directed = "directed"
			local undirected = ""
		}
		preserve
		
		local nname "_"
		if "" == "edgelist"{
			keep _fromid _toid 
			qui nwfromedge _fromid _toid  if  != . , name() vars() labs()  
		}
		if "" == "matrix"{
			local _netstub 
			nwset , name() vars() labs() 
		}
		restore
	}
	
	capture drop _*
	capture drop 
	
	di 
	di "{txt}{it:Loading successful}"
	nwset
	qui drop if _n > r(max_nodes)
	qui if "" != "" {
		gen _running=_n
		merge m:m _running using , nogenerate
		drop _running
		
	}
	nwload
end



	

