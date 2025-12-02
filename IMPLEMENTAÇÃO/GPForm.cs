using System;
using System.Windows.Forms;
using System.Drawing;
using Microsoft.Data.SqlClient;
using System.Configuration; // Para ler a connection string
using System.Data; // Para usar DataTable

namespace ProjetoFBD
{
    public partial class GPForm : Form
    {
        private string userRole;
        // As declarações DataGridView e Panel foram movidas para o Designer.cs
        // Usamos o operador '!' (null-forgiving) apenas na lógica, não na declaração

        public GPForm() : this("Guest") // Construtor padrão para o Designer
        {
            // Nota: InitializeComponent será chamado no construtor principal
        }

        // -------------------------------------------------------------------------
        // Construtor Principal (Com Parâmetro)
        // -------------------------------------------------------------------------
        public GPForm(string role)
        {
            // CRÍTICO: InitializeComponent deve ser chamado diretamente.
            InitializeComponent(); 
            
            this.userRole = role;
            this.Text = "GRAND PRIX - Lista de Corridas";
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Size = new Size(1000, 700);
            
            SetupRacesLayout();
            LoadRaceData();
        }

        private void SetupRacesLayout()
        {
            // Os controlos são inicializados aqui, usando as declarações do Designer
            this.dgvRaces = new DataGridView
            {
                Name = "dgvRaces",
                Location = new Point(20, 100),
                Size = new Size(950, 500),
                ReadOnly = true, 
                AllowUserToAddRows = false,
                Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right
            };
            this.Controls.Add(dgvRaces);

            this.pnlStaffActions = new Panel
            {
                Location = new Point(20, 620),
                Size = new Size(400, 50),
                Anchor = AnchorStyles.Bottom | AnchorStyles.Left
            };
            this.Controls.Add(pnlStaffActions);

            Button btnAdd = CreateActionButton("Adicionar Nova", new Point(0, 5));
            Button btnEdit = CreateActionButton("Editar Selecionada", new Point(130, 5));
            Button btnDelete = CreateActionButton("Eliminar", new Point(260, 5));
            
            pnlStaffActions.Controls.Add(btnAdd);
            pnlStaffActions.Controls.Add(btnEdit);
            pnlStaffActions.Controls.Add(btnDelete);
            
            // --- Lógica de Controlo de Acesso (RBAC) ---
            if (this.userRole != "Staff")
            {
                pnlStaffActions.Visible = false;
            }
        }
        
        // Método auxiliar para criar botões de ação
        private Button CreateActionButton(string text, Point location)
        {
            Button btn = new Button
            {
                Text = text,
                Location = location,
                Size = new Size(120, 40),
                BackColor = Color.FromArgb(204, 0, 0),
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                FlatAppearance = { BorderSize = 0 }
            };
            return btn;
        }

        private void LoadRaceData()
        {
            // ... (O código de BD é o mesmo, e deve funcionar após o erro CS0103 ser resolvido)
            // Certifique-se de que a tabela 'Races' existe na sua BD para evitar o erro de BD.
            string connectionString = DbConfig.ConnectionString;
            string query = "SELECT RaceName, CircuitName, RaceDate FROM Races ORDER BY RaceDate DESC";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                    DataTable raceTable = new DataTable();
                    adapter.Fill(raceTable);
                    
                    // Nota: O dgvRaces não pode ser nulo aqui porque foi inicializado em SetupRacesLayout
                    dgvRaces.DataSource = raceTable;
                    dgvRaces.AutoResizeColumns(DataGridViewAutoSizeColumnsMode.AllCells);
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Erro ao carregar dados de Corridas. Detalhe: {ex.Message}", 
                                    "Erro de BD", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    }
}