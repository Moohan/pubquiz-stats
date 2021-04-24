regularise_names <- function(data, name) {
  mutate(data, across(c({{ name }}), ~ str_replace(., "\\b[Cc]am\\w*\\b", "camille") %>%
    str_replace("\\b[Jj]onathan\\b", "jonty") %>%
    str_replace("\\b[Ss]pud\\b", "emma") %>%
    # Re-capitalise
    str_to_title() %>%
    str_replace("\\bAnd\\b", "and")))
}
