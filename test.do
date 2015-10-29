cscript
clear mata
do unw_core.do

local files : dir "cscripts" files "*.do"
foreach file in `files' {
	do "cscripts/`file'"
}

