library(readr)
library(knitr)
library(tidyverse)
library(flextable)
library(janitor)
library(data.table)
library(scales)
library(glue)
library(here)
options(Encoding="UTF-8")
here <- rprojroot::find_rstudio_root_file()


unique_medical_workers <- fread(glue("{here}/data/authors_in_bdd_included.csv"), colClasses = 'character') %>% 
  distinct(author_ch, .keep_all = T) %>% 
  mutate(docid = str_pad(docid, 4, "left", 0))


source("./code/06_deduplication.R")

docids_w_hospitals %>%
  left_join(unique_medical_workers, on = "docid") %>% 
  fwrite("./out/TEMP-doctors_hospitals.csv")

# NOW PLEASE SEE ./out/readme.md FOR AN EXPLANATION OF WHAT HAPPENED. 

joined_df <- docids_w_hospitals %>%
  left_join(unique_medical_workers, on = "docid")

hw_names_en <- fread("./out/health_worker_names_w_en.csv")
hospital_names_en <- fread("./out/clean_hospital_w_en.csv")


joined_df %>% 
  left_join(., hospital_names_en) %>% 
  left_join(., hw_names_en, on = "author_ch") %>% 
  distinct(author_ch, .keep_all = T) %>% 
  writexl::write_xlsx("./out/health_workers_names_and_hospitals_clean.xlsx")
  