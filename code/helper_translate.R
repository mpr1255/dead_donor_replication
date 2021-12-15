library(flextable)
library(data.table)
library(officer)
library(tidyverse)
library(here)
library(glue)
library(janitor)
library(googleLanguageR)


here <- rprojroot::find_root("dead_donor_replication.Rproj")

gl_auth("/mnt/c/Program Files/R/google_translate_api/try-apis-9f00867d8be6.json") #You'll need your own token to rerun these.

translate_text <- function(.x) {
  gl_translate(.x, target = "en")$translatedText
}

# Set up functions. Action happens underneath. ---------------------------------
template <- read_lines("./data/df2bib_template.bib")

make_bib_file <- function(x){
  y <- as.character(substitute(x))
  
  if (!file.exists(paste0("./data/bib_files/", y,".bib"))){
    
    for (i in 1:nrow(x)){
      
      temp <- template 
      
      bibtexentry <- as.character(x[["bibtexkey"]][i])
      title <- str_trim(x[["full_title"]][i])
      authors <- str_trim(x[["full_authors"]][i])
      journal <- str_trim(x[["journal"]][i])
      issue <- str_trim(x[["issue"]][i])
      year <- str_trim(x[["year"]][i])
      
      temp <- gsub("\\{bibtexentry\\}", bibtexentry, temp)
      temp <- gsub("\\{title\\}", title, temp)
      temp <- gsub("\\{authors\\}", authors, temp)
      temp <- gsub("\\{journal\\}", journal, temp)
      temp <- gsub("\\{issue\\}", issue, temp)
      temp <- gsub("\\{year\\}", year, temp)
      
      write_lines(temp, paste0("./bib_files/", y,".bib"), append=TRUE)
      
    } 
    
  }else{
    print("bib file exists.")
  }
}


# Fix references in appendix 2 --------------------------------------------

tbl_a <- fread(glue("{here}/appendix_2/bdd_included.csv", sep = "\t", colClasses = 'character', quote=""))[,`:=` (year = as.character(year), id = as.character(str_pad(id, 4, "left", 0)))][order(year)]

appendix2_refs <- tbl_a$id

all_papers <- bib2df::bib2df("./data/all_included_w_data.bib")
setDT(all_papers)

all_papers <- clean_names(all_papers)

all_papers <- all_papers[bibtexkey %in% appendix2_refs]

all_papers <- all_papers[,.(bibtexkey, author, title, journal, issue)]

all_papers$title

all_papers[,eng_titles := map_chr(title, ~translate_text(.x))]
all_papers[,eng_authors := map_chr(author, ~translate_text(.x))]

all_papers %>% fwrite("./appendix_2/bdd_included_translated_refs.csv")

str(all_papers)


# Fix references in main part of the paper --------------------------------
# This can't really be run as a program. It was done interactively until it worked; a lot of trial and error just to get the references in the main bib file translated using the google translate function. For that reason I've just commented it all out. 

# refs <- bib2df::bib2df("./bib_files/papers_only.bib")
# setDT(refs)
# refs <- clean_names(refs)
# 
# refs <- refs[,.(bibtexkey, author, title, journal, year, issue)]
# 
# refs[,eng_titles := map_chr(title, ~translate_text(.x))] 
# refs[,eng_authors := map_chr(author, ~try(translate_text(.x)))]
# refs[dt_eng_authors1, on = "bibtexkey"]
# # refs[,category := "ARTICLE"] %>% bib2df::df2bib("./bib_files/papers_with_eng.bib")
# 
# dt_eng_authors <- bib2df::bib2df("./bib_files/papers_with_eng.bib")
# setDT(dt_eng_authors)
# dt_eng_authors1 <- dt_eng_authors[,.(BIBTEXKEY, ENG_AUTHORS)]
# dt_eng_authors1 <- clean_names(dt_eng_authors1)
# 
# refs1 <- refs[,full_title := paste0(title, " [", eng_titles, "]")]
# refs1 <- refs[,full_authors := paste0(authors, " [", eng_authors, "]")]
# authors_only <- refs1[,.(bibtexkey, author)]
# 
# refs2 <- refs1[,.(bibtexkey, full_title, full_authors, journal, issue)]
# refs_join <- refs[,.(bibtexkey, year)]
# refs2 <- refs2[refs_join, on = "bibtexkey"]
# refs2 <- refs2[,-c("full_authors")]
# 
# refs2 <- refs2[dt_eng_authors1, on = "bibtexkey"]
# refs2 <- refs2[authors_only, on = "bibtexkey"]
# refs2[,full_authors := paste0(author, " [", eng_authors, "]")]
# 
# 
# refs3 <- refs2[,.(category, bibtexkey, full_authors, full_title, journal, year, issue)]
# setcolorder(refs2, "category")
# 
# refs2 %>% bib2df::df2bib("./bib_files/papers_with_eng2.bib")
# 
# make_bib_file(refs3)
