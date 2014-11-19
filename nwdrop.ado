*! Date      :18nov2014
*! Version   :1.0.4.1
*! Author    :Thomas Grund
*! Email     :thomas.u.grund@gmail.com

capture program drop nwdrop
program nwdrop
	version 9
	syntax [anything(name=netname)] [if/] [in/], [netonly ATTRibutes(varlist) reverseif]
	_nwsyntax , max(9999)

	local nets 
	local z = 0
	qui foreach dropnet in  {
		nwname 
		local id = r(id)
		local nodes = r(nodes)
		local z =  + 1
		
		// only drop nodes 
		if ("" != "" | "" != ""){
			tempvar keepnode
			gen  = 1
			if "" != "" {
				replace  = 0 if 
				if (""!= ""){
					recode  (0=1) (1=0)
				}
			}
			if "" != "" {
				replace  = 0 in 
			}
			
			mata: keepnode = st_data((1,), st_varindex(""))
			
			// WHY DID I INCLUDE THIS? IT MESSES WITH NWPLOT (MDS)
			// make sure that attributes are only included for dropping one network
			//if ( != ) {
			//	nwdropnodes , keepmat(keepnode) 
			//}
			//else {
				nwdropnodes , keepmat(keepnode)  attributes()
			//}
			mata: mata drop keepnode
		}
		
		// drop the whole network
		else {
			// delete Stata variables if needed
			scalar onenw = ""
			if "" == "" {
				capture confirm variable marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
				if _rc == 0 {
					qui drop marriage_4 marriage_5 marriage_6 marriage_7 marriage_8 marriage_10 marriage_11 marriage_12 marriage_13 marriage_14 marriage_15 marriage_16
				}
				capture drop _label	 
			}
	
			// update all Stata/Mata macros
			local k 	= 2 - 1
			forvalues j = / {
				local next =  + 1
				nwname, id()
				global nwname_ = r(name)
				global nwsize_ = r(nodes)
				global nwdirected_ = r(directed)			
		
				scalar movenw = ""
				global nw_ 
				
				mata: mata drop nw_mata
				mata: nw_mata = nw_mata
			}
			
			// clean-up
			macro drop nw_2
			macro drop nwsize_2
			macro drop nwname_2
			macro drop nwdirected_2
			macro drop nwlabs_2
			macro drop nwedgelabs_2
			mata: mata drop nw_mata2
			global nwtotal 1
			global nwtotal_mata = 1
		}
	}
	nwcompressobs
	mata: st_rclear()
end
	
	
	
