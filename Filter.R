#####
# This scripts reads previously created datasets (Subsets_construction.R) and filter them to get only RIDs with data through time
#####

# Lib to filter and select values
library(dplyr)

# Set path to data files
path = getwd()

# Read CSV files
control_file <- file.path(path, 'data', 'control.csv')
disease_file <- file.path(path, 'data', 'disease.csv')
converted_file <- file.path(path, 'data', 'converted.csv')
mci_file <- file.path(path, 'data', 'mc_constant.csv')
CN <- read.csv(control_file)
AD <- read.csv(disease_file)
MCtoAD <- read.csv(converted_file)
MC <- read.csv(mci_file)

## CONTROL DATASET
# Get only RIDs with months tracking 
CN <- subset(CN, VISCODE == 'bl' | VISCODE == 'm12' | VISCODE == 'm24'| VISCODE == 'm36' | VISCODE =='m48')
# Filter to get RIDs with cerebellum and hippocampus values 
CN <- filter(CN, !is.na(CN['WHOLECEREBELLUM_SUVR']) | !is.na(CN['RIGHT_HIPPOCAMPUS_VOLUME']) | !is.na(CN['LEFT_HIPPOCAMPUS_VOLUME']))
# Get only repeated values freq > 1 (give us tracked patients through time)
n_occur <- data.frame(table(CN$RID))
n_occur[n_occur$Freq > 1,]
# Control patients
CN_track <- CN[CN$RID %in% n_occur$Var1[n_occur$Freq > 1],]

## DISEASE DATASET
AD <- subset(AD, VISCODE == 'bl' | VISCODE == 'm12' | VISCODE == 'm24'| VISCODE == 'm36' | VISCODE =='m48')
AD <- filter(AD, !is.na(AD['WHOLECEREBELLUM_SUVR']) | !is.na(AD['RIGHT_HIPPOCAMPUS_VOLUME']) | !is.na(AD['LEFT_HIPPOCAMPUS_VOLUME']))
n_occur <- data.frame(table(AD$RID))
n_occur[n_occur$Freq > 1,]
# Patients with Alzheimer
AD_track <- AD[AD$RID %in% n_occur$Var1[n_occur$Freq > 1],]

## MC DATASETS
MCtoAD <- subset(MCtoAD, VISCODE == 'bl' | VISCODE == 'm12' | VISCODE == 'm24'| VISCODE == 'm36' | VISCODE =='m48')
MCtoAD <- filter(MCtoAD, !is.na(MCtoAD['WHOLECEREBELLUM_SUVR']) | !is.na(MCtoAD['RIGHT_HIPPOCAMPUS_VOLUME']) | !is.na(MCtoAD['LEFT_HIPPOCAMPUS_VOLUME']))
n_occur <- data.frame(table(MCtoAD$RID))
n_occur[n_occur$Freq > 1,]
# Transformant patients dataframe MC into Alzheimer
MCtoAD_track <- MCtoAD[MCtoAD$RID %in% n_occur$Var1[n_occur$Freq > 1],]

MC <- subset(MC, VISCODE == 'bl' | VISCODE == 'm12' | VISCODE == 'm24'| VISCODE == 'm36' | VISCODE =='m48')
MC <- filter(MC, !is.na(MC['WHOLECEREBELLUM_SUVR']) | !is.na(MC['RIGHT_HIPPOCAMPUS_VOLUME']) | !is.na(MC['LEFT_HIPPOCAMPUS_VOLUME']))
n_occur <- data.frame(table(MC$RID))
n_occur[n_occur$Freq > 1,]
# Constant MC patients
MC_track <- MC[MC$RID %in% n_occur$Var1[n_occur$Freq > 1],]

## Save files
control_file <- file.path(path,'data', 'CN_track.csv')
disease_file <- file.path(path, 'data','AD_track.csv')
converted_file <- file.path(path,'data', 'MC_AD_track.csv')
constant_mc_file <- file.path(path, 'data', 'MC_track.csv')

print("Writting data files:")
write.csv(CN_track, control_file, row.names=FALSE)
write.csv(AD_track, disease_file, row.names=FALSE)
write.csv(MCtoAD_track, converted_file, row.names=FALSE)
write.csv(MC_track, constant_mc_file, row.names=FALSE)
