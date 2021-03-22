winning_streak <- function(name) {
  person_scores <- clean_data %>%
    filter(
      person == name,
      !str_detect(quizmasters, name)
    ) %>%
    select(quizmasters, quiz_number, person, position) %>%
    arrange(desc(quiz_number)) %>%
    pull(position)

  streak_ended <- FALSE
  streak <- 0L
  while (!streak_ended) {
    if (person_scores[streak + 1L] == "1st") {
      streak <- streak + 1L
    } else {
      streak_ended <- TRUE
    }
  }
  return(streak)
}
last_winning_team_streaks <- map_int(last_winning_team$person, winning_streak)

max_streak <- max(last_winning_team_streaks)

people_on_streak <- last_winning_team$person[which(last_winning_team_streaks == max_streak)] %>%
  as_tibble() %>%
  unnest_tokens(input = "value", output = "person") %>%
  pull(person) %>%
  str_to_sentence() %>%
  str_sort()
