# Focus16
Repo for data generating scripts, paper rmarkdown and other files involved in methods

Contents of the repository:

```
── README.md
├── SILVA_132_SSURef_tax_silva.fasta
├── docs
│   ├── 2019-Nolan-Waters-focusdb.Rmd          # main text of paper
│   ├── 2019-Nolan-Waters-supplementary.Rmd    # code and details of analysis
│   ├── DADA2_analysis.Rmd                     # code for running community analysis
│   ├── figures                                # location for figures
│   ├── focusdb_references.bib                 # references
│   ├── blob_SRR2155541                        # Blobtools results of potentially contaminated datasets
│   ├── blob_SRR3571775                        # //
├── results
│   ├── 2019-12-19-results.tar.gz              # seqeunces, etc for organisms studied
│   ├── fast_focusDB_ribo16s.fasta             # extracted 16S alleles from --fast mode
│   └── full_focusDB_ribo16s.fasta             # extracted 16S alleles from full mode
└── scripts
    └── sralist.py  # for generating counts per organism of SRAs availabl
```

The working directory for all the markdown scripts is `./docs/`, not the project directory. If using RStudio, you can configure this under your project settings.
