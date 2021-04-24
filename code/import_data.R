sheet_id <- "12yUhkqq5ajM_uq7vLytH9cBceCCDFC0MEJluVX_aBdA"

# Read the sheet and clean up the variable names
quiz_data <-
  read_sheet("12yUhkqq5ajM_uq7vLytH9cBceCCDFC0MEJluVX_aBdA") %>%
  clean_names()
