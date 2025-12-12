using System;
using System.Drawing;
using System.Windows.Forms;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Linq;

namespace ProjetoFBD
{
    public partial class SessionForm : Form
    {
        private DataGridView? dgvSessions;
        private Panel? pnlStaffActions;
        
        private string userRole;
        private string gpName;
        private SqlDataAdapter? dataAdapter;
        private DataTable? sessionTable;

        public SessionForm(string role, string grandPrixName)
        {
            InitializeComponent();
            
            this.userRole = role;
            this.gpName = grandPrixName;
            
            this.Text = $"Sessions - {gpName}";
            this.Size = new Size(1000, 600);
            this.StartPosition = FormStartPosition.CenterScreen;

            SetupLayout();
            LoadSessionData();
        }

        // -------------------------------------------------------------------------
        // UI SETUP
        // -------------------------------------------------------------------------

        private void SetupLayout()
        {
            // Título
            Label lblTitle = new Label
            {
                Text = $"Sessions - {gpName}",
                Location = new Point(20, 20),
                Size = new Size(600, 30),
                Font = new Font("Arial", 16, FontStyle.Bold),
                ForeColor = Color.FromArgb(220, 20, 20)
            };
            this.Controls.Add(lblTitle);

            // DataGridView para listar sessões
            dgvSessions = new DataGridView
            {
                Name = "dgvSessions",
                Location = new Point(20, 70),
                Size = new Size(940, 350),
                Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right,
                AllowUserToAddRows = false,
                ReadOnly = false,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                RowHeadersVisible = false
            };
            this.Controls.Add(dgvSessions);

            // Painel de ações
            pnlStaffActions = new Panel
            {
                Location = new Point(20, 440),
                Size = new Size(840, 50),
                Anchor = AnchorStyles.Bottom | AnchorStyles.Left
            };
            this.Controls.Add(pnlStaffActions);

            // Criar Botões
            Button btnSave = CreateActionButton("Save Changes", new Point(0, 5));
            Button btnAdd = CreateActionButton("Add New", new Point(140, 5));
            Button btnDelete = CreateActionButton("Delete Selected", new Point(280, 5));
            Button btnEdit = CreateActionButton("Edit", new Point(420, 5));
            Button btnRefresh = CreateActionButton("Refresh", new Point(560, 5));
            Button btnClose = CreateActionButton("Close", new Point(700, 5));

            // Ligar Eventos
            btnSave.Click += btnSave_Click;
            btnAdd.Click += btnAdd_Click;
            btnDelete.Click += btnDelete_Click;
            btnEdit.Click += btnEdit_Click;
            btnRefresh.Click += btnRefresh_Click;
            btnClose.Click += (s, e) => this.Close();

            pnlStaffActions.Controls.Add(btnSave);
            pnlStaffActions.Controls.Add(btnAdd);
            pnlStaffActions.Controls.Add(btnDelete);
            pnlStaffActions.Controls.Add(btnEdit);
            pnlStaffActions.Controls.Add(btnRefresh);
            pnlStaffActions.Controls.Add(btnClose);

            // Role-Based Access Control
            if (this.userRole == "Staff")
            {
                dgvSessions.ReadOnly = false;
                pnlStaffActions.Visible = true;
            }
            else
            {
                dgvSessions.ReadOnly = true;
                btnSave.Visible = false;
                btnAdd.Visible = false;
                btnDelete.Visible = false;
                btnEdit.Visible = false;
            }
        }

        private Button CreateActionButton(string text, Point location)
        {
            Button btn = new Button
            {
                Text = text,
                Location = location,
                Size = new Size(130, 40),
                BackColor = Color.FromArgb(220, 20, 20),
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                FlatAppearance = { BorderSize = 0 }
            };
            return btn;
        }

        // -------------------------------------------------------------------------
        // DATA ACCESS METHODS (CRUD)
        // -------------------------------------------------------------------------

