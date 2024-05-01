#Verificando valor nulo na tabela track_in_spotify:
SELECT 
COUNT(*)
FROM `dados_spotify.track_in_spotify`
WHERE track_id IS NULL 

#Consulta para identificar valores nulos em track_technical_info:
SELECT
COUNT (*)
FROM `dados_spotify.track_technical_info`
WHERE key IS NULL

#Consulta para verificar os valores nulos ta tabela track_in_competition:
SELECT
  *
FROM
  `dados_spotify.track_in_competition`
WHERE
  in_shazam_charts IS NULL

#Consulta para substituir os valores nulos em in_shazam_charts pela mediana e manter os demais dados na planilha:
WITH median_values AS (
 SELECT
APPROX_QUANTILES(in_shazam_charts, 100)[OFFSET(50)] AS mediana_chazam_charts
  FROM
    `dados_spotify.track_in_competition`
)
SELECT
  IFNULL(in_shazam_charts, (SELECT mediana_chazam_charts FROM median_values)) AS in_shazam_charts,
  track_id,
  in_apple_playlists,
  in_apple_charts,
  in_deezer_playlists,
  in_deezer_charts,
FROM
  `dados_spotify.track_in_competition`

#Consulta mostrando o antes e depois do tratamento de valores nulos na variável "in_shazam_charts":
SELECT
  t1.in_shazam_charts AS original_in_shazam_charts,
  IFNULL(t1.in_shazam_charts, t2.median_value) AS replaced_in_shazam_charts
FROM
  `dados_spotify.track_in_competition` AS t1
CROSS JOIN (
  SELECT
    APPROX_QUANTILES(in_shazam_charts, 2)[OFFSET(1)] AS median_value
  FROM
    `dados_spotify.track_in_competition`
) AS t2

#Consulta para identificar valores duplicados na tabela track_technical_info:
SELECT 
COUNT (*) as total_ocorrencias
FROM `dados_spotify.track_technical_info` 
GROUP BY track_id
HAVING COUNT (*) > 1

#Consulta para identificar valores duplicados na tabela track_in_competition:
SELECT 
COUNT (*) as total_ocorrencias
FROM `dados_spotify.track_in_competition` 
GROUP BY track_id
HAVING COUNT (*) > 1

#Identificar e tratar dados discrepantes em track_name:
SELECT  
 track_name,
 REGEXP_REPLACE(track_name, r'[^a-zA-Z0-9 ]', '') AS track_name_corrigido
FROM `dados_spotify.track_in_spotify`

#Identificar dados discrepantes em artist_s_name:
SELECT  
 artist_s__name,
 REGEXP_REPLACE(artist_s__name, r'[^a-zA-Z0-9 ]', '') AS artist_s__name_corrigido
FROM `dados_spotify.track_in_spotify`

#Consulta para identificar dados discrepantes na tabela track_technical_info:
SELECT  
REGEXP_REPLACE(key, r'[^a-zA-Z0-9]', '') AS key_corrigido
FROM `dados_spotify.track_technical_info`

#Abaixo, a consulta mostra artist_s_name antes de corrigir e após corrigido:
SELECT
key,
REGEXP_REPLACE(key, r'[^a-zA-Z0-9]', '') AS key_corrigido
FROM `dados_spotify.track_technical_info`

#Alterar o tipo de dado: 
SELECT SAFE_CAST (streams AS INT64) AS streams_corrigido
FROM `dados_spotify.track_in_spotify`

#Consulta para tratar dados fora do escopo da análise, que foram as variáveis "key" e "mode":
SELECT 
  * 
  EXCEPT (key,mode)
FROM `dados_spotify.track_technical_info`

#Criar variavel release_date_concat:
SELECT
  track_id,
  track_name,
  artist_s__name,
  artist_count,
  CONCAT(CAST(released_year AS STRING), '-', CAST(released_month AS STRING), '-', CAST(released_day AS STRING)) AS data,
  in_spotify_playlists,
  in_spotify_charts,
  streams
FROM
 `dados_spotify.track_in_spotify`;
SELECT 
  track_name,
  artist_s__name,
  total_ocorrencias
FROM (
  SELECT 
    track_name,
    artist_s__name,
    total_ocorrencias,
    ROW_NUMBER() OVER(PARTITION BY track_name, artist_s__name ORDER BY total_ocorrencias DESC) AS row_number
  FROM (
    SELECT 
      A.track_name,
      A.artist_s__name,
      COUNT(*) AS total_ocorrencias
    FROM 
      `dados_spotify.track_in_spotify` AS A
    JOIN 
      dup_nome_musica AS B
    ON 
      A.track_name = B.track_name
    GROUP BY 
      A.track_name,
      A.artist_s__name
  ) AS C
) AS D
WHERE 
  row_number = 1
ORDER BY 
  total_ocorrencias DESC;

#Consulta para ver os valores mínimos, máximos e a média da variável numérica "in_apple_playlists' em track_in_competition (o mesmo comando foi realizado para as variáveis in_apple_charts, in_deezer_playlists, in_deezer_charts e in_shazam_charts):
SELECT
MAX(in_apple_playlists) AS maximo,
MIN(in_apple_playlists) AS minimo,
AVG(in_apple_playlists) AS media
FROM `dados_spotify.track_in_competition`
WHERE in_apple_playlists IS NOT NULL;

