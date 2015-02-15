capture program drop nwinstall
program nwinstall
	syntax [, permanently remove downloadoff]
	
	tempname fh1 fh2
					
	if "`remove'" != "" {
		window menu clear
		window menu refresh
	}
	else {
		run nwinstall_dlg.do
		
		if "`downdloadoff'" == "" {
			capture ado uninstall "nwcommands-dlg"
			net from "http://nwcommands.org"
			net install "nwcommands-dlg", all
		}
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
