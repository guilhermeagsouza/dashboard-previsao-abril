function(input,output,session) {

  
  output$select_marca_name <- shiny::renderUI({
    shiny::HTML(
      '<h4>',
      '<span class="badge badge-success">',
      input$select_marca %>%  stringr::str_to_upper(),
      '</span></h4>'
      )
  })

# insights ----------------------------------------------------------------

  output$insights <- shiny::renderUI({
    
    output = list_insights %>% 
      dplyr::filter(marca == input$select_marca) %>% 
      dplyr::pull(info) %>% 
      .[[1]]

    
    comp_1 = shiny::HTML(

       glue::glue('<p>{output$comentarios_gerais}</p>') %>%  shiny::HTML()
    )
    
    
    file_name = paste0(
      './data/dados_p_graficos/base_',
      input$select_marca,'.Rda')
    
    variacao = readr::read_rds(file_name) %>% 
      dplyr::mutate(ano = lubridate::year(x)) %>% 
      dplyr::group_by(ano) %>% 
      dplyr::summarise(y_sessoes = sum(y)) %>% 
      dplyr::mutate(
        lag_sessoes = dplyr::lag(y_sessoes, 1),
        divisao = 100*(y_sessoes/lag_sessoes)-100
      ) %>%
      na.omit() %>% 
      dplyr::mutate(
        valor_format = divisao %>% 
          round(2) %>% 
          stringr::str_replace_all('\\.','\\,') %>% 
          stringr::str_c('%'),
        pill = dplyr::case_when(
          divisao > 0 ~ glue::glue('<span class="badge badge-pill badge-success">{valor_format}</span>'),
          divisao == 0 ~ glue::glue('<span class="badge badge-pill badge-secondary">{valor_format}</span>'),
          divisao < 0 ~ glue::glue('<span class="badge badge-pill badge-danger">{valor_format}</span>')
        )
      )
      
    
   comp_2 =  shiny::HTML(
      'Variação anual do total de sessões:',
      '<ul class="list-group">', 
      glue::glue(
        '<li class="list-group-item d-flex justify-content-between align-items-center">
        {variacao$ano - 1} - {variacao$ano}
        <strong>{variacao$pill}</strong></li>') 
      %>%  shiny::HTML(),
      '</ul>'
    )
    
  
  comp_3 = 
    shiny::HTML(
     
      glue::glue('<p>{output$comentarios_gerais_2}</p>') %>%  shiny::HTML()
     
    )
    

    
  comp_4 =   shiny::HTML(
      'Erro de previsão (MAPE) dentro do período de teste:', 
      '<ulclass="list-group">',
      glue::glue('<li class="list-group-item">{output$erro_previsao}</li>') %>%  shiny::HTML(),
      '</ul>'
    )
    
  
  comp_final = shiny::div( shiny::HTML(comp_1,comp_2,comp_3,comp_4),
                           style = 'font-size: 13px;')
  
 
    
  })
  
  
# sessions ----------------------------------------------------------------

  
  
  output$sessions_plot <- highcharter::renderHighchart({
    file_name = paste0(
      './data/dados_p_graficos/base_',
      input$select_marca,'.Rda')
    readr::read_rds(file_name) %>% 
      fun_plot_ts()
  })
  
  output$trend_plot <- highcharter::renderHighchart({
    file_name = paste0(
      './data/decomposicao_temporal/decomposicao_temporal_',
      input$select_marca,'.Rda')
    decomposicao_temporal_marca <- readr::read_rds(
      file_name
    )
    
    df_decomp_marca <- decomposicao_temporal_marca %>%
      tibble::as_tibble() %>%
      dplyr::select(x = data, y = Tendencia) %>%
      dplyr::mutate(
        x_tooltip = x %>% format("%d %b %y"),
        y_tooltip = y %>%
          round(0) %>%
          format(nsmall = 0, big.mark = " ") %>%
          stringr::str_trim() %>%
          stringr::str_remove("NA"),
        x = highcharter::datetime_to_timestamp(x)
      )
    
    
    highcharter::highchart() %>%
      highcharter::hc_add_series(
        data = df_decomp_marca,
        name = "Tendência",
        type = "line",
        color = "#305973",
        highcharter::hcaes(x = x, y = y),
        marker = list(symbol = "circle", radius = 3),
        tooltip = list(
          headerFormat = "",
          pointFormat  = "{point.x_tooltip}<br><b>{point.y_tooltip}</b>"
        )
      ) %>%
      highcharter::hc_xAxis(
        type     = "datetime",
        crosshair = TRUE
      )
  })
  

# forecast ----------------------------------------------------------------

  
  
  output$forecast_plot <- highcharter::renderHighchart({
    file_name =  paste0(
      './data/tabela_previsao_consolidada/tbl_previsao_consolidada_',
      input$select_marca,'.Rda')
    df_forecast_full <- readr::read_rds(file_name)
    
    ################################################################################
    
    df_forecast_full <- readr::read_rds(file_name)
    df_forecast_full <- df_forecast_full %>%
      tibble::as_tibble()
    
    
    df_forecast_plot <- df_forecast_full %>%
      dplyr::filter(!is.na(STLF)) %>%
      tidyr::pivot_longer(
        cols = c(ATUAL, STLF, SARIMA, PROPHET, ENSEMBLE),
        names_to = "serie",
        values_to = "valor"
      ) %>%
      dplyr::filter(!is.na(valor)) %>%
      dplyr::rename(x = `.index`, y = valor) %>%
      dplyr::mutate(
        x_tooltip = x %>% format("%d %b %y"),
        y_tooltip = y %>% round(0) %>% format(nsmall = 0, big.mark = " "),
        x = highcharter::datetime_to_timestamp(x)
      )
    
    
    
    highcharter::highchart() %>%
      highcharter::hc_add_series(
        data = df_forecast_plot %>% 
          dplyr::mutate(TIPO_serie = str_c(TIPO,serie, sep = "-")) %>% 
          dplyr::filter(TIPO_serie %in% c("In_sample-ATUAL","Out_sample-SARIMA")),
        #name = "Basal",
        type = "line",
        color = c(
          highcharter::hex_to_rgba(x = "#5bae93", 1),
          highcharter::hex_to_rgba(x = "#FF9996", 1)
          #highcharter::hex_to_rgba(x = "#FF9996", 1),
          #highcharter::hex_to_rgba(x = "#FF9996", 1),
          #highcharter::hex_to_rgba(x = "#FF9996", 1)
        ),
        highcharter::hcaes(x = x, y = y, group = serie),
        marker = list(symbol = "circle", radius = 3),
        tooltip = list(
          headerFormat = "",
          pointFormat  = "{point.x_tooltip}<br><b>{point.y_tooltip}</b>"
        )
      ) %>%
      highcharter::hc_xAxis(
        type     = "datetime",
        crosshair = TRUE
      ) %>% 
      highcharter::hc_yAxis(
        min = 0
      )
  })
  
  
  
  
}