        private void LoadSessionData()
        {
            string connectionString = DbConfig.ConnectionString;
            
            string query = @"
                SELECT 
                    NomeSessão,
                    Estado,
                    CondiçõesPista,
                    NomeGP
                FROM Sessões
                WHERE NomeGP = @GPName
                ORDER BY NomeSessão ASC";

            try
            {
                dataAdapter = new SqlDataAdapter(query, connectionString);
                dataAdapter.SelectCommand.Parameters.AddWithValue("@GPName", gpName);
                
                sessionTable = new DataTable();
                
                dataAdapter.Fill(sessionTable);
                
                if (dgvSessions != null)
                {
                    dgvSessions.DataSource = sessionTable;

                    // Configurar colunas
                    if (dgvSessions.Columns.Contains("NomeSessão"))
                        dgvSessions.Columns["NomeSessão"]!.HeaderText = "Session Name";
                    
                    if (dgvSessions.Columns.Contains("Estado"))
                        dgvSessions.Columns["Estado"]!.HeaderText = "Status";
                    
                    if (dgvSessions.Columns.Contains("CondiçõesPista"))
                        dgvSessions.Columns["CondiçõesPista"]!.HeaderText = "Track Conditions";
                    
                    if (dgvSessions.Columns.Contains("NomeGP"))
                    {
                        dgvSessions.Columns["NomeGP"]!.ReadOnly = true;
                        dgvSessions.Columns["NomeGP"]!.Visible = false; // Esconder pois já sabemos o GP
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading Session data: {ex.Message}", "Database Error",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnSave_Click(object? sender, EventArgs e)
        {
            if (dataAdapter != null && sessionTable != null && userRole == "Staff")
            {
                string connectionString = DbConfig.ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    try
                    {
                        if (dgvSessions != null)
                        {
                            dgvSessions.EndEdit();
                        }

                        connection.Open();
                        
                        // Criar comandos SQL explícitos para chave primária composta
                        dataAdapter.InsertCommand = new SqlCommand(
                            @"INSERT INTO Sessões (NomeSessão, Estado, CondiçõesPista, NomeGP) 
                              VALUES (@NomeSessão, @Estado, @CondiçõesPista, @NomeGP)", connection);
                        dataAdapter.InsertCommand.Parameters.Add("@NomeSessão", SqlDbType.NVarChar, 100, "NomeSessão");
                        dataAdapter.InsertCommand.Parameters.Add("@Estado", SqlDbType.NVarChar, 50, "Estado");
                        dataAdapter.InsertCommand.Parameters.Add("@CondiçõesPista", SqlDbType.NVarChar, 50, "CondiçõesPista");
                        dataAdapter.InsertCommand.Parameters.Add("@NomeGP", SqlDbType.NVarChar, 100, "NomeGP");
                        
                        dataAdapter.UpdateCommand = new SqlCommand(
                            @"UPDATE Sessões 
                              SET Estado = @Estado, CondiçõesPista = @CondiçõesPista 
                              WHERE NomeSessão = @NomeSessão AND NomeGP = @NomeGP", connection);
                        dataAdapter.UpdateCommand.Parameters.Add("@Estado", SqlDbType.NVarChar, 50, "Estado");
                        dataAdapter.UpdateCommand.Parameters.Add("@CondiçõesPista", SqlDbType.NVarChar, 50, "CondiçõesPista");
                        dataAdapter.UpdateCommand.Parameters.Add("@NomeSessão", SqlDbType.NVarChar, 100, "NomeSessão");
                        dataAdapter.UpdateCommand.Parameters.Add("@NomeGP", SqlDbType.NVarChar, 100, "NomeGP");
                        
                        dataAdapter.DeleteCommand = new SqlCommand(
                            @"DELETE FROM Sessões WHERE NomeSessão = @NomeSessão AND NomeGP = @NomeGP", connection);
                        dataAdapter.DeleteCommand.Parameters.Add("@NomeSessão", SqlDbType.NVarChar, 100, "NomeSessão");
                        dataAdapter.DeleteCommand.Parameters.Add("@NomeGP", SqlDbType.NVarChar, 100, "NomeGP");

                        int rowsAffected = dataAdapter.Update(sessionTable);
                        MessageBox.Show($"{rowsAffected} row(s) updated successfully!", "Success",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
                        
                        sessionTable.AcceptChanges();
                    }
                    catch (SqlException sqlEx)
                    {
                        MessageBox.Show($"Database error: {sqlEx.Message}", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Error saving changes: {ex.Message}", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void btnAdd_Click(object? sender, EventArgs e)
        {
            if (sessionTable != null && userRole == "Staff")
            {
                using (var inputForm = new InputDialog("Add New Session", "Enter session name:"))
                {
                    if (inputForm.ShowDialog() == DialogResult.OK &&
                        !string.IsNullOrWhiteSpace(inputForm.InputValue))
                    {
                        string sessionName = inputForm.InputValue.Trim();

                        // Verificar se a sessão já existe para este GP
                        bool sessionExists = false;
                        foreach (DataRow row in sessionTable.Rows)
                        {
                            if (row.RowState != DataRowState.Deleted &&
                                row["NomeSessão"] != DBNull.Value &&
                                row["NomeSessão"].ToString() == sessionName)
                            {
                                sessionExists = true;
                                break;
                            }
                        }

                        if (sessionExists)
                        {
                            MessageBox.Show($"Session '{sessionName}' already exists for this GP!",
                                "Duplicate Session", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            return;
                        }

                        // Adicionar nova linha
                        try
                        {
                            DataRow newRow = sessionTable.NewRow();
                            newRow["NomeSessão"] = sessionName;
                            newRow["Estado"] = "Scheduled"; // Valor padrão
                            newRow["CondiçõesPista"] = "Dry"; // Valor padrão
                            newRow["NomeGP"] = gpName;
                            sessionTable.Rows.Add(newRow);

                            // Focar na nova linha
                            if (dgvSessions != null)
                            {
                                dgvSessions.CurrentCell = dgvSessions.Rows[dgvSessions.Rows.Count - 1].Cells[0];
                            }
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show($"Error adding session: {ex.Message}", "Error",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                }
            }
        }

        private void btnDelete_Click(object? sender, EventArgs e)
        {
            if (userRole == "Staff" && dgvSessions != null && dgvSessions.SelectedRows.Count > 0 && sessionTable != null)
            {
                DialogResult dialogResult = MessageBox.Show(
                    "Are you sure you want to delete the selected session(s)? This action cannot be undone.",
                    "Confirm Deletion",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Warning);

                if (dialogResult == DialogResult.Yes)
                {
                    try
                    {
                        foreach (DataGridViewRow row in dgvSessions.SelectedRows)
                        {
                            if (row.Index >= 0 && row.Index < sessionTable.Rows.Count)
                            {
                                sessionTable.Rows[row.Index].Delete();
                            }
                        }
                        MessageBox.Show("Selected row(s) marked for deletion. Click 'Save Changes' to commit.",
                            "Deletion Pending", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Error deleting session: {ex.Message}", "Error",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void btnEdit_Click(object? sender, EventArgs e)
        {
            if (dgvSessions != null && dgvSessions.SelectedRows.Count > 0)
            {
                dgvSessions.CurrentCell = dgvSessions.SelectedRows[0].Cells[0];
                dgvSessions.BeginEdit(true);
            }
        }

        private void btnRefresh_Click(object? sender, EventArgs e)
        {
            if (sessionTable != null && sessionTable.GetChanges() != null)
            {
                DialogResult result = MessageBox.Show(
                    "You have unsaved changes. Do you want to discard them and refresh the data?",
                    "Unsaved Changes",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Warning);

                if (result == DialogResult.Yes)
                {
                    sessionTable.RejectChanges();
                    LoadSessionData();
                }
            }
            else
            {
                LoadSessionData();
            }
        }

        // InputDialog class for Add functionality
        public class InputDialog : Form
        {
            private TextBox textBox;
            public string InputValue { get; private set; } = "";

            public InputDialog(string title, string prompt)
            {
                this.Text = title;
                this.Size = new Size(400, 180);
                this.StartPosition = FormStartPosition.CenterParent;
                this.FormBorderStyle = FormBorderStyle.FixedDialog;
                this.MaximizeBox = false;
                this.MinimizeBox = false;

                Label lblPrompt = new Label
                {
                    Text = prompt,
                    Location = new Point(20, 20),
                    Size = new Size(350, 20),
                    Font = new Font("Arial", 10)
                };
                this.Controls.Add(lblPrompt);

                textBox = new TextBox
                {
                    Location = new Point(20, 50),
                    Size = new Size(340, 25),
                    Font = new Font("Arial", 10)
                };
                this.Controls.Add(textBox);

                Button btnOK = new Button
                {
                    Text = "OK",
                    DialogResult = DialogResult.OK,
                    Location = new Point(200, 90),
                    Size = new Size(80, 30),
                    BackColor = Color.FromArgb(220, 20, 20),
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat
                };
                btnOK.FlatAppearance.BorderSize = 0;
                btnOK.Click += (s, e) =>
                {
                    InputValue = textBox.Text;
                    this.Close();
                };
                this.Controls.Add(btnOK);

                Button btnCancel = new Button
                {
                    Text = "Cancel",
                    DialogResult = DialogResult.Cancel,
                    Location = new Point(290, 90),
                    Size = new Size(80, 30),
                    BackColor = Color.Gray,
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat
                };
                btnCancel.FlatAppearance.BorderSize = 0;
                this.Controls.Add(btnCancel);

                this.AcceptButton = btnOK;
                this.CancelButton = btnCancel;
            }
        }
    }
}
