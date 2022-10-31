shinyServer(function(input, output) {

  ## 
  
  #PAGE 1
  
  #plot 2020
  output$active_month_lineplot_2020 <- renderPlotly({
    
    #summary 2020
    active_month_2020 <-
      activities_clean_final %>% 
      filter(year_record == 2020)
    
    active_month_2020 <-
      active_month_2020 %>%
      group_by(month_record) %>%
      summarise(time_total = sum(elapsed_time)) %>%
      ungroup() %>%
      mutate(total_hours = time_total/3600) %>%
      arrange(month_record) %>%
      mutate(label = glue("Month : {month_record}
                      Total Hours : {comma(total_hours)}"))
    
    #plot 2020
    active_month_lineplot_2020 <-
      ggplot(active_month_2020, 
             mapping = aes (x = month_record, 
                            group = 1 , 
                            text = label
             )
      ) + 
      geom_line(aes(y = total_hours),
                size = 1,
                show.legend = FALSE, 
                color = "red"
      ) +
      geom_point(aes(y = total_hours),
                 size = 2,
                 color = "red"
      ) +
      scale_y_continuous(labels = comma,
                         breaks = seq(0,120,20),
                         limits = c(0, 120)
      ) +
      labs(
        title = "Month Active 2020",
        y = "Total Hours",
        x = "Month"
      ) +
      theme_minimal()
    
    ggplotly(active_month_lineplot_2020, tooltip = "text")
    
  })
  
  #plot 2021
  output$active_month_lineplot_2021 <- renderPlotly({
    
    #summary 2021
    active_month_2021 <-
      activities_clean_final %>% 
      filter(year_record == 2021)
    
    active_month_2021 <-
      active_month_2021 %>%
      group_by(month_record) %>%
      summarise(time_total = sum(elapsed_time)) %>%
      ungroup() %>%
      mutate(total_hours = time_total/3600) %>%
      arrange(month_record) %>%
      mutate(label = glue("Month : {month_record}
                      Total Hours : {comma(total_hours)}"))
    
    #plot 2021
    active_month_lineplot_2021 <-
      ggplot(active_month_2021, 
             mapping = aes (x = month_record, 
                            group = 1 , 
                            text = label
             )
      ) + 
      geom_line(aes(y = total_hours),
                size = 1,
                show.legend = FALSE, 
                color = "red"
      ) +
      geom_point(aes(y = total_hours),
                 size = 2,
                 color = "red"
      ) +
      scale_y_continuous(labels = comma,
                         breaks = seq(0,120,20),
                         limits = c(0, 120)
      ) +
      labs(
        title = "Month Active 2021",
        y = "Total Hours",
        x = "Month"
      ) +
      theme_minimal()

    ggplotly(active_month_lineplot_2021, tooltip = "text")
    
  })
  
  #plot top sport
  output$barplot_top_sport <- renderPlotly({
    
    #summary top sport
    top_sport <-
      activities_clean_final %>%
      group_by(type) %>%
      summarise(time_total = sum(elapsed_time)) %>%
      ungroup() %>%
      mutate(total_hours = time_total/3600, 
             label = glue("Activity Type : {type}
                      Total Hours : {comma(total_hours)}")) %>%
      arrange(desc(total_hours))
    
    #plot top sport
    barplot_top_sport <-
      ggplot(data = top_sport,
             mapping = aes(x = total_hours,
                           y = reorder(type, total_hours),
                           text = label)) + 
      geom_col(aes(fill = total_hours), show.legend = FALSE) +
      scale_fill_gradient(low = "orange", high = "red") +
      labs(
        title = "Top Sport Total",
        y = "Activity Type",
        x = "Total Hours"
      )
    theme_minimal()
    
    ggplotly(barplot_top_sport, tooltip = "text")
    
  })
  
  output$fav_hour_lineplot <- renderPlotly({
    
    #summary fav hour
    fav_hour <-
      activities_clean_final %>%
      group_by(hour_record) %>%
      summarise(total_record = n()) %>%
      ungroup() %>%
      mutate(label = glue("Activity Count : {total_record}
                      Starting Hour : {hour_record}")) %>%
      arrange(hour_record)
    
    #fav hour lollipop plot
    fav_hour_lineplot <-
      ggplot(fav_hour, 
             mapping = aes (x = hour_record, 
                            group = 1 , 
                            text = label
             )
      ) +
      geom_point(aes(y = total_record),
                 size = 2,
                 color = "red"
      ) +
      geom_segment(aes(y = 0,xend = hour_record, yend = total_record),
                   size = 2, 
                   color = "red") +
      scale_x_continuous(breaks = seq(0,23,1), 
                         limit = c(0, 23)
      ) +
      scale_y_continuous(breaks = seq(0,150,25),
                         limits = c(0, 150)
      ) +
      labs(
        title = "Favorite Hour",
        y = "Activities Started",
        x = "Hour"
      ) +
      theme_minimal()
    
    ggplotly(fav_hour_lineplot, tooltip = "text")
    
  })
  
  #PAGE 2

  output$sport_calories_lineplot <- renderPlotly({
    
    #sport calories aggregation
    sport_calories <- 
      activities_clean_final %>%
      filter(type == input$type) %>%
      group_by(month_record) %>%
      summarise(total_calories = sum(calories)) %>%
      ungroup() %>%
      mutate(label = glue("Total Calories : {comma(total_calories)}
                      Month : {month_record}")) %>%
      arrange(month_record)
    
    #calories lineplot
    sport_calories_lineplot <-
      ggplot(sport_calories, 
             mapping = aes (x = month_record, 
                            group = 1 , 
                            text = label
             )
      ) + 
      geom_line(aes(y = total_calories),
                size = 1,
                show.legend = FALSE, 
                color = "red"
      ) +
      geom_point(aes(y = total_calories),
                 size = 2,
                 color = "red"
      ) +
      scale_y_continuous(labels = comma,
                         breaks = seq(0,35000,5000),
                         limits = c(0, 35000)
      ) +
      labs(
        title = "Calories Burned by Month",
        y = "Total Calories",
        x = "Month"
      ) +
      theme_minimal()
    
    ggplotly(sport_calories_lineplot, tooltip = "text")
  })
  
  
  output$top_calories_barplot <- renderPlotly({
    
    #top calories by activity id
    top_calories <- 
      activities_clean_final %>%
      arrange(desc(calories)) %>%
      select(activity_id, type, calories, moving_time) %>%
      mutate(hours = moving_time/3600, 
             label = glue("Calories : {comma(calories)}
                      Activity Type : {type}
                      Moving Hours : {format(round(hours, 2), nsmall = 2)}")) %>%
      head(input$sliderRanking)
    
    #plotting data
    top_calories_barplot <- 
      ggplot(data = top_calories, 
             mapping = aes(x = calories, 
                           y = reorder(activity_id, calories), 
                           text = label)) + 
      geom_col(aes(fill = calories), show.legend = FALSE) +
      scale_fill_gradient(low = "orange", high = "red") +
      labs(
        title = "Most Epic Activities",
        y = "Activity ID",
        x = "Calories Burned"
      ) +
      scale_x_continuous(labels = comma,
                         breaks = seq(0,6000,500),
                         limits = c(0, 6000)) +
      theme_minimal()
    
    ggplotly(top_calories_barplot, tooltip = "text")
    
  })
  
  output$data_sets <- DT::renderDataTable(activities_clean_final, options = list(scrollX = T))
  
  
  
})