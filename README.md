# Teste de Hipóteses - Spotify
  
  Neste projeto, foram utilizadas as ferramentas BigQuery, Google Colab e Power BI com o objetivo de aplicar o teste de hipóteses sobre uma base de dados da plataforma Spotify.

## Objetivo
  
  Através de uma base de dados da plataforma Spotify, o objetivo deste projeto foi aplicar testes estatísticos (correlação, teste de significância e regressão linear) para validar ou refutar hipóteses levantadas num cenário onde uma gravadora está buscando lançar um novo artista e busca entender o contexto da indústria musical.

<details>
  <summary><strong style="font-size: 16px;">Equipe</strong></summary>
  
  - Nicole Machado Corrêa
  - Lays Silva
</details>

<details>
  <summary><strong style="font-size: 16px;">Ferramentas e Tecnologias</strong></summary>
  
  - BigQuery
  - Google Colab
  - Power BI
  - Python
  - SQL
</details>

<details>
  <summary><strong style="font-size: 16px;">Processamento e Análises</strong></summary>
  
  ### Importação da base de dados
  
  A primeira etapa deste projeto foi realizar a importação das bases de dados para o ambiente BigQuery. Dentro da opção do Google Cloud “BigQuery” foi criada uma pasta chamada “projeto02_hipoteses”. Para isso, as tabelas foram importadas diretamente através do upload de arquivos, e adicionados os três arquivos CSV correspondentes a “_track_in_competition_”, “_track_in_spotify_” e “_track_technical_info_” dentro de uma subpasta chamada “_dados_spotify_”.
  
  ### Dados nulos
  
  Para identificar e tratar valores nulos, foi utilizado os comandos SQL SELECT, FROM, WHERE e IS NULL para buscar os valores nulos dentro de cada uma das variáveis das tabelas. Verificou-se que havia 50 valores nulos na variável “_in_shazam_charts_” e 95 valores nulos na variável “_key_”. Para a variável  “_in_shazam_charts_”, optou-se por utilizar o valor da mediana para o preenchimento dos valores nulos, uma vez que observou-se que ao aplicar este tratamento, a média dos dados muito pouco variou.

### Dados duplicados

Para identificar e tratar valores duplicados, foi utilizado os comandos SQL COUNT, GROUP BY, HAVING. Observou-se 10 valores duplicados para as variáveis “_track_name_”, sendo retirados, assim, 5 valores.


### Dados fora do escopo da análise e discrepantes

Por meio de comandos SQL SELECT EXCEPT, optou-se por retirar as variáveis “_key_” e “_mode_”, pois entendeu-se que não seriam relevantes para o propósito da análise. 

Já para dados discrepantes, utilizou-se o comando de manipulação de strings REGEXP REPLACE, onde se corrigiu caracteres nas variáveis “_track_name_” e “_artist_s__name_”.

No caso de dados discrepantes de variáveis numéricas, utilizou-se os comandos 'MAX', 'MIN' e 'AVG' para identificar os valores discrepantes na variável "_streams_", que estava originalmente como string. 

###  Alteração do tipo de dados

Converteu-se A variável "_streams_", originalmente no formato string, para variável numérica, através do comando SAFE_CAST.


###  Criação de novas variáveis

Através dos comandos CONCAT, CAST E JOIN, foram criadas as variáveis abaixo.

“_release_date_concat_”: criada com o propósito de combinar três variáveis: “_released_year_”, “_released_month_” e “_released_day_”, para formar uma única data que represente o ano, mês e dia de lançamento de uma música.

“_soma_playlists_” : variável que representa a soma de uma música em playlists do Spotify, Deezer e Apple, através da concatenação das variáveis "_in_spotify_playlists_", “_in_apple_playlists_” e “_in_deezer_playlists_”.

“_count_music_artosolo_”: variável criada representando a quantidade de músicas por artista solo. Aqui, foram utilizadas os comandos SQL WITH, COUNT e GROUP BY.


###  União de tabelas

Ao final, as tabelas “_track_in_competition_”, “_track_in_spotify_” e “_track_technical_info_” foram unidas através dos comandos CREATE TABLE e LEFT JOIN e JOIN, gerando a tabela “_dados_spotify_final_”.
</details>

<details>
 <summary><strong style="font-size: 16px;">Análise Exploratória</strong></summary>

