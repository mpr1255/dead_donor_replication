suppressMessages(library(PRISMAstatement))

# Note there are a few things happening here. The big difference is that I have simply copy/pasted the chief functions from the PRISMAstatement library into this script and directly modified them to swap the quantitative/qualitative box at the end (see https://cran.r-project.org/package=PRISMAstatement). So the only thing that actually calls the library is the prisma_pdf function; otherwise R looks directly in this namespace first and uses these functions. 

source("./code/helper_functions.R", encoding = "utf-8") 


prisma <- function (found, found_other, no_dupes, screened, screen_exclusions,
                    full_text, full_text_exclusions, qualitative,
                    labels = NULL, extra_dupes_box = FALSE, ..., dpi = 72, font_size = 10)
{
  DiagrammeR::grViz(prisma_graph(found = found, found_other = found_other,
                                 no_dupes = no_dupes, screened = screened, screen_exclusions = screen_exclusions,
                                 full_text = full_text, full_text_exclusions = full_text_exclusions,
                                 qualitative = qualitative,
                                 labels = labels, extra_dupes_box = extra_dupes_box,
                                 dpi = dpi, font_size = font_size, ...))
}


prisma_graph <- function (found, found_other, no_dupes, screened, screen_exclusions, 
                          full_text, full_text_exclusions, qualitative, quantitative = NULL, 
                          labels = NULL, extra_dupes_box = FALSE, ..., dpi = 72, font_size = 10) 
{
  stopifnot(length(found) == 1)
  stopifnot(length(found_other) == 1)
  stopifnot(length(no_dupes) == 1)
  stopifnot(length(screened) == 1)
  stopifnot(length(screen_exclusions) == 1)
  stopifnot(length(full_text) == 1)
  stopifnot(length(full_text_exclusions) == 1)
  stopifnot(length(qualitative) == 1)
  stopifnot(is.null(quantitative) || length(quantitative) == 
              1)
  stopifnot(found == floor(found))
  stopifnot(found_other == floor(found_other))
  stopifnot(no_dupes == floor(no_dupes))
  stopifnot(screened == floor(screened))
  stopifnot(screen_exclusions == floor(screen_exclusions))
  stopifnot(full_text == floor(full_text))
  stopifnot(full_text_exclusions == floor(full_text_exclusions))
  stopifnot(qualitative == floor(qualitative))
  stopifnot(is.null(quantitative) || quantitative == floor(quantitative))
  stopifnot(found >= 0)
  stopifnot(found_other >= 0)
  stopifnot(no_dupes >= 0)
  stopifnot(screened >= 0)
  stopifnot(screen_exclusions >= 0)
  stopifnot(full_text >= 0)
  stopifnot(full_text_exclusions >= 0)
  stopifnot(qualitative >= 0)
  stopifnot(is.null(quantitative) || quantitative >= 0)
  stopifnot(no_dupes <= found + found_other)
  stopifnot(screened <= no_dupes)
  stopifnot(full_text <= screened)
  stopifnot(qualitative <= full_text)
  stopifnot(quantitative <= qualitative)
  stopifnot(screen_exclusions <= screened)
  stopifnot(full_text_exclusions <= full_text)
  if (screened - screen_exclusions != full_text) 
    warning("After screening exclusions, a different number of remaining ", 
            "full-text articles is stated.")
  if (full_text - full_text_exclusions != qualitative) 
    warning("After full-text exclusions, a different number of remaining ", 
            "articles for qualitative synthesis is stated.")
  dupes <- found + found_other - no_dupes
  labels_orig <- list(found = pnl("Records identified through", 
                                  "database searching", paren(found)), found_other = pnl("Additional records identified", 
                                                                                         "through other sources", paren(found_other)), no_dupes = pnl("Records after duplicates removed", 
                                                                                                                                                      paren(no_dupes)), dupes = pnl("Duplicates excluded", 
                                                                                                                                                                                    paren(dupes)), screened = pnl("Records screened", paren(screened)), 
                      screen_exclusions = pnl("Records excluded", paren(screen_exclusions)), 
                      full_text = pnl("Full-text articles assessed", "for eligibility", 
                                      paren(full_text)), full_text_exclusions = pnl("Full-text articles excluded,", 
                                                                                    "with reasons", paren(full_text_exclusions)), qualitative = pnl("Studies included in quantitative synthesis", # NOTE: The change is here; 'quant' swapped for 'qual'
                                                                                                                                                    paren(qualitative)), quantitative = pnl("Studies included in", 
                                                                                                                                                                                            "qualitative synthesis", paren(quantitative))) # and also here - vice versa
  for (l in names(labels)) labels_orig[[l]] <- labels[[l]]
  labels <- labels_orig
  dupes_box <- sprintf("nodups -> incex;\n    nodups [label=\"%s\"];", 
                       labels$no_dupes)
  if (extra_dupes_box) 
    dupes_box <- sprintf("nodups -> {incex; dups};\n       nodups [label=\"%s\"];\n       dups [label=\"%s\"]; {rank=same; nodups dups}", 
                         labels$no_dupes, labels$dupes)
  dot_template <- "digraph prisma {\n    node [shape=\"box\", fontsize = %d];\n    graph [splines=ortho, nodesep=1, dpi = %d]\n    a -> nodups;\n    b -> nodups;\n    a [label=\"%s\"];\n    b [label=\"%s\"]\n    %s\n    incex -> {ex; ft}\n    incex [label=\"%s\"];\n    ex [label=\"%s\"];\n    {rank=same; incex ex}\n    ft -> {qual; ftex};\n    ft [label=\"%s\"];\n    {rank=same; ft ftex}\n    ftex [label=\"%s\"];\n    qual -> quant\n    qual [label=\"%s\"];\n    quant [label=\"%s\"];\n  }"
  sprintf(dot_template, font_size, dpi, labels$found, labels$found_other, 
          dupes_box, labels$screened, labels$screen_exclusions, 
          labels$full_text, labels$full_text_exclusions, labels$qualitative, 
          labels$quantitative)
}



paren <- function (n){
  sprintf("(n = %d)", n)
}




pnl <- function (...){
  paste(..., sep = "\n")
}

n_all_entries <- as.integer(read_lines("./data/database_nrow.txt"))
n_all_pdf_files <- length(list.files(glue("{here}/data/pdf")))
n_all_text_files <- length(list.files(glue("{here}/data/txt")))
n_couldnt_convert <- n_all_pdf_files - n_all_text_files
n_all_examined <- fread(glue("{here}/data/string_match_full_output.csv"))[string_distance < .28][context %like% "供"] %>% distinct(file_name) %>% nrow()
n_bdd_included <- nrow(fread(glue("{here}/appendix_2/bdd_included.csv")))


prsm <- prisma(found = n_all_entries,
               found_other = 0,
               no_dupes = n_all_entries,
               screened = n_all_entries,
               screen_exclusions = n_all_entries - n_all_text_files,
               full_text = n_all_text_files,
               full_text_exclusions = n_all_text_files - n_all_examined,
               qualitative = n_all_examined,
               quantitative = n_bdd_included,
               width = 50, height = 60,
               font_size = 9,
               font = "Times New Roman",
               dpi = 72)

pdf_out <- "./figures/Fig1.pdf"
PRISMAstatement:::prisma_pdf(prsm, pdf_out)
knitr::include_graphics(path = pdf_out)
system(glue("pdftoppm -png {here}/{pdf_out} > {here}/figures/Fig1.png"))

