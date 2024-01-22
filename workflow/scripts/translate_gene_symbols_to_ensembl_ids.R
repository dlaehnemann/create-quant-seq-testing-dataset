log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library("biomaRt")
# tidy syntax
library("tidyverse")
# useful error messages upon aborting
library("cli")

# this variable holds a mirror name until
# useEnsembl succeeds ("www" is last, because
# of very frequent "Internal Server Error"s)
mart <- "useast"
rounds <- 0
while (class(mart)[[1]] != "Mart") {
  mart <- tryCatch(
    {
      # done here, because error function does not
      # modify outer scope variables, I tried
      if (mart == "www") rounds <- rounds + 1
      # equivalent to useMart, but you can choose
      # the mirror instead of specifying a host
      biomaRt::useEnsembl(
        biomart = "ENSEMBL_MART_ENSEMBL",
        dataset = str_c(snakemake@params[["species"]], "_gene_ensembl"),
        version = snakemake@params[["release"]],
        mirror = mart
      )
    },
    error = function(e) {
      # change or make configurable if you want more or
      # less rounds of tries of all the mirrors
      if (rounds >= 3) {
        stop(
          str_c(
            "Have tried all 4 available Ensembl biomaRt mirrors ",
            rounds,
            " times. You might have a connection problem, or no mirror is responsive.\n",
            "The last error message was:\n",
            message(e)
          )
        )
      }
      # hop to next mirror
      mart <- switch(mart,
        useast = "uswest",
        uswest = "asia",
        asia = "www",
        www = {
          # wait before starting another round through the mirrors,
          # hoping that intermittent problems disappear
          Sys.sleep(30)
          "useast"
        }
      )
    }
  )
}


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
