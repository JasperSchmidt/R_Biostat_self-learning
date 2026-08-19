library(nhanesA)
library(dplyr)

#https://cran.r-project.org/web/packages/nhanesA/vignettes/Introducing_nhanesA.html 

#two year surveys that start in uneven years: 2005 = 2006 survey


View(nhanesTables("EXAM", 2005)) # available variables in survey group
View(nhanesTableVars("EXAM", "BMX_D")) #show table variables
length(nhanesSearchTableNames('BMX')) #list of tables that match pattern

#get tables
bmx_d <- nhanes("BMX_D")  # D = 2005-2006
bmx_e <- nhanes("BMX_E")  # E = 2007-2008

surveys = c("DEMO", "DIET", "EXAM", "LAB", "Q")


#DEMO
View(nhanesTables("DEMO", 2005))

#EXAM
View(nhanesTables("EXAM", 2005))

#LAB
View(nhanesTables("LAB", 2005))

#Q
View(nhanesTables("Q", 2005))
View(nhanesTableVars("Q", "SMQ_D"))
View(nhanes("SMQ_D"))

# Smoking
# check for years with available smoking data (A and K missing)
smoking_years <- nhanesSearchTableNames('SMQ_') 

#check if questions are identical 
smq_d_vars <- nhanesTableVars("Q", "SMQ_D")$Variable.Name # Question Code in years d
smq_e_vars <- nhanesTableVars("Q", "SMQ_E")$Variable.Name # Question Code in years e

#filter out only the questions that are asked in both years
common_vars <- nhanesTableVars("Q", "SMQ_D") |> 
  filter(Variable.Name %in% intersect(smq_d_vars, smq_e_vars)) 

# select question Code for questions of interest
columns <- common_vars[c(1,4,5),1] # SEQN, age last smoked, amount smoked

smq_d <- select(nhanes("SMQ_D"), all_of(columns)) # truncate data to questions of interest
smq_e <- select(nhanes("SMQ_E"), all_of(columns))

smq_d <- smq_d |> 
  filter(!is.na(SMD055)) #filter out NA data (non smoker answers)

smq_e <- smq_e |> 
  filter(!is.na(SMD055))


