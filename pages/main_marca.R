main_marca <- shiny::div(
  shiny::fluidRow(
      bs4Dash::bs4Card(
        width =  6, 
        title = 'Insights',
        shiny::fluidRow(
          shiny::column(
            12,
            shiny::uiOutput(outputId = 'insights') %>% 
              shinycssloaders::withSpinner(color = 'green')
          )
          
        )
        
      ),
      bs4Dash::bs4Card(
        title = 'Sessões',
        highcharter::highchartOutput(outputId = 'sessions_plot') %>% 
          shinycssloaders::withSpinner(color = 'green')
        ),
   
      bs4Dash::bs4Card(
        title = 'Tendência',
         highcharter::highchartOutput(outputId = 'trend_plot') %>% 
           shinycssloaders::withSpinner(color = 'green')),
   
      bs4Dash::bs4Card(
        title = 'Previsão (16 passos à frente)',
        highcharter::highchartOutput(outputId = 'forecast_plot') %>% 
         shinycssloaders::withSpinner(color = 'green')
        )
  )
)