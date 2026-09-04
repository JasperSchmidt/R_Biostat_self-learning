## Notes on the usage of the dataset (nhanes)


https://cran.r-project.org/web/packages/nhanesA/vignettes/Introducing_nhanesA.html 

two year surveys that start in uneven years: 2005 = 2006 survey


##### Letters:  
A	1999-2000	
B	2001-2002	
C	2003-2004	
D	2005-2006	
E	2007-2008	
F	2009-2010	
G	2011-2012   
H	2013-2014   
I	2015-2016   
J	2017-2018   
K	2019-2020 (COVID-disrupted, often merged/excluded)  
L	2021-2023 


##### Types of survey:
DEMOGRAPHICS, DIETARY, EXAMINATION, LABORATORY, QUESTIONNAIRE
Abbreviated terms may also be used: (DEMO, DIET, EXAM, LAB, Q).

##### functions:
Use "nhanesTables" to display available tables in each survey
Use "nhanesTableVars" to see definition of each table


##### File Structure: 

Year
----Surveys (e.g. DEMO)
--------Tables (e.g. Blood pressure)
------------Data (e.g. Diastolic; and Participant number)



##### Linked Mortality dataset:
https://ftp.cdc.gov/pub/Health_Statistics/NCHS/datalinkage/linked_mortality/ 