###  Comportamento e visualização dos dados

Ao importar a tabela csv “_dados_spotify_final_” para o ambiente do Power BI,  realizou-se um agrupamento para verificar quantos streams havia por artista, e criados gráficos de barras para a visualização desta variável categórica. O mesmo foi feito para observar quantos streams havia por música.

Além disso, verificou-se os valores de média, mediana e desvio padrão das variáveis numéricas da tabela, bem como criou-se histogramas para a visualização da distribuição das variáveis. Também foi gerado um gráfico de linhas para a visualização do número de músicas lançadas por ano. 

###  Cálculo de quartis

As variáveis que representam as características das músicas (“_bpm_”, “_danceability_”, “_valence_”, “_energy_”, “_acousticness_”, “_instrumentalness_”, “_liveness_” e “_speechiness_”) foram categorizadas em quartis, recebendo valores de 1 a 4. Para isso, foram utilizados os comandos WITH, NTILE, OVER e ORDER BY. 

###  Segmentação dos dados

Foram criadas categorias nomeadas “_alta_” e “_baixa_” para os quartis, onde agrupou-se os valores 1 e 2 em “_baixa_” e 3 e 4 em “_alta_”, utilizando o comando IF e agregando a tabela através do comando JOIN. Foi criada uma tabela matriz para cada uma das variáveis das características das músicas para verificar o valor médio de streams para cada uma das duas categorias criadas para cada variável.

Ao final, foi criada uma nova tabela utilizando o comando CREATE TABLE chamada “_dados_spotify_categorizados_”.

###  Teste de correlação

Dentro do ambiente do BigQuery, aplicou-se o teste de correlação para as hipóteses levantadas no início deste projeto, por meio do comando  CORR, para fins de validação das mesmas.

###  Teste de significância (Mann-Whitney)

Dentro do ambiente do Google Colab, utilizou-se a linguagem Python para realizar o teste de significância não paramétrico de Mann-Whitney para as hipóteses deste trabalho, com o objetivo de determinar se há uma diferença significativa entre dois grupos independentes.Uma das principais vantagens deste teste é que ele não exige que os dados sejam normalmente distribuídos, e por isso foi escolhido pois a normalidade dos dados era desconhecida. 

###  Teste de regressão linear

Utilizando Python, realizou-se uma análise de regressão linear para as hipóteses, para permitir examinar as relações entre as variáveis e determinar se existem associações significativas entre elas ou não. Além disso, foram também criados gráficos de dispersão para a visualização do comportamento destas variáveis, em cada uma das hipóteses do projeto.
</details>

<details>
<summary><strong style="font-size: 16px;">Resultados e Conclusões</strong></summary>


Os resultados serão apresentados com base em cada umas das hipóteses.

- **_Hipótese 1_:** a suposição inicial, de que músicas com bpm (batidas por minuto) mais altas tendem a ter um maior número de streams não se confirmou. No teste de correlação, observou-se um valor de p= -0.0023, indicando que há uma fraca correlação negativa entre as variáveis “_bpm_” e “_streams_”. Além disso, o teste de significância indicou que não há diferença significativa entre as categorias “_alta_” e “_baixa_” da característica “_bpm_” em relação ao número de streams. Por fim, o teste de regressão apresentou um valor de p = 0.944 para a variável independente “_bpm_”, ou seja,  a variável bpm não é estatisticamente significativa para prever os streams, indicando que ela não é uma boa “preditora”. Assim, não há evidência estatística para apoiar a ideia de que as variáveis “_bpm_” (batidas por minuto) e “_streams_” têm uma relação significativa uma com a outra. 

- **_Hipótese 2_:** os testes confirmaram a hipótese inicial de que as músicas mais populares no ranking do Spotify também possuem um comportamento semelhante nas plataformas Deezer e Apple. As correlações apresentaram valores de p= 0.599 para Spotify e Deezer, e p= 0.551 para Spotify e Apple, evidenciando uma correlação positiva. As regressões aplicadas também apresentaram valores de p < 0.05, indicando que há evidência estatisticamente significativa para que as músicas mais populares no ranking do Spotify tenham uma relação significativa com as plataformas Deezer e Apple. Em outras palavras, há uma associação estatisticamente significativa entre a popularidade das músicas no Spotify e seu desempenho nas plataformas Deezer e Apple. Desta forma, a hipótese foi validada.
  
