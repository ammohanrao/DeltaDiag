````
 "Expectation, qualiﬁcation and proximity determine each word’s meaning. This entails cognition."
                                   
                                   -Primer of Indian Logic by Annambhatta. https://en.wikipedia.org/wiki/Tarka-Sangraha
````
# Delta-diag
A medical diagnostic decision support model on DBMI database with 95% accuracy. This model is being extended to a database consisting of 171K published clinical reports.

Output of ML with 100% accuracy is given in epoch_out.txt.

Extrapolation of shared atomic positions of features to diagnosis is obtained with 95% accuracy.

Input files are: columbia.csv  downloaded from DBMI site. Declared feature ids in: col_ftrs1: dis ids in: col_diag1nr (Note: case id = diag ids) and col_auinr. Database MRHIER of UMLS 2024 is obtained from NLM site and used for unification purpose.

Model is run to obtain atomic vectors (dbmi_report2.txt) which are extrapolated to feature-feature and feature-disease links.

Over 6 million vectors for feature-disease links are obtained from model https://github.com/AndriyMulyar/semantic-text-similarity are used in datafile (col_ftrs_diagvec_pmcver3.txt). Vectors relevant here are given in files data_pmc_diag.txt and data_pmc_ndiag.txt.

Script files, col_dbmi.sh, col_dbmi1.sh and col_dbmi2.sh are run sequentially to get final diagnosis.

Weights for feature disease links derived from both unify and pmc clinical reports are given in data_pmc_diag1.txt and data_pmc_ndiag1.txt

PUBMED CENTRAL opensource clinical reports are processed to obtain files: col_prelim2_def.txt, col_core_diagnr3.txt and evo_data_corpus.txt. Note that these data shares ids from dbmi database. For features 1 to 408 from  dbmi, and 409 to 871 from pmc. For diseases 1 to 134 from dbmi and 135 to 2132 from pmc. Atoms shared with pmc data are shown in core_aui_nr.txt.

PMC output of ML with 100% accuracy is given in epoch_out1.txt.
