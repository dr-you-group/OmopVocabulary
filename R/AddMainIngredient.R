dataFolder <- file.path(Sys.getenv("gitFolder"), "dr-you-group/OmopVocabulary/data/drug")

drugfee <- read.csv( file = file.path(dataFolder, "drug_fee.csv"),
          header = TRUE, sep = ",")

drug <- read.csv( file = file.path(dataFolder, "drug.csv"),
                  header = TRUE, sep = ",")

names(drugfee)[2] <- c("source_code")
colnames(drugfee)
drugfee$source_code <- as.character(drugfee$source_code)
a <- left_join(drug,drugfee, by = "source_code")

colnames(a)
names(a)[12] <- c("main_ingredient")
names(a)[14] <- c("ATC_code")

a <- a %>% relocate(main_ingredient, .after = source_code) 
a <- a %>% relocate(ATC_code, .after = source_code)

write.csv(a, file = "C:/Users/yijoo0320/git/dr-you-group/OmopVocabulary/data/drug/drug.csv", fileEncoding = "euc-kr", na = "")
