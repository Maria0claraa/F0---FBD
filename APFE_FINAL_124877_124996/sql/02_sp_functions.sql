-- ======================================================
-- SEÇÃO 1: LIMPEZA (DROP PROCEDURES) PARA RE-EXECUÇÃO SEGURA
-- ======================================================
IF OBJECT_ID('dbo.GerirCircuito', 'P') IS NOT NULL DROP PROCEDURE dbo.GerirCircuito;
IF OBJECT_ID('dbo.GerirEquipa', 'P') IS NOT NULL DROP PROCEDURE dbo.GerirEquipa;
IF OBJECT_ID('dbo.GerirTemporada', 'P') IS NOT NULL DROP PROCEDURE dbo.GerirTemporada;
IF OBJECT_ID('dbo.GerirGrandePremio', 'P') IS NOT NULL DROP PROCEDURE dbo.GerirGrandePremio;
IF OBJECT_ID('dbo.GerirSessao', 'P') IS NOT NULL DROP PROCEDURE dbo.GerirSessao;

IF OBJECT_ID('dbo.AdicionarPilotoCompleto', 'P') IS NOT NULL DROP PROCEDURE dbo.AdicionarPilotoCompleto;
IF OBJECT_ID('dbo.GerirContrato', 'P') IS NOT NULL DROP PROCEDURE dbo.GerirContrato;
IF OBJECT_ID('dbo.AdicionarNovoMembro', 'P') IS NOT NULL DROP PROCEDURE dbo.AdicionarNovoMembro;

IF OBJECT_ID('dbo.RegistarResultado', 'P') IS NOT NULL DROP PROCEDURE dbo.RegistarResultado;
IF OBJECT_ID('dbo.RegistarPenalizacao', 'P') IS NOT NULL DROP PROCEDURE dbo.RegistarPenalizacao;
IF OBJECT_ID('dbo.RegistarPitstop', 'P') IS NOT NULL DROP PROCEDURE dbo.RegistarPitstop;

IF OBJECT_ID('dbo.ObterMembrosPorEquipa', 'P') IS NOT NULL DROP PROCEDURE dbo.ObterMembrosPorEquipa;
IF OBJECT_ID('dbo.ObterContratosMembro', 'P') IS NOT NULL DROP PROCEDURE dbo.ObterContratosMembro;
IF OBJECT_ID('dbo.ConsultarSessaoDetalhada', 'P') IS NOT NULL DROP PROCEDURE dbo.ConsultarSessaoDetalhada;
IF OBJECT_ID('dbo.ConsultarGrandePremioComSessoes', 'P') IS NOT NULL DROP PROCEDURE dbo.ConsultarGrandePremioComSessoes;
IF OBJECT_ID('dbo.ConsultarTemporadaComGrandesPremios', 'P') IS NOT NULL DROP PROCEDURE dbo.ConsultarTemporadaComGrandesPremios;
IF OBJECT_ID('dbo.VisualizacaoHierarquicaTemporada', 'P') IS NOT NULL DROP PROCEDURE dbo.VisualizacaoHierarquicaTemporada;
IF OBJECT_ID('dbo.DashboardSessao', 'P') IS NOT NULL DROP PROCEDURE dbo.DashboardSessao;
IF OBJECT_ID('dbo.RemoverPiloto', 'P') IS NOT NULL DROP PROCEDURE dbo.RemoverPiloto;
IF OBJECT_ID('dbo.RemoverMembroEquipa', 'P') IS NOT NULL DROP PROCEDURE dbo.RemoverMembroEquipa;
IF OBJECT_ID('dbo.RemoverEquipa', 'P') IS NOT NULL DROP PROCEDURE dbo.RemoverEquipa;
IF OBJECT_ID('dbo.RemoverTemporada', 'P') IS NOT NULL DROP PROCEDURE dbo.RemoverTemporada;
GO

-- ======================================================
-- SEÇÃO 2: PROCEDIMENTOS CRUD (ADMINISTRADOR)
-- ======================================================

-- 1. GERIR CIRCUITOS 
CREATE PROCEDURE dbo.GerirCircuito
    @ID_Circuito INT = NULL,
    @Ação CHAR(1), -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    @Nome NVARCHAR(100) = NULL,
    @Cidade NVARCHAR(100) = NULL,
    @Pais NVARCHAR(100) = NULL,
    @Comprimento_km DECIMAL(10, 3) = NULL,
    @NumCurvas INT = NULL
