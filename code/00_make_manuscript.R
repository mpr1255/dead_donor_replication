# Clean environment, load functions and libs ---------------------------
rm(list=ls())
source("./code/helper_functions.R", encoding = "utf-8") 

# Set locale to Chinese ---------------------------------------------------
# All this is not necessary on Unix systems. R in Windows just doesn't play well with Chinese characters.
# Sys.setlocale("LC_ALL", locale = "chs")
# Sys.setlocale("LC_ALL", locale = "English_United States.1252")
# Sys.setlocale("LC_CTYPE", locale = "C")
# Sys.setlocale("LC_CTYPE", locale = "C.UTF-8")

# Extract from local database -------------------------------------------------
# Does not need to be run again; included for reference only.
# source("./code/01_extract_from_database.R", encoding = 'utf-8')

# Clean reference data -------------------------------------------------
# Does not need to be run again; included for reference only.
# source("./code/02_make_references.R", encoding = 'utf-8')

# Clean text files --------------------------------------------------------
# Does not need to be run again; included for reference only.
# source("./code/03_cleantxt.R", encoding = "utf-8")

# Fuzzymatch focused set of target strings over expanded corpus -----------------------
# source("./code/04_fuzzymatch.R", encoding = "utf-8")

# Generate prisma flowchat  ------------------------------------------
# Does not need to be run again; included for reference only.
# source("./code/05_prisma.R", encoding = "utf-8")

# Deduplicate hospital names for geocoding ---------------------------------------------------
# Does not need to be run again; included for reference only.
# source("./code/06_deduplication.R", encoding = 'utf-8')

# Generate map based on deduped hospital names ---------------------------------------------------
# Does not need to be run again; included for reference only.
# source("./code/07_map.R", encoding = 'utf-8')

# Delete existing ms and appendices, render ----------------------------------------
if (dir.exists("./manuscript/dead_donor_manuscript_cache")) {
  
  unlink("./manuscript/dead_donor_manuscript_cache", recursive = TRUE)
  unlink("./appendix/appendix_1.docx", recursive = TRUE)
  unlink("./appendix/appendix_2.docx", recursive = TRUE)
  
  source("./code/08_render.R", encoding = 'utf-8')
  
} else{
  source("./code/08_render.R", encoding = 'utf-8')
}
