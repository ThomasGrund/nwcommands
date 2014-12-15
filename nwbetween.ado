*! Date        : 19sept2014
*! Version     : 1.0
*! Author      : Thomas Grund, Linköping University
*! Email	   : contact@nwcommands.org

/////////////////////////////////
//
// Algorithm from Brandes (2001), Journal of Mathematical Sociology
// Implementation builds on Mata code from Modesto Escobar, 2014
//
/////////////////////////////////

capture program drop nwbetween
program nwbetween
	syntax [anything(name=netname)], [GENerate(string) nosym]
	_nwsyntax `netname', max(9999)
	_nwsetobs `netname'
	
	if `networks' > 1 {
		local k = 1
	}
	
	foreach netname_temp in `netname' {
		nwtomata `netname_temp', mat(betweennet)
		if "`sym'" != "" {
			mata: betweennet = betweennet :+ betweennet'
		}
	
		if "`sym'" == "" {
			mata: betweennet = betweennet :/ betweennet
			mata: _editmissing(betweennet, 0)
		}
		
		mata: C = between(betweennet)
		if "`sym'" != ""  {
			mata: C = C:/2
		}
	
	
		if "`generate'" == "" {
			local generate "_between"
		}
		
		capture drop `generate'`k'
		nwtostata, mat(C) gen(`generate'`k')
		mata: mata drop betweennet C
		local k = `k' + 1
	}
	mata: st_rclear()
end


/////////////////////////////////
//
// Algorithm from Brandes (2001), Journal of Mathematical Sociology
// Implementation builds on Mata code from Modesto Escobar, 2014
//
/////////////////////////////////

capture mata: mata drop between()
capture mata: mata drop dequeue()

mata:

real scalar function dequeue(real vector Queue)
{
	qvalue=Queue[1]
	for (q=1; q<cols(Queue); q++) { 
		Queue[q]=Queue[q+1]
	}
	if(cols(Queue)==1) { 
		Queue=J(1,0,.)
	}
	else {
		Queue=Queue[1..cols(Queue)-1]
	}
	return(qvalue)
}

real vector between(real matrix net){

	adjacencyList=J(rows(net),rows(net)-1,.)
	for (m=1; m<=rows(net); m++) {
		k=1
		for (n=1; n<=rows(net); n++) {
			if ( m!=n & net[m,n]>0) adjacencyList[m,k++]=n
		}
    }
	
	Cb=J(1,rows(net),0)
	for(s=1; s<=rows(net); s++) {
		Stack=J(1,0,.)
		P=J(rows(net),rows(net),.)
		nP=J(rows(net),1,1)
		S=J(1,rows(net),0)
		S[s]=1
		D=J(1,rows(net),-1)
		D[s]=0
		Queue=J(1,0,.)
		Queue=(cols(Queue)? Queue,s : s)
		
		while(cols(Queue)) {
			v=dequeue(Queue)
		
			Stack=cols(Stack)? v,Stack : v
			for(j=1; j<=sum(adjacencyList[v,.]:<.);j++) {
				w=adjacencyList[v,j]
				if(D[w]<0) {
					Queue=(cols(Queue)? Queue,w : w)
					D[w]=D[v]+1
				}
				if(D[w]==D[v]+1) {
					S[w]=S[w]+S[v]
					P[w,nP[w]]=v; nP[w]=nP[w]+1
				}     
			}	
		}
		
		Dd=J(1,rows(net),0)
		
		while (cols(Stack)) {
			w=dequeue(Stack)
  
			for(j=1; j<nP[w]; j++) {
				v=P[w,j]
				Dd[v]=Dd[v]+(S[v]/S[w])*(1+Dd[w])
			}
			if (w!=s) Cb[w]=Cb[w]+Dd[w]
		}
	}
	return(Cb')
}
end