AS
BEGIN
    IF @Ação = 'I'
        INSERT INTO Circuito (Nome, Cidade, Pais, Comprimento_km, NumCurvas)
        VALUES (@Nome, @Cidade, @Pais, @Comprimento_km, @NumCurvas);
    ELSE IF @Ação = 'U' AND @ID_Circuito IS NOT NULL
        UPDATE Circuito SET Nome = ISNULL(@Nome, Nome), Cidade = ISNULL(@Cidade, Cidade), Pais = ISNULL(@Pais, Pais), Comprimento_km = ISNULL(@Comprimento_km, Comprimento_km), NumCurvas = ISNULL(@NumCurvas, NumCurvas) WHERE ID_Circuito = @ID_Circuito;
    ELSE IF @Ação = 'D' AND @ID_Circuito IS NOT NULL
        DELETE FROM Circuito WHERE ID_Circuito = @ID_Circuito;
    ELSE
        RAISERROR('Ação inválida ou ID_Circuito ausente para Update/Delete.', 16, 1);
END
GO

-- 2. GERIR EQUIPA 
CREATE PROCEDURE dbo.GerirEquipa
    @ID_Equipa INT = NULL,
    @Ação CHAR(1), -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    @Nome NVARCHAR(100) = NULL,
    @Nacionalidade NVARCHAR(100) = NULL,
    @Base NVARCHAR(100) = NULL,
    @ChefeEquipa NVARCHAR(100) = NULL,
    @AnoEstreia INT = NULL,
    @ModeloChassis NVARCHAR(100) = NULL,
    @Power_Unit NVARCHAR(100) = NULL,
    @PilotosReserva INT = NULL
AS
BEGIN
    IF @Ação = 'I'
        INSERT INTO Equipa (Nome, Nacionalidade, Base, ChefeEquipa, AnoEstreia, ModeloChassis, Power_Unit, PilotosReserva)
        VALUES (@Nome, @Nacionalidade, @Base, @ChefeEquipa, @AnoEstreia, @ModeloChassis, @Power_Unit, @PilotosReserva);
    ELSE IF @Ação = 'U' AND @ID_Equipa IS NOT NULL
        UPDATE Equipa SET Nome = ISNULL(@Nome, Nome), Nacionalidade = ISNULL(@Nacionalidade, Nacionalidade), Base = ISNULL(@Base, Base), ChefeEquipa = ISNULL(@ChefeEquipa, ChefeEquipa), AnoEstreia = ISNULL(@AnoEstreia, AnoEstreia), ModeloChassis = ISNULL(@ModeloChassis, ModeloChassis), Power_Unit = ISNULL(@Power_Unit, Power_Unit), PilotosReserva = ISNULL(@PilotosReserva, PilotosReserva) WHERE ID_Equipa = @ID_Equipa;
    ELSE IF @Ação = 'D' AND @ID_Equipa IS NOT NULL
        DELETE FROM Equipa WHERE ID_Equipa = @ID_Equipa;
    ELSE
        RAISERROR('Ação inválida ou ID_Equipa ausente para Update/Delete.', 16, 1);
END
GO

-- 3. GERIR TEMPORADA (CRUD)
CREATE PROCEDURE dbo.GerirTemporada
    @Ano INT = NULL,
    @Ação CHAR(1), -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    @NumCorridas INT = NULL
AS
BEGIN
    -- 'PontosPiloto', 'PontosEquipa', 'PosiçãoPiloto', 'PosiçãoEquipa' são inicializados como NULL/0 ou calculados.
    IF @Ação = 'I'
        INSERT INTO Temporada (Ano, NumCorridas, PontosPiloto, PontosEquipa, PosiçãoPiloto, PosiçãoEquipa)
        VALUES (@Ano, ISNULL(@NumCorridas, 0), NULL, NULL, NULL, NULL);
    ELSE IF @Ação = 'U' AND @Ano IS NOT NULL
        UPDATE Temporada SET NumCorridas = ISNULL(@NumCorridas, NumCorridas) WHERE Ano = @Ano;
    ELSE IF @Ação = 'D' AND @Ano IS NOT NULL
        DELETE FROM Temporada WHERE Ano = @Ano;
    ELSE
        RAISERROR('Ação inválida ou Ano ausente para Update/Delete.', 16, 1);
END
GO

-- 4. GERIR GRANDE PRÉMIO (CRUD)
CREATE PROCEDURE dbo.GerirGrandePremio
    @NomeGP NVARCHAR(100),
    @Ação CHAR(1), -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    @DataCorrida DATE = NULL,
    @NumeroVoltas INT = NULL,
    @ID_Circuito INT = NULL,
    @Ano_Temporada INT = NULL
