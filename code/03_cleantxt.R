# This code has already been run and the files on the github repo are cleaned. This is included for transparency. 
# First I ran this in the command line after navigating to the folder holding the txt files: `for f in *.txt; do tr -d " \t\n\r" < "$f" > "${f%.txt}"--clean.txt; done`
# Following that, the code below was used to fix the 'Chinese' Arabic numerals and Latin characters.

# Fix the Chinese characters in the papers for the original folders --------------------------------

path_in <- "./data/papers_txt/"
path_in <- "./data/papers_ocr_txt/"

file_list_no_path <- list.files(path_in)
file_list_w_path <- list.files(path_in, full.names = TRUE) 
file_list <- as.data.table(cbind(file_list_no_path, file_list_w_path))

path_out <- "./data/papers_txt_clean/"

en_ch_replace = list("～" = "~", "０" = "0", "１" = "1", "２" = "2", "３" = "3", "４" = "4", "５" = "5", "６" = "6", "７" = "7", "８" = "8", "９" = "9", "ａ" = "a", "ｂ" = "b", "ｃ" = "c", "ｄ" = "d", "ｅ" = "e", "ｆ" = "f", "ｇ" = "g", "ｈ" = "h", "ｉ" = "i", "ｊ" = "j", "ｋ" = "k", "ｌ" = "l", "ｍ" = "m", "ｎ" = "n", "ｏ" = "o", "ｐ" = "p", "ｑ" = "q", "ｒ" = "r", "ｓ" = "s", "ｔ" = "t", "ｕ" = "u", "ｖ" = "v", "ｗ" = "w", "ｘ" = "x", "ｙ" = "y", "ｚ" = "z")

# this can be accessed two ways. paste0() will print the values. and names() will print the 'names', which are the things I want to replace.
# names(en_ch_replace[1])
# paste0(en_ch_replace[1])

clean_text <- function(file){
  file_in <- read_lines(paste0(path_in, file))
  broken_up <- unlist(strsplit(file_in, split = ""))
  res <- map(broken_up, ~replace(.x, .x == names(en_ch_replace[.x]), paste0(en_ch_replace[.x])))
  file_out <- paste0(res, collapse = "")
  write_lines(file_out, paste0(path_out, file))
  # return(file_out)
  invisible()
}


map(file_list[[1]], ~clean_text(.x))
