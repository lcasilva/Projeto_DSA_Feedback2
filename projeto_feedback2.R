## Projeto Feedback 2
# Machine Learning na Segurança do Trabalho - Prevendo a Eficiência de Extintores de Incêndio


## Breve descrição do problema de negócio
# Obs.: A Descrição completa do Problema de Negócio pode ser vista no arquivo "Descrição do Problema de Negócio.txt"

# O teste hidrostático extintor é um procedimento da norma ABNT NBR 12962/2016 que
# determina que todos os extintores de incêndio devem ser testados em baixa e alta
# pressão a cada 5 anos para identificar vazamentos e a resistência dos materiais 
# de extintores. 

# Com a intenção de adicionar mais uma camada de segurança às operações das empresas,
# poderíamos usar Machine Learning para prever a eficiência dos extintores de incêndio?
# Esse é o objetivo do Projeto com Feedback 2.

# Usaremos os dados reais disponíveis publicamente do link https://www.muratkoklu.com/datasets/vtdhnd07.php
# O conjunto de dados consiste do resultado de testes de extinção de quatro chamas de
# combustíveis diferentes (gasolina, querosene, thinner e GLP) usando um sistema de 
# extinção de incêndio baseado em ondas sonoras. Um computador foi usado como fonte 
# de frequência, um anemômetro como medidor do fluxo de ar resultante das ondas sonoras 
# durante a fase de extinção das chamas e um decibelímetro para medir a intensidade do 
# som. Um total de 17.442 testes foram realizados com esta configuração experimental.

# O conjunto de dados inclui as característica de tamanho do recipiente de combustível,
# tipo de combustível, frequência, decibéis, distância, fluxo de ar e extinção da chama 
# (status com informação de extinção de chama (1) e não extinção de chama (0). Esta última
# é a variável alvo onde pode ser prevista a partir dos 6 recursos de entrada.

# Créditos:
# Yavuz Selim TASPINAR, Murat KOKLU and Mustafa ALTIN
# CV:https://www.muratkoklu.com/en/publications/

# Objetivo:
# Construir um modelo de Machine Learning capaz de prever, com base em novos dados, a
# eficiência de extintores de incêndio.


## Etapas do Processo de Construção de ML: 
# 1. Definição do Problema de Negócio (Descrição acima);
# 2. Coleta dos dados;
# 3. Análise Exploratória dos dados;
# 4. Pré-Processamento dos dados (Limpeza, Organização dos dados e Seleção de Variáveis);
# 5. Preperação dos dados de treino e dados de teste;
# 6. Construção, treinamento, avaliação e otimização do Modelo de ML.


# Configurando o diretório de trabalho
#setwd("C:/Users/User/Cursos/DSA/FCD/1-BigDataRAzure/Cap20-Projetos_com_Feedback/Projeto_Feedback2")
#getwd()

# Carregando Funções úteis
source("Tools.R")

# 2. Coleta dos dados
library(readxl)
dados <- read_excel("Acoustic_Extinguisher_Fire_Dataset.xlsx")
dim(dados)
View(dados)
str(dados)
summary(dados)


# 3. Análise Exploratória dos dados

# Renomeando as variáveis
var <- colnames(dados)
var
var[1] <- "TamCombustivel"
var[2] <- "TipoCombustivel"
var[3] <- "Distancia"
var[4] <- "Decibeis"
var[5] <- "FluxoAr"
var[6] <- "Frequencia"
var[7] <- "Status"
var
colnames(dados) <- var
str(dados)
remove(var)

# Mudando algumas variável para tipo Fator
dados$TamCombustivel <- as.factor(dados$TamCombustivel)
dados$TipoCombustivel <- as.factor(dados$TipoCombustivel)
dados$Status <- as.factor(dados$Status)
str(dados)
summary(dados)

# Verificando se os dados possuem valores missing (valores ausentes)
any(is.na(dados)) # Sem valores missing

# Verificando se a classe Status está balanceada 
table(dados$Status)
prop.table(table(dados$Status))
barplot(prop.table(table(dados$Status)))
# Resultado: A classe status está balanceada

