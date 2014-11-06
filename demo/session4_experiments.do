**********************************************
**********************************************
*****
*****		Introduction to agent-based modeling and 
*****		social network analysis using Stata
*****		
*****		30 May 2013, Institute for Futures Studies, Stockholm
*****		
*****
***** 		Stata commands to be used in the course
*****     
*****			Session 4: programming, computational experiments
*****
*****			@: Thomas Grund, thomas.grund@iffs.se
*****
**********************************************
**********************************************

**************************
* Write your own programs
**************************
* Do something inside a program. Once you have done that, you only need to call this program.

clear all
program define hello
	di "hello world"
end

* Call your first program.

hello

* You can also return values by using rclass

program define hello2, rclass
	return local text = "hello world2"
end

* Call the program. But nothing seems to happen. Check out return list instead.

hello2
return list
	
	
* You can also write your program so that it accepts arguments.

program define addition, rclass
	args number1 number2
	return scalar mysum = `number1' + `number2'
end

addition 5 7
return list
di r(mysum)

program dir
program drop addition


* Often we need to repeat the simulation many times. 
*
****************************
* 	Nested loops, different dataset 
* 	POSTFILE command
****************************

* Assume we have the following program:
clear
set more off
set obs 100
gen threshold=round(uniform()*(_N-1))

gen act=int(uniform()+.1)

forvalues t=1/10 {
	quietly sum act
	replace act=1 if threshold<=r(sum)
	display "Time `t': " r(mean)
}


* Now we will use Stata's postfile command to save the results for the simulations in another dataset.
* We recommend that you use this command.	
* The syntax of the postfile command consists of four parts:
*
* (1) Declare the name of an internal memory buffer where Stata is to keep the results. If we    
*     decide to call this memory buffer sim, we need to type: tempname sim
*
* (2) Declare which information you want to keep and the name of the dataset where this information is 
*     to be stored. If we want to store the information in a Stata file called results.dta and   
*     we want to store three variables called run, time, mean we need to type:
*     postfile `sim' run time mean using results.dta, replace
*
* (3) Now you need to tell Stata at what point you want it to store the information to the file.
*     In our example, you do this by typing: post `sim' (`r') (`t') (r(mean)) 
*     Make sure that the information to be stored in the same order in (2) and (3)
*
* (4) Finally we need to tell Stata to stop posting any more information to results.dta, and we
*     do this by typing: postclose `sim'
*
* When we want to examine the results being saved, we simply open the the file we have created
* by typing: use results.dta
		
* Let us now make use of postfile in conjunction with the above program:

clear
set more off

* Step 1:
tempname sim

* Step 2:
postfile `sim' run time rioters using results.dta, replace

forvalues rep=1/20 {
	set obs 100
	gen threshold=round(uniform()*(_N-1))
	gen act=int(uniform()+.1)

	forvalues time=0/10 {
		quietly sum act
		* Step 3:
		post `sim' (`rep') (`time') (`r(sum)') 
		replace act=1 if threshold<=r(sum)
	}
	 drop threshold act
}

