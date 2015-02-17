# install and load necessary R packages
if (!require("foreign",character.only = TRUE)) { install.packages("foreign", repos = "http://cran.rstudio.com/") } 
if (!require("ergm",character.only = TRUE)) { install.packages("ergm", repos = "http://cran.rstudio.com/") } 
suppressPackageStartupMessages(library("foreign", quietly=TRUE, verbose=FALSE, warn.conflicts=FALSE))
suppressPackageStartupMessages(library("ergm", quietly=TRUE, verbose=FALSE, warn.conflicts=FALSE))
suppressPackageStartupMessages(library("network", quietly=TRUE, verbose=FALSE, warn.conflicts=FALSE))

# set R working directory to Stata working directory
setwd("/Users/thogr49/Dropbox/STATA/nwcommands")

# load network and attributes
data <- read.dta("ergdata.dta")
netsize <- dim(data)[1]
netmat <- as.matrix(data[unlist(strsplit("g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13 g14 g15 g16 g17 g18 g19 g20 g21 g22 g23 g24 g25 g26 g27 g28 g29 g30 g31 g32 g33 g34 g35 g36 g37 g38 g39 g40 g41 g42 g43 g44 g45 g46 g47 g48 g49 g50 g51 g52 g53 g54"," "))])
netsym <- all(netmat == t(netmat))
net<- network(netmat, directed = !netsym)
attrs <- dim(data)[2] - dim(data)[1]
for (i in 1:attrs){ 
       att <- data[,i] 
       set.vertex.attribute(net, colnames(data[i]),att) 
} 

# run ERGM
model <- net~edges + nodematch("Birthplace") + nodematch("Prison") + absdiff("Age")
try({summary(model)
ergmresults<-ergm(model, , verbose=TRUE)
summary(ergmresults)})

# generate code for goodness of fit analysis
g <- gof(ergmresults, control=control.gof.ergm(nsim=30), verbose = TRUE )
simid<- rep(seq(1,dim(g$psim.espart)[1]),dim(g$psim.espart)[2])
value<- rep(1:dim(g$psim.espart)[2],each=dim(g$psim.espart)[1])
espart<-as.vector(g$psim.espart[,1:g$network.size-1])
dist<-as.vector(g$psim.espart[,1:g$network.size-1])
obsespart<-rep(g$pobs.espart[1:g$network.size-1],each=dim(g$psim.espart)[1])
obsdist<-rep(g$pobs.dist[1:g$network.size-1],each=dim(g$psim.espart)[1])
if (netsym) { 
       deg<-as.vector(g$psim.deg[,1:g$network.size-1])
       obsdeg<-rep(g$pobs.deg[1:g$network.size-1],each=dim(g$psim.espart)[1])
   gof.data<- as.data.frame(cbind(simid,value, obsdeg, deg, obsespart, espart, obsdist, dist))
}
if (!netsym) { 
       ideg<-as.vector(g$psim.ideg[,1:g$network.size-1])
       odeg<-as.vector(g$psim.odeg[,1:g$network.size-1])
       obsideg<-rep(g$pobs.ideg[1:g$network.size-1],each=dim(g$psim.espart)[1])
   obsodeg<-rep(g$pobs.odeg[1:g$network.size-1],each=dim(g$psim.espart)[1])
   gof.data<- as.data.frame(cbind(simid,value, obsideg, ideg, obsodeg, odeg, obsespart, espart, obsdist, dist))
}
write.csv(as.data.frame(gof.data), 'erggof.csv', na='.')

# generate code for mcmc diagnostics
if (length(ergmresults$sample)!=0){
  mcmcres<-as.data.frame(ergmresults$sample)
  mcmcnames<-names(mcmcres)
  names(mcmcres)<-sub('#','_',mcmcnames)
  write.dta(mcmcres, 'ergmcmc.dta')}

write.table(geterrmessage(),'ergerror.txt')

# produce output files: ergcoefs.csv, ergcov.csv, ergmodel.csv,  ergstats.csv
write.csv(round(summary(ergmresults)$coefs, 3), 'ergcoefs.csv', na='.')
write.csv(summary(ergmresults)$asycov, 'ergcov.csv', na='.')
write.csv(round(as.data.frame(summary(model)), 3), 'ergmodel.csv', na='.')
capture.output(summary(ergmresults)$control, file='ergcontrol.csv')
fileCon<-file('ergstats.csv', 'w')
writeLines('vertices,edges,directed,numcoeff,coeff,iterations,estimate,aic,bic,samplesize,message', fileCon)
writeLines(paste(network.size(net),',',network.edgecount(net),',',net[[2]]$directed,',',dim(summary(ergmresults)$coef)[1],',',gsub(',','',toString(names(summary(model)))),',',summary(ergmresults)$iterations, ',',summary(ergmresults)$estimate,',',round(summary(ergmresults)$aic,2),',',round(summary(ergmresults)$bic,2),',',summary(ergmresults)$samplesize,',',summary(ergmresults)$message), fileCon)
close(fileCon)
