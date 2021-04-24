sheet_id <- "12yUhkqq5ajM_uq7vLytH9cBceCCDFC0MEJluVX_aBdA"


# Read the sheet and clean up the variable names
quiz_data <-
  read_sheet(
    ss = sheet_id, sheet = "Data",
    .name_repair = make_clean_names
  )

quiz_data_fixed_names <- quiz_data %>%
  clean_names() %>%
  regularise_names(quizmasters) %>%
  regularise_names(winning_team) %>%
  regularise_names(second_place) %>%
  regularise_names(third_place) %>%
  regularise_names(fourth_place) %>%
  reorder_quizmasters(quizmasters)

if (all(quiz_data == quiz_data_fixed_names | (is.na(quiz_data) & is.na(quiz_data_fixed_names)))) {
  quiz_data <- clean_names(quiz_data)
} else {
  range_write(
    ss = sheet_id,
    data = quiz_data_fixed_names,
    sheet = "Data",
    range = cell_limits(
      ul = c(2, 1),
      lr = c(
        nrow(quiz_data_fixed_names) + 1,
        ncol(quiz_data_fixed_names)
      )
    ), col_names = FALSE
  )
  quiz_data <- clean_names(quiz_data_fixed_names)
}
