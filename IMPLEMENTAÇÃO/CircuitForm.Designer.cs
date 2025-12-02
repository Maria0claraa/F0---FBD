namespace ProjetoFBD
{
    partial class CircuitForm
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1200, 700);
            this.Text = "Circuits Management";
            this.ResumeLayout(false);
        }

        #endregion

        // Variáveis de Controlo (IMPORTANTE: Estas são as variáveis que o seu CS usa!)
        // O código no CS deve usar estas declarações.
        private System.Windows.Forms.DataGridView dgvCircuitos;
        private System.Windows.Forms.Panel pnlStaffActions;
        
        // Embora o dataAdapter e o circuitoTable sejam usados na lógica, 
        // mantemo-los no .CS para simplificar a gestão de dados.
    }
}