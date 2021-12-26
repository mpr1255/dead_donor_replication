library(bib2df)
library(tidyverse)
library(janitor)
library(data.table)
library(glue)
here <- rprojroot::find_rstudio_root_file()
`%notlike%` <- Negate(`%like%`)
refs <- bib2df("./bib_files/dead_donor_references_original.bib")
setDT(refs)
actually_included <- str_remove(read_lines("./bib_files/actually_included_bibtags.txt"), "@")
refs <- refs[BIBTEXKEY %in% actually_included] 
refs <- janitor::remove_empty(refs, which = "cols")
refs[,JOURNAL := str_to_title(JOURNAL)]
refs[JOURNAL == "Bbc", JOURNAL :=  "BBC"]
refs[JOURNAL %like% "Bmc", JOURNAL := str_replace(JOURNAL, "Bmc", "BMC")]

# There are incomplete references in the database to some of the Chinese articles. I have to now export them, get the full metadata from elsewhere, and bring them back in. 
# Identify these problematic cases first....
# refs[is.na(VOLUME) & ISSUE %like% "[0-9]"] %>% df2bib("./bib_files/chinese_paper_w_missing_metadata.bib")
# Made some changes upstream to dead_donor_references_original.bib and the rest of the cleaning follows. 

# Filter out the Chinese papers and fix up the titles ---------------------
refs[grepl("[\\p{Han}]", TITLE, perl = T), TITLE := str_extract(TITLE, "(?<=\\[).*?(?=\\])")]
refs[grepl("[\\p{Han}]", BOOKTITLE, perl = T), BOOKTITLE := str_extract(BOOKTITLE, "(?<=\\[).*?(?=\\])")]
refs[grepl("[\\p{Han}]", CONFERENCE, perl = T), CONFERENCE := str_extract(CONFERENCE, "(?<=\\[).*?(?=\\])")]
refs[grepl("[\\p{Han}]", PUBLISHER, perl = T), PUBLISHER := str_extract(PUBLISHER, "(?<=\\[).*?(?=\\])")]
refs[, AUTHOR := map_chr(AUTHOR, ~paste0(.x, collapse = "; "))]
refs[grepl("[\\p{Han}]", AUTHOR, perl = T), AUTHOR := str_replace_all(AUTHOR, ",", ";")]
refs[grepl("[\\p{Han}]", AUTHOR, perl = T), AUTHOR := str_extract(AUTHOR, "(?<=\\[).*?(?=\\])")]
refs[,TITLE := paste0("{", TITLE, "}")]

# Fix cases that have non-closing curly braces ----------------------------
refs[HOWPUBLISHED %like% "\\{" & HOWPUBLISHED %notlike% "\\}", HOWPUBLISHED := paste0(HOWPUBLISHED, "}")]

# Fix Chinese journal name volume/issue
refs[ISSUE %like% "年", VOLUME := str_extract(ISSUE, "(?<=年).*?(?=期)")]
refs[, YEAR := parse_number(YEAR)]
refs[JOURNAL %like% ";", JOURNAL := str_trim(str_extract(JOURNAL, "(?<=;).*$"))]
refs[grepl("[\\p{Han}]", JOURNAL, perl = T), JOURNAL := str_extract(JOURNAL, "(?<=\\[).*?(?=\\])")]
refs[AUTHOR %like% ";", AUTHOR := str_replace_all(AUTHOR, ";", " and")]


# save
refs %>% df2bib("./ms_rr/dead_donor_references.bib")
