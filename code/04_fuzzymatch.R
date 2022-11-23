rm(list = ls())

# This code takes a single vector of strings and searches across a vector of file paths (with the function reading in the file, searching, outputting results).

# You have to tweak this per your computer settings.
suppressMessages(library(furrr))
plan(multisession, workers = 8)

# Set up strings to match. ts = 'target strings'
ts_intubation <- utf8::as_utf8(c("脑死亡后用麻醉机维持呼吸", "死亡后迅速建立人工呼吸", "自主呼吸丧失的脑死亡供体,在特定条件下应尽可能迅速建立辅助呼吸支持循环,维持供心的血氧供应,避免或缩短热缺血时间,同时迅速剖胸取心", "供体大脑死亡后,首先分秒必争地建立呼吸与静脉通道", "经气管切开气管插管建立人工呼吸", "快速胸部正中切口进胸", "供者脑死亡后迅速建立人工呼吸", "供心保护脑死亡后用麻醉机维持呼吸", "供体确定脑死亡后,气管插管,彻底吸除气道分泌物,用简易呼吸器人工控制呼吸", "供体脑死亡后,迅速建立人工呼吸", "供体脑死亡后快速正中开胸,同时插入气管导管人工通气", "脑死亡后,紧急气管插管", "供者行气管插管", "供者行气管插管,球囊加压通气,静脉注射肝素200mg", "脑死亡后，用麻醉机维持呼吸", "供体在确认脑死亡后,气管插管,建立人工呼吸", "脑死亡后气管紧急插管,纯氧通气", "供体死亡后行人工呼吸、循环支持", "脑死亡后,气管插管", "脑死亡后立即气管内插管给氧", "脑死亡,面罩加压给氧,辅助呼吸", "脑死亡后,将供体取仰卧位,争取做气管插管", "脑死亡后迅速气管插管", "脑死亡后迅速气管插管进行机械通气", "协助麻醉医生进行支纤镜检查后进行供体气管插管", "脑死亡后,4例气管插管,3例面罩吸氧", "脑死亡后插入气管导管", "在这紧急情况下,必须在紧急开胸的同时,进行紧急气管插管及辅助呼吸", "供体手术气管插管通气", "供体手术气管插管", "气管切开气管插管", "供体心脏的提取供心者取仰卧位,垫高胸腔,气管插管", "进行供心、肺切取,吸净气管分泌物,气管插管给氧", "供体心肺的切取气管插管", "供肺切取:供体气管插管", "供者平卧位,气管插管", "供心切取配合,护士协助医生气管插管辅助呼吸", "供心切取配合..气管插管", "供体平卧位，气管插管", "协助麻醉医生进行支纤镜检查后进行气管插管", "供体心肺的获取和保护..行气管插管通气", "供心的切取供体气管插管后", "供者气管插管", "供体全身肝素化后，仰卧位，经口气管内插管","面罩吸氧"))

target_strings <- ts_intubation

# Ensure no duplications. Output should be character(0)
target_strings %>% .[duplicated(.)]

# Read in list of files
path <- ("./data/txt/")
file_list <- data.table(file_w_path = list.files(path, full.names = TRUE))[,basename := basename(file_w_path)]

# Set up main functions
getStringMatches <- function(file_text, target_string){
  # target_string <- target_strings[1]
  res <- stringdist::afind(file_text, target_string, window = nchar(target_string), method="running_cosine")
  location <- res$location
  distance <- res$distance
  match <- res$match
  context <- substr(file_text, as.integer(location)-70, as.integer(location)+70)
  res2 <- as.data.table(cbind(target_string, location, distance, match, context))
  return(res2)
}

getFullMatch <- function(file, target_strings) {
  # file <- "./data/txt/0111.txt"
  file_text <- fread(file, sep = NULL, header = FALSE)
  res <- rbindlist(future_map(target_strings, ~getStringMatches(file_text, .x)))
  res <- cbind(file, res)
  names(res) <- c("file", "target_string", "string_location",  "string_distance", "matching_string", "context")
  return(res)
}
possibly_getFullMatch <- possibly(getFullMatch, otherwise = NA)
options(datatable.prettyprint.char=20000L)
all_res <- future_map_dfr(file_list$file_w_path[1], ~possibly_getFullMatch(.x, target_strings))

# Show-and-tell -----------------------------------------------------------
result <- possibly_getFullMatch("./data/txt/0111.txt", target_strings)
result[string_distance < .20]
options(datatable.prettyprint.char=20L)
setDT(result)


# Previously output here.
# all_res <- fread("./data/string_match_full_output.csv")

n_examined <- string_cutoff %>% distinct(file_name) %>% nrow()

string_cutoff <- all_res[string_distance < .28][context %like% "供"]
string_cutoff <- string_cutoff[,document_id := str_remove(file_name, "\\.txt")]


# These were outputted and examined iteratively.
# string_cutoff[document_id %notin% all_matched$document_id] %>% writexl::write_xlsx("./data/round3_examine_strings.xlsx")
# string_cutoff[document_id %notin% all_matched$document_id] %>% writexl::write_xlsx("./data/round4_examine_strings.xlsx")