# Install and load packages
install.packages(c("rlang", "dplyr", "openxlsx", "readr"))
library(rlang)
library(dplyr)
library(openxlsx)
library(readr)

# Load the device.csv dataset
dataFolder <- file.path(Sys.getenv("gitFolder"), "dr-you-group/OmopVocabulary/data/device")
DEVICE <- read.csv(file = file.path(dataFolder, "device.csv"), header = TRUE, sep = ",")

# Load and process the CONCEPT.csv dataset
concept <- read.csv("C:/Users/yijoo0320/git/dr-you-group/OmopVocabulary/data/OmopVoca2022.11.13/CONCEPT.csv", 
                    quote = "", row.names = NULL, sep = "\t")
colnames(concept)[1] <- "source_concept_id"
names(DEVICE)[6] <- "target_concept_id"
concept <- concept[,c(1,2,3,4,5,7)]
conMap <- left_join(DEVICE, concept, by = "source_concept_id")
conMap$source_vocabulary_id <- conMap$vocabulary_id
conMap$source_domain_id <- conMap$domain_id
conMap$source_concept_class_id <- conMap$concept_class_id

# Load and process the CONCEPT_SYNONYM.csv dataset
synonym <- read.csv("C:/Users/yijoo0320/git/dr-you-group/OmopVocabulary/data/OmopVoca2022.11.13/CONCEPT_SYNONYM.csv", 
                    quote = "", row.names = NULL, sep = "\t")
colnames(synonym)[1] <- "source_concept_id"
conMap <- left_join(conMap, synonym, by = "source_concept_id")
conMap$source_concept_synonym <- conMap[,14]
conMap <- conMap[,-c(14)]
colnames(conMap)[13] <- "source_concept_synonym"

# Perform the same processing on the target_concept_id and add columns
colnames(concept)[1] <- "target_concept_id"
union1 <- left_join(conMap, concept, by = "target_concept_id")
conMap$target_vocabulary_id <- union1$vocabulary_id
conMap$target_code_description <- union1$concept_name
conMap$target_domain_id <- union1$domain_id
conMap$target_concept_class_id <- union1$concept_class_id
