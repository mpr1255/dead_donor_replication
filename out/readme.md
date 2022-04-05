I need to explain the provenance of the files in this folder. 

>	.
>	├── TEMP-doctors_hospitals.csv
>	├── clean_hospital_w_en.csv
>	├── health_worker_names_w_en.csv

`TEMP-doctors_hospitals.csv` was initially created by `./code/medical_worker_analysis.R`. Then the two columns in it -- the hospitals and the authors -- were *manually* copied out, uniqued (in Sublime Text), pasted in Google Translate, translated, then pasted back into those csv files. 

The rest of medical_worker_analysis.R will stitch the files back together and link the doctors with the hospitals in both Chinese and English. 

MPR 20220405