* Step 4:
postclose `sim'

use results.dta, clear
edit

****************************
*
* 	SIMPLE GRAPHS IN STATA
*
****************************
* Now we have the results, but we want to present them somehow.

* The PRESERVE command simply stores the current dataset, so that we can come back to it with RESTORE

preserve

* Let us go back to some simple graphs in Stata

clear
set obs 100
gen time = _n
gen value = 50 + sqrt(time)
twoway (line value time)

clear
set obs 1000
gen time = mod(_n,100)
gen value = 50 + sqrt(time) * (uniform() + .2)
twoway (scatter value time)

bys time: egen valuemean = mean(value)
twoway (line valuemean time, lwidth(vthick)) (scatter value time, msize(small))


* Goes back to the dataset that we stored
restore

browse

twoway (connected rioters time) if run == 1

* Make a plot for each run		
twoway (connected rioters time, sort), by(run, style(combine) noyrescale)

* Plot all results in one graph
twoway (scatter rioters time, sort)
lowess rioters time

sort time
bys time: egen riotersmean = mean(rioters)
twoway (line riotersmean time) 



**********************************
*
* 	Applying treatments
*
* 	Now let us run the same simulation again, but let us run two treatment conditions
* 	1) at the onset 10 % of rioters join and 2) at the onset 30 % of rioters join.
*
**********************************

capture program drop riot
program define riot
	args initial
	set more off
	forvalues rep=1/20 {
		set obs 100
		gen threshold=round(uniform()*(_N-1))
		gen act=int(uniform()+`initial')

		forvalues time=1/10 {
			quietly sum act
			replace act=1 if threshold<=r(sum)

			* Step 3:
			post sim (`rep') (`time') (`initial')  (`r(sum)') 
		}
		drop threshold act
	}
end

clear 
set more off

postfile sim run time treatment  rioters using results.dta, replace

riot 0.1
riot 0.3
riot 0.5

postclose sim

use results.dta, clear
tab treatment

* Now let us plot the results from the two treatments

collapse rioters, by(treatment time)
replace treatment = treatment * 10
reshape wide rioters, i(time) j(treatment)

* Make a plot 
label var rioters1 "initial 0.1"
label var rioters3 "initial 0.3"	
label var rioters5 "initial 0.5"		
twoway (connected rioters1 time) (connected rioters3 time) (connected rioters5 time)



****************************
* Contour and 3D surface plot
****************************
*
* We noticed that the mean over several repetitions of the simulation does not tell the whole story. But even the min, max and
* standard deviation might not be enough.
*
* Think again about what we do. We simulate how many people riot at a certain time. We repeat this a lot of times and each time we
* potentially could get some different results. Thus, in fact, for each point in time we have a distribution of how many people riot
* over the repetitions.
*
* We can certainly plot this whole distribution as well. However, not with Stata :-( well, to be fair, you could, but
* it would not look nice... Let's use Excel instead.
*
* This takes six steps:
*
*	(1) 	Run a model several times and POST the results at each time step as we did before.
*
*	(2) 	Open the results data and calculate the mean number of rioters at each time step. We 
*		do this with the EGEN command (combined with bysort).	
*	
*	(3) 	Recode the number of rioters in groups, e.g. 0-5, 6-10, 11-15... and so on. This is as later on we want to 
*		know how many times the simulation ends with a particular group of rioters.
*
*	(4)	We start off here with a little trick and say that each case represents one simulation ending up with
*		rioters in that group. Then we add these numbers up for all simulations ending up in that group. We do 
*		this with the collapse command, which is very powerful as well. There are two important parts of it. The 
*		first one says how and what we want to collapse (we choose "sum" and "numberingroup). The second part
*		indicates when we want to collapse. We want to collapse by riotergroup and time.
*
*	(5)	Now we reshape the data. This brings the data in another format. Some cases are transformed to columns.
*
*	(6) 	The data we created now gives us x, y, and z coordinates. The x coordinate indicates the group of the
*		number of rioters (How many people riot?). The y coordinate is time. And the z coordinate says how
*		many of the repetitions we ran ended up with the given number of rioters (x) at a certain time (y). 
*		We can visualize this data e.g. in Excel.

* Step 1:
clear
set more off
postfile results run time rioters using results.dta, replace

forvalues r=1/40 {
	di `r'
	qui {
	nwsmall 50, ne(4) s(10)
	nwdegree
	gen threshold=uniform()
	gen act=int(uniform()+.1)

	forvalues t=1/20 {
		quietly sum act
		nwcontext act, gen(alteract`t')
		gen perc_alters = alteract`t' / indegree
		replace act=1 if perc_alters >= threshold
		drop perc_alters
		sum act
		post results (`r') (`t') (`r(sum)') 
	}
	drop _all
	}
}

postclose results

* Step 2:
use results.dta, clear
bys time: egen riotersmean = mean(rioters)
twoway (line riotersmean time, lwidth(vthick)) (scatter rioters time, msize(small))

* Step 3:
gen riotersgroup = recode(rioters, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50)

* Step 4:
gen numberingroup = 1
collapse (sum) numberingroup, by(riotersgroup time)

* Step 5:
reshape wide  numberingroup, i(time) j(riotersgroup)
browse

* Step 6:
* Use e.g. Excel to visualize the new data
