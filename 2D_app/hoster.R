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


#host the app
rsconnect::setAccountInfo(name='dario-x',
                          token='E4CB8DE11E8D3719FB14F4B3D099BCCB',
                          secret='Y+3CEYZALvA+6FAmq1rdPEH4pKTvEdyPg2gojsR2')

rsconnect::deployApp('C:/Users/user/Desktop/History/')


