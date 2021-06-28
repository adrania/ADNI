#####
# This scripts reads previously filter datasets (Filter.R) and process them to remove NaN values
#####

# Lib to drop NaN values
library(dplyr)

# Set path to data files
path = getwd()

# Read CSV files
control_file <- file.path(path, 'data', 'CN_track.csv')
disease_file <- file.path(path, 'data', 'AD_track.csv')
converted_file <- file.path(path, 'data', 'MC_AD_track.csv')
mc_file <- file.path(path, 'data', 'MC_track.csv')

CN <- read.csv(control_file)
AD <- read.csv(disease_file)
MCtoAD <- read.csv(converted_file)
MC <- read.csv(mc_file)

# Processing - remove NaN values
CN[is.na(CN)] <- 0
AD[is.na(AD)] <- 0
MC[is.na(MC)] <- 0
MCtoAD[is.na(MCtoAD)] <- 0

# Save files
p_controls_file <- file.path(path, 'data', 'p_control.csv')
p_disease_file <- file.path(path, 'data', 'p_disease.csv')
p_converted_file <- file.path(path, 'data', 'p_converted.csv')
p_mc_file <- file.path(path, 'data', 'p_mc.csv')

write.csv(CN, p_controls_file, row.names=FALSE)
write.csv(AD, p_disease_file, row.names=FALSE)
write.csv(MCtoAD, p_converted_file, row.names=FALSE)
write.csv(MC, p_mc_file, row.names=FALSE)

print(summary(CN))
print(summary(AD))
print(summary(MC))

# Also, print out number of subjects in each group
#ent_volumes <- CN$Entorhinal > 0
#ent_ds <- subset(CN, Entorhinal > 0)
#ent_ds <- select(ent_ds, RID, Entorhinal)
#print("")
#print(paste0("Subjects with Entorhinal values: ", length(ent_volumes)))
#print(head(ent_ds))

#unique_ent_ds = ent_ds %>% distinct(RID)
#subjects = unique_ent_ds$RID
#print(paste0("Unique subjected in DS: ",length(subjects)))
