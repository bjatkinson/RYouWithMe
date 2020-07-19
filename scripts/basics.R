# load packages ----

library(tidyverse)
library(here)
library(skimr)
library(janitor)

# read in data ----

beaches <- read_csv(here("data", "sydneybeaches.csv"))

# exploring the data ----

View(beaches)

# tidying columns ----

glimpse(beaches)

select_all(beaches, toupper)
select_all(beaches, tolower)

cleanbeaches <- clean_names(beaches)

names(cleanbeaches)

#for rename use newname = oldname
cleanbeaches <- rename(cleanbeaches, beachbugs = enterococci_cfu_100ml)

cleanbeaches
View(cleanbeaches)

#select a subset of columns
select(cleanbeaches, council, site, beachbugs, everything())

# pipe %>%

cleanbeaches <- beaches %>%
  clean_names() %>%
  rename(beachbugs = enterococci_cfu_100ml)

write_csv(cleanbeaches, "cleanbeaches.csv")

# which beach has the most extreme levels of bugs

worstbugs <- cleanbeaches %>%
  arrange(desc(beachbugs))
View(worstbugs)

worstcoogee <- cleanbeaches %>%
  filter(site == "Coogee Beach") %>%
  arrange(desc(beachbugs))

#let's compare councils

cleanbeaches %>%
  distinct(council)

councilbysite <- cleanbeaches %>%
  group_by(council, site) %>%
  summarise(meanbugs = mean(beachbugs, na.rm = TRUE),
            medianbugs = median(beachbugs, na.rm = TRUE))

# compute new variables ----

glimpse(cleanbeaches)

testdate <- cleanbeaches %>%
  separate(date, c("day", "month", "year"), remove = FALSE)

cleanbeaches %>%
  unite(council_site, council:site, remove = FALSE)

# use mutate to transform the beachbugs data

summary(cleanbeaches)

cleanbeaches %>%
  mutate(logbeachbugs = log(beachbugs))

# use mutate to compute new numeric variable

cleanbeaches %>%
  mutate(beachbugsdiff = beachbugs - lag(beachbugs))

# use mutate to compute new logical variable

cleanbeaches %>%
  mutate(buggier = beachbugs > mean(beachbugs, na.rm = TRUE))

meanbugs = mean(cleanbeaches$beachbugs, na.rm = TRUE)

cleanbeaches_new <- cleanbeaches %>%
  separate(date, c("day", "month", "year"), remove = FALSE) %>%
  mutate(logbeachbugs = log(beachbugs)) %>%
  mutate(beachbugsdiff = beachbugs - lag(beachbugs)) %>%
  mutate(buggier_all = beachbugs > mean(beachbugs, na.rm = TRUE)) %>%
  group_by(site) %>%
  mutate(buggier_site = beachbugs > mean(beachbugs, na.rm = TRUE))