AS
BEGIN
    IF @Ação = 'I'
        INSERT INTO Grande_Prémio (NomeGP, DataCorrida, NumeroVoltas, ID_Circuito, Ano_Temporada)
        VALUES (@NomeGP, @DataCorrida, @NumeroVoltas, @ID_Circuito, @Ano_Temporada);
    ELSE IF @Ação = 'U'
        UPDATE Grande_Prémio SET DataCorrida = ISNULL(@DataCorrida, DataCorrida), NumeroVoltas = ISNULL(@NumeroVoltas, NumeroVoltas), ID_Circuito = ISNULL(@ID_Circuito, ID_Circuito), Ano_Temporada = ISNULL(@Ano_Temporada, Ano_Temporada) WHERE NomeGP = @NomeGP;
    ELSE IF @Ação = 'D'
        DELETE FROM Grande_Prémio WHERE NomeGP = @NomeGP;
    ELSE
        RAISERROR('Ação inválida.', 16, 1);
END
GO

-- 5. GERIR SESSÕES (CRUD)
CREATE PROCEDURE dbo.GerirSessao
    @NomeSessão NVARCHAR(100),
    @Ação CHAR(1), -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    @Estado NVARCHAR(50) = NULL,
    @CondiçõesPista NVARCHAR(50) = NULL,
    @NomeGP_FK NVARCHAR(100) = NULL
AS
BEGIN
    IF @Ação = 'I'
        INSERT INTO Sessões (NomeSessão, Estado, CondiçõesPista, NomeGP)
        VALUES (@NomeSessão, @Estado, @CondiçõesPista, @NomeGP_FK);
    ELSE IF @Ação = 'U'
        UPDATE Sessões SET Estado = ISNULL(@Estado, Estado), CondiçõesPista = ISNULL(@CondiçõesPista, CondiçõesPista), NomeGP = ISNULL(@NomeGP_FK, NomeGP) WHERE NomeSessão = @NomeSessão;
    ELSE IF @Ação = 'D'
        DELETE FROM Sessões WHERE NomeSessão = @NomeSessão;
    ELSE
        RAISERROR('Ação inválida.', 16, 1);
END
GO

-- 6. ADICIONAR NOVO MEMBRO DA EQUIPA (Para pessoal que não é piloto)
CREATE PROCEDURE dbo.AdicionarNovoMembro
    @Nome NVARCHAR(100),
    @Nacionalidade NVARCHAR(100),
    @DataNascimento DATE,
    @Género CHAR(1),
    @Função NVARCHAR(100),
    @ID_Equipa INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Equipa WHERE ID_Equipa = @ID_Equipa)
    BEGIN
        RAISERROR('Equipa com ID %d não encontrada.', 16, 1, @ID_Equipa);
        RETURN;
    END
    INSERT INTO Membros_da_Equipa (Nome, Nacionalidade, DataNascimento, Género, Função, ID_Equipa)
    VALUES (@Nome, @Nacionalidade, @DataNascimento, @Género, @Função, @ID_Equipa);
END
GO

-- 7. ADICIONAR PILOTO COMPLETO (Insere em Membro e Piloto)
CREATE PROCEDURE dbo.AdicionarPilotoCompleto
    @Nome NVARCHAR(100),
    @Nacionalidade NVARCHAR(100),
    @DataNascimento DATE,
    @Género CHAR(1),
    @ID_Equipa INT,
    @NumeroPermanente INT,
    @Abreviação CHAR(3)
AS
BEGIN
    DECLARE @ID_Membro INT;
    
    -- 1. Inserir como Membro da Equipa (Função = 'Piloto')
    INSERT INTO Membros_da_Equipa (Nome, Nacionalidade, DataNascimento, Género, Função, ID_Equipa)
    VALUES (@Nome, @Nacionalidade, @DataNascimento, @Género, 'Piloto', @ID_Equipa);
    
    SELECT @ID_Membro = SCOPE_IDENTITY();

    -- 2. Inserir como Piloto
    INSERT INTO Piloto (NumeroPermanente, Abreviação, ID_Equipa, ID_Membro)
    VALUES (@NumeroPermanente, @Abreviação, @ID_Equipa, @ID_Membro);
END
GO

