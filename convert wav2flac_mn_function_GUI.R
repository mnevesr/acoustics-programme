##################################################################################################################
##################################################################################################################
###########    Preparing Detection Datasets as Detector Training Datasets for MERIDIAN G&C efforts     ###########
##################################################################################################################
##################################################################################################################

library(seewave)
library(tuneR)
library(beepr)
library(svDialogs)

## Converting WAVE files to FLAC files

## Specify location to flac encoder required by wav2flac function

path2exe<- dlg_dir(default = getwd(), title = "Choose the path to the FLAC binary file (flac.exe)")$res


path2wav<- dlg_dir(default = getwd(), title = "Choose the Drive containing the .wav files you wish to convert")$res

## Make list of wave files for conversion in a chosen directory (recursive = TRUE to include all subfolders)
beep(wav.list<-list.files(path2wav, full.names = TRUE, pattern = "\\.wav$", recursive = TRUE)
     , sound = 2)
head(wav.list)


## Convert wav to flac in the same directory using a for loop
system.time(
  beep(
    for(i in 1:length(wav.list)){
      wav2flac(file=wav.list[[i]],exename="flac.exe",path2exe=path2exe)
      
    }
    , sound = 2)
)

######################################################################################################


# To run after creating flac from wav files
## About the function 'flac.transfer':
## 1. lists all .flac files in the directory where the source .wav files are located.
## 2. creates copy of directory with same folder structure in new /FLAC directory.
## 3. Moves all .flac files from original directory to new directory in /FLAC folder.

flac.transfer <- function(from) {
  list.from <- list.files(from, full.names = TRUE, pattern = "\\.flac$", recursive = TRUE)
  list.to <- gsub(pattern = '^(.*:/)(.*)$', replacement = '\\1FLAC/\\2', x = list.from)
  todir <- unique(dirname(list.to))
  lapply(todir, function(x) if(!dir.exists(x)) dir.create(x, recursive=TRUE))
  x <- file.rename(from = list.from ,  to = list.to)
  if (all(x)) message("Flac move complete!") else message('!Error occurred!')
}

flac.transfer <- source("flactransfer_fun.R")

flac.transfer(path2wav)

###########