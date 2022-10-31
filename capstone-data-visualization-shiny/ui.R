dashboardPage(
  
  # HEADER
  header <- dashboardHeader(title = "Sport Summary"),
  
  #SIDEBAR
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Summary", tabName = "tab_summary", icon = icon("dashboard")),
      menuItem("Sport", tabName = "tab_sport", icon = icon("bicycle")),
      menuItem("Database", tabName = "tab_data", icon = icon("table")),
      menuItem("Source Code", icon = icon("file-code-o"), 
               href = "https://github.com/mirfani28/capstone-datavisualization"),
      menuItem("Strava Profile", icon = icon("person"), 
               href = "https://www.strava.com/athletes/47225027")
    )
  ),
  
  #BODY
  body <- dashboardBody(
    tabItems(
      # PAGE 1
      tabItem(tabName = "tab_summary",
              #ROW1 -> 
              fluidPage(
                h2(tags$b("Sport Summary from Strava")),
                br(),
                div(style = "text-align:justify", 
                    p("The purpose of this project is to try summarize and getting insight from activities records of one person. This will beneficial for anyone who is interested in data processing their records for better exercise plan, compare performance with others or their own-record. 
                      Feel free to copy, manipulate, or train your data skills with this article and data-set.
                      "),
                    p("Check out my ", 
                      a(href = "https://www.strava.com/athletes/47225027",
                        "Strava Profile")),
                    br()
                )
              ),
              
              #ROW2 ->
              fluidRow(
                infoBox("Total Moving Time (in Hours)",
                        (comma(summary_sport$total_moving_time/3600)),
                        icon = icon("clock"), 
                        color = "black"), 
                infoBox("Total Calories (in Calories)",
                        (comma(summary_sport$total_calories)),
                        icon = icon("fire"),
                        color = "red"),
                infoBox("Total Distance (in Meter)",
                        (comma(summary_sport$total_distance)),
                        icon = icon("road"), 
                        color = "black")
              ),
                
              #ROW2 ->
              fluidPage(
                tabBox(width = 6,
                       tabPanel(tags$b("2020"), 
                                plotlyOutput("active_month_lineplot_2020")
                       ),
                       tabPanel(tags$b("2021"), 
                                plotlyOutput("active_month_lineplot_2021")
                       ) 
                ),
                tabBox(width = 6,
                       tabPanel(tags$b("Top Sport"), 
                                plotlyOutput("barplot_top_sport")
                       ), 
                       tabPanel(tags$b("Favorite Hour"), 
                                plotlyOutput("fav_hour_lineplot")
                       )
                )

              ),
      ),
      
      # PAGE 2
      tabItem(tabName = "tab_sport", 
              
              #ROW1 -> 
              fluidPage(
                box(width = 9,
                    solidHeader = T,
                    title = tags$b("Total Calories Burned Each Month"), 
                    plotlyOutput("sport_calories_lineplot")
                    ),
                box(width = 3, 
                    solidHeader = T,
                    background = "red",
                    height = 460,
                    selectInput(inputId = "type",
                                label = h4(tags$b("Select Activity Type:")),
                                choices = selectType)
                    )
              ), 
              
              #ROW2 -> 
              fluidPage(
                box(width = 9,
                    solidHeader = T,
                    title = tags$b("Most Epic Activities"), 
                    plotlyOutput("top_calories_barplot")
                ),
                box(width = 3, 
                    solidHeader = T,
                    background = "red",
                    height = 460,
                    sliderInput(
                      "sliderRanking",
                      label = "Number of Ranking",
                      min = 10,
                      max = 30,
                      value = 1,
                      step = 1,
                      round = TRUE,
                    )
                )
              )
      ),
      
      # PAGE 3
      tabItem(
        tabName = "tab_data",
        h2(tags$b("Strava Dataset 2020-2021")),
        DT::dataTableOutput("data_sets")
      )
    )  
  )
)

# Combining Dashboard Part
dashboardPage(
  header = header,
  body = body,
  sidebar = sidebar,
  skin = "red"
)
