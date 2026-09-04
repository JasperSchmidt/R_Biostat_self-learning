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

View(nhanesTables("Q", 2005))
View(nhanesTableVars("Q", "SMQ_D"))
View(nhanes("SMQ_D"))

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
  filter(!is.na(SMD055)) |> #filter out NA data (non smoker answers)
  filter(SMD055 < 500) |>  #filter out extreme data (probably artefacts)
  filter(SMD057 < 500)

smq_e <- smq_e |> 
  filter(!is.na(SMD055)) |> 
  filter(SMD055 < 500) |>  #filter out extreme data (probably artefacts)
  filter(SMD057 < 500)

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