#Criar nova tabela e inserir a variavel soma_playlists
CREATE TABLE `projeto02-hipoteses.dados_spotify.dados_consolidados_spotify` AS (
SELECT
  *,
  in_spotify_playlists + in_apple_playlists + in_deezer_playlists AS soma_playlists
FROM
  `dados_spotify.dados_consolidados`
)

#Consulta para criar tabela dados_spotify_final e criar a variável count_music_artsolo:
CREATE TABLE `dados_spotify.dados_spotify_final` AS
WITH musicas_artsolo AS (
  SELECT
    artist_s_name,
    COUNT(*) AS count_music_artsolo
  FROM `dados_spotify.dados_consolidados_spotify`
  WHERE
    artist_count = 1 
  GROUP BY artist_s_name
)
SELECT 
  s.*,
  COALESCE(m.count_music_artsolo, 0) AS count_music_artsolo
FROM (
  SELECT DISTINCT artist_s_name
  FROM `dados_spotify.dados_consolidados_spotify`
) AS artista_solo
JOIN `dados_spotify.dados_consolidados_spotify` s
ON artista_solo.artist_s_name = s.artist_s_name
LEFT JOIN musicas_artsolo m
ON s.artist_s_name = m.artist_s_name;

# Criação de nova tabela com a informação de quartis e categorias
CREATE TABLE `projeto02-hipoteses.dados_spotify.dados_spotify_categorizados`
AS

# Consulta para criação dos quartis:
WITH quartis AS (
  SELECT
    track_id,
    bpm,
    NTILE(4) OVER (ORDER BY bpm) AS bpm_quartil,
    danceability__,
    NTILE(4) OVER (ORDER BY danceability__) AS danceability_quartil,
    valence__,
    NTILE(4) OVER (ORDER BY valence__) AS valence_quartil,
    energy__,
    NTILE(4) OVER (ORDER BY energy__) AS energy_quartil,
    acousticness__,
    NTILE(4) OVER (ORDER BY acousticness__) AS acousticness_quartil,
    instrumentalness__,
    NTILE(4) OVER (ORDER BY instrumentalness__) AS instrumentalness_quartil,
    liveness__,
    NTILE(4) OVER (ORDER BY liveness__) AS liveness_quartil,
    speechiness__,
    NTILE(4) OVER (ORDER BY speechiness__) AS speechiness_quartil
  FROM
    `dados_spotify.dados_spotify_final`
),

# Consulta para criação das categorias "alta" e "baixa":
categorias AS (
  SELECT
    track_id,
    IF(bpm_quartil = 1 OR bpm_quartil = 2, 'baixa', 'alta') AS bpm_categoria,
    IF(danceability_quartil = 1 OR danceability_quartil = 2, 'baixa', 'alta') AS danceability_categoria,
    IF(valence_quartil = 1 OR valence_quartil = 2, 'baixa', 'alta') AS valence_categoria,
    IF(energy_quartil = 1 OR energy_quartil = 2, 'baixa', 'alta') AS energy_categoria,
    IF(acousticness_quartil = 1 OR acousticness_quartil = 2, 'baixa', 'alta') AS acousticness_categoria,
    IF(instrumentalness_quartil = 1 OR instrumentalness_quartil = 2, 'baixa', 'alta') AS instrumentalness_categoria,
    IF(liveness_quartil = 1 OR liveness_quartil = 2, 'baixa', 'alta') AS liveness_categoria,
    IF(speechiness_quartil = 1 OR speechiness_quartil = 2, 'baixa', 'alta') AS speechiness_categoria
  FROM
    quartis
)

#Consulta para o cálculo de correlação de bpm com streams (HIPOTESE 1):
SELECT 
    CORR(streams, bpm) AS correlacao_bpm,
FROM 
    `dados_spotify.dados_spotify_categorizados`


#Consulta para o cálculo de correlação dos charts do Spotify com as demais plataformas (HIPOTESE 2):
    CORR(in_spotify_charts, in_shazam_charts) AS correlacao_shazam,
    CORR(in_spotify_charts, in_apple_charts) AS correlacao_apple,
    CORR(in_spotify_charts, in_deezer_charts) AS correlacao_deezer
FROM 
    `dados_spotify.dados_spotify_categorizados`

#Consulta para cálculo de correlação da soma das playlists com streams (HIPOTESE 3): 
SELECT
  CORR(soma_playlists, streams) AS correlacao_playlists_streams
FROM
  `dados_spotify.dados_spotify_categorizados`


#Consulta para o cálculo de correlação das playlists do Spotify com streams (HIPOTESE 4):
WITH artist_stream_counts AS (
  SELECT
  artist_s_name,
    COUNT(track_id) AS total_songs,
    SUM(streams) AS total_streams
  FROM
    `dados_spotify.dados_spotify_categorizados`
  GROUP BY
    artist_s_name
)
SELECT
  CORR(total_songs, total_streams) AS correlation_coefficient
FROM
  artist_stream_counts;


#Consulta para o cálculo de correlação das características das músicas (HIPOTESE 5):
SELECT 
    CORR(streams, bpm) AS correlacao_bpm,
    CORR(streams, danceability__) AS correlacao_danceability,
    CORR(streams, valence__) AS correlacao_valence,
    CORR(streams, energy__) AS correlacao_energy,
    CORR(streams, acousticness__) AS correlacao_acousticness,
    CORR(streams, instrumentalness__) AS correlacao_instrumentalness,
    CORR(streams, liveness__) AS correlacao_liveness,
    CORR(streams, speechiness__) AS correlacao_speechiness
FROM 
    `dados_spotify.dados_spotify_categorizados`
