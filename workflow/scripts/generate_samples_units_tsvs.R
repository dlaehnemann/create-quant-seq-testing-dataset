log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

# tidy syntax
library("tidyverse")
# useful error messages upon aborting
library("cli")

runs <- read_tsv(
  file = snakemake@input[["samples"]]
)

samples <- runs |>
  select(
    c(
      Run,
      condition
    )
  ) |>
  rename(
    sample = "Run"
  )

write_tsv(
  x = samples,
  file = snakemake@output[["samples"]],
)

units <- samples |>
  add_column(
    unit = "u1",
    fragment_len_mean = 430,
    fragment_len_sd = 43,
    fq2 = ""
  ) |>
  mutate(
    fq1 = str_c(c("../test-data/quant_seq/", sample, ".fastq.gz")),
    .before = "fq1"
  )

write_tsv(
  x = units,
  file = snakemake@output[["units"]]
)