-- 8. GERIR CONTRATO (Criação - Histórico)
CREATE PROCEDURE dbo.GerirContrato
    @ID_Membro INT,
    @AnoInicio INT,
    @AnoFim INT,
    @Função NVARCHAR(100),
    @Salário DECIMAL(20, 4), -- Sincronizado com DECIMAL(20, 4) do DDL
    @Género CHAR(1)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Membros_da_Equipa WHERE ID_Membro = @ID_Membro)
    BEGIN
        RAISERROR('Membro com ID %d não encontrado.', 16, 1, @ID_Membro);
        RETURN;
    END
    
    INSERT INTO Contrato (AnoInicio, AnoFim, Função, Salário, Género, ID_Membro)
    VALUES (@AnoInicio, @AnoFim, @Função, @Salário, @Género, @ID_Membro);
END
GO

-- ======================================================
-- SEÇÃO 3: REGISTO DE DADOS DE PISTA (ADMINISTRADOR)
-- ======================================================

-- 9. REGISTAR RESULTADOS PÓS-SESSÃO (UPSERT)
CREATE PROCEDURE dbo.RegistarResultado
    @NomeSessão NVARCHAR(100),
    @AbreviaçãoPiloto CHAR(3),
    @PosiçãoGrid INT,
    @PosiçãoFinal INT,
    @TempoFinal TIME,
    @Status NVARCHAR(50),
    @Pontos DECIMAL(5, 2)
AS
BEGIN
    DECLARE @ID_Piloto INT;
    SELECT @ID_Piloto = ID_Piloto FROM Piloto WHERE Abreviação = @AbreviaçãoPiloto;

    IF @ID_Piloto IS NULL
    BEGIN
        RAISERROR('Piloto com abreviação %s não encontrado.', 16, 1, @AbreviaçãoPiloto);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Sessões WHERE NomeSessão = @NomeSessão) -- Corrigido para Sessões
    BEGIN
        RAISERROR('Sessão %s não encontrada.', 16, 1, @NomeSessão);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Resultados WHERE NomeSessão = @NomeSessão AND ID_Piloto = @ID_Piloto)
        UPDATE Resultados SET PosiçãoGrid = @PosiçãoGrid, TempoFinal = @TempoFinal, PosiçãoFinal = @PosiçãoFinal, Status = @Status, Pontos = @Pontos WHERE NomeSessão = @NomeSessão AND ID_Piloto = @ID_Piloto;
    ELSE
        INSERT INTO Resultados (PosiçãoGrid, TempoFinal, PosiçãoFinal, Status, Pontos, NomeSessão, ID_Piloto)
        VALUES (@PosiçãoGrid, @TempoFinal, @PosiçãoFinal, @Status, @Pontos, @NomeSessão, @ID_Piloto);
END
GO

-- 10. REGISTAR PITSTOP
CREATE PROCEDURE dbo.RegistarPitstop
    @NomeSessão NVARCHAR(100),
    @AbreviaçãoPiloto CHAR(3),
    @NumeroVolta INT,
    @DuraçãoParagem TIME,
    @DuraçãoPitlane TIME
AS
BEGIN
    DECLARE @ID_Piloto INT;
    SELECT @ID_Piloto = ID_Piloto FROM Piloto WHERE Abreviação = @AbreviaçãoPiloto;

    IF @ID_Piloto IS NULL
    BEGIN
        RAISERROR('Piloto com abreviação %s não encontrado.', 16, 1, @AbreviaçãoPiloto);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Sessões WHERE NomeSessão = @NomeSessão) -- Corrigido para Sessões
    BEGIN
        RAISERROR('Sessão %s não encontrada.', 16, 1, @NomeSessão);
        RETURN;
    END

    INSERT INTO Pitstop (NumeroVolta, DuraçãoParagem, DuraçãoPitlane, NomeSessão, ID_Piloto)
    VALUES (@NumeroVolta, @DuraçãoParagem, @DuraçãoPitlane, @NomeSessão, @ID_Piloto);
END
GO

-- 11. REGISTAR PENALIZAÇÕES
CREATE PROCEDURE dbo.RegistarPenalizacao
    @NomeSessão NVARCHAR(100),
    @AbreviaçãoPiloto CHAR(3),
    @TipoPenalização NVARCHAR(100),
    @Motivo NVARCHAR(255),
    @ID_Resultados INT = NULL -- Coluna correta: ID_Resultados (no plural)
