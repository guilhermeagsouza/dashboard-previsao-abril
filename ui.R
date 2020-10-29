bs4Dash::bs4DashPage(
  old_school = FALSE,
  sidebar_collapsed = TRUE,
  controlbar_collapsed = TRUE,
  title = "Previsões",
  
  navbar = bs4Dash::bs4DashNavbar(
    skin = "dark",
    shiny::uiOutput(outputId = 'select_marca_name'),
    rightUi = tagList(
      bs4DropdownMenu(
        show = FALSE,
        labelText = "!",
        status = "danger",
        src = "https://www.google.fr",
        bs4DropdownMenuItem(
          message = "Versão 0.0.1",
          #time = "today",
          type = "notification"
        )
      )
    )
  ),
  sidebar =   bs4Dash::bs4DashSidebar(
    title = 'ID - Analytics',
    brandColor = 'dark',
    src = 'abril_logo.png',
    elevation = 3,
    opacity = 0.5,
    skin = "dark",
    status = 'secondary',
    bs4Dash::bs4SidebarMenu(
      bs4Dash::bs4SidebarHeader(""),
      bs4Dash::bs4SidebarMenuItem(
        startExpanded = TRUE,
        "Previsão",
        tabName = "home_tab",
        icon = "chart-line"
      )
    )
  ),
  controlbar = bs4Dash::bs4DashControlbar(
    skin = "dark",
    title = 'Filtros',
    hr(class = 'bg-white'),
    shiny::selectInput(
      inputId = 'select_marca',
      label = 'Selecione a marca',
      choices = marca_choices
      )
     
  ),
  
  body = bs4Dash::bs4DashBody(
    tags$head(tags$link(rel="shortcut icon", href='abril_logo.png')),
    bs4Dash::bs4TabItems(
      bs4Dash::bs4TabItem(
        tabName = "home_tab",
        main_marca
       
      )
    )
  )
)