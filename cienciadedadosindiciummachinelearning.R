# Aqui é o caminho do arquivo "teste_indicium_precificacao.csv", e será necessário 
# trocar o caminho abaixo para o caminho onde o arquivo está no seu PC.
setwd("C:/Users/joao/Downloads")

# Trazendo o arquivo "teste_indicium_precificacao.csv" para um DataFrame chamado "df"
df <- read.csv("teste_indicium_precificacao.csv",header=TRUE,encoding="UTF-8")

# Como dito no relatório, foi necessário retirar a variável "nome", e o resto 
# das variáveis retirei para que o machine learning aconteca com mais eficácia.
df$id<- NULL  
df$host_id <- NULL
df$host_name <- NULL
df$calculado_host_listings_count <- NULL
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

# Dizendo que quero 70% das linhas do DataFrame para treino
linhas <- sample(1:length(df$price),length(df$price)*0.7)
treino = df[linhas,]  

# Dizendo que quero 30% das linhas do DataFrame para treino (o sinal de "-" pois estou
# pegando o resto que não foi selecionado de linhas)
teste = df[-linhas,]

# Importando rpart e criando um modelo:
library(rpart)  
modelo <- rpart(price ~ .,
                data=treino,
                control=rpart.control(cp=0))

# Sobescrevendo tudo que fizemos e modificamos do arquivo "teste_indicium_precificacao.csv" 
# para um novo arquivo chamado "Treino_indicum.csv":
write.table(treino, file="Treino_indicium.csv", row.names = FALSE, sep=",", fileEncoding="UTF-8")

# Pegando esse arquivo recém criado e o fazendo como um DataFrame chamado "teste"
teste <- read.csv("Treino_indicium.csv")

# Fazendo a previsão do modelo:
teste$Previsão <- predict(modelo,teste)
View(teste)

# Analisando a taxa de erro das previsões em uma nova variável que iremos criar para o DataFrame:
teste$taxa_de_erro = round(teste$Previsão/teste$price,2)
View(teste)
# Acima podemos ver que se passou de 1.0 é o quanto erramos para mais alto valor. Exemplo:
# se ficou 1.07, então o valor previsto tá 7% ACIMA do PREÇO.
# E se tá abaixo de 1.0 é o quanto erramos para mais baixo valor. Exemplo:
# se ficou 0.90, então o valor previsto tá 10% ABAIXO do PREÇO.

# Podemos ver isso facilmente fazendo assim:
teste$taxa_de_erro <- teste$taxa_de_erro - 1
View(teste)

# Historiagrama com a variável de preço:
hist(df$price, breaks=6,labels=T)

# Historiagrama com a variável de bairros:
hist(df$bairro_group, breaks=6,labels=T)