AS
BEGIN
    DECLARE @ID_Piloto INT;
    SELECT @ID_Piloto = ID_Piloto FROM Piloto WHERE Abreviação = @AbreviaçãoPiloto;

    IF @ID_Piloto IS NULL 
    BEGIN
        RAISERROR('Piloto com abreviação %s não encontrado.', 16, 1, @AbreviaçãoPiloto);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Sessões WHERE NomeSessão = @NomeSessão) -- Corrigido para Sessões
    BEGIN
        RAISERROR('Sessão %s não encontrada.', 16, 1, @NomeSessão);
        RETURN;
    END

    INSERT INTO Penalizações (TipoPenalização, Motivo, NomeSessão, ID_Piloto, ID_Resultados)
    VALUES (@TipoPenalização, @Motivo, @NomeSessão, @ID_Piloto, @ID_Resultados);
END
GO

-- ======================================================
-- SEÇÃO 4: CONSULTAS DE VISUALIZAÇÃO (VISITANTE / ADMIN)
-- ======================================================

-- 12. CONSULTAR SESSÃO DETALHADA
CREATE PROCEDURE dbo.ConsultarSessaoDetalhada
    @NomeSessão NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sessões WHERE NomeSessão = @NomeSessão)
    BEGIN
        RAISERROR('Sessão %s não encontrada.', 16, 1, @NomeSessão);
        RETURN;
    END

    -- Resultados da sessão
    SELECT 
        r.PosiçãoFinal,
        p.Abreviação,
        me.Nome as Piloto, -- Usando Membros_da_Equipa para o nome completo
        e.Nome as Equipa,
        r.PosiçãoGrid,
        r.TempoFinal,
        r.Status,
        r.Pontos
    FROM Resultados r
    INNER JOIN Piloto p ON r.ID_Piloto = p.ID_Piloto
    INNER JOIN Equipa e ON p.ID_Equipa = e.ID_Equipa
    INNER JOIN Membros_da_Equipa me ON p.ID_Membro = me.ID_Membro
    WHERE r.NomeSessão = @NomeSessão
    ORDER BY r.PosiçãoFinal;

    -- Pitstops da sessão
    SELECT 
        p.Abreviação,
        me.Nome as Piloto,
        ps.NumeroVolta,
        ps.DuraçãoParagem,
        ps.DuraçãoPitlane
    FROM Pitstop ps
    INNER JOIN Piloto p ON ps.ID_Piloto = p.ID_Piloto
    INNER JOIN Membros_da_Equipa me ON p.ID_Membro = me.ID_Membro
    WHERE ps.NomeSessão = @NomeSessão
    ORDER BY ps.NumeroVolta;
    
    -- Penalizações da sessão
    SELECT 
        p.Abreviação,
        me.Nome as Piloto,
        pen.TipoPenalização,
        pen.Motivo
    FROM Penalizações pen
    INNER JOIN Piloto p ON pen.ID_Piloto = p.ID_Piloto
    INNER JOIN Membros_da_Equipa me ON p.ID_Membro = me.ID_Membro
    WHERE pen.NomeSessão = @NomeSessão;
END
GO

-- 13. CONSULTAR GRANDE PRÉMIO COM SESSÕES
CREATE PROCEDURE dbo.ConsultarGrandePremioComSessoes
    @NomeGP NVARCHAR(100),
    @Ano_Temporada INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Grande_Prémio WHERE NomeGP = @NomeGP AND Ano_Temporada = @Ano_Temporada)
    BEGIN
        RAISERROR('Grande Prémio %s não encontrado na temporada %d.', 16, 1, @NomeGP, @Ano_Temporada);
        RETURN;
    END

    -- Detalhes do Grande Prémio
    SELECT 
        gp.NomeGP,
        gp.DataCorrida,
        c.Nome as Circuito,
        c.Pais
    FROM Grande_Prémio gp
    INNER JOIN Circuito c ON gp.ID_Circuito = c.ID_Circuito
    WHERE gp.NomeGP = @NomeGP AND gp.Ano_Temporada = @Ano_Temporada;

    -- Sessões do Grande Prémio
    SELECT 
        NomeSessão,
        Estado,
        CondiçõesPista
    FROM Sessões
    WHERE NomeGP = @NomeGP;
END
GO

