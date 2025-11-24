namespace ProjetoFBD
{
    partial class LoadingPage
    {
        [STAThread] // Necessário para aplicações Windows Forms
        static void Main()
        {
            Application.SetHighDpiMode(HighDpiMode.SystemAware); // Ajuste para telas de alta DPI
            Application.EnableVisualStyles(); // Ativa estilos modernos
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new LoadingPage()); // Inicializa e abre o Form1
        }
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.Label0 = new System.Windows.Forms.Label();
            this.Label1 = new System.Windows.Forms.Label();
            this.Label2 = new System.Windows.Forms.Label();
            this.Label3 = new System.Windows.Forms.Label();
            this.ImageList4 = new System.Windows.Forms.ImageList(this.components);
            this.Label5 = new System.Windows.Forms.Label();
            this.PictureBox6 = new System.Windows.Forms.PictureBox();
            this.ProgressBar7 = new System.Windows.Forms.ProgressBar();
            this.Timer8 = new System.Windows.Forms.Timer(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.PictureBox6)).BeginInit();
            this.SuspendLayout();
            // 
            // Label0
            // 
            this.Label0.AutoSize = true;
            this.Label0.Font = new System.Drawing.Font("Century Gothic", 30F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.Label0.Location = new System.Drawing.Point(312, 168);
            this.Label0.Name = "Label0";
            this.Label0.Size = new System.Drawing.Size(219, 59);
            this.Label0.TabIndex = 0;
            this.Label0.Text = "Fórmula";
            // 
            // Label1
            // 
            this.Label1.AutoSize = true;
            this.Label1.Font = new System.Drawing.Font("Century Gothic", 30F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.Label1.Location = new System.Drawing.Point(520, 172);
            this.Label1.Name = "Label1";
            this.Label1.Size = new System.Drawing.Size(53, 59);
            this.Label1.TabIndex = 1;
            this.Label1.Text = "0";
            this.Label1.ForeColor = System.Drawing.Color.FromArgb(204, 0, 0);
            // 
            // Label2
            // 
            this.Label2.AutoSize = true;
            this.Label2.Font = new System.Drawing.Font("Century Gothic", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.Label2.Location = new System.Drawing.Point(12, 395); // ou 340, experimenta
            this.Label2.Name = "Label2";
            this.Label2.Size = new System.Drawing.Size(95, 21);
            this.Label2.TabIndex = 2;
            this.Label2.Text = "Loading...";
            // 
            // Label3
            // 
            this.Label3.AutoSize = true;
            this.Label3.Font = new System.Drawing.Font("Century Gothic", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.Label3.ForeColor = System.Drawing.SystemColors.AppWorkspace;
            this.Label3.Location = new System.Drawing.Point(556, 4);
            this.Label3.Name = "Label3";
            this.Label3.Size = new System.Drawing.Size(170, 21);
            this.Label3.TabIndex = 3;
            this.Label3.Text = "Inês Batista, 124877";
            // 
            // ImageList4
            // 
            // Removido: this.ImageList4.HandleCreated = true;
            // 
            // Label5
            // 
            this.Label5.AutoSize = true;
            this.Label5.Font = new System.Drawing.Font("Century Gothic", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.Label5.ForeColor = System.Drawing.SystemColors.ButtonShadow;
            this.Label5.Location = new System.Drawing.Point(524, 24);
            this.Label5.Name = "Label5";
            this.Label5.Size = new System.Drawing.Size(203, 21);
            this.Label5.TabIndex = 5;
            this.Label5.Text = "Maria Quinteiro, 124996";
            // 
            // PictureBox6
            // 
            this.PictureBox6.Location = new System.Drawing.Point(156, 80);
            this.PictureBox6.Name = "PictureBox6";
            this.PictureBox6.Size = new System.Drawing.Size(156, 152);
            this.PictureBox6.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.PictureBox6.TabIndex = 6;
            this.PictureBox6.TabStop = false;
            // 
            // ProgressBar7
            // 
            this.ProgressBar7.BackColor = System.Drawing.SystemColors.ActiveBorder;
            this.ProgressBar7.ForeColor = System.Drawing.Color.Firebrick;
            this.ProgressBar7.Location = new System.Drawing.Point(86, 240);
            this.ProgressBar7.Name = "ProgressBar7";
            this.ProgressBar7.Size = new System.Drawing.Size(540, 23);
            this.ProgressBar7.TabIndex = 7;
            this.ProgressBar7.Value = 50;
            // 
            // Timer8
            // 
            this.Timer8.Interval = 1000;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(744, 424);
            this.Controls.Add(this.ProgressBar7);
            this.Controls.Add(this.PictureBox6);
            this.Controls.Add(this.Label5);
            this.Controls.Add(this.Label3);
            this.Controls.Add(this.Label2);
            this.Controls.Add(this.Label1);
            this.Controls.Add(this.Label0);
            this.Name = "Form1";
            this.Text = "Inês Batista, 124877";
            ((System.ComponentModel.ISupportInitialize)(this.PictureBox6)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        #endregion

        private System.Windows.Forms.Label Label0;
        private System.Windows.Forms.Label Label1;
        private System.Windows.Forms.Label Label2;
        private System.Windows.Forms.Label Label3;
        private System.Windows.Forms.ImageList ImageList4;
        private System.Windows.Forms.Label Label5;
        private System.Windows.Forms.PictureBox PictureBox6;
        private System.Windows.Forms.ProgressBar ProgressBar7;
        private System.Windows.Forms.Timer Timer8;
    }
}