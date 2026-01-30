````
"Expectation, qualiﬁcation and proximity determine each word’s meaning. This entails cognition.
Expectation is hidden cognition of a word, which appears only by logical interaction of other words.
Weight of a word is its qualiﬁcation. Distance of a word is its proximity. Sentence devoid of
 expectancy, qualiﬁcation or proximity has no meaning. "
     -Annam Bhatta’s Tarkasamgraha (c. 1623; “Compendium of Logic”)       
````

<img align="center" width="41" height="30" alt="diagnose" src="https://github.com/user-attachments/assets/0758a7dc-dc8f-4bdf-bf78-8e71166d4a1e"/><div></div>
<img width="184" height="51" alt="pairs-logo" src="https://github.com/user-attachments/assets/20387c29-ca7d-4c42-8898-4a414a17c2f6" />


# Delta-diag
A medical diagnostic decision support model on DBMI database with 95% accuracy. This model is being extended to a database consisting of 171K published clinical reports.

Output of ML with 100% accuracy is given in epoch_out.txt.


Extrapolation of shared atomic positions of features to diagnosis is obtained with 95% accuracy.

Input files are: columbia.csv  downloaded from DBMI site. Declared feature ids in: col_ftrs1: dis ids in: col_diag1nr (Note: case id = diag ids) and col_auinr. Database MRHIER of UMLS 2024 is obtained from NLM site and used for unification purpose.

````
Qualification Q = magnitude of vectors [ A, n, D] where A = unified atom of features and disease (D). n= position of atom,
`````
Model is run to obtain atomic vectors (dbmi_report2.txt) which are extrapolated to feature-feature and feature-disease links.

````
Proximity B = BERT vector of {feature to disease} link
````
Over 6 million vectors for feature-disease links are obtained from model https://github.com/AndriyMulyar/semantic-text-similarity are used in datafile (col_ftrs_diagvec_pmcver3.txt). Vectors relevant here are given in files data_pmc_diag.txt and data_pmc_ndiag.txt.

````
Expectation E = (B / Q). B and Q are bert and atomic vectors where B is variable and Q is constant. Expectation is set to 1.
````
Script files, col_dbmi.sh, col_dbmi1.sh and col_dbmi2.sh are run sequentially to get final diagnosis.

Weights for feature disease links derived from both unify and pmc clinical reports are given in data_pmc_diag1.txt and data_pmc_ndiag1.txt

PUBMED CENTRAL opensource clinical reports are processed to obtain files: col_prelim2_def.txt, col_core_diagnr3.txt and evo_data_corpus.txt. Note that these data shares ids from dbmi database. For features 1 to 408 from  dbmi, and 409 to 871 from pmc. For diseases 1 to 134 from dbmi and 135 to 2132 from pmc. Atoms shared with pmc data are shown in core_aui_nr.txt.

PMC output of ML with 100% accuracy is given in epoch_out1.txt.

## Definitions
atom = each hierarchical step of a concept. atomic number = sequential number in the hierarchy. valence = terminal atomic number in unify causing a diagnosis. adjunct = terminal atomic number in unify not causing a diagnosis.
atomic weight = approximation of vectors of qualification and proximity. cognition = relationship between valence and adjunct. expectation = 1 which is constant. 

### valid cognition
cognition whose expectation is 1.

# How to run the program
run col_dbmi.sh, col_dbmi1.sh and col_dbmi2.sh sequentially.


References
1. Unification Grammars by Nissim Francez and Schuly Wintner. 2011. Cambridge University Press.
2. Automated Knowledge Acquisition from Clinical Narrative Reports. Xiaoyan Wang, Amy Chused, Noémie Elhadad, Carol Friedman, Marianthi Markatou. AMIA Annu Symp Proc.2008:783–787.
3. https://www.ncbi.nlm.nih.gov/books/NBK9685/table/ch03.T.computable_hierarchies_file_mrhie/
4. Primer of Indian Logic by Annambhatta. https://en.wikipedia.org/wiki/Tarka-Sangraha
5. https://www.academia.edu/127352969/Primer_of_Indian_Logic
