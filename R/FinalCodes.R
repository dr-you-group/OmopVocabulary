## Set .Renviron to hide important information
#install.packages("usethis")
#usethis::edit_r_environ()

## Install required packages ##
# install.packages("rlang")
# install.packages("dplyr") 
# install.packages("openxlsx") 
# install.packages("readr")
library(rlang)
library(dplyr)
library(openxlsx)
library(readr)
library(tidyverse)
library(stringr)
library(plyr)

dataFolder <- file.path("C:/Users/yijoo0320/Desktop/연구_박이주/EDI to OMOP CDM/MAPPING/진행")

# 언어 삭제/변경(인코딩 오류)
Sys.setlocale("LC_ALL", "C") 
Sys.setlocale("LC_ALL", "Korean.utf8")

conMap <- read.csv(
  file = file.path(dataFolder, "IncompleteMapping_drug2022.11.17.csv"),
  header = TRUE, sep = ",", fileEncoding = "euc-kr")

#concept <- read.csv("C:/Users/yijoo0320/git/dr-you-group/OmopVocabulary/data/OmopVoca2022.11.13/CONCEPT.csv", quote = "", row.names = NULL, sep = "\t") #,nrows=10

# target_vocabulary_id에 vocabulary_id 작성
conMap$target_concept_id <- as.character(conMap$target_concept_id)
names(concept)[1] <- c("target_concept_id")
union1 <- left_join(conMap, concept, by = "target_concept_id")

# target_vocabulary_id 작성
conMap$target_vocabulary_id <- union1$vocabulary_id

conMap$target_code_description <- union1$concept_name

# target_domain_id 추가
conMap$target_domain_id <- union1$domain_id

# target_concept_class_id 추가
conMap$target_concept_class_id <- union1$concept_class_id

conMap <- conMap %>% relocate(target_domain_id, .before = target_vocabulary_id) 
conMap <- conMap %>% relocate(target_concept_class_id, .after = target_vocabulary_id)
conMap <- conMap %>% relocate(target_code_description, .after = target_concept_class_id)
conMap <- conMap %>% relocate(ATC_code, .before = X)


#conMap$source_concept_synonym <- str_replace_all(conMap$source_concept_synonym, "," , ".")
conMap$source_code_description <- str_replace_all(conMap$source_code_description, "," , ".")
conMap$target_code_description <- str_replace_all(conMap$target_code_description, "," , ".")

# seperate data to complete/incomplete data
CompleteData <- conMap
IncompleteData <- conMap

## Complete ##
CompleteData$target_vocabulary_id = ifelse(str_detect(CompleteData$target_vocabulary_id, "Rx")|str_detect(CompleteData$target_vocabulary_id, "SNOMED"),
                                           CompleteData$target_vocabulary_id,
                                           NA
)

CompleteData$invalid_reason <-  0
CompleteData$source_code <-  ifelse(is.na(CompleteData$source_code), 0, CompleteData$source_code)
CompleteData$source_concept_id <-  ifelse(is.na(CompleteData$source_concept_id), 0, CompleteData$source_concept_id)
CompleteData$source_domain_id <-  ifelse(is.na(CompleteData$source_domain_id), 0, CompleteData$source_domain_id)
CompleteData$source_vocabulary_id <-  ifelse(is.na(CompleteData$source_vocabulary_id), 0, CompleteData$source_vocabulary_id)
CompleteData$source_concept_class_id <-  ifelse(is.na(CompleteData$source_concept_class_id), 0, CompleteData$source_concept_class_id)
#CompleteData$source_concept_synonym <-  ifelse(is.na(CompleteData$source_concept_synonym), 0, CompleteData$source_concept_synonym)
CompleteData$source_code_description <-  ifelse(is.na(CompleteData$source_code_description), 0, CompleteData$source_code_description)
CompleteData$target_code_description <-  ifelse(is.na(CompleteData$target_code_description), 0, CompleteData$target_code_description)
CompleteData$comment <-  ifelse(is.na(CompleteData$comment), 0, CompleteData$comment)
CompleteData$seq <-  ifelse(is.na(CompleteData$seq), 1, CompleteData$seq)



CompleteData <- na.omit(CompleteData)

# invalid_reason NA
CompleteData$invalid_reason <- "U"

# valid_start_date 작성
CompleteData$valid_start_date <- "2022-10-20"

# valid_end_date 작성
CompleteData$valid_end_date <- NA


## Incomplete ##
IncompleteData$target_vocabulary_id = ifelse(is.na(IncompleteData$target_vocabulary_id), 0, IncompleteData$target_vocabulary_id)
IncompleteData$target_vocabulary_id = ifelse(str_detect(IncompleteData$target_vocabulary_id, "Rx")|str_detect(IncompleteData$target_vocabulary_id, "SNOMED"), NA, IncompleteData$target_vocabulary_id)

IncompleteData$invalid_reason <-  0
IncompleteData$source_code <-  ifelse(is.na(IncompleteData$source_code), 0, IncompleteData$source_code)
IncompleteData$source_concept_id <-  ifelse(is.na(IncompleteData$source_concept_id), 0, IncompleteData$source_concept_id)
IncompleteData$source_domain_id <-  ifelse(is.na(IncompleteData$source_domain_id), 0, IncompleteData$source_domain_id)
IncompleteData$source_vocabulary_id <-  ifelse(is.na(IncompleteData$source_vocabulary_id), 0, IncompleteData$source_vocabulary_id)
IncompleteData$source_concept_class_id <-  ifelse(is.na(IncompleteData$source_concept_class_id), 0, IncompleteData$source_concept_class_id)
# IncompleteData$source_concept_synonym <-  ifelse(is.na(IncompleteData$source_concept_synonym), 0, IncompleteData$source_concept_synonym)
IncompleteData$source_code_description <-  ifelse(is.na(IncompleteData$source_code_description), 0, IncompleteData$source_code_description)
IncompleteData$target_code_description <-  ifelse(is.na(IncompleteData$target_code_description), 0, IncompleteData$target_code_description)
IncompleteData$target_concept_id <-  ifelse(is.na(IncompleteData$target_concept_id), 0, IncompleteData$target_concept_id)
IncompleteData$target_domain_id <-  ifelse(is.na(IncompleteData$target_domain_id), 0, IncompleteData$target_domain_id)
IncompleteData$target_concept_class_id <-  ifelse(is.na(IncompleteData$target_concept_class_id), 0, IncompleteData$target_concept_class_id)
IncompleteData$valid_end_date <-  ifelse(is.na(IncompleteData$valid_end_date), 0, IncompleteData$valid_end_date)
IncompleteData$comment <-  ifelse(is.na(IncompleteData$comment), 0, IncompleteData$comment)
IncompleteData$seq <-  ifelse(is.na(IncompleteData$seq), 1, IncompleteData$seq)


IncompleteData <- na.omit(IncompleteData)

x <- rbind(CompleteData, IncompleteData)
x <- arrange(x, x$X)
write.csv(x, file = file.path(dataFolder,"IncompleteMapping_drug2022.11.17.csv"), fileEncoding = "euc-kr", na = "", row.names = FALSE)

