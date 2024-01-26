# Snakemake workflow: `create-quant-seq-testing-dataset`

[![DOI](https://zenodo.org/badge/745028447.svg)](https://zenodo.org/doi/10.5281/zenodo.10572323)
[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/dlaehnemann/create-quant-seq-testing-dataset/workflows/Tests/badge.svg?branch=main)](https://github.com/dlaehnemann/create-quant-seq-testing-dataset/actions?query=branch%3Amain+workflow%3ATests)


A Snakemake workflow for (reproducibly) creating a QuantSeq 3' mRNA testing dataset that is both small enough to run in standard continuous integration testing environments, and large enough to produce (some reasonably) meaningful results.

This workflow is based on data presented and analyzed here:

Corley, S.M., Troy, N.M., Bosco, A. et al. QuantSeq. 3′ Sequencing combined with Salmon provides a fast, reliable approach for high throughput RNA expression analysis. Sci Rep 9, 18895 (2019). https://doi.org/10.1038/s41598-019-55434-x

The full data can be found here:

https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA509074&o=acc_s%3Aa

We use the QuantSeq data, which should be the samples with `LibraryLayout` `SINGLE` and `AvgSpotLen` `75` according to the methods section:

https://www.nature.com/articles/s41598-019-55434-x#Sec10

Thus, the total samples selected are:

https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA509074&f=avgspotlen_l%3An%3A75%3Blibrarylayout_s%3An%3Asingle%3Ac&o=acc_s%3Aa

The study identifies `UROSEVIC_RESPONSE_TO_IMIQUIMOD` as the most significant differentially regulated gene set affected by their `polyI:C` treatment:
https://www.gsea-msigdb.org/gsea/msigdb/human/geneset/UROSEVIC_RESPONSE_TO_IMIQUIMOD

We thus restrict the raw data to reads mapping to the contained genes in order to drastically reduce data set size while hopefully maintaining some kind of useful result.
In addition, we also add in the `KEGG_PROTEASOME` which is not expected to be detected as a differentially expressed gene set in the QuantSeq data:
https://www.gsea-msigdb.org/gsea/msigdb/human/geneset/KEGG_PROTEASOME

For reference, Figure 7 of the original manuscript gives the most important results of the gene set enrichment analysis:
https://www.nature.com/articles/s41598-019-55434-x/figures/7

The MSigDB gene sets are used according to their [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/), which is given here:
https://www.gsea-msigdb.org/gsea/msigdb_license_terms.jsp

## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=dlaehnemann%2Fcreate-quant-seq-testing-dataset).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) create-quant-seq-testing-datasetsitory and its DOI (see above).