# Plotando Boxplots e Histogramas de todas as variáveis numéricas
#df <- as.data.frame(dados)
#numeric.var <- sapply(df, is.numeric) # Selecionar apenas variáveis numéricas
# Plotando histograma e boxplot de todas as variáveis numéricas do dataset
#graphs <- lapply(names(df[,numeric.var]), function(x) {hist(df[,x], 100,
#                                                            col="lightblue",
#                                                            main=paste0("Histograma de ", x),
#                                                            xlab=x);boxplot(df[,x], 
#                                                                            main=paste0("Boxplot de ",x), 
#                                                                            horizontal = TRUE)})
#remove(df)
#remove(numeric.var)
#remove(graphs)
getGraphs(dados) # Função do arquivo Tools.R


# 4. Pré-Processamento dos dados (Limpeza, Organização dos dados e Seleção de Variáveis)

## Seleção de Variáveis mais relevantes (Feature Selection)

# Que variáveis (features) presentes em nosso conjunto de dados, devem ser usadas na criação do modelo?
# Avalidando a importância de todas as variaveis usando modelo randomForest
#library(randomForest)
#modelo <- randomForest(Status ~ . , 
#                       data = dados, 
#                       ntree = 100, 
#                       nodesize = 10,
#                       importance = TRUE) # importance = TRUE nos informa as variáveis mais importantes ...

# Plotando as variáveis por grau de importância
#varImpPlot(modelo)
#remove(modelo)
getImpVar(dados, dados$Status) # Função do arquivo Tools.R


# 5. Preparação dos dados de treino e dados de teste
#linhas <- sample(1:nrow(dados), 0.7 * nrow(dados))
#dados_treino <- dados[linhas,]
#dados_teste <- dados[-linhas,]
#View(dados_treino)
#View(dados_teste)
# Os dados de treino e teste também estão com a classe balanceada
#prop.table(table(dados_treino$Status))
#prop.table(table(dados_teste$Status))
#remove(linhas)

# Gerando dados de treino e de teste
splits <- splitData(dataframe = dados, dec = 0.7) # Função do arquivo Tools.R

# Separando os dados
dados_treino <- splits$trainset
dados_teste <- splits$testset
prop.table(table(dados_treino$Status))
prop.table(table(dados_teste$Status))


# 6. Construção, treinamento, avaliação e otimização do Modelo de ML
# Vamos criar 3 modelos diferentes e avaliar qual é o melhor ...

# Modelo 1: Support Vector Machine (SVM)
# Ajustamos o kernel para 'radial', já que esse conjunto de dados não tem um plano
# linear que possa ser desenhado
library(e1071)
modelo1 <- svm(Status ~ .,
                     data = dados_treino,  # dados de treino inclui variável alvo
                     type = 'C-classification',
                     kernel = 'radial')

# Previsões nos dados de teste
previsao1 <- predict(modelo1, dados_teste[,1:6])

# Percentual de previsões corretas com o dataset de teste
mean(previsao1 == dados_teste$Status) # [1] 0.9442003

# Confusion Matrix
cm <- table(dados_teste$Status, previsao1)
cm

# Obtendo as Medidas de Performance do modelo Support Vector Machine (SVM)
getAccuracy(cm)
getRecall(cm)
getPrecision(cm)
getF1(cm)


# Modelo 2: Random Forest
library(rpart)
modelo2 <- rpart(Status ~., 
                      data = dados_treino,
                      control = rpart.control(cp = .0005)) # nível das folhas em um random forest

# Previsões nos dados de teste
previsao2 <- predict(modelo2, dados_teste[,1:6], type='class')

# Percentual de previsões corretas com dataset de teste
mean(previsao2 == dados_teste$Status) # [1] 0.9455379

# Confusio matrix
cm <- table(dados_teste$Status, previsao2)
cm

# Obtendo as Medidas de Performance do modelo Random Forest
getAccuracy(cm)
getRecall(cm)
getPrecision(cm)
getF1(cm)


# Modelo 3: Árvore de Decisão
library(C50)
modelo3 <- C5.0(Status ~ ., data = dados_treino)

# Agora fazemos previsões com o modelo usando dados de teste
previsao3 <- predict(modelo3, dados_teste[,1:6])

# Percentual de previsões corretas com dataset de teste
mean(previsao3 == dados_teste$Status) # [1] 0.9549016

# Confusio matrix
cm <-  table(dados_teste$Status, previsao3)
cm

# Obtendo as Medidas de Performance do modelo Árvore de Decisão
getAccuracy(cm)
getRecall(cm)
getPrecision(cm)
getF1(cm)

# RESULTADO
# O modelo de Árvore de Decisão apresentou as melhores medidas de performance
# se comparado com os outros modelos supracitados.



