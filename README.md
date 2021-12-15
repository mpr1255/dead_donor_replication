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

As shown below.

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


### Data

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



### Tools and utilities

...

### Compiled files

...

### 3rd party libraries

...

### License information

If you want to share your work with others, please consider choosing an open
source license and include the text of the license into your project.
The text of a license is usually stored in the `LICENSE` (or `LICENSE.txt`,
`LICENSE.md`) file in the root of the project.

> You’re under no obligation to choose a license and it’s your right not to
> include one with your code or project. But please note that opting out of
> open source licenses doesn’t mean you’re opting out of copyright law.
> 
> You’ll have to check with your own legal counsel regarding your particular
> project, but generally speaking, the absence of a license means that default
> copyright laws apply. This means that you retain all rights to your source
> code and that nobody else may reproduce, distribute, or create derivative
> works from your work. This might not be what you intend.
>
> Even in the absence of a license file, you may grant some rights in cases
> where you publish your source code to a site that requires accepting terms
> of service. For example, if you publish your source code in a public
> repository on GitHub, you have accepted the [Terms of Service](https://help.github.com/articles/github-terms-of-service)
> which do allow other GitHub users some rights. Specifically, you allow others
> to view and fork your repository.

For more info on how to choose a license for an open source project, please
refer to http://choosealicense.com

This readme was adapted from this helpful example: https://github.com/kriasoft/Folder-Structure-Conventions/blob/master/README.md