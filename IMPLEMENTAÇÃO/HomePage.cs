    using System;
    using System.Drawing;
    using System.Windows.Forms;
    using System.Reflection;
    using System.IO;
    using System.Linq; // Necessário para usar FirstOrDefault

    namespace ProjetoFBD
    {
        // A palavra-chave 'partial' é crucial para ligar ao HomePage.Designer.cs
        public partial class HomePage : Form
        {
            private string userRole;
            
            // As declarações dos Painéis foram movidas para o Designer.cs
            // private Panel pnlGrandPrix;
            // private Panel pnlSeasons;
            // private Panel pnlGrid;
            
            // -------------------------------------------------------------------------
            // CONSTRUTOR
            // -------------------------------------------------------------------------
            
            public HomePage(string role) 
            {
                // CRÍTICO: InitializeComponent() deve ser a primeira chamada
                InitializeComponent(); 
                
                // 1. Configurações Iniciais e Background
                SetupBackgroundImage();
                this.userRole = role; 
                
                this.Text = "Home Page - " + role;
                
                // 2. Criação do Layout
                SetupLayout(); 
            }

            // -------------------------------------------------------------------------
            // BACKGROUND IMAGE (Recurso Embutido com Fallback)
            // -------------------------------------------------------------------------
            
            private void SetupBackgroundImage()
            {
                var assembly = Assembly.GetExecutingAssembly();
                
                // Tenta encontrar o recurso que termine em "background.png"
                string? resourceName = assembly.GetManifestResourceNames().FirstOrDefault(n => n.EndsWith("background.png", StringComparison.OrdinalIgnoreCase));

                Image? backgroundImg = null;

                if (!string.IsNullOrEmpty(resourceName))
                {
                    using (var stream = assembly.GetManifestResourceStream(resourceName))
                    {
                        if (stream != null)
                        {
                            backgroundImg = Image.FromStream(stream);
                        }
                    }
                }

                // Fallback: tenta carregar a partir da pasta de execução
                if (backgroundImg == null)
                {
                    string fallbackPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "background.png");
                    if (File.Exists(fallbackPath))
                    {
                        backgroundImg = Image.FromFile(fallbackPath);
                    }
                }

                if (backgroundImg != null)
                {
                    // Criar imagem com 50% de opacidade
                    Bitmap dimmedImage = new Bitmap(backgroundImg.Width, backgroundImg.Height);
                    using (Graphics g = Graphics.FromImage(dimmedImage))
                    {
                        // Desenha a imagem original
                        g.DrawImage(backgroundImg, 0, 0);
                        
                        // Desenha overlay preto com 50% de opacidade por cima
                        using (SolidBrush brush = new SolidBrush(Color.FromArgb(128, 0, 0, 0)))
                        {
                            g.FillRectangle(brush, 0, 0, dimmedImage.Width, dimmedImage.Height);
                        }
                    }
                    
                    // Usa o PictureBox pbFundo para o background
                    pbFundo.Image = dimmedImage;
                    pbFundo.SendToBack();
                }
                else
                {
                    // Se nada funcionar, define uma cor de fundo sólida
                    this.BackColor = Color.FromArgb(20, 20, 20); 
                }
            }

            // -------------------------------------------------------------------------
            // LAYOUT E MENU (Com Estilo F1)
            // -------------------------------------------------------------------------

            private void SetupLayout()
            {
                // --- 1. Criar e Ancorar o Painel de Menu Principal no Topo ---
                Panel pnlMainMenu = new Panel
                {
                    Size = new Size(this.ClientSize.Width, 70),
                    Location = new Point(0, 0),
                    BackColor = Color.FromArgb(200, 15, 15, 15), // Mais opaco para destaque
                    Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right,
                    Name = "pnlMainMenu"
                };
                this.Controls.Add(pnlMainMenu);
                pnlMainMenu.BringToFront();
                
                // --- 2. Criação dos Botões do Cabeçalho (Estilo F1 Moderno) ---
                
                Font menuFont = new Font("Arial", 14, FontStyle.Bold);
                Color headerColor = Color.FromArgb(220, 20, 20); // Vermelho F1
                Color textColor = Color.White;
                
                Button btnGrandPrix = CreateMenuHeaderButton("GRAND PRIX", menuFont, headerColor, textColor, new Point(30, 15));
                Button btnSeasons = CreateMenuHeaderButton("SEASONS", menuFont, headerColor, textColor, new Point(230, 15));
                Button btnGrid = CreateMenuHeaderButton("GRID", menuFont, headerColor, textColor, new Point(430, 15));

                pnlMainMenu.Controls.Add(btnGrandPrix);
                pnlMainMenu.Controls.Add(btnSeasons);
                pnlMainMenu.Controls.Add(btnGrid);
                
                // --- 3. Criação e Configuração dos Painéis Dropdown ---
                
                // Os painéis globais são inicializados no Designer, mas reconfigurados e reposicionados aqui
                this.pnlGrandPrix = CreateDropdownPanel(new Point(30, 70)); 
                this.pnlSeasons = CreateDropdownPanel(new Point(230, 70)); 
                this.pnlGrid = CreateDropdownPanel(new Point(430, 70)); 
                
                // Adicionar Itens e Eventos Toggle... (Resto da lógica de layout)
                AddDropdownItem(pnlGrandPrix, "GP", 0);
                AddDropdownItem(pnlGrandPrix, "Circuits", 1);

                AddDropdownItem(pnlSeasons, "Team Standings", 0);
                AddDropdownItem(pnlSeasons, "Driver Standings", 1);
                AddDropdownItem(pnlSeasons, "All Seasons", 2);
                
                AddDropdownItem(pnlGrid, "Drivers", 0);
                AddDropdownItem(pnlGrid, "Teams", 1);

                // Adicionar os painéis ao formulário (só se não os adicionou no Designer)
                // Se o Designer já os adicionou, remova as próximas 3 linhas
                this.Controls.Add(pnlGrandPrix);
                this.Controls.Add(pnlSeasons);
                this.Controls.Add(pnlGrid);

                // CRÍTICO: Trazer os painéis para frente para ficarem acima do background
                pnlGrandPrix.BringToFront();
                pnlSeasons.BringToFront();
                pnlGrid.BringToFront();

                pnlGrandPrix.Visible = false;
                pnlSeasons.Visible = false;
                pnlGrid.Visible = false;
                
                // Lógica de Clique (Toggle)
                btnGrandPrix.Click += (s, e) => ToggleDropdown(pnlGrandPrix);
                btnSeasons.Click += (s, e) => ToggleDropdown(pnlSeasons);
                btnGrid.Click += (s, e) => ToggleDropdown(pnlGrid);
                
                // Mensagem de Boas-Vindas e Logout
                DisplayWelcomeMessage();
                
                Button btnLogout = new Button
                {
                    Text = "LOGOUT",
                    Font = new Font("Arial", 11, FontStyle.Bold),
                    BackColor = Color.FromArgb(150, 150, 150),
                    ForeColor = Color.White,
                    Size = new Size(120, 40),
                    Location = new Point(this.ClientSize.Width - 140, this.ClientSize.Height - 60),
                    FlatStyle = FlatStyle.Flat,
                    Cursor = Cursors.Hand,
                    Anchor = AnchorStyles.Bottom | AnchorStyles.Right
                };
                btnLogout.FlatAppearance.BorderSize = 0;
                btnLogout.FlatAppearance.MouseOverBackColor = Color.FromArgb(180, 180, 180);
                btnLogout.Click += new EventHandler(this.btnLogout_Click);
                this.Controls.Add(btnLogout);
                btnLogout.BringToFront();
            }

            // -------------------------------------------------------------------------
            // MÉTODOS AUXILIARES E EVENTOS
            // -------------------------------------------------------------------------
            
            private void DisplayWelcomeMessage()
            {
                // Mensagem de boas-vindas simples sem painel de fundo
                Label lblWelcome = new Label
                {
                    Text = $"BEM-VINDO, {userRole.ToUpper()}!",
                    Font = new Font("Arial", 28, FontStyle.Bold),
                    AutoSize = false,
                    Size = new Size(500, 60),
                    Location = new Point(this.ClientSize.Width / 2 - 250, this.ClientSize.Height / 2 - 30),
                    TextAlign = ContentAlignment.MiddleCenter,
                    BackColor = Color.Transparent,
                    ForeColor = Color.White
                };

                this.Controls.Add(lblWelcome);
                lblWelcome.SendToBack();
            }

            private void btnLogout_Click(object? sender, EventArgs e)
            {
                this.Close();
                LoginForm loginForm = new LoginForm();
                loginForm.Show();
            }

            private Button CreateMenuHeaderButton(string text, Font font, Color backColor, Color foreColor, Point location)
            {
                Button btn = new Button
                {
                    Text = text,
                    Font = font,
                    BackColor = backColor,
                    ForeColor = foreColor,
                    Size = new Size(180, 40),
                    Location = location,
                    FlatStyle = FlatStyle.Flat,
                    Cursor = Cursors.Hand,
                    TextAlign = ContentAlignment.MiddleCenter
                };
                btn.FlatAppearance.BorderSize = 0;
                btn.FlatAppearance.MouseDownBackColor = Color.FromArgb(180, 10, 10);
                btn.FlatAppearance.MouseOverBackColor = Color.FromArgb(240, 30, 30);
                return btn;
            }

            private Panel CreateDropdownPanel(Point location)
            {
                Panel panel = new Panel
                {
                    Size = new Size(180, 200),
                    Location = location,
                    BackColor = Color.FromArgb(240, 240, 240),
                    BorderStyle = BorderStyle.None,
                    AutoScroll = true
                };
                
                panel.Paint += (sender, e) => {
                    // Borda mais elegante
                    using (Pen pen = new Pen(Color.FromArgb(200, 200, 200), 1))
                    {
                        e.Graphics.DrawRectangle(pen, 0, 0, panel.Width - 1, panel.Height - 1);
                    }
                };
                
                panel.BringToFront();
                return panel;
            }

            private void AddDropdownItem(Panel parentPanel, string text, int index)
            {
                Button btnItem = new Button
                {
                    Text = text,
                    Size = new Size(parentPanel.Width, 30),
                    Location = new Point(0, index * 30),
                    FlatStyle = FlatStyle.Flat,
                    FlatAppearance = { 
                        BorderSize = 0, 
                        MouseDownBackColor = Color.LightGray, 
                        MouseOverBackColor = Color.Gainsboro 
                    }, 
                    TextAlign = ContentAlignment.MiddleLeft,
                    Padding = new Padding(10, 0, 0, 0), 
                    BackColor = Color.White,
                    ForeColor = Color.Black 
                };
                
                btnItem.Paint += (sender, e) => {
                    e.Graphics.DrawLine(Pens.LightGray, 0, btnItem.Height - 1, btnItem.Width, btnItem.Height - 1);
                };
                
                btnItem.MouseEnter += (s, e) => btnItem.BackColor = Color.Gainsboro;
                btnItem.MouseLeave += (s, e) => btnItem.BackColor = Color.White;

                parentPanel.Controls.Add(btnItem);
        if (parentPanel == pnlGrandPrix && text == "GP") // Assumi que "Races" é o seu GP no código
    {
        btnItem.Click += (s, e) => OpenGPForm();
    }
    else if (parentPanel == pnlGrandPrix && text == "Circuits")
    {
        btnItem.Click += (s, e) => OpenCircuitForm(); 
    }
    else if (parentPanel == pnlSeasons && text == "All Seasons") // <-- NOVO CÓDIGO AQUI
    {
        btnItem.Click += (s, e) => OpenSeasonForm();
    }

            }
            

            private void ToggleDropdown(Panel targetPanel)
            {
                pnlGrandPrix.Visible = false;
                pnlSeasons.Visible = false;
                pnlGrid.Visible = false;
                
                targetPanel.Visible = !targetPanel.Visible;
            }


            // Ficheiro: HomePage.cs

    private void OpenGPForm()
    {
        // 1. Esconder o painel dropdown após a seleção
        pnlGrandPrix.Visible = false;
        
        // 2. Abre o formulário da Lista de Grandes Prémios
        // Passamos o papel do utilizador para que o GrandePremioForm saiba quem pode editar
        GPForm gpForm = new GPForm(this.userRole);
        
        // Usa ShowDialog() para que o utilizador feche a lista antes de interagir novamente com a HomePage/Menu
        gpForm.ShowDialog(); 
    }

    private void OpenCircuitForm()
    {
        // 1. Esconder o painel dropdown após a seleção
        pnlGrandPrix.Visible = false;
        
        // 2. Abre o formulário da Lista de Circuitos
        CircuitForm circuitForm = new CircuitForm(this.userRole);
        
        // Usa ShowDialog() para que o utilizador feche a lista antes de interagir novamente com a HomePage/Menu
        circuitForm.ShowDialog();
    }
    private void OpenSeasonForm()
    {
        //1. Esconder o painel dropdown após a seleção
        pnlSeasons.Visible = false; // Tem que esconder o painel correto
        
        // 2. Abre o formulário da Lista de Temporadas
        // Assumimos que a classe SeasonForm está disponível no namespace ProjetoFBD
        SeasonForm seasonForm = new SeasonForm(this.userRole);
        
        // Usa ShowDialog() para que o utilizador feche a lista antes de interagir novamente com a HomePage/Menu
        seasonForm.ShowDialog();
    }

    // Nota: Você pode precisar de ajustar os nomes dos seus métodos (OpenGPForm, OpenCircuitForm) 
    // para corresponder exatamente aos nomes que está a usar no seu projeto.
        }
    }