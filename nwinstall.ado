capture program drop nwinstall
program nwinstall
	syntax [, permanently remove downloadoff help all]
	
	tempname fh1 fh2
	
	if "`all'" != "" {
		local help = "help"
		local permanently = "permanently"
	}
	
	if "`help'" != "" {
		capture ado uninstall "nwcommands-hlp"
		net from "http://nwcommands.org"
		net install "nwcommands-hlp", all
	}
	
	set more off
	
	if "`remove'" != "" {
		window menu clear
		window menu refresh
		capture ado uninstall "nwcommands-dlg"
		capture ado uninstall "nwcommands-ado"
		capture ado uninstall "nwcommands-hlp"
		local permanently "permanently'"
	}
	else {
		if "`downloadoff'" == "" {
			capture ado uninstall "nwcommands-dlg"
			net from "http://nwcommands.org"
			net install "nwcommands-dlg", all
		}
		qui nwinstall_menu
	}
		
		
	if "`permanently'" != "" {
		if "`remove'" != "" {
			capture findfile "profile.do", path("`c(sysdir_stata)'")
			local existingProfile "`r(fn)'"
			if _rc == 0 {
				file open `fh1' using "`r(fn)'", read 
				file open `fh2' using "`c(sysdir_stata)'profile_temp.do", write replace
				file read `fh1' line
				while r(eof) == 0 {
					if "`line'" != "run nwinstall_dlg.do" {
						file write `fh2' `"`line'"' _n
					}
					file read `fh1' line
				}
				file close `fh1'
				file close `fh2'
				erase `existingProfile'
				if c(os) == "MacOSX" {
					shell export PATH="$PATH:`:environ PATH':`c(pwd)':`c(sysdir_stata)':`c(adopath)':/usr/local/bin:/usr/bin:/opt/local/bin:/opt/ImageMagick/bin/:`imagick'/";mv `c(sysdir_stata)'profile_temp.do `existingProfile'
				}
				if c(os) == "Windows" {
					shell rename `c(sysdir_stata)'profile_temp.do `existingProfile'
				}
			}

		}
		// add to profile
		else  {
			capture findfile "profile.do",  path("`c(sysdir_stata)'")
			if _rc == 0{
				local alreadyInstalled = 0
				file open `fh1' using "`c(sysdir_stata)'profile.do", read 
				file read `fh1' line
				while r(eof) == 0 {
					if "`line'" == "run nwinstall_dlg.do" {
						local alreadyInstalled = 1
					}
					file read `fh1' line
				}
				file close `fh1'
				
				if `alreadyInstalled' == 0 {
					file open `fh2' using "`c(sysdir_stata)'profile.do", write append
					file write `fh2' `"run nwinstall_dlg.do"' _n
					file close `fh2'
				}	
			}
			// write profile.do
			else {
				file open `fh2' using "`c(sysdir_stata)'profile.do", write
				file write `fh2' `"run nwinstall_dlg.do"' _n
				file close `fh2'
			}
		}
	}	
end


capture program drop nwinstall_menu
program nwinstall_menu
	window menu append submenu "stUser" "Network Analysis"
	
	window menu append submenu "Network Analysis" "Generate Network"	
	window menu append item "Generate Network" "Random Network" "db nwrandom"
	window menu append item "Generate Network" "Small-World Network" "db nwsmall"
	window menu append item "Generate Network" "Ring-Lattice Network" "db nwring"
	window menu append item "Generate Network" "Lattice Network" "db nwlattice"
	window menu append item "Generate Network" "Preferential Attachment Network" "db nwpref"
	window menu append item "Generate Network" "Homophily  Network" "db nwhomophily"
	window menu append item "Generate Network" "Tie Probabilities Network" "db nwdyadprob"
	
	window menu append separator "Generate Network"	
	window menu append item "Generate Network" "Expand From Variable" "db nwexpand"
	window menu append item "Generate Network" "Duplicate Network" "db nwduplicate"

	window menu append separator "Network Analysis"
	window menu append item "Network Analysis" "Example Networks" "help netexample"
	
	window menu append separator "Network Analysis"
	window menu append item "Network Analysis" "Declare Network Data" "db nwset"
	window menu append item "Network Analysis" "Open Networks" "run nwuse.do"
	window menu append item "Network Analysis" "Save Networks As..." "run nwsave.do"
	window menu append separator "Network Analysis"
	window menu append item "Network Analysis" "Import Networks" "db nwimport"
	window menu append item "Network Analysis" "Export Networks" "db nwexport"

	window menu append submenu "Network Analysis" "Convert To/From Edgelist"
	window menu append item "Convert To/From Edgelist" "Convert To Edgelist" "db nwfromedge"
	window menu append item "Convert To/From Edgelist"  "Convert From Edgelist" "db nwfromedge"	
	
	window menu append separator "Network Analysis"
	window menu append submenu "Network Analysis" "Network Manipulation"
	window menu append item "Network Manipulation" "Drop or Keep Nodes" "db nwdrop"	
	window menu append item "Network Manipulation" "Drop or Keep Networks" "db nwdrop"
	window menu append item "Network Manipulation" "Add Nodes" "db nwaddnodes"
	
	window menu append separator "Network Manipulation"
	window menu append item "Network Manipulation" "Subset Network" "db nwsubset"	
	window menu append item "Network Manipulation" "Permute Network" "db nwpermute"		
	window menu append item "Network Manipulation" "Transpose Network" "db nwtranspose"	
	window menu append item "Network Manipulation" "Replace With Matrix" "db nwreplacemat"	
	
	window menu append separator "Network Manipulation"
	window menu append item "Network Manipulation" "Rename Network" "db nwrename"
	window menu append item "Network Manipulation" "Symmetrize Network" "db nwsym"
	window menu append item "Network Manipulation" "Unsymmetrize Network" "db nwunsym"
		
	window menu append separator "Network Manipulation"
	window menu append item "Network Manipulation" "Replace Networks" "help nwreplace"
	window menu append item "Network Manipulation" "Recode Tie Values" "db nwrecode"	
	window menu append item "Network Manipulation" "Synchronize Network With Variables" "db nwsync"	

	window menu append submenu "Network Analysis" "Network Utilities"
	window menu append item "Network Utilities" "Clear All Networks" "nwclear"	
	window menu append item "Network Utilities" "Load Network As Stata Variables" "db nwload"
	window menu append item "Network Utilities" "Synchronize Network With Variables" "db nwsync"		
	window menu append item "Network Utilities" "Order Networks" "db nworder"
	
	window menu append separator "Network Analysis"
	window menu append submenu "Network Analysis" "Summarize Networks"
	window menu append item "Summarize Networks" "List Networks" "db nwds"
	window menu append item "Summarize Networks" "Summarize" "db nwsummarize"
	window menu append item "Summarize Networks" "Dyad/Triad Census" "db nwcensus"

	window menu append submenu "Network Analysis" "Paths Between Nodes"
	window menu append item "Paths Between Nodes" "All Shortest Paths" "db nwgeodesic"	
	window menu append item "Paths Between Nodes" "Paths Between Two Nodes" "db nwpath"
	window menu append item "Paths Between Nodes" "Reachability" "db nwreach"
	window menu append separator "Network Analysis"
		
	window menu append submenu "Network Analysis" "Node-Level Characteristics"
	window menu append item "Node-Level Characteristics" "Node Centrality Coefficients" "db nwcentrality"
	window menu append item "Node-Level Characteristics" "Components and Membership" "db nwcomponents"
	window menu append item "Node-Level Characteristics" "Clustering Coefficient" "db nwclustering"	
	window menu append item "Network Analysis" "Generate Context Variable" "db nwcontext"	
	window menu append separator "Network Analysis"
	
	window menu append submenu "Network Analysis" "Tabulate Networks"
	window menu append item "Tabulate Networks" "Oneway-Tabulate Network" "db nwtabulate2_net"	
	window menu append item "Tabulate Networks" "Twoway-Tabulate Networks" "db nwtabulate2net"	
	window menu append item "Tabulate Networks" "Twoway-Tabulate Network and Variable" "db nwtabulate2var"

	window menu append submenu "Network Analysis" "Correlate Networks"
	window menu append item "Correlate Networks" "Correlate Two Networks" "db nwcorrelate"	
	window menu append item "Correlate Networks" "Correlate Network and Variable" "db nwcorrelateAttr"	
	
	window menu append item "Network Analysis" "Quadratic Assignment Procedure" "help nwqap"
	window menu append item "Network Analysis" "Exponential Random Graph Model" "help nwergm"
	window menu append separator "Network Analysis"
	
	window menu append submenu "Network Analysis" "Visualize Networks"
	window menu append item "Visualize Networks" "Plot" "db nwplot"	
	window menu append item "Visualize Networks" "Plot As Matrix" "db nwplotmatrix"		
	window menu append item "Visualize Networks" "Make Network Movie" "db nwmovie"
	window menu append separator "Network Analysis"
	
	window menu append separator "Network Analysis"
	window menu append item "Network Analysis" "Help NWCOMMANDS" "help nwcommands"	
	window menu refresh


end
