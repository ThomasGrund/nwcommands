{smcl}
{* *! version 1.0.2  17apr2009}
{marker topic}
{helpb nw_topical##concept:[NW-2.1] Concepts}
{hline}

{title:Example networks}

{pstd}The datasets listed are in {help nwsave##fileformat:Stata network file-format} and hosted on the nwcommands.org server.
{p_end}
{hline}

        {help netexample##gang:gang}{col 29}{stata "webnwuse gang":use} | {stata "sysdescribe gang.dta":describe}
        {help netexample##glasgow:glasgow}{col 29}{stata "webnwuse glasgow":use} | {stata "sysdescribe glasgow.dta":describe}
        {help netexample##florentine:florentine}{col 29}{stata "webnwuse florentine":use} | {stata "sysdescribe florentine.dta":describe}
        {help netexample##usstates:usstates}{col 29}{stata "webnwuse usstates":use} | {stata "sysdescribe usstates.dta":describe}
        {help netexample##klas12b:klas12b}{col 29}{stata "webnwuse klas12b":use} | {stata "sysdescribe klas12b.dta":describe}
        {help netexample##hpotter:hpotter}{col 29}{stata "webnwuse hpotter":use} | {stata "sysdescribe hpotter.dta":describe}
		 
{hline}

{marker ucinet}{...}
{pstd}The datasets listed are in {help nwsave##fileformat:Ucinet file-format} and hosted on http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm.
{p_end}

        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#bkfrat":Bernhard & Killworh fraternity}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/bkfrat.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#bkham":Bernhard & Kilworth ham radio}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/bkham.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#bkoff":Bernhard & Kilworth office}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/bkoff.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#bktec":Bernhard & Kilworth technical}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/bktec.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#prison":Gangnon & Macrae prison}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/prison.dat, type(ucinet) name(PRISON)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#kapmine":Kapferer mine}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/kapmine.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#kaptail":Kapferer tailor shop}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/kaptail.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#krackoff":Krackhardt office (non-symmetric)}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/krackad.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#krackoff":Krackhadt office (symmetric)}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/krackfr.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#newfrat":Newcomb fraternity}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/newfrat.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#sampson":Sampson monastery}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/sampson.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#taro":Schwimmer taro exchange}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/taro.dat, type(ucinet) name(TARO)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#thuroff":Thurman office}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/thuroff.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#wolf":Wolfe primates}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/wolf.dat, type(ucinet)":import} 
        {browse "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#zachary":Zachary karate club}{col 55}{stata "nwimport http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/zachary.dat, type(ucinet)":import} 

		
{marker gang}
{title:Gang data}

{pstd}
{bf:Networks:} {it:gang}{p_end}
{pstd}
{bf:Vertex attributes:} {it:Age, Birthplace, Residence, Arrests, Convictions, Prison, Music}.

{pstd}
This is a dataset of co-offending in a London-based youth gang. Data were collected by 
James Densley and Thomas Grund. The data has been used in Grund & Densley (2012) and Grund & Densley (2014). 

{pmore}
Network tie values:

		= 1 (hang out together)
		= 2 (co-offend together)
		= 3 (co-offend together, serious crime)
		= 4 (co-offend together, serious crime, kin)
		
{pmore}
{bf:References}

{pmore}
Grund, T. and Densley, J. (2014) Ethnic Homophily and Triad Closure: Mapping Internal Gang Structure Using Exponential Random Graph Models. Journal of Contemporary Criminal Justice. online first

{pmore}
Grund, T. and Densley, J. (2012) Ethnic Heterogeneity in the Activity and Structure of a Black Street Gang. European Journal of Criminology, Vol. 9, Issue 3, pp. 388-406.


{marker glasgow}
{title:Glasgow data}

{pstd}
{bf:Networks:} {it:glasgow1, glasgow2, glasgow3}{p_end}
{pstd}
{bf:Vertex attributes:} {it:smoke1, smoke2, smoke2, alcohol1, alcohol2, alcohol3, sport1, sport2, sport3}

{pstd}
This is an excerpt of 50 girls from the Teenage Friends and Lifestyle Study data set. The social network data were
collected in the Teenage Friends and Lifestyle Study (Michell and Amos 1997, 
Pearson and Michell 2000, Pearson and West 2003). Friendship network data and substance use were recorded for a cohort of pupils in
a school in the West of Scotland. The panel data were recorded over a three year period starting in 1995, when the pupils were
aged 13, and ending in 1997. A total of 160 pupils took part in the study, 129 of whom were present at all three measurement
points. The friendship networks were formed by allowing the pupils to name up to twelve best friends. Pupils were also asked
about substance use and adolescent behavior associated with, for instance, lifestyle, sporting behavior and tobacco, alcohol
and cannabis consumption. The question on sporting activity asked if the pupil regularly took part in any sport, or go training
for sport, out of school (e.g. football, gymnastics, skating, mountain biking). The school was representative of others in the
region in terms of social class composition (Pearson and West 2003).

{pmore}
The variables included are:

{pmore}
{it:smoke1, smoke2, smoke3}: Smoking behavior at waves 1, 2 and 3.{p_end}

		= 1 (non)
		= 2 (occasional)
		= 3 (regular, i.e. more than once per week).
	
{pmore}
{it:alcohol1, alcohol2, alcohol3}: Drinking behavior at waves 1, 2 and 3.{p_end}

		= 1 (non)
		= 2 (once or twice a year)
		= 3 (once a month)
		= 4 (once a week) 
		= 5 (more than once a week).

{pmore}
{it:sport1, sport2, sport3}: Sport behavior at waves 1, 2 and 3.{p_end}

		= 1 (not regular)
		= 2 (regular).

{pmore}
{bf:References}

{pmore}
Michell, L., and A. Amos 1997. Girls, pecking order and smoking. Social Science and Medicine, 44, 1861 - 1869.

{pmore}
Pearson, M.A., and L. Michell. 2000. Smoke Rings: Social network analysis of friendship groups, smoking and drug-taking. Drugs: education, prevention and policy, 7, 21-37.

{pmore}
Pearson, M., and P. West. 2003. Drifting Smoke Rings: Social Network Analysis and Markov Processes in a Longitudinal Study of Friendship Groups and Risk-Taking. Connections, 25(2), 59-76.

{pmore}
Pearson, Michael, Steglich, Christian, and Snijders, Tom. Homophily and assimilation among sport-active adolescent substance users. Connections 27(1), 47-63. 2006.



{marker florentine}
{title:Florentine data}

{pstd}
{bf:Networks:} {it:flomarriage} and {it:flobusiness}{p_end}
{pstd}
{bf:Vertex attributes:} {it:wealth} and {it:priorates}

{pstd}
This is a dataset of marriage and business ties among Renaissance Florentine families. The data is originally from Padgett
(1994). Breiger & Pattison (1986), in their discussion of local role analysis, use a subset of data on the social
relations among Renaissance Florentine families (person aggregates) collected by John Padgett from historical documents. The
relations are marriage alliances (flomarriage between the families) and business relationships (recorded financial ties such
as loans, credits and joint partnerships).

{pstd}
As Breiger & Pattison point out, the original data are symmetrically coded. This is perhaps acceptable perhaps for marital
ties. Vertex information is provided on (1) {it:wealth} each family's net wealth in 1427 (in thousands of lira); (2) 
the number of {it:priorates} (seats on the civic council) held between 1282- 1344.

{pstd}
Substantively, the data include families who were locked in a struggle for political control of the city of Florence around
1430. Two factions were dominant in this struggle: one revolved around the infamous Medicis (9), the other around the powerful Strozzis (15).

{pmore}
{bf:References}

{pmore}
Padgett, John F. 1994. Marriage and Elite Structure in Renaissance Florence, 1282-1500. Paper delivered to the Social Science History Association.

{pmore}
Breiger R. and Pattison P. (1986). Cumulated social roles: The duality of persons and their algebras, Social Networks, 8, 215-256.




{marker klas12b}
{title:Klas12b data}

{pstd}
{bf:Networks:} {it:klas12b_wave1, klas12b_wave2, klas12b_wave3, klas12b_wave4, klas12b_primary}{p_end}
{pstd}
{bf:Vertex attributes:}
{it:delinq1, delinq3, delinq3, delinq4, alcohol2, alcohol3, alcohol4, sex age, ethnicity, age, religion, advice}

{pstd}
This data is about a friendship network in a Dutch school class. The data were collected between September 2003 and June 2004 by Andrea 
Knecht, supervised by Chris Baerveldt, at the Department of Sociology of the University of Utrecht (NL). The entire study is reported in
Knecht (2008). The project was funded by the Netherlands Organisation for Scientific Research NWO, grant 401-01-554.

{pstd}
The 26 students were followed over their first year at secondary school during which friendship networks as well as other data were assessed 
at four time points at intervals of three months. There were 17 girls and 9 boys in the class, aged 11-13 at the beginning of the school
year. Network data were assessed by asking students to indicate up to twelve classmates which they considered good friends.

{pstd}
Delinquency is defined as a rounded average over four types of minor delinquency (stealing, vandalism, graffiti, and fighting), measured in
each of the four waves of data collection. The five-point scale ranged from `never' to `more than 10 times', and the distribution is highly
skewed. In a range of 1-5, the mode was 1 at all four waves, the average rose over time from 1.4 to 2.0, and the value 5 was never observed.

{pstd}
Friendship networks at four waves {it:klas12b_wave1-4}:	

	0 = no,
	1 = yes,
	9 = missing,
	10 = not a member of the classroom (structural zero).
	

{pstd}
Same primary school ({it:klas12b_primary}): 
	
	0 = no, 
	1 = yes.
	
{pstd}
{it:delinq1, delinq3, delinq3, delinq4}: Delinquency at waves 1, 2, 3 and 4; rounded average of four items (stealing, vandalizing, fighting, graffiti).{p_end}

	1 = never, 
	2 = once, 
	3 = 2-4 times, 
	4 = 5-10 times, 
	5 = more than 10 times;
	0 = missing.
	
{pstd}
{it:alcohol2, alcohol3, alcohol4}: Alcohol use ("How often did you drink alcohol with friends in the last three months?"), but it refers only to waves 2-3-4. 

	1 = never, 
	2 = once, 
	3 = 2-4 times, 
	4 = 5-10 times, 
	5 = more than 10 times;
	0 = missing.

{pstd}
{it:sex (1 = girl, 2 = boy)}

{pstd}
{it:age (in years)}

{pstd}
{it:ethnicity}
	
	1 = Dutch, 
	2 = other, 
	0 = missing

{pstd}	
{it:religion}

	1 = Christian, 
	2 = non-religious, 
	3 = non-Christian religion, 
	0 = missing
	
{pstd}
{it:advice} contains the variable "school advice", the assessment given at the end of primary school about the school capacities of the pupil

	4 = low, 
	8 = high, 
	0 = missing


{pmore}
{bf:Reference}

{pmore}
Knecht, A., 2008. Friendship Selection and Friends' Influence. Dynamics of Networks and Actor Attributes in Early Adolescence. PhD dissertation, University of Utrecht.

{pmore}
Andrea Knecht, Tom A. B. Snijders, Chris Baerveldt, Christian E. G. Steglich, and Werner Raub. Friendship and Delinquency: Selection and Influence Processes in Early Adolescence, Social Development.
http://dx.doi.org/10.1111/j.1467-9507.2009.00564.x.

{pmore}
Snijders, T.A.B., Steglich, C.E.G., and van de Bunt, G.G. (2010). Introduction to actor-based models for network dynamics. Social Networks, 32, 44-60.
http://dx.doi.org/10.1016/j.socnet.2009.02.004.

{pmore}
Steglich, Christian, and Knecht, Andrea (2009), Die statistische Analyse dynamischer Netzwerkdaten. In: Christian Stegbauer and Roger Häußling (Eds.), Handbuch der Netzwerkforschung, Wiesbaden (Verlag für Sozialwissenschaften).





{marker hpotter}
{title:Harry Potter data}

{pstd}
{bf:Networks:} {it:hpbook1, hpbook1, hpbook2, hpbook3, hpbook4, hpbook5, hpbook6 }{p_end}
{pstd}
{bf:Vertex attributes:}
{it:schoolyear, gender, and house}

{pstd}
Goele Bossaert and Nadine Meidert have coded the support ties between 64 characters in the well-known books about Harry Potter. They analyzed this by Siena; their findings were published in

{pmore}
{bf:Reference}

{pmore}
Goele Bossaert and Nadine Meidert (2013). 'We are only as strong as we are united, as weak as we are divided'. A dynamic analysis of the peer support networks in the Harry Potter books. Open Journal of Applied Sciences, Vol. 3 No. 2, pp. 174-185. 
http://dx.doi.org/10.4236/ojapps.2013.32024
