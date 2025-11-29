using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;
using System.IO;
using System.Xml.Linq;
using System.Linq;

namespace WindowsFormsApp1
{
    public class DatabaseHelper
    {
        // Connection string đến Server Mẹ (Central)
        // Mặc định: localhost (chạy trên cùng máy server)
        // Để kết nối từ xa: sửa file App.config trong folder bin, thay localhost thành IP server (ví dụ: 172.20.10.6)
        private static string serverIP = GetServerIPFromConfig();
        private static string connectionString = $@"Data Source={serverIP}\SQLEXPRESS06,1436;Initial Catalog=ThuVien_Central;User ID=sa;Password=123456;TrustServerCertificate=True;";

        private static string GetServerIPFromConfig()
        {
            try
            {
                string configPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "WindowsFormsApp1.exe.config");
                if (File.Exists(configPath))
                {
                    XDocument doc = XDocument.Load(configPath);
                    var serverIPElement = doc.Descendants("add").FirstOrDefault(x => (string)x.Attribute("key") == "ServerIP");
                    if (serverIPElement != null)
                    {
                        return (string)serverIPElement.Attribute("value") ?? "localhost";
                    }
                }
                return "localhost";
            }
            catch
            {
                return "localhost";
            }
        }

        public static string GetConnectionString()
        {
            return connectionString;
        }

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }

        // Phương thức thực thi SELECT và trả về DataTable
        public static DataTable ExecuteQuery(string query, SqlParameter[] parameters = null)
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlConnection conn = GetConnection())
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(dataTable);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi thực thi truy vấn: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return dataTable;
        }

        // Phương thức thực thi Stored Procedure không trả về kết quả
        public static bool ExecuteNonQuery(string storedProcedure, SqlParameter[] parameters = null)
        {
            return ExecuteNonQuery(storedProcedure, parameters, true);
        }

        // Phương thức thực thi câu lệnh SQL hoặc Stored Procedure không trả về kết quả
        public static bool ExecuteNonQuery(string commandText, SqlParameter[] parameters, bool isStoredProcedure)
        {
            try
            {
                using (SqlConnection conn = GetConnection())
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(commandText, conn))
                    {
                        cmd.CommandType = isStoredProcedure ? CommandType.StoredProcedure : CommandType.Text;
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }
                        cmd.ExecuteNonQuery();
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi thực thi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return false;
            }
        }

        // Phương thức thực thi Stored Procedure và trả về DataTable
        public static DataTable ExecuteStoredProcedure(string storedProcedure, SqlParameter[] parameters = null)
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlConnection conn = GetConnection())
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(storedProcedure, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(dataTable);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi thực thi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return dataTable;
        }
    }
}
