# Parsing of HTML/XML files  
library(rvest)    

# String manipulation
library(stringr)   
# puttling data frames together
library(dplyr)

# Library web page: https://www.lapl.org/whats-on/calendar
webpage <- read_html("https://www.lapl.org/whats-on/calendar")
results <- webpage %>% html_nodes("tr")

# loop through all results
records <- vector("list", length = length(results))

for (i in seq_along(results)) {
  # to find the date, grab things with the tag "strong".  Just try this for the first lie
  first_result <- results[i]
  # split up each even into the different columns
  entries <- first_result %>% html_nodes("td")
  # get date and times
  # date_time <-first_result %>% html_nodes("td span") %>% html_text(trim = TRUE)
  date_time <- entries[1] %>% html_nodes("span") %>% html_text(trim=TRUE)
  date = date_time[1]
  duration = date_time[2]
  start_time = date_time[3]
  end_time = date_time[4]
  # get event name
  event_name <-  xml_contents(entries[2])[2] %>% html_text(trim = TRUE)
  # getbranch name
  branch <-  xml_contents(entries[3])[2] %>% html_text(trim = TRUE)
  # get audience
  audience <- xml_contents(entries[4])[2] %>% html_text(trim=TRUE)
  records[[i]] <- data_frame(date = date, duration = duration, start_time = start_time,
                             end_time = end_time, event_name = event_name, branch = branch, 
                             audience = audience)
}
df <- bind_rows(records)