- **_Hipótese 3_:** aqui, se testou se a presença de uma música em um maior número de playlists está correlacionada com um maior número de streams, o que se confirmou após os testes aplicados. Após as análises, confirmou-se que a presença de uma música em um maior número de playlists está, de fato, correlacionada com um aumento significativo no número de streams (p = 0.7835). O teste de regressão indicou que o R-quadrado é de 0.625, o que significa que aproximadamente 62.5% da variabilidade nos streams pode ser explicada pela presença de uma música em playlists. Isso sugere uma relação moderadamente forte entre as variáveis. Essa relação evidencia a importância das playlists como um dos principais impulsionadores de sucesso para as músicas no ambiente de streaming. Assim, essa hipótese foi validada.

- **_Hipótese 4_:**: os resultados obtidos demonstraram uma correlação positiva entre o número de músicas disponíveis de um artista no Spotify e o total de streams acumulados (p = 0.7783). A regressão linear retornou um valor de p<0.05, assim concluiu-se que há uma relação positiva e estatisticamente significativa entre o número de faixas de um artista e a quantidade de streams no Spotify. O R-quadrado calculado para esta análise foi de 0.606, indicando que aproximadamente 60.6% da variabilidade nos streams pode ser explicada pela variação no número de faixas dos artistas. Em média, um aumento no número de faixas está associado a um aumento significativo na quantidade de streams. Isso sugere que artistas com um maior número de faixas têm uma tendência a receber mais streams em suas músicas no Spotify. Essa relação destaca a importância da disponibilidade do catálogo de um artista para o sucesso na plataforma de streaming. Assim, esta hipótese foi validada. 

- **_Hipótese 5_:** a última hipótese que foi analisada era de que as características de uma música influenciam o sucesso em termos de número de streams no Spotify. No teste de  correlação, observamos que todas as características das músicas demonstraram correlação negativa muito fraca com relação a quantidade de streams,já que os valores de correlação foram todos próximos de zero. Já no teste de significância, se observou somente na variável "_speechiness_" diferença significativa entre as categorias da variável e a quantidade de streams. Com base na análise da regressão linear, observou-se que algumas características da música, como “_danceability_” e “_speechiness_” têm uma influência significativa no número de streams no Spotify. No entanto, outras características, como valence, energy, acousticness, instrumentalness e liveness, não apresentaram uma relação estatisticamente significativa com os streams. Portanto, enquanto algumas características da música parecem influenciar o sucesso em termos de número de streams, outras não demonstraram uma associação clara com essa métrica.
De forma geral, optou-se por refutar essa hipótese, pois a característica que apresentam uma influência no número de streams na percepção análitica não são estatisticamente significativas se comparado com os outros coeficientes, e de acordo com os outros testes tem-se um outro cenário que corrobora na decisão de refutar essa hipótese. 
</details>

<details>
<summary><strong style="font-size: 16px;">Próximos Passos</strong></summary>

Como indicações e insights sobre o projeto, dado que a presença de uma música em um maior número de playlists está fortemente correlacionada com um aumento significativo no número de streams, é recomendável que a gravadora invista em estratégias para incluir as músicas do novo artista em playlists relevantes nas plataformas de streaming.
Também seria interessante a gravadora incentivar o novo artista a lançar um catálogo diversificado de músicas, para aumentar sua visibilidade e sucesso na plataforma. Além disso, embora algumas características das músicas possam influenciar o sucesso em termos de número de streams, é importante reconhecer que nem todas as características demonstraram uma relação estatisticamente significativa. Portanto, ao produzir músicas para o novo artista, a gravadora pode se concentrar nas características que mostraram influência significativa, como danceability e speechiness, e considerar ajustes para melhorar esses aspectos nas faixas. A gravadora também pode observar com atenção a correlação positiva entre as músicas mais populares no ranking do Spotify e seu desempenho nas plataformas Deezer e Apple. Isso sugere que estratégias bem-sucedidas no Spotify podem ser replicadas em outras plataformas de streaming para maximizar o alcance do novo artista Seguindo estas sugestões, a gravadora pode aumentar as chances de sucesso do novo artista no mercado de streaming, aproveitando os insights gerados a partir das análises das hipóteses.
</details>

