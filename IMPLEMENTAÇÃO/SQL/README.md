# Estrutura SQL do Projeto Formula0-DataBase

## � COMO EXECUTAR (PASSO-A-PASSO)

### **Opção 1: SCRIPT ÚNICO (MAIS FÁCIL)** ⭐ RECOMENDADO

1. **Abrir Azure Data Studio**
2. **Conectar à base de dados:**
   - Server: `mednat.ieeta.pt,8101`
   - Database: `p3g9`
   - User: `p3g9`
   - Password: `MQ_IB_FBD_2526`

3. **Abrir o ficheiro:**
   ```
   IMPLEMENTAÇÃO/SQL/00_EXECUTAR_TUDO.sql
   ```

4. **Clicar em "Run" (F5)**
   - ✅ Cria Indexes
   - ✅ Cria UDFs
   - ✅ Cria Views
   - ✅ Cria Stored Procedures
   - ✅ Cria Triggers

5. **PRONTO!** 🎉

---

### **Opção 2: COMEÇAR DO ZERO (Apaga tudo)**

**⚠️ ATENÇÃO: Isto APAGA TODOS OS DADOS!**

1. **Executar DDL primeiro (cria tabelas):**
   ```
   APFE_FINAL_124877_124996/sql/01_ddl_fixed.sql
   ```

2. **Depois executar:**
   ```
   IMPLEMENTAÇÃO/SQL/00_EXECUTAR_TUDO.sql
   ```

---

## 📁 O QUE FOI CRIADO

```
SQL/
├── 00_EXECUTAR_TUDO.sql         ⭐ EXECUTAR ESTE!
├── README.md                     📖 Este ficheiro
├── indexes.sql                   🔍 Performance
├── Triggers/
│   └── audit_triggers.sql        ✅ Validações automáticas
├── UDFs/
│   └── utility_functions.sql     🔧 Funções úteis
├── views/
│   ├── season_views.sql          📊 Views de temporadas
│   └── standings_views.sql       🏆 Views de standings
└── SPs/
    └── sp_standings.sql          ⚙️ Stored procedures
```

---

## ✨ O QUE CADA FICHEIRO FAZ

### **Triggers** (Validações Automáticas)
- ✅ `trg_ValidateRaceDate` - Impede datas de corrida inválidas
- ✅ `trg_ValidateResultPoints` - Impede pontos negativos
- ✅ `trg_UpdateSeasonRaceCount` - Atualiza contadores automaticamente

### **UDFs** (Funções Úteis)
- `fn_CalculateAge(@BirthDate)` - Calcula idade
- `fn_GetDriverTotalPoints(@DriverID)` - Total de pontos
- `fn_GetDriverWins(@DriverID)` - Total de vitórias
- `fn_IsDriverActive(@DriverID)` - Verifica se está ativo
- `fn_GetDriverFullName(@DriverID)` - Nome completo

### **Views** (Consultas Prontas)
- `vw_SeasonSummary` - Resumo de temporadas
- `vw_DriverStandings` - Standings de pilotos
- `vw_TeamStandings` - Standings de equipas
- `vw_DriverStandingsBySeason` - Por temporada (pilotos)
- `vw_TeamStandingsBySeason` - Por temporada (equipas)

### **Stored Procedures**
- `sp_GetDriverStandingsBySeason(@Season)` - Standings de pilotos
- `sp_GetTeamStandingsBySeason(@Season)` - Standings de equipas

---

## 💡 EXEMPLOS DE USO

### Usar Views
```sql
-- Ver todos os standings
SELECT * FROM vw_DriverStandings ORDER BY Position;
SELECT * FROM vw_TeamStandings ORDER BY Position;

-- Ver por temporada
SELECT * FROM vw_DriverStandingsBySeason WHERE Season = 2025;
```

### Usar Stored Procedures
```sql
-- Standings de 2025
EXEC sp_GetDriverStandingsBySeason @Season = 2025;
EXEC sp_GetTeamStandingsBySeason @Season = 2025;
```

### Usar UDFs
```sql
-- Calcular idade
SELECT dbo.fn_CalculateAge('1990-01-15') AS Idade;

-- Ver pontos de um piloto
SELECT dbo.fn_GetDriverTotalPoints(1) AS TotalPontos;

-- Ver vitórias
SELECT dbo.fn_GetDriverWins(1) AS Vitorias;
```

---

## ⚠️ AVISOS

- ✅ **00_EXECUTAR_TUDO.sql** é SEGURO - Não apaga dados
- ❌ **01_ddl_fixed.sql** APAGA TUDO - Usar com cuidado
- 🔄 Podes executar **00_EXECUTAR_TUDO.sql** várias vezes sem problemas

---

**Última atualização:** 15/12/2025
