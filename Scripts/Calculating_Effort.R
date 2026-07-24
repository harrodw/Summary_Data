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
bird_frog_dir <- "D:/Bird_Anuran_ARUs"
bat_dir <- "D:/Bat_ARUs"

################################################################################
# 2: Bird and Anuran ARU Effort ################################################
################################################################################

# List the ARUS
aru_ls <- dir_ls(bird_frog_dir)
n_aru <- length(aru_ls)

# View
aru_ls
n_aru

# View info for the first aru
aru_info <- aru_ls[4] |>
  dir_info() |>
  mutate(file = basename(path)) |>
  mutate(file.name = str_remove_all(file, "SMM2-\\d{2}_")) |>
  mutate(file.name = str_remove_all(file.name, "\\.wav")) |>
  mutate(file.name = str_remove_all(file.name, "_")) |> 
  mutate(date.time = parse_date_time(file.name, orders = "ymd%H%M%S")) |> 
  select(date.time, size, file)

# View
glimpse(aru_info)
head(aru_info)
# what is the range of file sizes
aru_info |> 
  count(size) |> 
  arrange(size) |> 
  mutate(size = as.numeric(str_remove_all(as.character(size), "M")))

# Large recordings are over 100 MB
lrg_fil_sze <-  100

# Blank data frame to store the number of morning recordings 
rec_info <- tibble(
)

# Loop over the ARUs and extract the relevant information
for(i in 1:n_aru){

  # Define a single ARU
  aru <- aru_ls[i]
  plot <- basename(aru)
  
  # List the recordings made by that ARU by size and extract the important information
  recs <- aru|>
    dir_info() |>
    mutate(file = basename(path),
           Plot = plot) |>
    mutate(file.name = str_remove_all(file, "SMM2-\\d{2}_")) |>
    mutate(file.name = str_remove_all(file.name, "\\.wav")) |>
    mutate(file.name = str_remove_all(file.name, "_")) |> 
    mutate(date.time = parse_date_time(file.name, orders = "ymd%H%M%S")) |> 
    mutate(size = as.numeric(str_remove_all(as.character(size), "M"))) |> 
    mutate(Morning = case_when(
      size > lrg_fil_sze ~ 1,
      size <= lrg_fil_sze ~ 0
    )) |> 
    select(Plot, date.time, Morning, size, file)
  
  # Combine with the others
  rec_info <- bind_rows(rec_info, recs)
  
  # Message
  message("Finished extracting info for  ", plot, " Plot ", i, " out of ", n_aru)
}

# View
glimpse(rec_info)

# Where are the NA's?
rec_info |> 
  filter(if_any(everything(), is.na))

