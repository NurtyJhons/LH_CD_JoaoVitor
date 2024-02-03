# Aqui é o caminho do arquivo "teste_indicium_precificacao.csv", e será necessário 
# trocar o caminho abaixo para o caminho onde o arquivo está no seu PC.
setwd("C:/Users/joao/Downloads")

# Trazendo o arquivo "teste_indicium_precificacao.csv" para um DataFrame chamado "df":
df <- read.csv("teste_indicium_precificacao.csv",header=TRUE,encoding="UTF-8")

# Como dito no relatório, foi necessário retirar a variável "nome", e o resto 
# das variáveis retirei para que o machine learning aconteca com mais eficácia.
df$id<- NULL
df$host_id <- NULL
df$host_name <- NULL  
df$room_type <- NULL
df$bairro <- NULL
df$ultima_review <- NULL
df$nome <- NULL

# Mudando o nome das variáveis (Também explicado o porquê no relatório): Na coluna 
# "bairro_group",ao invés dos bairros "Bronx" estarem com esse nome "Bronx", serão 
# chamados de "1". Para acertar isso, faremos assim:
df$bairro_group[df$bairro_group=="Bronx"] <- 1
df$bairro_group[df$bairro_group=="Brooklyn"] <- 2
df$bairro_group[df$bairro_group=="Manhattan"] <- 3
df$bairro_group[df$bairro_group=="Queens"] <- 4
df$bairro_group[df$bairro_group=="Staten Island"] <- 5

# Transformando para numérico:
df$bairro_group <- as.numeric(df$bairro_group)

# Transformando as variáveis abaixo em numérico pois foi necessário para fazer a correlação
# funcionar! O pacote mlbench não aceita sem as variáveis estarem assim.
df$price <- as.numeric(df$price)
df$minimo_noites <- as.numeric(df$minimo_noites)
df$numero_de_reviews <- as.numeric(df$numero_de_reviews)
df$calculado_host_listings_count <- as.numeric(df$calculado_host_listings_count)
df$disponibilidade_365 <- as.numeric(df$disponibilidade_365)

# Importando a biblioteca para correlação de dados:
install.packages("mlbench")
library(mlbench)

# Aplicando a correlaçao do DataFrame "df":
View(cor(df))