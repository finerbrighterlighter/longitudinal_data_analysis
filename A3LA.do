use "/Users/hteza/Desktop/Class/RACE626/Assignment_3_LA/Pedometry data.dta"
d
misstable sum
* no missing data

tab day
* 150 subject 1 week

encode sex, gen (gender)
numlabel, add

* string to numeric categorical
encode day, gen (day1)
numlabel, add
* not in order

* reorder the ordinal
recode day1 (4=1 "Sunday") (2=2 "Monday") (6=3 "Tuesday") (7=4 "Wednesday") (5=5 "Thursday") (1=6 "Friday") (3=7 "Saturday"), gen(dow)
numlabel, add
tab dow

*************************

* steps x days of week

* descriptive statistics
bysort dow : sum steps,d
* not normally distributed
* I will report median with iqr

*declare multiple
xtset id dow

* Mixed linear model with random intercept
mixed steps i.dow ||id:, nolog

numlabel, remove
* margin adjusted pred with 95 CI
margin dow
*marginsplot

*************************

* steps x dow x age group

* descriptive statistics
bysort agegr : sum steps,d

* Mixed linear model with random intercept
* without interaction
mixed steps i.agegr i.dow ||id:, nolog
margin agegr
margin dow, by(agegr)
* marginsplot

* interaction
mixed steps i.agegr##i.dow||id:, nolog
margin dow, by(agegr)
* marginsplot

*************************

* steps x dow x gender

* descriptive statistics
bysort gender : sum steps,d

* Mixed linear model with random intercept
* without interaction
mixed steps i.gender i.dow||id:, nolog
margin gender
margin dow, by(gender)
* marginsplot

* interaction
mixed steps i.gender##i.dow||id:, nolog
margin dow, by(gender)
* marginsplot

*************************

* steps x dow x bmi group

* descriptive statistics
bysort bmi_gr : sum steps,d

* Mixed linear model with random intercept
* without interaction
mixed steps i.bmi_gr i.dow||id:, nolog
margin bmi_gr
margin dow, by(bmi_gr)
* marginsplot

* interaction
mixed steps i.bmi_gr##i.dow||id:, nolog
margin dow, by(bmi_gr)
* marginsplot

*************************


qui : mixed steps i.dow ||id:, nolog
est store A

qui : mixed steps i.agegr i.dow||id:, nolog
est store B

lrtest A B

qui : mixed steps i.gender i.dow||id:, nolog
est store C

lrtest A C

qui : mixed steps i.bmi_gr i.dow||id:, nolog
est store D

lrtest A D

**

qui : mixed steps i.agegr i.gender i.dow||id:, nolog
est store C1

lrtest B C1

qui : mixed steps i.agegr i.bmi_gr i.dow||id:, nolog
est store D1

lrtest B D1

**

qui : mixed steps i.agegr i.bmi_gr i.gender i.dow||id:, nolog
est store C2

lrtest D1 C2

**

*final model

* without interaction
mixed steps i.agegr i.bmi_gr i.dow||id:, nolog
margin dow, by(agegr bmi_gr)
* marginsplot

* interaction
mixed steps i.agegr##i.bmi_gr##i.dow||id:, nolog
margin dow, by(agegr bmi_gr)
* marginsplot
