using System;

namespace ProjetoFBD
{
    /// <summary>
    /// Fornece a string de conexão centralizada para toda a aplicação.
    /// </summary>
    public static class DbConfig
    {
        // A string de conexão completa com as credenciais fornecidas.
        // Como o ficheiro é parte do código-fonte (sem App.config),
        // deve-se ter o máximo cuidado com a segurança desta string.
        public const string ConnectionString =
            "Server=mednat.ieeta.pt,8101;" +
            "Database=p3g9;" +
            "User Id=p3g9;" +
            "Password=MQ_IB_FBD_2526;" +
            "TrustServerCertificate=True;";
    }
}