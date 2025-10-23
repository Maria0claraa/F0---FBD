# BD: Trabalho Prático APF-T

**Grupo**: P3G9
- Inês Batista, MEC: 124877
- Maria Quinteiro, MEC: 124996

## Introdução / Introduction
 
O projeto consiste na criação de uma base de dados relacional destinada à gestão de um campeonato de corridas automóveis, inspirado na Fórmula 1. O sistema tem como objetivo estruturar e armazenar informações sobre temporadas, circuitos, corridas (Grande Prémio), sessões, pilotos, equipas e os seus membros, bem como contratos e resultados obtidos.

## ​Análise de Requisitos / Requirements

O Visitante deverá poder:
* Visualizar a classificação atual de um determinado piloto na temporada atual;
* Visualizar a classificação atual de uma determinada equipa na temporada atual;
* Visualizar tabelas de classificação de temporadas passadas de pilotos ou equipas;
* Ver a lista completa de corridas passadas da temporada;
* Ver os resultados detalhados de cada sessão;
* Ver a grelha de partida e a classificação final de um piloto numa determinada corrida/sessão;
* Ver o estado de cada sessão (ex: cancelada, adiada, etc...);
* Ver os detalhes de pitstops de um piloto numa sessão;
* Ver as Penalizações aplicadas a pilotos durante uma sessão;
* Consultar a página de um Piloto/Equipa com a informação correspondente;
* Ver a informação de um Circuito;

O Administrador de Membros da Equipa deverá poder:
* Adicionar, editar/atualizar ou remover temporadas, circuitos, pilotos, equipas;
* Adicionar novos Membros da Equipa;
* Gerir os Contratos do pessoal, associando um Membro da Equipa a uma Equipa com um salário e duração;
* Criar as Corridas/Sessões para uma temporada, associando-as a um Circuito;
* Registar dados Pós-Corrida/Sessão;
* Registar Penalizações dadas a um piloto durante uma sessão;
* Atualizar Classificações;

## DER - Diagrama Entidade Relacionamento/Entity Relationship Diagram

### Versão final/Final version

![DER Diagram!](der.pdf "AnImage")

### Melhorias/Improvements 

O principal conjunto de alterações entre o DER inicial e a versão final reside na nomenclatura dos atributos de classificação. A entidade STAFF foi renomeada para a mais específica Membros da Equipa, de forma a permitir que a entidade Piloto herde os seus atributos, sendo que integram a mesma. Além disso, a entidade Corridas foi renomeada para Grande Prémio. Estruturalmente, o modelo foi normalizado pela remoção dos atributos de classificação da temporada (Pontos Temporada e Posição Temporada) que existiam diretamente nas entidades Piloto e Equipa, garantindo que esta informação seja gerida de forma centralizada na entidade Temporada. Finalmente, o atributo Ano Temporada, presente em Corridas no diagrama inicial, foi removido de Grande Prémio, corrigindo a modelação da relação de muitos para muitos entre Corridas e Temporada.

## ER - Esquema Relacional/Relational Schema

### Versão final/Final Version

![ER Diagram!](er.pdf "AnImage")

### Melhorias/Improvements

A alteração mais crítica reside na modelação das Chaves Primárias das entidades fracas. No modelo final, entidades como Sessões, Resultados, Penalizações, Pitstops e Contrato tiveram a sua PK corrigida para ser composta pelo seu discriminador e a PK completa da entidade forte de que dependem, garantindo que as respetivas Chaves Estrangeiras se tornassem parte da sua PK. Adicionalmente, foi corrigida a modelação do relacionamento de muitos para muitos entre Grande Prémio e Temporada pela remoção da FK ambígua da tabela Grande Prémio, e a PK ID Staff foi renomeada para ID Membro.

## ​SQL DDL - Data Definition Language

[SQL DDL File](sql/01_ddl.sql "SQLFileQuestion")
