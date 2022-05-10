rm(list=ls())
source("./code/helper_functions.R", encoding = "utf-8") 

here <- rprojroot::find_rstudio_root_file()


# NB: This takes up exactly where post_2015_analysis left off -------------

res_2015 <- as.data.table(readxl::read_xlsx(glue("{here}/data/post_2015_examination.xlsx")))


link_codes <- fread("./_data/old_and_new_id_codes_linking_to_original_database.csv", colClasses = 'character')
original_database <- fread("./_data/transplant_papers_20210607_1307.csv", colClasses = 'character')
dt <- original_database[document_id %in% link_codes$document_id]
dt <- dt[link_codes, on = "document_id"]

post_2015 <- dt[journal_year > 2015 & abstract_ch %like% "手术" & abstract_ch %like% "心脏" & abstract_ch %like% "移植"] %>% 
  unique(., by = "docid") 

post_2015[,have_file := ifelse(file.exists(paste0(here,"/data/txt/",docid,".txt")), 1, 0)]
post_2015[have_file == 1,fulltext := map_chr(docid, ~read_file(paste0(here,"/data/txt/",.x,".txt")))]

# STRUCTURE: The code is run, and the results are explained.

post_2015[have_file == 1]
# There are 102 files related to heart transplant surgery in my dataset; I have all 100 of them in txt files. ("related to heart transplant surgery" means that the papers contain the words "heart" and "transplant" and "surgery" in the abstract. This was the same basic criteria used to filter the papers for the AJT manuscript.)

post_2015[have_file == 1 & fulltext %like% "自愿|捐献" & fulltext %like% "脑死"]
# 48 of those 100 contain the words "voluntary" or "donation". These were not inspected further. 

options(datatable.prettyprint.char=40L)
post_2015[have_file == 1 & fulltext %notlike% "自愿|捐献"][,.(docid)]
# 52 of them don't refer to voluntary or donation. 

post_2015[have_file == 1 & fulltext %notlike% "自愿|捐献" & fulltext %notlike% "供体"][,.(docid)]
# 24 of that 52 do not refer to donors anywhere in the paper. I looked at some of these and some are about heart transplants while some aren't -- for example, they're analyses of other surgeries or treatments of heart transplant recipients (not REPORTS of heart transplants.)

post_2015[have_file == 1 & fulltext %notlike% "自愿|捐献" & fulltext %like% "供体"][,.(docid)]
# 28 refer to donors in the paper. It's mainly these we're interested in: they are about heart transplant surgeries, they are post 2015, they talk about donors somewhere, but they don't use the words voluntary or donation. Let's have a look at some....
