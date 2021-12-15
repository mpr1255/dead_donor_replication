Replication materials for "Execution by organ procurement: Breaching the dead donor rule in China" by Matthew P. Robertson and Jacob Lavee
=====================================

> This repository contains the replication materials for the above paper. 
> Following is an explanation of the folder structure, the files, and the code that performed the analysis. 

### Structure of the project

    .
    ├── appendix_1             # All files necessary for knitting Appendix 1
    ├── appendix_2             # All files necessary for knitting Appendix 2
    ├── code                   # All R and bash scripts plus a Word macro 
    ├── data                   # All raw and processed txt, pdf, & analysis files
    ├── figures                # Figures used in the ms.
    ├── ms_rr                  # The manuscript for the revised and resubmitted version of the paper
    ├── tables                 # Used in the ms
    ├── LICENSE
    └── README.md

> Note: The project is around 1.5gb

### Appendix 1

The file and folder structure should be intuitive, but: 

- `/references` contains the bibliographic material of the papers consulted for the pilot study; 
- `/txt` contains the full text files that were consulted;
- `appendix_1.Rmd` file knits to `.docx` format through the template file, used also in the other appendix and the manuscript file.

### Appendix 2

These file names should also be straightforward to interpret. Apart from the obvious files:

- `bdd_included.csv` are all of the papers that were coded as containing problematic brain death declarations (BDD);
- `bdd_included_translated_refs.csv` contain the unique docids, references, and translations of those papers

### Code

As shown below. Note that the code was written and tested across Windows 10, Ubuntu (in WSL), and OSX. However, please also note that attempting to process the Chinese-language text files in Windows might lead to all manner of difficulties. The best environment for this is either Linux or OSX. 

    .
    ├── ...
    ├── code                    			# we are here.
    │   ├── 00_make_manuscript.R 			# acts as the makefile for the project 				
    │   ├── 01_extract_from_database.R 		# pulls the original files from the major dataset and processes them for this project					
    │   ├── 02_make_references.R 			# creates `.bib` files based on references in `.csv` format			
    │   ├── 03_cleantxt.R 					# cleans up the `.txt` files after sometimes messy text conversion/OCR		
    │   ├── 04_fuzzymatch.R 				# this is the primary algorithm that searches through the full text of the papers			
    │   ├── 05_prisma.R 					# creates PRISMA diagram (Fig 1 in ms)		
    │   ├── 06_deduplication.R 				# cleans up and deduplicates the hospitals from the references			
    │   ├── 07_map.R 						# uses GIS libraries to plot the hospitals on a map of the PRC	
    │   ├── 08_render.R 					# a few lines of code that actually renders the ms and appendices		
    │   ├── dead_donor_word_macro.txt 		# used in Microsoft Word to fix track changes from merged documents					
    │   ├── helper_functions.R 				# loads libraries and contains a few small functions used in project			
    │   ├── helper_translate.R 				# calls Google Translate
    │   ├── post_2015_analysis_for_ajt_review.R # code written to be sure no post-2015 findings during peer review process							
    │   ├── scratch.R  						# rough notes.	
    │   └── ...                
    └── ...

> Note: The manuscript may not knit, and you may not be able to completely reproduce all elements of the analysis, because you do not have the original database files used for a few of the operations. These have not been made public because (1) they are extremely large, (2) they would expose the source of this material. Ultimately however, those files only play a minor role in this paper. All of the pdf and txt files of all of the manuscripts actually analyzed are present in this repo. Please feel free to contact the authors with questions about the code and the manuscript's reproducibility.

### Data

As shown below.

    .
    ├── ...
    ├── data                    					# we are here.
    │   ├── /pdf									# original pdf files of medical papers
    │   ├── /txt									# OCRed or otherwise converted txt of those papers	
    │   ├── all_included_w_data.bib					# references to all included publications
    │   ├── authors_in_bdd_included.csv    			# all unique author-docids, used to calculate the number of implicated surgeons in ms
    │   ├── bdd_included_docids_w_hospitals.csv		# all unique hospital-docids, featuring deduplicated hospitals per code above
    │   ├── bdd_not_included.csv					# papers not identified as problematic BDD, kept for reference
    │   ├── cities_for_dedupe.txt					# a large number of Chinese city names, used to create blocking variables for deduplication
    │   ├── database_nrow.txt						# number of rows in the main database this material was pulled from 		
    │   ├── df2bib_template.bib						# template used to create `.bib` files based on data in `.csv`
    │   ├── full_reference_data_nocode.csv    		# full citation material for all papers						
    │   ├── hospital_addresses_nonames.txt			# full list of addresses for the hospitals, created from `map.R`; names are dropped here because irrelevant; only function was to establish the number of unique addresses
    │   ├── hospital_mainpage_name_province_url_list.csv # a master list of over 9,000 hospitals and locations used as a reference 
    │   ├── hospitals_canonical_list.csv			# a canonical list of hospitals used as part of deduplication code
    │   ├── hospitals_deduped_w_latlon_clean.csv	# deduplicated hospitals with their latitude and longtitude coordinates
    │   ├── hospitals_w_latlon_raw.Rds				# the raw `.Rds` file for the above
    │   ├── post_2015_examination.xlsx				# code to create Excel file to examine papers published after 2015 specifically				
    │   ├── round4_examine_strings.xlsx				# one of the files the authors used to examine the excerpts from the publications					
    │   ├── unique_cities_provinces.txt				# a list of all the unique cities and provinces which held a hospital in bdd_included; generated from Google's GIS functions, thus in pinyin
    │   └── ... 
    └── ...



### figures, ms_rr, tables

The files in these folders are self-explanatory. 

### License information

> MIT License

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
> SOFTWARE.

This readme was adapted from this helpful example: https://github.com/kriasoft/Folder-Structure-Conventions/blob/master/README.md