-- 14. CONSULTAR TEMPORADA COM GRANDES PRÉMIOS
CREATE PROCEDURE dbo.ConsultarTemporadaComGrandesPremios
    @AnoTemporada INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Temporada WHERE Ano = @AnoTemporada)
    BEGIN
        RAISERROR('Temporada %d não encontrada.', 16, 1, @AnoTemporada);
        RETURN;
    END

    -- Detalhes da Temporada
    SELECT *
    FROM Temporada
    WHERE Ano = @AnoTemporada;

    -- Grandes Prémios da temporada
    SELECT 
        gp.NomeGP,
        gp.DataCorrida,
        c.Nome as Circuito,
        c.Pais
    FROM Grande_Prémio gp
    INNER JOIN Circuito c ON gp.ID_Circuito = c.ID_Circuito
    WHERE gp.Ano_Temporada = @AnoTemporada
    ORDER BY gp.DataCorrida;
END
GO

-- 15. OBTER MEMBROS (Incluindo Pilotos) DE UMA EQUIPA
CREATE PROCEDURE dbo.ObterMembrosPorEquipa
    @ID_Equipa INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Equipa WHERE ID_Equipa = @ID_Equipa)
    BEGIN
        RAISERROR('Equipa com ID %d não encontrada.', 16, 1, @ID_Equipa);
        RETURN;
    END

    SELECT 
        me.ID_Membro,
        me.Nome,
        me.Nacionalidade,
        me.Função,
        CASE WHEN p.ID_Piloto IS NOT NULL THEN 'Sim' ELSE 'Não' END as É_Piloto,
        p.Abreviação,
        p.NumeroPermanente
    FROM Membros_da_Equipa me
    LEFT JOIN Piloto p ON me.ID_Membro = p.ID_Membro
    WHERE me.ID_Equipa = @ID_Equipa
    ORDER BY me.Função, me.Nome;
END
GO

-- 16. OBTER CONTRATOS DE UM MEMBRO
CREATE PROCEDURE dbo.ObterContratosMembro
    @ID_Membro INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Membros_da_Equipa WHERE ID_Membro = @ID_Membro)
    BEGIN
        RAISERROR('Membro com ID %d não encontrado.', 16, 1, @ID_Membro);
        RETURN;
    END

    SELECT 
        c.ID_Contrato,
        c.AnoInicio,
        c.AnoFim,
        c.Função,
        c.Salário
    FROM Contrato c
    WHERE c.ID_Membro = @ID_Membro
    ORDER BY c.AnoInicio DESC;
END
GO

-- 17. DASHBOARD RESUMO DA SESSÃO
CREATE PROCEDURE dbo.DashboardSessao
    @NomeSessão NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sessões WHERE NomeSessão = @NomeSessão)
    BEGIN
        RAISERROR('Sessão %s não encontrada.', 16, 1, @NomeSessão);
        RETURN;
    END

    -- Podio da sessão (top 3)
    SELECT 
        'PÓDIO' as Categoria,
        r.PosiçãoFinal,
        me.Nome as Piloto,
        e.Nome as Equipa,
        r.Pontos
    FROM Resultados r
    INNER JOIN Piloto p ON r.ID_Piloto = p.ID_Piloto
    INNER JOIN Equipa e ON p.ID_Equipa = e.ID_Equipa
    INNER JOIN Membros_da_Equipa me ON p.ID_Membro = me.ID_Membro
    WHERE r.NomeSessão = @NomeSessão AND r.PosiçãoFinal <= 3 AND r.PosiçãoFinal > 0
    ORDER BY r.PosiçãoFinal;

    -- Estatísticas de pitstops
    SELECT 
        'PITSTOPS' as Categoria,
        COUNT(ID_Pitstop) as TotalPitstops,
        MIN(DuraçãoParagem) as PitstopMaisRapido,
        (SELECT TOP 1 me.Nome FROM Pitstop ps INNER JOIN Piloto pi ON ps.ID_Piloto = pi.ID_Piloto INNER JOIN Membros_da_Equipa me ON pi.ID_Membro = me.ID_Membro WHERE ps.NomeSessão = @NomeSessão GROUP BY me.Nome ORDER BY COUNT(*) DESC) as PilotoComMaisPitstops
    FROM Pitstop
    WHERE NomeSessão = @NomeSessão;
END
GO

