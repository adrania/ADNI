# LIBRARIES to be installed if not yet done  
# install.packages('Hmisc')
# install.packages("/path/ADNIMERGE_0.0.1.tar.gz", repos = NULL, type = "source")
library('Hmisc')
library(ADNIMERGE)
options(digits = 5)
library(knitr)
library(ggplot2)
library(gridExtra)
library(RColorBrewer)

## Setting workpath
path <- getwd()
setwd(path)
message <- cat("Set work path for dir: ", file.path(path))
print(message)

## ADNI dataset
data <- adnimerge
# print("ADNI merge dataset content:")
# print(head(data))

## Florbetapir dataset: 'UCBERKELEYAV45_01_14_21.csv' file
av45_file <- file.path(path, 'data', "UCBERKELEYAV45_01_14_21.csv")
florbetapir <- read.csv(av45_file)
florbetapir <- subset(florbetapir, select=-VISCODE)  #remove first VISCODE
names(florbetapir)[2] <- 'VISCODE'  #change name VISCODE2 into VISCODE to merge tables

## Patients' subsets. Based on their baseline diagnostic 
# 5 levels of diagnosis DX.bl ('CN', 'SMC', 'EMCI', 'LMCI', 'AD')
control_bl <- subset(data, DX.bl == 'CN')
disease_bl <- subset(data, DX.bl == 'AD')
mc_bl <- subset(data, DX.bl == 'SMC' | DX.bl == 'EMCI' | DX.bl == 'LMCI')

## Vector of interesting columns 
col_adni <- c('RID', 'VISCODE', 'EXAMDATE', 'DX.bl', 'DX', 'AGE','PTGENDER', 'PTGENDER', 'PTRACCAT', 'APOE4','AV45','ABETA','TAU', 'PTAU', 'Hippocampus', 'WholeBrain', 'Entorhinal')
col_flor <- c('RID', 'VISCODE', 'EXAMDATE', 'WHOLECEREBELLUM_SUVR', 'CTX_LH_ENTORHINAL_SUVR', 'CTX_RH_ENTORHINAL_SUVR','LEFT_HIPPOCAMPUS_VOLUME','RIGHT_HIPPOCAMPUS_VOLUME', 'TOTAL_INTRACRANIAL_VOLUME', 'SUMMARYSUVR_WHOLECEREBNORM_1.11CUTOFF', 'CSF_SUVR')
florbetapir <- subset(florbetapir, select=col_flor)

## Control baseline dataset processing
# 3 levels of diagnosis DX ('CN', 'Dementia', 'MCI')
control_ct <- subset(control_bl, DX == 'CN', select = col_adni) # constant control pacients
CN <- merge(control_ct, florbetapir, by = c('RID','VISCODE', 'EXAMDATE'), all.x=TRUE, no.dups=TRUE) # CONTROL DATASET

## Disease baseline dataset processing 
disease_ct <- subset(disease_bl, DX == 'Dementia' | DX == 'MCI', select=col_adni) # constant disease
AD <- merge(disease_ct, florbetapir, by = c('RID','VISCODE', 'EXAMDATE'), all.x=TRUE, no.dups=TRUE) # CONSTANT DISEASE DATASET

## MC baseline dataset processing
transform_mc_ad <- subset(mc_bl, DX == 'Dementia', select=col_adni) # MC into Dementia
MCtoAD <- merge(transform_mc_ad, florbetapir, by = c('RID','VISCODE', 'EXAMDATE'), all.x=TRUE, no.dups=TRUE) # MC into DISEASE 

mc_ct <- subset(mc_bl, DX == 'MCI', select=col_adni) # MC constant
MC <- merge(mc_ct, florbetapir, by=c('RID','VISCODE', 'EXAMDATE'), all.x=TRUE, no.dups=TRUE) # CONSTANT MC DATASET

## Save files
control_file <- file.path(path,'data', 'control.csv')
disease_file <- file.path(path, 'data','disease.csv')
converted_file <- file.path(path,'data', 'converted.csv')
constant_mc_file <- file.path(path, 'data', 'mc_constant.csv')

print("Writting data files:")
write.csv(CN, control_file, row.names=FALSE)
write.csv(AD, disease_file, row.names=FALSE)
write.csv(MCtoAD, converted_file, row.names=FALSE)
write.csv(MC, constant_mc_file, row.names=FALSE)
