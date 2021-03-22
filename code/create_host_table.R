hosted_table <- quiz_data %>%
  select(quizmasters, hosted_quiz, winning_team) %>%
  drop_na() %>%
  group_by(quizmasters) %>%
  summarise(
    n_hosted = n(),
    last_hosted = time_length(interval(max(hosted_quiz), today()), "weeks")
  ) %>%
  arrange(-n_hosted, last_hosted) %>%
  mutate(last_hosted = if_else(last_hosted == 1,
    str_glue("{ceiling(last_hosted)} week ago"),
    str_glue("{ceiling(last_hosted)} weeks ago")
  )) %>%
  rename(
    "Quiz Hosts" = quizmasters,
    "Times hosted" = n_hosted,
    "Last hosted" = last_hosted
  ) %>%
  gt()