-- 18. VISUALIZAÇÃO HIERÁRQUICA COMPLETA DA TEMPORADA (Simulação)
CREATE PROCEDURE dbo.VisualizacaoHierarquicaTemporada
    @AnoTemporada INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Temporada WHERE Ano = @AnoTemporada)
    BEGIN
        RAISERROR('Temporada %d não encontrada.', 16, 1, @AnoTemporada);
        RETURN;
    END

    -- Grandes Prémios
    SELECT 'GRANDE PRÉMIO' as Nivel,
           gp.NomeGP + ' (' + c.Nome + ')' as Descricao,
           CAST(@AnoTemporada AS NVARCHAR(10)) as Parente
    FROM Grande_Prémio gp
    INNER JOIN Circuito c ON gp.ID_Circuito = c.ID_Circuito
    WHERE gp.Ano_Temporada = @AnoTemporada;

    -- Sessões
    SELECT 'SESSÃO' as Nivel,
           s.NomeSessão + ' (' + s.Estado + ')' as Descricao,
           s.NomeGP as Parente
    FROM Sessões s
    INNER JOIN Grande_Prémio gp ON s.NomeGP = gp.NomeGP
    WHERE gp.Ano_Temporada = @AnoTemporada;

    -- Resumo
    SELECT 
        'Total de GPs: ' + CAST(COUNT(DISTINCT gp.NomeGP) AS NVARCHAR(10)) as Resumo
    FROM Grande_Prémio gp
    WHERE gp.Ano_Temporada = @AnoTemporada
    UNION ALL
    SELECT 
        'Total de Sessões: ' + CAST(COUNT(s.NomeSessão) AS NVARCHAR(10))
    FROM Sessões s
    INNER JOIN Grande_Prémio gp ON s.NomeGP = gp.NomeGP
    WHERE gp.Ano_Temporada = @AnoTemporada;
END
GO

-- ======================================================
-- SEÇÃO 5: PROCEDIMENTOS DE REMOÇÃO EM CASCATA (ADMINISTRADOR)
-- ======================================================
-- Nota: Estas operações são complexas e pressupõem a gestão manual da remoção de FKs, ou que as FKs sejam ON DELETE CASCADE.
-- Como o DDL não especificou ON DELETE CASCADE, usamos remoção explícita em cascata.

-- 19. REMOVER MEMBRO DA EQUIPA (E seus Contratos)
CREATE PROCEDURE dbo.RemoverMembroEquipa
    @ID_Membro INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Piloto WHERE ID_Membro = @ID_Membro)
    BEGIN
        RAISERROR('Erro: Este membro é um Piloto. Use dbo.RemoverPiloto primeiro.', 16, 1);
        RETURN;
    END

    DELETE FROM Contrato WHERE ID_Membro = @ID_Membro;
    DELETE FROM Membros_da_Equipa WHERE ID_Membro = @ID_Membro;
END
GO

-- 20. REMOVER PILOTO (E todos os seus dados de Resultados/Pitstops/Penalizações)
CREATE PROCEDURE dbo.RemoverPiloto
    @ID_Piloto INT
AS
BEGIN
    DECLARE @ID_Membro INT;
    
    SELECT @ID_Membro = ID_Membro FROM Piloto WHERE ID_Piloto = @ID_Piloto;

    IF @ID_Membro IS NULL
    BEGIN
        RAISERROR('Piloto com ID %d não encontrado.', 16, 1, @ID_Piloto);
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        DELETE FROM Resultados WHERE ID_Piloto = @ID_Piloto;
        DELETE FROM Pitstop WHERE ID_Piloto = @ID_Piloto;
        DELETE FROM Penalizações WHERE ID_Piloto = @ID_Piloto;
        DELETE FROM Piloto WHERE ID_Piloto = @ID_Piloto;
        
        -- Remove o registro de Membro (e seus contratos)
        DELETE FROM Contrato WHERE ID_Membro = @ID_Membro;
        DELETE FROM Membros_da_Equipa WHERE ID_Membro = @ID_Membro;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 21. REMOVER EQUIPA (Remove Pilotos/Membros/Contratos em cascata)
CREATE PROCEDURE dbo.RemoverEquipa
    @ID_Equipa INT
AS
BEGIN
    DECLARE @ID_Piloto INT, @ID_Membro INT;

    -- Remove Pilotos e seus dados
    DECLARE pilotos_cursor CURSOR FOR SELECT ID_Piloto FROM Piloto WHERE ID_Equipa = @ID_Equipa;
    OPEN pilotos_cursor;
    FETCH NEXT FROM pilotos_cursor INTO @ID_Piloto;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.RemoverPiloto @ID_Piloto = @ID_Piloto;
        FETCH NEXT FROM pilotos_cursor INTO @ID_Piloto;
    END
    CLOSE pilotos_cursor;
    DEALLOCATE pilotos_cursor;
    
    -- Remove membros restantes
    DECLARE membros_cursor CURSOR FOR SELECT ID_Membro FROM Membros_da_Equipa WHERE ID_Equipa = @ID_Equipa;
    OPEN membros_cursor;
    FETCH NEXT FROM membros_cursor INTO @ID_Membro;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.RemoverMembroEquipa @ID_Membro = @ID_Membro;
        FETCH NEXT FROM membros_cursor INTO @ID_Membro;
    END
    CLOSE membros_cursor;
    DEALLOCATE membros_cursor;
    
    -- Remove a Equipa
    EXEC dbo.GerirEquipa @ID_Equipa = @ID_Equipa, @Ação = 'D';
