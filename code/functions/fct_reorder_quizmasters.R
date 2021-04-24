reorder_quizmasters <- function(data, quizmasters) {
  data %>%
    rowwise() %>%
    mutate({{ quizmasters }} := if_else(
      str_detect({{ quizmasters }}, "\\b[Aa]nd\\b"),
      str_match({{ quizmasters }}, "(\\b\\w+?\\b) \\b[Aa]nd\\b (\\b\\w+?\\b)")[-1] %>%
        str_sort() %>%
        str_flatten(" and "),
      {{ quizmasters }}
    )) %>%
    ungroup()
}
