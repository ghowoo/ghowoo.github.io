## read dbf file;
sessionInfo()

library(digest)
library(devtools)
library(Wu)


getwd()
File1 <- "GRanD_dams_v1_3.dbf"
library(foreign)
t <- read.dbf(File1, as.is = FALSE)
## tab <- read.dbf("GRanD_dams_v1_3.dbf", as.is = TRUE)

## t <- read.dbf(system.file(File1, package="foreign"))

colnames(t)
dim(t)
## [1] 7320   58

library(data.table)
dt <- as.data.table(t)
dt[YEAR >= 2000,.N,by=list(YEAR)][order(YEAR)]
colnames(dt)
## dt <- dt[]

## CATCH_SKM: upsteam catchment 
dt <- dt[
  , area := CATCH_SKM^(1/2)
  ][, area := case_when(
    area < 1 ~ 1
    , TRUE ~ area
  )]
summary(dt$area)

## total: dim(dt)
##[1] 7320   59
summary(dt$YEAR)
##Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##-99    1948    1965    1859    1979    2017
dt <- dt[
  order(as.numeric(YEAR))
  ][, cum := 1:.N
    ][, perc := cum/.N
      ][, flag_half := ifelse(as.numeric(YEAR) < 2000, "Before 2000", "After 2000")
        ][, flag_half := factor(flag_half, levels = c("Before 2000", "After 2000"))]
dt[,.(min(YEAR), max(YEAR), .N), by = flag_half]
##View(dt[,list(cum, perc, flag_half, YEAR, DAM_NAME)])

#flag_half   V1   V2
#1: Before Half  -99 1965
#2:  Later Half 1965 2017

dt[,.(min(YEAR), max(YEAR)), by = list(as.numeric(YEAR) > 0)]

