capture program drop nwclique
program nwclique
	syntax [(anything=netname)], R(namelist) P(namelist) X(namelist)
	_nwsyntax `netname'
	
	
	if 
end


nwtomata random, mat(net)
mata: BronKerbosch1(net, (-999),(-999),(1::10))


capture mata: mata drop BronKerbosch1()
capture mata: mata drop enqueue()
capture mata: mata drop dequeue()
capture mata: mata drop combineSet()
capture mata: mata drop cutSet()
capture mata: mata drop subSet()
capture mata: mata drop neighbors()

capture mata: mata drop BronKerbosch1()
mata:
real vector function BronKerbosch1(real matrix nw, real vector R, real vector P, real vector X)
{	
	if ((rows(P) == 1) & (rows(X) == 0)) {
		return(R)
	}
	P
	
	for (i = 2; i<= 1; i++) {
		P
		v = J(1,1,P[i])
		R2 = combineSet(R,v)
		P2 = cutSet(P, neighbors(nw,v))
		X2 = cutSet(X, neighbors(nw,v))
		
		v
		neighbors(nw,v)

		return(BronKerbosch1(nw, R2, P2, X2))
			
		P = subSet(P, v)
		X = combineSet(X, v)	
	}
}
end
mata: BronKerbosch1(net, (-999),(-999),(1::10))


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
end

mata:
real vector function enqueue(real vector Queue, real scalar value)
{
	matrix newQueue
	scalar newElement
	
	newQueue = J((rows(Queue) + 1),1,.)
	newQueue[(1::rows(Queue)),1]= Queue
	newElement = rows(Queue) + 1
	newQueue[newElement,1] = value
	return(newQueue)
}
end


mata:
real vector function cutSet(real vector Queue1, real vector Queue2)
{
	matrix newQueue
	matrix q1sort
	matrix q2sort
	scalar q1index
	scalar q2index
	scalar index
	
	q1sort = sort(Queue1, 1)
	q2sort = sort(Queue2, 1)
	newQueue = J(1,1,-999)
	
	q1index = 1
	q2index = 1
	
	while (q1index <= rows(q1sort) & q2index <= rows(q2sort)) {
		if (q1sort[q1index,1] == q2sort[q2index,1]){
			newQueue = enqueue(newQueue, q1sort[q1index,1])
			q1index = q1index + 1
			q2index = q2index + 1
		}
		else {
			if (q1sort[q1index,1] > q2sort[q2index,1]) {
				q2index = q2index + 1
			}
			if (q1sort[q1index,1] < q2sort[q2index,1]) {
				q1index = q1index + 1
			}
		}
	}
	return(newQueue)
}
end


mata:
real vector function combineSet(real vector Queue1, real vector Queue2)
{
	matrix newQueue
	newQueue = J(rows(Queue1) + rows(Queue2),1,.)
	newQueue[(1::rows(Queue1))] = Queue1
	q1 = rows(Queue1)+1
	q2 = rows(newQueue)
	newQueue[(q1::q2),1] = Queue2
	return(sort(uniqrows(newQueue),1))
}
end

capture mata: mata drop subSet()
mata:
real vector function subSet(real vector Queue1, real vector Queue2)
{
	matrix newQueue
	matrix q1sort
	matrix q2sort
	scalar q1index
	scalar q2index
	
	q1sort = sort(Queue1, 1)
	q2sort = sort(Queue2, 1)
	newQueue = J(1,1,-999)
	
	q1index = 1
	q2index = 1
	
	while (q1index <= rows(q1sort)) {
		if (q1sort[q1index,1] == q2sort[q2index,1]){
			q1index = q1index + 1
			q2index = q2index + 1
		}
		else {
			newQueue = enqueue(newQueue, q1sort[q1index,1])
			q1index = q1index + 1
		}
	}
	return(newQueue)
}
end

capture mata: mata drop neighbors()
mata:
real vector function neighbors(real matrix nw, real scalar vertex)
{
	matrix N 
	N = (1::rows(nw))  
	return(select(N,(nw[vertex,.])'))
}
end



mata: rows(neighbors(test,1))

mata: test = (1\5\3\88\6)
mata: test
mata: sort(test,1)



