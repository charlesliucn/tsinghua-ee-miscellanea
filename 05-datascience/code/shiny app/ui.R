library(leaflet)

vars <- c(
  "Choose A City" = "choose",
  "San Jose" = "sanjose",
  "San Francisco" = "sanfrancisco",
  "Palo Alto" = "paloalto",
  "Mountain View" = "mountainview"
)

maps <- c(
  "OpenStreetMap" = "default",
  "Stamen.Toner" = "Stamen.Toner",
  "Stamen.TonerLite" = "Stamen.TonerLite",
  "Stamen.TonerLabels" = "Stamen.TonerLabels",
  "Stamen.TonerLines" = "Stamen.TonerLines",
  "CartoDB.Positron" = "CartoDB.Positron"
  )

navbarPage("Bay Area Bike Share", id="nav",

  tabPanel("Interactive Map",
    div(class="outer",

      tags$head(includeCSS("styles.css")),
      leafletOutput("map", width="100%", height="100%"),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 250, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",

        h2("Bike Station Explorer"),
        selectInput("basemap", "Base Map", maps),
        selectInput("city", "City", vars),
        selectInput("stationfrom","Start Station",stationinfo$stationinfo),
        selectInput("stationend","Destination",stationinfo$stationinfo)
      ),
      absolutePanel(id = "plots", class = "panel panel-default", fixed = TRUE,
      draggable = TRUE, top = 60, left = 20, right = "auto", bottom = "auto",
      width = 360, height = "auto",
                    
      h3("  Plot Explorer"),
      plotOutput("barPlot", height = 200),
      plotOutput("faceSubCust",height = 200),
      plotOutput("tripdistribute",height = 200)
      )      
      
    )
  ),
  conditionalPanel("false", icon("calendar"))
  )
