source("./code/helper_functions.R", encoding = "utf-8")

# EXPLANATION
# You will be unable to run this file from your computer. It calls local datasets -- several gigabyes of flat files of references to academic publication on many topics -- and filters them for publications directly responsive to our research question in this paper. The code is presented here for transparency around the filters used.


# Read in main dataset ----------------------------------------------------

dt_orig <- fread("../DIR/data/tbl_articles_all1.csv")
dt_orig[abstract_ch == "",abstract_ch := title_ch]

search_terms <- read_rds("../DIR/data/tbl_articles_search_terms_all.Rds")
ot_all <- search_terms %>% filter(search_terms == "OrganTransplantation_all")
ot_other <- search_terms %>% filter(search_terms != "OrganTransplantation_all")
ot_all_only <- ot_all %>% filter(document_id %notin% ot_other[["document_id"]])
search_terms_sm <- search_terms %>% filter(document_id %notin% ot_all_only[["document_id"]])

exclusion_title <- as_utf8(c("鼠","犬", "猪", "动物", "兔", "活体", "胰腺", "角膜", "腹部", "婴", "儿", "宝贝"))
exclusion_abstract <- as_utf8(c("鼠", "猪", "兔", "活体", "胰腺", "腹部", "婴", "宝贝"))
inclusion_any <- as_utf8(c("心脏移植","肺移植","心肺联合移植", "供体", "供者", "供心", "供肺", "原位心脏移植", "心、肺联合移植", "热缺血", "心移植", "心脏原位移植", "脑死亡", "心脏死亡", "脑死亡")) # any papers that include these in the title or abstract

# apply the main filters to it -- now I have 2883 papers only that the fulltext fuzzy matching is going to run across. 
dt <- dt_orig[document_id %notin% ot_all_only[["document_id"]]][title_ch %notlike% paste(exclusion_title, collapse = "|")][abstract_ch %notlike% paste(exclusion_abstract, collapse = "|")][title_ch %like% "心|肺|脑死亡"][abstract_ch %like% "手术|心脏移植|肺移植|心肺联合移植|脑死亡" & title_ch %like% paste(inclusion_any, collapse = "|")]

# dt[document_id %like% "CJFD9899_ZDFB901.023"]




# dt_orig %>% nrow() %>% write_lines("./data/database_nrow.txt")
