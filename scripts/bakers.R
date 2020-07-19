library(tidyverse)
library(here)
library(skimr)
library(janitor)

bakers_wide <- read_csv(here("data", "bakers_wide.csv"))

bakers_long <- bakers_wide %>%
  pivot_longer(names_to = "spice",
               values_to = "correct",
               cols = -baker)

beachbugs_wide <- read_csv(here("data", "beachbugs_wide.csv"))

beachbugs_long <- beachbugs_wide %>%
  pivot_longer(names_to = "site",
               values_to = "buglevels",
               cols = -year)

frames_wide <- read_csv(here("data", "frames_wide.csv"))

frames_long <- frames_wide %>%
  pivot_longer(names_to = "item",
               values_to = "score",
               cols = -(id:condition))

frames_long <- frames_long %>%
  separate(item, c("sample", "item"))