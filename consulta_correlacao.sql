#Consulta para o cálculo de correlação de bpm com streams (HIPOTESE 1):
SELECT 
    CORR(streams, bpm) AS correlacao_bpm,
FROM 
    `dados_spotify.dados_spotify_final`


#Consulta para o cálculo de correlação dos charts do Spotify com as demais plataformas (HIPOTESE 2):
    CORR(in_spotify_charts, in_shazam_charts) AS correlacao_shazam,
    CORR(in_spotify_charts, in_apple_charts) AS correlacao_apple,
    CORR(in_spotify_charts, in_deezer_charts) AS correlacao_deezer
FROM 
    `dados_spotify.dados_spotify_final`

#Consulta para cálculo de correlação da soma das playlists com streams (HIPOTESE 3): 
SELECT
  CORR(soma_playlists, streams) AS correlacao_playlists_streams
FROM
  `dados_spotify.dados_spotify_final`


#Consulta para o cálculo de correlação das playlists do Spotify com streams (HIPOTESE 4):
WITH artist_stream_counts AS (
  SELECT
  artist_s_name,
    COUNT(track_id) AS total_songs,
    SUM(streams) AS total_streams
  FROM
    `dados_spotify.dados_spotify_final`
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
    `dados_spotify.dados_spotify_final`


