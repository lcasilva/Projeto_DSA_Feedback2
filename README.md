# Projeto_Feedback2
Projeto Feedback 2: Machine Learning na Segurança do Trabalho - Prevendo a Eficiência de Extintores de Incêndio

Trata-se de um projeto da Formação Cientista de Dados da Data Science Academy (Curso Big Data Analytics com R e Microsoft Azure MAchine Learning).

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