END
GO

-- 22. REMOVER DADOS DE UMA SESSÃO
CREATE PROCEDURE dbo.RemoverDadosSessao
    @NomeSessão NVARCHAR(100)
AS
BEGIN
    DELETE FROM Resultados WHERE NomeSessão = @NomeSessão;
    DELETE FROM Pitstop WHERE NomeSessão = @NomeSessão;
    DELETE FROM Penalizações WHERE NomeSessão = @NomeSessão;
END
GO

-- 23. REMOVER GRANDE PRÉMIO (e suas Sessões/Dados)
CREATE PROCEDURE dbo.RemoverGrandePremio
    @NomeGP NVARCHAR(100)
AS
BEGIN
    DECLARE @NomeSessão NVARCHAR(100);

    -- Remove dados de todas as sessões do GP
    DECLARE sessao_cursor CURSOR FOR SELECT NomeSessão FROM Sessões WHERE NomeGP = @NomeGP;
    OPEN sessao_cursor;
    FETCH NEXT FROM sessao_cursor INTO @NomeSessão;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.RemoverDadosSessao @NomeSessão = @NomeSessão;
        EXEC dbo.GerirSessao @NomeSessão = @NomeSessão, @Ação = 'D';
        FETCH NEXT FROM sessao_cursor INTO @NomeSessão;
    END
    CLOSE sessao_cursor;
    DEALLOCATE sessao_cursor;

    -- Remove o Grande Prémio
    EXEC dbo.GerirGrandePremio @NomeGP = @NomeGP, @Ação = 'D';
END
GO

-- 24. REMOVER TEMPORADA (e todos os seus Grandes Prémios/Sessões/Dados)
CREATE PROCEDURE dbo.RemoverTemporada
    @AnoTemporada INT
AS
BEGIN
    DECLARE @NomeGP NVARCHAR(100);

    -- Remove todos os Grandes Prémios da Temporada
    DECLARE gp_cursor CURSOR FOR SELECT NomeGP FROM Grande_Prémio WHERE Ano_Temporada = @AnoTemporada;
    OPEN gp_cursor;
    FETCH NEXT FROM gp_cursor INTO @NomeGP;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.RemoverGrandePremio @NomeGP = @NomeGP;
        FETCH NEXT FROM gp_cursor INTO @NomeGP;
    END
    CLOSE gp_cursor;
    DEALLOCATE gp_cursor;

    -- Remove a Temporada
    EXEC dbo.GerirTemporada @Ano = @AnoTemporada, @Ação = 'D';
END
GO

-- 25. FUNÇÃO PARA CALCULAR PONTOS DE UM PILOTO NUMA TEMPORADA (Função de Agregação/Consulta)
-- NOTA: Criamos uma Stored Procedure de consulta que simula o cálculo, pois o DDL não suporta funções escalares complexas nativamente
CREATE PROCEDURE dbo.ConsultarPontosPilotoTemporada
    @ID_Piloto INT,
    @AnoTemporada INT
AS
BEGIN
    SELECT 
        me.Nome AS Piloto,
        e.Nome AS Equipa,
        @AnoTemporada AS Ano,
        SUM(r.Pontos) AS TotalPontos
    FROM Resultados r
    INNER JOIN Piloto p ON r.ID_Piloto = p.ID_Piloto
    INNER JOIN Sessões s ON r.NomeSessão = s.NomeSessão
    INNER JOIN Grande_Prémio gp ON s.NomeGP = gp.NomeGP
    INNER JOIN Membros_da_Equipa me ON p.ID_Membro = me.ID_Membro
    INNER JOIN Equipa e ON p.ID_Equipa = e.ID_Equipa
    WHERE 
        p.ID_Piloto = @ID_Piloto AND gp.Ano_Temporada = @AnoTemporada
    GROUP BY me.Nome, e.Nome
    ORDER BY TotalPontos DESC;
END
GO