clean_data <- quiz_data %>%
  rename(quiz_date = hosted_quiz) %>%
  mutate(
    quiz_date = as.Date(quiz_date),
    quiz_number = row_number(),
    time_weighting = (quiz_number * 2.5) %>% scale(center = FALSE)
  ) %>%
  # Restructure to make it easier to work with
  pivot_longer(
    cols = c(winning_team, second_place, third_place, fourth_place),
    names_to = "position",
    values_to = "team_members"
  ) %>%
  # Drop missing data
  drop_na() %>%
  separate_rows(team_members, sep = "-") %>%
  group_by(quiz_date) %>%
  mutate(team_number = row_number()) %>%
  ungroup() %>%
  # Restructure and tidy up the text
  unnest_tokens(
    output = "person",
    input = "team_members"
  ) %>%
  anti_join(get_stopwords(), by = c("person" = "word")) %>%
  # Fixes for names
  mutate(
    person = case_when(
      person == "cami" ~ "camille",
      person == "jonathan" ~ "jonty",
      person == "spud" ~ "emma",
      TRUE ~ person
    ),
    # Re-capitalise
    person = str_to_sentence(person)
  ) %>%
  # Create a nicely ordered factor
  mutate(position = ordered(position, position_order, position_label)) %>%
  # Calculate scaled scores
  group_by(quiz_date, team_number) %>%
  mutate(team_size = n()) %>%
  group_by(quiz_date) %>%
  # Score scaled according to the number of teams
  mutate(scaled_score = fct_rev(position) %>%
    as.integer() %>%
    scale(center = FALSE)) %>%
  # Scaled score inversely weighted by the size of the team
  # Also a cumulative mean of the weighted score
  mutate(
    team_weighted_score = scaled_score * max(team_size) / team_size,
    time_weighted_score = team_weighted_score * time_weighting
  ) %>%
  # Count quizzes per person
  group_by(person) %>%
  mutate(
    score_cummean = cummean(team_weighted_score),
    time_weighted_score_cummean = cummean(time_weighted_score),
    n_quizzes = n()
  ) %>%
  left_join(
    summarise(., n_quizzes = max(n_quizzes)) %>%
      mutate(n_quizzes_rank = rank(-n_quizzes, ties.method = "min"))
  ) %>%
  left_join(
    filter(., n_quizzes >= min_quizzes) %>%
      summarise(
        overall_rank = last(score_cummean),
        time_weighted_rank = last(time_weighted_score_cummean)
      ) %>%
      mutate(
        overall_rank = rank(-overall_rank, ties.method = "min"),
        time_weighted_rank = rank(-time_weighted_rank, ties.method = "min")
      )
  )
