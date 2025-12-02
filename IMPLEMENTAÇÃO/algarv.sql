USE p3g9; 
GO

INSERT INTO Circuito (Nome, Cidade, Pais, Comprimento_km, NumCurvas)
VALUES 
(
    N'Autódromo Internacional do Algarve', -- Nome
    N'Portimão',                          -- Cidade
    N'Portugal',                          -- País
    4.653,                                -- Comprimento_km
    15                                    -- NumCurvas
);

GO

-- Agora, o ID_Circuito será gerado automaticamente (ex: 1, 2, 3...)