CREATE TRIGGER trg_AtualizarClassificacaoGeral
ON Resultados
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Assume-se que apenas uma temporada (a atual) é afetada por vez
    DECLARE @AnoTemporada INT;

    -- Tenta obter o ano da temporada afetada pelos resultados inseridos/apagados
    IF EXISTS(SELECT 1 FROM inserted)
        SELECT TOP 1 @AnoTemporada = GP.Ano_Temporada
        FROM inserted i
        INNER JOIN Sessões S ON i.NomeSessão = S.NomeSessão
        INNER JOIN Grande_Prémio GP ON S.NomeGP = GP.NomeGP;
    ELSE IF EXISTS(SELECT 1 FROM deleted)
        SELECT TOP 1 @AnoTemporada = GP.Ano_Temporada
        FROM deleted d
        INNER JOIN Sessões S ON d.NomeSessão = S.NomeSessão
        INNER JOIN Grande_Prémio GP ON S.NomeGP = GP.NomeGP;

    IF @AnoTemporada IS NULL RETURN;

    -- Recálculo da Classificação de Pilotos
    WITH ClassPilotos AS (
        SELECT
            P.ID_Piloto,
            SUM(R.Pontos) AS TotalPontos
        FROM Piloto P
        INNER JOIN Resultados R ON P.ID_Piloto = R.ID_Piloto
        INNER JOIN Sessões S ON R.NomeSessão = S.NomeSessão
        INNER JOIN Grande_Prémio GP ON S.NomeGP = GP.NomeGP
        WHERE GP.Ano_Temporada = @AnoTemporada
        GROUP BY P.ID_Piloto
    ),
    RankPilotos AS (
        SELECT
            TotalPontos,
            RANK() OVER (ORDER BY TotalPontos DESC) AS Posição
        FROM ClassPilotos
    )
    -- Atualiza a tabela Temporada com a Posição e Pontos do Piloto Líder (ou o ponto máximo)
    UPDATE T
    SET 
        T.PontosPiloto = (SELECT MAX(TotalPontos) FROM ClassPilotos),
        T.PosiçãoPiloto = (SELECT MIN(Posição) FROM RankPilotos) -- Posição 1
    FROM Temporada T
    WHERE T.Ano = @AnoTemporada;

    -- Recálculo da Classificação de Equipas
    -- Lógica similar seria implementada aqui para atualizar T.PontosEquipa e T.PosiçãoEquipa
END
GO