using System.Reflection;

namespace ProjetoFBD
{
    public partial class LoadingPage : Form
    {
            private int steps = 0;
        private const int totalSteps = 100;
        private const int interval = 5000 / totalSteps;

        public LoadingPage()
        {
            InitializeComponent();

            this.StartPosition = FormStartPosition.CenterScreen;

            var assembly = Assembly.GetExecutingAssembly();
            using var stream = assembly.GetManifestResourceStream("ProjetoFBD.logo.png");
            if (stream != null)
                PictureBox6.Image = Image.FromStream(stream);

            ProgressBar7.Minimum = 0;
            ProgressBar7.Maximum = totalSteps;
            ProgressBar7.Value = 0;
            ProgressBar7.Style = ProgressBarStyle.Continuous;

            Timer8.Interval = interval;
            Timer8.Tick += Timer8_Tick;
            Timer8.Start();
        }

        private void Timer8_Tick(object? sender, EventArgs e)
        {
            steps++;
            ProgressBar7.Value = steps;

            if (steps >= totalSteps)
            {
                Timer8.Stop();

                ProgressBar7.Value = totalSteps;
                ProgressBar7.Update();          // força o desenho agora
                Application.DoEvents();         // dá tempo ao UI para atualizar

                this.Close();                   // só depois fecha
            }
        }
    }
}