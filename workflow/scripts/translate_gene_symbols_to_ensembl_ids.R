log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library("biomaRt")
# tidy syntax
library("tidyverse")
# useful error messages upon aborting
library("cli")

mart <- biomaRt::useEnsembl(
  biomart = "genes",
  verbose = TRUE,
  dataset = str_c(snakemake@params[["species"]], "_gene_ensembl"),
  version = snakemake@params[["release"]],
  mirror = "www"
)

pathway_genes <- (
  read_lines(snakemake@input[["gmt"]]) |>
  str_split("\t")
)[[1]][-c(1,2)]

ensembl_transcript_ids <- getBM(
  attributes = c(
    "ensembl_transcript_id_version",
    "transcript_length"
  ),
  filters = "hgnc_symbol",
  values = pathway_genes,
  mart = mart
) |> rename(
    chrom = "ensembl_transcript_id_version",
    chromEnd = "transcript_length"
  ) |> add_column(
    chromStart = 0,
    .before = "chromEnd"
  )


write_tsv(
  x = ensembl_transcript_ids,
  file = snakemake@output[["transcript_bed"]],
  col_names = FALSE
)