## read future dams;
## nt <- read.csv(file = "FHReD_2015_future_dams_Zarfl_et_al_beta_version.csv", stringsAsFactors = FALSE)
nt <- read.csv(file = "future dams - Sheet1.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
dim(nt)
## [1] 3700   20
nt <- as.data.table(nt)
colnames(nt)
## View(nt)
nt <- nt[
  , name_dam := Project.name
][, year := case_when(
  is.na(Start) ~ as.character("")
  , TRUE ~ as.character(Start)
)
  ][, status := case_when(
    Stage == "P" ~ "Planned"
    , Stage == "U" ~ "Under Construction"
    , TRUE ~ ""
  )][, area := 50
     ][, txt := paste0(name_dam, " - ",status, " ", Main_river, " ", Major.Basin, " ", year,sep = "")
       ][, type := "Future"
         ][, latitude := LAT_cleaned
           ][, longtitude := Lon_Cleaned]

nt[,.N,by=list(is.na(Stage))]
nt[,.N,by=list(is.na(name_dam))]
class(nt$Start)

library(plotly)
## install.packages("maps")
library(maps)

dat <- map_data("world", "canada") %>% group_by(group)

Sys.setenv('MAPBOX_TOKEN' = 'pk.eyJ1IjoiZ2hvd29vIiwiYSI6ImNrMjN0OWdqNDBpaWkzY3BocTMwb3pmeDkifQ.ByodOjdL9QK0JBvvfPNAkQ')

p <- plot_mapbox(dat, x = ~long, y = ~lat) %>%
  add_paths(size = I(2)) %>%
  add_segments(x = -100, xend = -50, y = 50, 75) %>%
  layout(mapbox = list(zoom = 0,
                       center = list(lat = ~median(lat),
                                     lon = ~median(long))
  ))
## p


df = read.csv('https://raw.githubusercontent.com/bcdunbar/datasets/master/meteorites_subset.csv')

colnames(dt)
## CATCH_SKM: upsteam catchment 
dt <- dt[
    , area := CATCH_SKM^(1/2)
][, area := case_when(
        area < 1 ~ 1
        , TRUE ~ area
    )][, type := "Built"]
summary(dt$area)


## some dams don't have name
## View(dt[is.na(DAM_NAME)])
dt <- dt[
  , name_dam := case_when(
    !is.na(DAM_NAME) ~ as.character(DAM_NAME)
    , !is.na(ALT_NAME) ~ as.character(ALT_NAME)
    , !is.na(RIVER) ~ as.character(RIVER)
    , !is.na(ALT_RIVER) ~ as.character(ALT_RIVER)
    , !is.na(MAIN_BASIN) ~ as.character(MAIN_BASIN)
    , !is.na(SUB_BASIN) ~ as.character(SUB_BASIN)
    , !is.na(NEAR_CITY) ~ as.character(NEAR_CITY)
    , TRUE ~ ""
  )
]
## View(dt[is.na(name_dam)])

dt <- dt[
  , year := case_when(
    as.numeric(YEAR) < 0 ~ ""
    , TRUE ~ as.character(YEAR)
  )
][, txt := paste0(name_dam, year, sep = " ")
  ][, latitude := LAT_DD
    ][, longtitude := LONG_DD]

dt2 <- rbind(
  dt[, list(name_dam, txt, type, area, latitude, longtitude)]
  , nt[, list(name_dam, txt, type, area, latitude, longtitude)]
)


## layout.mapbox.style

styles <- schema()$layout$layoutAttributes$mapbox$style$values
styles

style_buttons <- lapply(styles, function(s) {
  list(
    label = s, 
    method = "relayout", 
    args = list("mapbox.style", s)
  )
})

t <- list(
  family = "sans serif",
  size = 14,
  color = toRGB("grey50"))

?add_text
quantile(dt$LAT_DD)

t <- list(
  family = "sans serif",
  size = 14,
  color = "rgba(240,127,127,1)")


text_x <- quantile(dt$LONG_DD, 0.05)
text_y <- quantile(dt$LAT_DD, 0.75)

a <- list(
  x = text_x,
  y = text_y,
  text = "Dams Around the World",
#  xref = "x",
#  yref = "y",
  showarrow = TRUE,
  arrowhead = 0,
  arrowsize = 0,
  ax = 0,
  ay = 0
)

class(dt2$longtitude)
class(dt2$latitude)
summary(dt2$latitude)
summary(dt2$longtitude)
summary(dt2$area)



main_text <- c(
  "The blue dots on the map represent 7320 constructed"
  , "dams in the world by 2017 based on the Global"
  , "Reservoir and Dam Database (<a href = 'http://globaldamwatch.org/grand/'>GRanD v1.3</a>). It does"
  , "not cover all dams around the world, however," 
  , "it is the most comprehensive single geographically"
  , "explicit and reliable database."
  , ""
  , "The orange dots on the map represent 3700 dams"
  , "planned or under construction based on the Future"
  , "Hydropower Reservoirs and Dams Database"
  , "(<a href = 'http://globaldamwatch.org/fhred/'>FHReD 2015</a>)."
  , ""
  , "The map is created using R software with packages"
  , "of <a href = 'https://plot.ly/'>plotly</a> and <a href = 'https://cran.r-project.org/web/packages/maps/'>maps</a> based on <a href = 'https://www.mapbox.com/'>Mapbox</a> technology." 
, "Please zoom in and out to see details."
, ""
, ""
, ""
, ""
, ""
, ""
, ""
, ""
  , ""
  )

p <- as.data.frame(dt2) %>%
    plot_mapbox(
    ) %>%
    add_markers(
                y = ~ latitude
      , x = ~ longtitude
      , split = ~ type
      , size = ~ area
      , mode = 'scattermapbox'
      , colors = c("red1", "orange2")
      , text = ~ txt
      , hoverinfo = ~ "text"
    )  %>%
    layout(
        title = 'Dams'
      , font = list(color='white')
      , plot_bgcolor = '#DDDDDD'
      , paper_bgcolor = '#DDDDDD'
      , mapbox = list(style = 'light', zoom = 2)
      ## , updatemenus = list(list(y = 0.8, buttons = style_buttons))
      , legend = list(orientation = 'h',
                      font = list(size = 8))
      , margin = list(l = 0, r = 0,
                      b = 0, t = 0,
                      pad = 2)
      , annotations = list(
        x = c(0.01)
        , y = c(0.97, seq(0.90, 0.84, by = -0.02), seq(0.66, 0.14, by = -0.02))
        , text = c(
          "Hydraulic Dams around the World"
          , "<a href = 'https://ghowoo.github.io/'>Wu Gong</a>"
        , "October 29th, 2019"
        , ""
        , ""
        , ""
        , ""
          , ""
          , main_text
          )
        , font = list(
          family = "sans serif"
          , color="black"
          #, size=c(36, rep(12, 8))
          )
        , showarrow = FALSE 
        )
      , showlegend = FALSE
      )

p

main_text <- c(
  "While hydraulic dams are economically profitable,"
  , "often being symbolics of modernity and national"
  , "development, dams frequently entail the physical"
  , "and imaginative displacement of local communities"
  , "(Rob Nixon, Slow Violence and the"
  , "Environmentalism of the Poor)."
  , ""
  , "Hereby, how many dams do we need? More or less?"
  , "Should we honor the law of return? The law"
  , "requires that what is taken from nature must be"
  , "given back (Wendell Berry, Money Versus Good)."
  , ""
  , "The blue dots on the map represent 7320 constructed"
  , "dams in the world by 2017 based on the Global"
  , "Reservoir and Dam Database (<a href = 'http://globaldamwatch.org/grand/'>GRanD v1.3</a>). It does"
  , "not cover all dams around the world, however," 
  , "it is the most comprehensive single geographically"
  , "explicit and reliable database."
  , ""
  , "The orange dots on the map represent 3700 dams"
  , "planned or under construction based on the Future"
  , "Hydropower Reservoirs and Dams Database"
  , "(<a href = 'http://globaldamwatch.org/fhred/'>FHReD 2015</a>)."
  , ""
  , "The map is created using R software with packages"
  , "of <a href = 'https://plot.ly/'>plotly</a> and <a href = 'https://cran.r-project.org/web/packages/maps/'>maps</a> based on <a href = 'https://www.mapbox.com/'>Mapbox</a> technology." 
  , "Please zoom in and out to see details."
  )

length(main_text)

htmlwidgets::saveWidget(as.widget(p), "hydraulic_dams_around_the_world.html")

##link_plotly href = 'https://plot.ly/'
## link maps; href = 'https://cran.r-project.org/web/packages/maps/'
## mapbox line; href = 'https://www.mapbox.com/'
## GRanD v1.3; href = 'http://globaldamwatch.org/grand/'
## href = 'http://globaldamwatch.org/fhred/'

##26
## View(dt)
## summary(dt$CATCH_SKM)
