#####
# This scripts reads previously created datasets and process them to remove NaN values
#####

# Lib to drop NaN values
library(dplyr)

# Set path to data files
path = getwd()

# Read CSV files
controls_file <- file.path(path, 'data', 'control.csv')
disease_file <- file.path(path, 'data', 'disease.csv')
converted_file <- file.path(path, 'data', 'converted.csv')
CN <- read.csv(controls_file)
AD <- read.csv(disease_file)
MC <- read.csv(converted_file)

# print(CN)


# Processing - remove NaN values
# CN <- na.replace(CN, 0)
# AD <- na.replace(AD, 0)
# MC <- na.replace(MC, 0)

CN[is.na(CN)] <- 0
AD[is.na(AD)] <- 0
MC[is.na(MC)] <- 0
print(head(CN))
print(head(AD))
print(head(MC))

apply_col_clean = FALSE
if (apply_col_clean){
  # Any column with only NaN values?
  lista <- list()

  for (column in names(p)) {
    len <- length(lista)
    if (sum(is.na(p[column])) == length(p)) {lista[[len+1]] <- column}}
    
  print(lista)
}

#if there is any column with only NaN values we have to remove it

# Save files
p_controls_file <- file.path(path, 'data', 'p_control.csv')
p_disease_file <- file.path(path, 'data', 'p_disease.csv')
p_converted_file <- file.path(path, 'data', 'p_converted.csv')
write.csv(CN, p_controls_file, row.names=FALSE)
write.csv(CN, p_disease_file, row.names=FALSE)
write.csv(CN, p_converted_file, row.names=FALSE)

print(summary(CN))
print(summary(AD))
print(summary(MC))


# TODO: Clean auxiliar variables to include only representative ones, i.e., remove columnas like "CC_CENTRAL_SUVR","CC_CENTRAL_VOLUME","CC_MID_ANTERIOR"_SUVR",...
# We are only interested in Entorhinal and Hippocampus volumes and WHOLECEREBELLUM_SUVR, "SUMMARYSUVR_WHOLECEREBNORM_1.11CUTOFF"
# and others relevant biomarkers to predict AD conversion

# Also, print out number of subjects in each group
ent_volumes <- CN$Entorhinal > 0
ent_ds <- subset(CN, Entorhinal > 0)
ent_ds <- select(ent_ds, RID, Entorhinal)
print("")
print(paste0("Subjects with Entorhinal values: ", length(ent_volumes)))
print(head(ent_ds))

unique_ent_ds = ent_ds %>% distinct(RID)
subjects = unique_ent_ds$RID
print(paste0("Unique subjected in DS: ",length(subjects)))
