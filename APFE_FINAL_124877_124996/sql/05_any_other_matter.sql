
-- 1. CLASSIFICAÇÃO ATUAL DE PILOTOS (Visitante: Visualizar classificação atual/passada)
-- Retorna a classificação de todos os pilotos para a temporada especificada
CREATE VIEW View_ClassificacaoPilotos AS
SELECT
    T.Ano AS Temporada,
    RANK() OVER (PARTITION BY T.Ano ORDER BY SUM(R.Pontos) DESC) AS Posicao,
    P.Abreviação AS Piloto,
    M.Nome AS NomePiloto,
    E.Nome AS Equipa,
    SUM(R.Pontos) AS Pontos
FROM
    Temporada T
INNER JOIN
    Grande_Prémio GP ON T.Ano = GP.Ano_Temporada
INNER JOIN
    Sessões S ON GP.NomeGP = S.NomeGP
INNER JOIN
    Resultados R ON S.NomeSessão = R.NomeSessão
INNER JOIN
    Piloto P ON R.ID_Piloto = P.ID_Piloto
INNER JOIN
    Membros_da_Equipa M ON P.ID_Membro = M.ID_Membro
INNER JOIN
    Equipa E ON P.ID_Equipa = E.ID_Equipa
GROUP BY
    T.Ano, P.Abreviação, M.Nome, E.Nome;
GO

-- 2. RESULTADOS DETALHADOS POR SESSÃO (Visitante: Ver os resultados detalhados)
CREATE VIEW View_DetalhesSessao AS
SELECT
    GP.NomeGP,
    S.NomeSessão,
    S.Estado, -- Requisito: Ver o estado de cada sessão
    R.PosiçãoFinal,
    R.PosiçãoGrid, -- Requisito: Ver a grelha de partida e classificação final
    P.Abreviação AS Piloto,
    E.Nome AS Equipa,
    R.TempoFinal,
    R.Status,
    R.Pontos
FROM
    Sessões S
INNER JOIN
    Grande_Prémio GP ON S.NomeGP = GP.NomeGP
INNER JOIN
    Resultados R ON S.NomeSessão = R.NomeSessão
INNER JOIN
    Piloto P ON R.ID_Piloto = P.ID_Piloto
INNER JOIN
    Equipa E ON P.ID_Equipa = E.ID_Equipa;
GO

-- 3. LISTA COMPLETA DE CORRIDAS PASSADAS (Visitante: Ver a lista completa de corridas passadas)
CREATE VIEW View_ListaCorridasPassadas AS
SELECT
    T.Ano AS Temporada,
    GP.NomeGP AS Corrida,
    GP.DataCorrida,
    C.Nome AS Circuito,
    S.Estado
FROM
    Grande_Prémio GP
INNER JOIN
    Temporada T ON GP.Ano_Temporada = T.Ano
INNER JOIN
    Circuito C ON GP.ID_Circuito = C.ID_Circuito
INNER JOIN
    Sessões S ON GP.NomeGP = S.NomeGP
WHERE 
    S.NomeSessão LIKE 'Corrida%' AND S.Estado = 'Concluída';
GO

-- 4. DETALHES DE ENTIDADES (Visitante: Consultar página de Piloto/Equipa/Circuito)
-- Funções de consulta de detalhes de entidades (usadas nas páginas de detalhe)
CREATE PROCEDURE dbo.ConsultarDetalhesPiloto
    @Abreviação CHAR(3)
AS
BEGIN
    SELECT
        P.Abreviação, P.NumeroPermanente, E.Nome AS EquipaAtual, M.Nome AS NomeCompleto, M.Nacionalidade
    FROM Piloto P
    INNER JOIN Membros_da_Equipa M ON P.ID_Membro = M.ID_Membro
    INNER JOIN Equipa E ON P.ID_Equipa = E.ID_Equipa
    WHERE P.Abreviação = @Abreviação;
END
GO

CREATE PROCEDURE dbo.ConsultarDetalhesCircuito
    @ID_Circuito INT
AS
BEGIN
    SELECT 
        Nome, Cidade, Pais, Comprimento_km, NumCurvas
    FROM Circuito 
    WHERE ID_Circuito = @ID_Circuito;
END
GO