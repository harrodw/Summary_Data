################################################################################
# Title: Sensor Effort
# Creator: Will Harrod
# Created: 2026-07-23
# Description: Calculating the number of survey days for camera traps and ARUs
################################################################################

################################################################################
# 1: Prep ######################################################################
################################################################################

# Clear environments
rm(list = ls())

# Add packages
library(tidyverse)
library(fs)

# Directories
bird_frog_dir <- "G:/Bird_Anuran_ARUs"
bat_dir <- "G:/Bat_ARUs"

################################################################################
# 2: Bird and Anuran ARU Effort ################################################
################################################################################

# List the ARUS
aru_ls <- dir_ls(bird_frog_dir)

# View
aru_ls
length(aru_ls)

# View info for the first aru
single_aru_info <- aru_ls[1] |>
  dir_info() |>
  mutate(file = basename(path)) |>
  mutate(file = str_remove_all(file, "SMM2-\\d{2}_")) |>
  mutate(file = str_remove_all(file, "\\.wav")) |>
  mutate(date = str_extract(file, "\\d{8}_"),
         time = str_extract(file, "_\\d{6}")) |>
  mutate(date = str_remove_all(date, "_"),
         time = str_remove_all(time, "_")) |>
  # mutate(date = ymd(date),
  #        time = hms(time)) |>
  select(file, date, time, size)

glimpse(single_aru_info)


# Blank data frame to store the number of morning recordings 