# Funções úteis
# Usadas no Projeto Feedback2
# By Luiz Cláudio
# 03/08/2022


# Função para Plotar Boxplots e Histogramas de todas as variáveis numéricas dado um dataframe
getGraphs <- function(x){
  df <- as.data.frame(x)
  numeric.var <- sapply(df, is.numeric) # Selecionar apenas variáveis numéricas
  
  # Plotando histograma e boxplot de todas as variáveis numéricas do dataset
  graphs <- lapply(names(df[,numeric.var]), function(x) {hist(df[,x], 100,
                                                              col="lightblue",
                                                              main=paste0("Histograma de ", x),
                                                              xlab=x);boxplot(df[,x], 
                                                                              main=paste0("Boxplot de ",x), 
                                                                              horizontal = TRUE)})

}


# Função para plotar o ranking das variáveis mais importantes 
getImpVar <- function(x, target){
  library(randomForest)
  modelo <- randomForest(target ~ . , 
                         data = x, 
                         ntree = 100, 
                         nodesize = 10,
                         importance = TRUE) # importance = TRUE nos informa as variáveis mais importantes ...
  
  # Plotando as variáveis por grau de importância
  varImpPlot(modelo)
}


# Funcao para gerar dados de treino e dados de teste
splitData <- function(dataframe, dec, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  index <- 1:nrow(dataframe)
  trainindex <- sample(index,  dec * nrow(dataframe))  
  trainset <- dataframe[trainindex, ]
  testset <- dataframe[-trainindex, ]
  list(trainset = trainset, testset = testset)
}


# Acurácia
# Acurácia (Exatidão): Taxa de acerto do Modelo
# Diz quanto o meu modelo acertou das previsões possíveis
# accuracy = (TP + TN) / (TP + FN + FP + TN ) = Predições corretas / todas as predições
getAccuracy <- function(x){
  (x[1,1] + x[2,2]) / (x[1,1] + x[1,2] + x[2,1] + x[2,2])
}
# Acurácia ajustada (DSA)
getW_Accuracy  <- function(x){
  (x[1,1] + x[2,2]) / (x[1,1] + 5 * x[1,2] + x[2,1] + x[2,2])
}

# Recall
# Recall responde a seguinte pergunta: Qual proporção de positivos foi identificados corretamente?
# Em outras palavras, quão bom meu modelo é para prever positivos, sendo positivo entendido como a 
# classe que se quer prever, no nosso contexto, se o crédito ruim.
# recall = TP / (TP + FN)
getRecall <- function(x){  
  x[1,1] / (x[1,1] + x[1,2])
}

# Precision
# Pode-se definir precisão com a seguinte pergunta:
# Qual a proporção de identificações positivas foi realmente correta? 
# Em outras palavras, o qual bem meu modelo trabalhou.
# precision = TP / (TP + FP)
getPrecision <- function(x){
  x[1,1] / (x[1,1] + x[2,1])
}

# f-score
# Já o f-score nos mostra o balanço entre a precisão e o recall de nosso modelo. 
# f-score = (2 * precision * recall) / (precision + recall)
# f-score = 2 * TP / (2 * TP + FN + FP)
getF1 <- function(x){
  2 * x[1,1] / (2 * x[1,1] + x[1,2] + x[2,1])
}



