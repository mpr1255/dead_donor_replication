# Set up functions. Action happens underneath. ---------------------------------
library(bib2df)
library(tidyverse)
library(janitor)
library(data.table)
library(glue)

template <- read_lines("./data/df2bib_template.bib")
options(Encoding="UTF-8")
here <- rprojroot::find_rstudio_root_file()

`%notlike%` <- Negate(`%like%`)

make_bib_file <- function(x){
  y <- as.character(substitute(x))
  
  if (!file.exists(paste0("./data/refs/", y,".bib"))){
    
    for (i in 1:nrow(x)){
      
      temp <- template 
    
      bibtexentry <- as.character(x[["docid"]][i])
      title <- str_trim(x[["title_ch"]][i])
      authors <- str_trim(x[["author_ch"]][i])
      journal <- str_trim(x[["journal"]][i])
      issue <- str_trim(x[["journal_issue"]][i])
      year <- str_trim(x[["journal_year"]][i])
      
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

# Some local-only data cleaning and reconciliation here -------------------
# This won't run on your computer, because it calls files that reveal the specific databases the papers came from, and doing so may limit further access to such sources. Thus, they are not published as part of the paper. Of course, all data used for the paper comes from officially published PRC scientific journals and is available to anyone who subscribes to them. We also include the full text files in our dataset.

all_included <- fread("./_data/..._and_new_id_codes_linking_old_new.csv", colClasses = 'character')
dt_orig <- fread("../..._analysis/data/tbl_articles_all1.csv")
dt_authors <-  fread("../..._analysis/data/transplant_authors_20210607_1307.csv")

all_included_w_data <- dt_orig[all_included, on = "document_id"]
all_included_authors <- dt_authors[document_id %in% all_included_w_data$document_id]
all_included_authors[,author_ch := map(author_ch, ~paste0(.x, collapse = ","))]
all_included_authors <- all_included_authors[, lapply(.SD, paste0, collapse=", "), by=document_id][,-c("V1")]
all_included_w_data <- all_included_authors[all_included_w_data, on = "document_id"]

# make bib file. 
make_bib_file()