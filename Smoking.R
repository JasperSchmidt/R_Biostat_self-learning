library(nhanesA)

#https://cran.r-project.org/web/packages/nhanesA/vignettes/Introducing_nhanesA.html 

#two year surveys that start in uneven years: 2005 = 2006 survey


#View(nhanesTables("EXAM", 2005)) # available variables in survey group
#View(nhanesTableVars("EXAM", "BMX_D")) #show table variables
length(nhanesSearchTableNames('BMX')) #list of tables that match pattern

#get tables
bmx_d <- nhanes("BMX_D")  # D = 2005-2006
bmx_e <- nhanes("BMX_E")  # E = 2007-2008




bmi_d <- bmx_d[,c(1,11)]
bmi_e <- bmx_e[,c(1,11)]



