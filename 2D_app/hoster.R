library(rsconnect)
library(shiny)
library(DT)
library(lazyeval)
library(leaflet)
library(leaflet.providers)
library(raster)
library(shinythemes)
library(sp)
library(terra)

# set the working directory to directory of the script
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#host the app 
rsconnect::setAccountInfo(name='dario-x', 
                          token='B2851460A9710DA623BF1C1F19C34424', 
                          secret='irGcCeP2PN3ckEKl3IwXZSifo9L4rCej2nA8SHJ9')

rsconnect::deployApp('C:/Users/user/PycharmProjects/history_seven/2D_app/', appTitle = 'History7')

