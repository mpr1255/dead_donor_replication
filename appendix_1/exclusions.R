library(glue)
library(here)
library(utf8)

here <- here()

# Create list of files and paper titles for fuzzy searching ---------------
path <- glue("{here}/appendix_1/txt/")
appendix1_ref_data <- fread(glue("{here}/appendix_1/references/appendix1_full_ref_data.csv"))

raw_file_list <- as_utf8(list.files(path)) %>% 
  as_tibble() %>% 
  separate(col="value", sep = "--", into = c("id_number", as_utf8("title")), remove = FALSE, extra = "drop")

n_file_list_pilot <- nrow(raw_file_list)

# Sys.setlocale("LC_CTYPE", locale = "chs")

# Establish exclusions ----------------------------------------------------
# These terms were derived from clerical review and common sense. The title of the paper is checked against these terms, and if the title includes the terms, the paper is excluded and the reason for exclusion marked. Note that titles of papers found later were added to the general terms below.
# A: Animal research
# O: Other organs (not hearts or lungs)
# I: Infant
# V: Voluntary donors (per an affirmative, explicit statement that they were volunteers or family)
# NC: Non-clinical

exclusion_terms_A <- as_utf8(c("鼠","犬", "猪", "动物", "兔"))
exclusion_terms_O <- as_utf8(c("肾", "活体", "胰腺",  "肝",  "角膜", "腹部"))
exclusion_terms_I <- as_utf8(c("婴", "儿", "宝贝"))
exclusion_terms_V <- as_utf8(c("亲", "志愿"))
exclusion_terms_NC <- as_utf8(c("基因", "植物", "共识"))

# Find exclusions in paper_reference_data file by searching through abstracts. Only applicable to animal
exclude_list_from_abstract_A <- appendix1_ref_data %>% 
  filter(grepl(paste(as_utf8(exclusion_terms_A), collapse='|'), abstract_ch)) %>% 
  mutate(id_number = str_pad(id_number, 4, "left", "0")) %>% 
  select(id_number) %>% as.list(.)
  
# Put exclusions in a dataframe -------------------------------------------

df_exclusions <- tibble()
df_exclusions <- raw_file_list %>% 
  mutate(
    exclusion_term = case_when(
      grepl(paste(as_utf8(exclusion_terms_O), collapse='|'), title) ~ "O",
      grepl(paste(as_utf8(exclusion_terms_A), collapse='|'), title) ~ "A",
      grepl(paste(as_utf8(exclusion_terms_I), collapse='|'), title) ~ "I",
      grepl(paste(as_utf8(exclusion_terms_V), collapse='|'), title) ~ "V",
      grepl(paste(as_utf8(exclusion_terms_NC), collapse='|'), title) ~ "NC", 
      id_number %in% exclude_list_from_abstract_A ~ "A")) %>%
  filter(!is.na(exclusion_term))

df_exclusion_counts <- df_exclusions %>% count(exclusion_term, sort = TRUE)

o_ex <- df_exclusion_counts$n[1]
a_ex <- df_exclusion_counts$n[2]
i_ex <- df_exclusion_counts$n[3]
nc_ex <- df_exclusion_counts$n[4]
v_ex <- df_exclusion_counts$n[5]

# Same for second round of exclusions
ft_exclusion_terms_A <- as_utf8(c("心不停跳心脏移植的初步研究", "无心跳供体心脏移植热缺血时限的实验研究", "1例小肠移植术后感染的观察与治疗", "无心跳供体肺移植中部分液体通气对肺保护的病理学评估", "实验脑死状态海马与皮层电活动研究", "热缺血后低温保存对供心的影响"))
ft_exclusion_terms_O <- as_utf8(c("胰岛移植(文献综述)", "心脏死亡器官捐献9例报告", "器官捐献过程中供体采集的手术配合", "1例小肠67b n  移植术后感染的观察与治疗", "胰岛", "1例应用ECMO技术成功进行心死亡器官捐献病人器官维护的护理"))
ft_exclusion_terms_I <- as_utf8("新生儿脑死亡诊断标准探讨")
ft_exclusion_terms_V <- as_utf8("脑死亡无偿器官捐献供体维护期的护理")
ft_exclusion_terms_NC <- as_utf8(c("《实用医学杂志》2009年第25卷主题词索引", "1999年日本第93次医师国家考试试题(A、B、C、D、E、F)", "一个成功的临床抢救过程——记北京安贞医院成功抢救心脏停跳三小时患者", "论脑死亡立法的生物医学基础、社会学意义及推动程序", "的问题", "拟订", "第十届", "心死亡捐献供体器官保护中体外膜肺氧合技术的应用研究进展", "脑死亡诊断标准浅析","肺移植四十年进展","肺移植国内外研究近况与展望","临终期停止治疗与脑死亡","脑死的放射学诊断及其病理学基础","有关重型颅脑损伤的标准、手术和治疗结果的探讨","脑死亡诊断标准","脑死亡的确定","成人脑死亡的确定标准及背景材料","1999年日本第93次医师国家考试试题(A、B、C、D、E、F)", "论脑死亡立法的生物医学基础、社会学意义及推动程序"))

# These are identified by id number. They were discovered during clerical review, because the paper titles had no information in the title itself distinguishing them as being about animal research. Most were filtered out by grepping "猪|兔|犬|鼠" in the s_context field of t_match_output.

ft_exclusion_id_numbers_A <- c("0041","0078","0110","0125","0147","0163","0173","0196","0227", "0276", "0334", "0428", "0542", "0553", "0581", "0598", "0614", "0628", "0656", "0334", "0571")

df_fulltext_exclusions <- raw_file_list %>%  
  filter(id_number %notin% df_exclusions$id_number) %>% 
  mutate(
    exclusion_term = case_when(
      grepl(paste(as_utf8(ft_exclusion_terms_O), collapse='|'), title) ~ "O",
      grepl(paste(as_utf8(ft_exclusion_terms_A), collapse='|'), title) ~ "A",
      grepl(paste(as_utf8(ft_exclusion_terms_I), collapse='|'), title) ~ "I",
      grepl(paste(as_utf8(ft_exclusion_terms_V), collapse='|'), title) ~ "V",
      grepl(paste(as_utf8(ft_exclusion_terms_NC), collapse='|'), title) ~ "NC", 
      id_number %in% ft_exclusion_id_numbers_A ~ "A")) %>% 
  filter(!is.na(exclusion_term))

n_total_ft_exclusions <- nrow(df_fulltext_exclusions)


# Update main file list to remove excluded files -----------------------------------------

file_list <- raw_file_list %>%  
  filter(id_number %notin% df_exclusions$id_number,
         id_number %notin% df_fulltext_exclusions$id_number) %>% 
  rename(doc_id = value)