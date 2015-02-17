capture program drop nwrecode
program nwrecode
	version 9
	syntax anything(name=arg) [, into(string) generate(string) prefix(string) *]

	if "`arg'" == "" {
		exit
	}
	
	if "`into'" != "" {
		local generate "`into'"
	}
	
	local ruleStart = strpos("`arg'", "(")
	local netname = substr("`arg'",1, `=`ruleStart'-1')
	local rules = substr("`arg'",`ruleStart',.)

	_nwsyntax_other `netname', max(9999)
	
	preserve
	tokenize `generate'
	local i = 1
	foreach onenet in `othernetname' {
		_nwsyntax `onenet'
		local onedirected `directed'
		nwtoedge `onenet', forcedirected
		recode `onenet' `rules', `options'		
		qui nwfromedge _fromid _toid `onenet', name(__temp_network)
		nwtomata __temp_network, mat(recodeNet)
		if "`generate'" == "" & "`prefix'" == "" {
			nwreplacemat `onenet', newmat(recodeNet)
		}
		else {
			if "`prefix'" != "" {
				nwduplicate `onenet', name(`prefix'`onenet')
				nwreplacemat `prefix'`onenet', newmat(recodeNet)
			}
			if "`generate'" != "" {
				if "``i''" != "" {
					nwduplicate `onenet', name(``i'')
					nwreplacemat ``i'', newmat(recodeNet)	
				}
				else {
					nwreplacemat `onenet', newmat(recodeNet)
				}
			}
		}
		capture nwdrop __temp_network
		mata: mata drop recodeNet
		local i = `i' + 1
		nwname `onenet', newdirected(`onedirected')
	}
	restore
end
