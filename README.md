# Delta-diag
A medical diagnostic decision support model on DBMI database with 95% accuracy. This model is being extended to a database consisting of 171K published clinical reports.

Output of ML is given in epoch_out.txt

INPUT FILES: columbia.csv  downloaded from DBMI site. Declared ftr ids in: col_ftrs1: dis ids in: col_diag1nr (Note: case id = diag ids) and col_auinr. Database MRHIER of UMLS 2024 is obtained from NLM site and used for unification purpose.

Model is run to obtain atomic vectors (dbmi_report2.txt) which are extrapolated to ftr-ftr and ftr-dis links.

Over 6 million vectors for ftr-dis links are obtained from model https://github.com/AndriyMulyar/semantic-text-similarity are used in datafile (col_ftrs_diagvec_pmcver3).

Script files: col_dbmi.sh, col_dbmi1.sh and col_dbmi2.sh are run sequentially to get final diagnosis.
