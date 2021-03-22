sheet_url <- "https://docs.google.com/spreadsheets/d/12yUhkqq5ajM_uq7vLytH9cBceCCDFC0MEJluVX_aBdA/edit?usp=sharing"

# Sheet doesn't need auth as it has link editing enabled
gs4_deauth()

# Read the sheet and clean up the variable names
quiz_data <-
  read_sheet(sheet_url) %>%
  clean_names()
