suppressMessages(library(reclin))
suppressMessages(library(rsvg))
suppressMessages(library(DiagrammeRsvg))
suppressMessages(library(data.table))
suppressMessages(library(here))
suppressMessages(library(scales))
suppressMessages(library(tidyverse))
suppressMessages(library(glue))
suppressMessages(library(janitor))
suppressMessages(library(readtext))
suppressMessages(library(readr))
suppressMessages(library(stringr))
suppressMessages(library(stringdist))
suppressMessages(library(stringi))
suppressMessages(library(utf8))
suppressMessages(library(readxl))
suppressMessages(library(writexl))
suppressMessages(library(bib2df))
suppressMessages(library(tictoc))
suppressMessages(library(googleLanguageR))

`%notlike%` <- Negate(`%like%`)
`%notin%` <- Negate(`%in%`)

here <- here()

join_to_year <- function(x) {
  left_join(x, paper_reference_data, by = "id_number") %>% 
    select(-c(doc_id, title_ch, authors_ch, institutions, funding, journal, issue, keywords_ch, abstract_ch)) %>% 
    mutate(year = as.integer(year))
}

