library(nhanesA)
library(dplyr)


View(nhanesTables("EXAM", 2005)) # available variables in survey group
View(nhanesTableVars("EXAM", "BMX_D")) #show table variables
length(nhanesSearchTableNames('BMX')) #list of tables that match pattern

#get tables
bmx_d <- nhanes("BMX_D")  # D = 2005-2006
bmx_e <- nhanes("BMX_E")  # E = 2007-2008

surveys = c("DEMO", "DIET", "EXAM", "LAB", "Q")


#### Data Selection Process ####
# For each cohort (d, e)
# 1. filter out metrics of interest: SEQN, bp, age, age last smoked, amount smoked
# 2. filter out NAs
# 3. merge lists (using SEQN) by intersecting strings (i.e. leaving out individuals with incomplete data) 
# 
#


#### data import ####

#LAB
#View(nhanesTables("LAB", 2005))


##### Smoking #####

# check for years with available smoking data (A and K missing)
smoking_years <- nhanesSearchTableNames('SMQ_') 


View(nhanesTableVars("Q", "SMQ_D")) #compare codes to questions
View(nhanesTableVars("Q", "SMQ_E"))


smq_d <- nhanes("SMQ_D") |> 
  select(all_of(c("SEQN", "SMQ040", "SMD070"))) |> 
  filter(SMD070 < 500 | is.na(SMD070)) # filter out extreme data (artefacts?), apparently "filter" discard NA - keep them here

smq_e <- nhanes("SMQ_E") |> 
  select(all_of(c("SEQN", "SMQ040"))) 

# average age of last smoked in cohort d and e
mean(smq_d$SMD055)
mean(smq_e$SMD055)

# average amount smoked
mean(smq_d$SMD057)
mean(smq_e$SMD057)

##### DEMO ##### 
#View(nhanesTables("DEMO", 2005))
#View(nhanesTableVars("DEMO", "DEMO_D"))
demo_d <- nhanes("DEMO_D") #get demographics for d & e cohort
demo_e <- nhanes("DEMO_E")

#select out SEQN and age (collumns: 38, 28)
#View(nhanesTableVars("DEMO", "DEMO_D"))
#View(nhanesTableVars("DEMO", "DEMO_E"))

demo_d <- demo_d |> 
  select(all_of(c("SEQN", "RIDAGEEX"))) |> #select age data
  filter(!is.na(RIDAGEEX)) #filter out na

demo_e <- demo_e |> 
  select(all_of(c("SEQN", "RIDAGEEX"))) |> 
  filter(!is.na(RIDAGEEX))

#mean(demo_d$RIDAGEEX)/12 # average age
#mean(demo_e$RIDAGEEX)/12


##### EXAM #####
#View(nhanesTables("EXAM", 2005))
#View(nhanesTableVars("EXAM", "BPX_D"))
bpx_d <- nhanes("BPX_D") #get bp data for d,e cohort
bpx_e <- nhanes("BPX_E")


#bp_columns_di = c("BPXDI1", "BPXDI2", "BPXDI3", "BPXDI4")
#bp_columns_sy = c("BPXSY1", "BPXSY2", "BPXSY3", "BPXSY4")

# use only first measurement (for now)

bpx_d <- bpx_d |> 
  select(all_of(c("SEQN", "BPXDI1", "BPXSY1"))) |>  #select bp data 
  filter(!is.na(BPXDI1)) |> 
  filter(!is.na(BPXSY1))

bpx_e <- bpx_e |> 
  select(all_of(c("SEQN", "BPXDI1", "BPXSY1"))) |> #select bp data 
  filter(!is.na(BPXDI1)) |> 
  filter(!is.na(BPXSY1))

#mean(bpx_e$BPXDI1)
#mean(bpx_e$BPXSY1)


#### merge data ####

data_cleaned_d <- smq_d |> 
  inner_join(demo_d, by = "SEQN") |> 
  inner_join(bpx_d, by = "SEQN")

data_cleaned_e <- smq_e |> 
  inner_join(demo_e, by = "SEQN") |> 
  inner_join(bpx_e, by = "SEQN")

#hist(data_cleaned_d$SMD055) #truncated normal distr? 


#### analysis ####

# test smoker and non smoker diastolic blood pressure in d cohort


smoker_d <- filter(data_cleaned_d, SMQ040 == "Every day")
non_smoker_d <- filter(data_cleaned_d, SMQ040 == "Not at all")

# t-test

mean(smoker_d$BPXSY1)
mean(non_smoker_d$BPXSY1)

t.test(smoker_d$BPXSY1, non_smoker_d$BPXSY1, alternative = "t")

# significant result that smoker have lower sys bp

mean(smoker_d$RIDAGEEX) / 12
mean(non_smoker_d$RIDAGEEX) / 12

hist(smoker_d$RIDAGEEX / 12) 
hist(non_smoker_d$RIDAGEEX / 12)

# age distribution of smokers not identical (TODO: check mortality: much more old non-smokers)

# compare smokers and non-smokers at age 70-75

smoker_d_old <- filter(smoker_d, RIDAGEEX >= 70*12 & RIDAGEEX < 75*12)
non_smoker_d_old <- filter(non_smoker_d, RIDAGEEX >= 70*12 & RIDAGEEX < 75*12)

mean(smoker_d_old$BPXSY1)
mean(non_smoker_d_old$BPXSY1)

t.test(smoker_d_old$BPXSY1, non_smoker_d_old$BPXSY1)

# result not significant ! (TODO: check power of test, required sample size -> resize age subset) 




# ToDo: confounding factors: age, definition of non smokers (e.g. smoked previously), bmi, antihypertensiva

# Maybe ToDo: ANCOVA?, Stratification?,  (linear?) regression?

# Review: check for selection biases, check if model assumptions of t-test are satisfied (tests?)

# other ideas: distribution fit?, truncated normals in some variables (how to deal with this)? 








