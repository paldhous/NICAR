library(readr)
library(dplyr)
library(lubridate)

tweets <- read_csv("trump_tweets_raw.csv", col_types = cols(id_str = col_character(),
                                                            is_retweet = col_logical())) %>%
  mutate(timestamp = mdy_hms(created_at),
         est_timestamp = with_tz(timestamp, tzone = "America/New_York")) %>%
  select(-created_at)

write.csv(tweets, "trump_tweets.csv", row.names = F, na="")

trump_tweets <- read_csv("trump_tweets.csv")                   

glimpse(trump_tweets)
  