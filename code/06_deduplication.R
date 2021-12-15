source("./code/helper_functions.R", encoding = "utf-8") 
library(googleway)
library(ggmap)


filter_vect <- as_utf8('所|科|院|医院|室|校|基金会|队|中心|会|部|处|大学|集团|中学|公司|厂|站|社|组|委|局|报道|基地|厅|注册|临床|系')

# Blocking vars
cities = as_utf8("(北京|天津|上海|重庆|济南|青岛|滨州|菏泽|德州|济宁|聊城|淄博|日照|烟台|临沂|东营|泰安|威海|潍坊|枣庄|莱芜|广州|深圳|东莞|佛山|湛江|茂名|江门|韶关|珠海|汕头|中山|汕尾|肇庆|河源|揭阳|惠州|南京|常州|无锡|苏州|南通|徐州|泰州|扬州|镇江|连云港|宿迁|淮安|杭州|嘉兴|金华|丽水|台州|宁波|温州|湖州|绍兴|衢州|舟山|郑州|安阳|南阳|洛阳|开封|新乡|平顶山|三门峡|漯河|濮阳|信阳|焦作|商丘|许昌|武汉|荆州|襄阳|恩施州|黄石|十堰|随州|仙桃|潜江|宜昌|荆门|黄冈|鄂州|长沙|岳阳|常德|衡阳|益阳|郴州|怀化|邵阳|湘潭|吉首|永州|株洲|娄底|石家庄|唐山|张家口|邢台|保定|邯郸|秦皇岛|沧州|承德|廊坊|福州|厦门|漳州|南平|泉州|莆田|龙岩|沈阳|大连|锦州|辽阳|鞍山|本溪|抚顺|朝阳|丹东|盘锦|铁岭|长春|吉林|延边|哈尔滨|大庆|鸡西|牡丹江|齐齐哈尔|鹤岗|佳木斯|鸭山|七台河|合肥|芜湖|蚌埠|淮北|淮南|马鞍山|宣城|安庆|池州|毫州|阜阳|滁州|巢湖|六安|南昌|赣州|九江|吉安|宜春|上饶|景德镇|萍乡|南宁|柳州|桂林|钦州|贵港|百色|梧州|太原|大同|阳泉|长治|晋中|晋城|运城|成都|南充|乐山|德阳|绵阳|泸州|宜宾|自贡|达州|攀枝花|西安|宝鸡|咸阳|汉中|延安|昆明|曲靖|大理州|玉溪|楚雄彝族自治州|西双版纳傣族自治州|红河哈尼族彝族自治州|保山|呼和浩特|包头|赤峰|鄂尔多斯|通辽|乌兰察布|兴安盟|巴彦淖尔|贵阳|遵义|黔南布依族苗族自治州|乌鲁木齐|石河子|兰州|白银|嘉峪关|酒泉|海口|三亚|西宁|银川|拉萨|驻马店)")

provinces = as_utf8("(山东|广东|江苏|浙江|河南|湖北|湖南|河北|福建|辽宁|吉林|黑龙江|安徽|江西|广西壮族自治区|山西|四川|陕西|云南|内蒙古自治区|贵州|新疆维吾尔自治区|甘肃|海南|青海|宁夏回族自治区|西藏自治区)") #"自治区 are not provinces" yes I know

special_id_name = as_utf8("(华西|湘雅|协和|同仁|福州|新华|新桥|仁德|朝阳|友好|胜利)")

special_id_type = as_utf8("(首都|医学|空军|军|人民|大学|武警|总队|附属|中心医院|医科|结合|总医院|总队|眼科|红旗|市立)")

replace_nums <- as_utf8(c("一" = "1", "二" = "2", "三" = "3", "四" = "4", "五" = "5", "六" = "6", "七" = "7", "八" = "8", "九" = "9", "十" = "10", "０" = "0", "ｏ" = "0", "○" = "0", "〇" = "0"))

replace_nums_back <- as_utf8(c("1" = "一","2" = "二","3" = "三","4" = "四","5" = "五","6" = "六","7" = "七","8" = "八","9" = "九","10" = "十","0" = "〇"))

# nums = as_utf8("(一|二|三|四|五|六|七|八|九|十|０|ｏ|[0-9]{1,3})")
nums = as_utf8("([0-9]{1,3})")

######################################

# Clean hospital names ----------------------------------------------------
docids_w_hospitals <- fread("./data/bdd_included_docids_w_hospitals.csv", colClasses = "character")
names(docids_w_hospitals) <- c("hospital", "docid")

# hospitals <- unique(docids_w_hospitals$hospital)

docids_w_hospitals[,hospital_clean := str_replace_all(hospital, "!.*", "")]
docids_w_hospitals[,hospital_clean := str_replace_all(hospital_clean, "([0-9]{4,6})", "")]
docids_w_hospitals[,hospital_clean := str_replace_all(hospital_clean, "\\s+.*", "")]
docids_w_hospitals <- docids_w_hospitals[hospital_clean %like% filter_vect]



unique_hospitals <- as.data.table(tibble("hospital" = unique(str_replace_all(unique(docids_w_hospitals[,.(hospital_clean)])$hospital_clean, "医院.*", "医院"))))

# unique_hospitals <- unique_hospitals %>% 
  # mutate(geo_date = 
options(pillar.sigfig=8)

hospitals_deduped_w_latlon <- unique_hospitals %>% 
  mutate(geocoded = map_dfr(hospital, ~geocode(location = .x, 
                                              output = 'latlon', 
                                              source = "google", 
                                              force = TRUE, 
                                              language ="zh-CN",
                                              messaging=TRUE, 
                                              override_limit=TRUE)))


hospitals_deduped_w_latlon1 <- tibble(hospitals_deduped_w_latlon) 

hospitals_deduped_w_latlon1$lon <- hospitals_deduped_w_latlon1$geocoded$lon
hospitals_deduped_w_latlon1$lat <- hospitals_deduped_w_latlon1$geocoded$lat
hospitals_deduped_w_latlon1$lonlat <- paste(hospitals_deduped_w_latlon1$geocoded$lon, hospitals_deduped_w_latlon1$geocoded$lat, sep = "--")

hospitals_deduped_w_latlon1 <- hospitals_deduped_w_latlon1 %>% distinct(lonlat, .keep_all = TRUE)

hospitals_deduped_w_latlon1_clean <- hospitals_deduped_w_latlon1

# hospitals_deduped_w_latlon1_clean %>% select(-c(geocoded, lonlat)) %>% fwrite("./data/hospitals_deduped_w_latlon_clean.csv")


hospitals_rev_geocoding <- read_rds("./data/hospitals_w_latlon_raw.Rds")
test1 <- hospitals_rev_geocoding

res <- list()
for(i in 1:nrow(test1$geocoded)){
  res[[i]] <- as.numeric(as.data.table(test1$geocoded)[i])
}

# res2 <- map(res, ~(revgeocode(.x, output = "address")))
split_all <- map(res2, ~str_split(.x, "\\,"))
# split_all %>% write_lines("./data/hospital_addresses_nonames.txt")
