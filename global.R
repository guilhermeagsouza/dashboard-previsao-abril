require(shiny)
require(bs4Dash)
require(DT)
require(shinycssloaders)

require(readxl)
require(dplyr)
require(reshape2)
require(data.table)
require(formattable)

require(writexl)
require(highcharter)
require(plotly)

library(anomalize)
library(strucchange)
library(tidyverse)


list.files(path = "src", pattern = ".R$", full.names = TRUE,recursive = TRUE) %>%
  purrr::walk(.f = source, encoding = "UTF-8")





list_insights <- tibble::tibble(
  marca = c('veja','superinteressante','capricho','saude','guiadoestudante','quatrorodas',
            'claudia','boaforma'),
  info = list( 
    list(
      'comentarios_gerais' = c(
        'A série do site Veja apresentou outliers em outubro de 2018 
        (referentes à temas políticos) e entre março/abril de 2020 com temas envolvendo COVID-19.',
        'A partir de agosto de 2016 a série apresentou uma tendência de crescimento, 
        alcançando uma basal de 10M de sessões por semana.'
      ),
      'comentarios_gerais_2' = c(
      'A série apresentou apenas uma quebra estrutural a partir da semana 32 de 2016,
      ocasionando um crescimento de 45% em relação à basal anterior.'),
      'erro_previsao' = c(
        'SARIMA - 26%'
      )
    ), 
    list(
      'comentarios_gerais' = c(
        'A série do site Superinteressante apresentou uma mudança brusca da basal 
        em meados de julho de 2018, o que é explicado pela incorporação da Revista 
        Mundo Estranho ao conteúdo do site. Além disso, há a presença de outliers 
        concentrados no período de março a abril de 2020, motivado pela intensidade de 
        matérias sobre tema COVID-19.',
        'A série apresentou um comportamento estável entre o ano de 2015 até 
        meio do ano de 2018, apresentando uma tendência de crescimento logo 
        depois. É uma série que não apresenta sazonalidade significativa.'
      ),
      'comentarios_gerais_2' = c(
        'A primeira ocorrendo na semana 13 de 2016, ocasionando um crescimento
        de 18% em relação à basal anterior.',
        'A segunda ocorrendo na semana 33 de 2018, apresentando um crescimento de 
        91% em relação à basal anterior.'),
      'erro_previsao' = c(
        'STLF -  32,3%'
      )
    ),
    list(
      'comentarios_gerais' = c(
        'A série apresenta outliers em períodos diferentes. Como é um site que 
        veicula matérias ligadas às personalidades, é normal que esses picos 
        estejam associados a elas e não a uma tendência de comportamento.',
        'A série apresentou de 2015 até meados de julho de 2017, uma basal em 
        torno de 3.5M. De agosto de 2018 até (25/10/2020), o comportamento foi de 
        queda.'
      ),
      'comentarios_gerais_2' = c(
        'Apesar de apresentar picos/spikes na decomposição sazonal, a série não 
        apresenta sazonalidade significativa.',
        'A série apresentou três quebras estruturais significativas.',
        'A primeira ocorrendo na semana 28 de 2017, ocasionando um crescimento 
        de 13% em relação à basal anterior. ',
        'A segunda ocorrendo na semana 31 de 2018, apresentando uma queda de 25% 
        em relação à basal anterior.',
        'A terceira ocorrendo na semana 34 de 2019, apresentando uma queda de 25% em 
        relação à basal anterior'
        ),
      'erro_previsao' = c(
        'SARIMA - 13%'
      )
    ),
    list(
      'comentarios_gerais' = c(
        'A série de Saúde apresentou uma mudança de nível brusca em meados de 
        maio de 2019, motivada pelo recebimento do Google Trusted (uma espécie 
        de selo que legitima a confiabilidade do site). Além disso, verifica-se 
        a presença de outliers bem concentrados no período de março de 2020 até 
        25/10/2020, correspondendo à intensidade de matérias sobre o tema COVID-19.',
        'A série não apresenta sazonalidade significativa.'
      ),
      'comentarios_gerais_2' = c(
        'A série apresentou três quebras estruturais significativas.',
        'A primeira ocorrendo na semana 02 de 2018, ocasionando um crescimento
        de 127% em relação à basal anterior.',
        'A segunda ocorrendo na semana 12 de 2019, apresentando um crescimento 
        de 93% em relação à basal anterior.',
        'A terceira ocorrendo na semana 09 de 2020, apresentando um crescimento 
        de 49% em relação à basal anterior.'),
      'erro_previsao' = c(
        'STLF - 27%'
      )
    ),
    list(
      'comentarios_gerais' = c(
        'A série do site Guia do Estudante apresenta outliers em períodos 
        específicos de janeiro que corresponde à divulgação dos resultados 
        do ENEM e outubro/novembro que correspondem às datas do exame.',
        'Do período de 2015 a 2017 a série se manteve no mesmo patamar,
        ocorrendo uma quebra estrutural a partir do meio do ano de 2018, 
        levando a um comportamento de tendência de queda.',
        'A série apresenta um comportamento sazonal em torno da semana 43/44 
        que é a data do ENEM.'
      ),
      'comentarios_gerais_2' = c(
        'A série apresentou apenas uma quebra estrutural significativa.',
        'A quebra estrutural ocorreu na semana 25 de 2018, ocasionando uma queda 
        de 27% em relação ao período anterior.'),
      'erro_previsao' = c(
        'SARIMA - 22,6%'
      )
    ),
    list(
      'comentarios_gerais' = c(
        'A série de Quatro Rodas apresentava uma tendência de crescimento até 
        meados de agosto de 2019.',
        'A série não apresenta sazonalidade significativa.'
      ),
      'comentarios_gerais_2' = c(
        'A série apresentou três quebras estruturais significativas.',
        ' A primeira ocorrendo na semana 24 de 2016, ocasionando um crescimento 
        de 41% em relação à basal anterior.',
        'A segunda ocorrendo na semana 19 de 2017, apresentando um crescimento 
        de 21% em relação à basal anterior.',
        'A terceira ocorrendo na semana 32 de 2019, apresentando um crescimento 
        de 41% em relação à basal anterior'),
      'erro_previsao' = c(
        'STLF - 36%'
      )
    ),
    list(
      'comentarios_gerais' = c(
        'A série do site Claudia (sem parceiros) apresenta outliers de matérias 
        com temas específicos. Além disso, a série indica muitas quebras estruturais, 
        o que será visto adiante.'
      ),
      'comentarios_gerais_2' = c(
        'A série apresentou quatro quebras estruturais significativas.',
        'A primeira ocorrendo na semana 51 de 2017, ocasionando um crescimento 
        de 34% em relação à basal anterior.',
        'A segunda ocorrendo na semana 29 de 2018, apresentando uma queda de 23% 
        em relação à basal anterior.',
        'A terceira ocorrendo na semana 18 de 2019, apresentando um crescimento 
        de 50% em relação à basal anterior.',
        'A quarta ocorrendo na semana 02 de 2020, apresentando uma queda de 57% 
        em relação à basal anterior.'),
      'erro_previsao' = c(
        'SARIMA - 28,6%'
      )
    ),
    list(
      'comentarios_gerais' = c(
        'Verifica-se a presença de outliers entre os períodos de 14/ago/2017 a
        04/set/2017. Páginas que tiveram como títulos dieta/emagrecimento e Paolla 
        Oliveira podem ter motivado esse aumento no número de sessões.',
        'Considerando o ano de 2017 como base e considerando *o número médio
        de sessões por semana de cada ano*, -0,2% em relação a 2018, -25% em 
        relação a 2019 e -52,7% em relação a 2020 (até a semana 25/10/2020).'
      ),
      'comentarios_gerais_2' = c(
        'Apesar de apresentar picos/spikes na decomposição sazonal, a série 
        não apresenta sazonalidade significativa.',
        'A série apresentou três quebras estruturais significativas.',
        'A primeira ocorrendo na semana 30 de 2017, ocasionando um crescimento de 
        36% em relação à basal anterior. ',
        'A segunda ocorrendo na semana 16 de 2018, apresentando uma queda de 18% 
        em relação à basal anterior.',
        'A terceira ocorrendo na semana 23 de 2019, apresentando uma queda de 
        31,5% em relação à basal anterior.'),
      'erro_previsao' = c(
        'SARIMA - 23,1%'
      )
    )
  )
)


marca_choices = c(
  'Veja' = 'veja',
  'Superinteressante' = 'superinteressante',
  'Capricho' = 'capricho',
  'Saúde' = 'saude',
  'Guia do Estudante' = 'guiadoestudante',
  'Quatro Rodas' = 'quatrorodas',
  'Claudia' = 'claudia',
  'Boa Forma' = 'boaforma'
  
  
  
)


list.files(path = "pages" , pattern = ".R$", full.names = TRUE) %>%
  purrr::walk(.f = source, encoding = "UTF-8")