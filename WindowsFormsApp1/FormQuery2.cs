using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class FormQuery2 : Form
    {
        private Label lblMaTG;
        private TextBox txtMaTG;
        private Button btnTimKiem;
        private DataGridView dgvKetQua;

        public FormQuery2()
        {
            InitializeComponent();
            this.Text = "Truy vấn 2: Sách của tác giả được mượn (01/01/1999 - 30/06/1999)";
            this.Size = new System.Drawing.Size(700, 450);
            this.StartPosition = FormStartPosition.CenterScreen;

            InitializeControls();
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(700, 450);
            this.Name = "FormQuery2";
            this.Text = "FormQuery2";
            this.ResumeLayout(false);
        }

        private void InitializeControls()
        {
            lblMaTG = new Label { Text = "Mã tác giả:", Location = new System.Drawing.Point(20, 20), Width = 100 };
            txtMaTG = new TextBox { Location = new System.Drawing.Point(130, 20), Width = 150 };
            btnTimKiem = new Button { Text = "Tìm kiếm", Location = new System.Drawing.Point(290, 18), Width = 100 };
            btnTimKiem.Click += BtnTimKiem_Click;

            dgvKetQua = new DataGridView
            {
                Location = new System.Drawing.Point(20, 60),
                Size = new System.Drawing.Size(640, 340),
                ReadOnly = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            };

            this.Controls.AddRange(new Control[] { lblMaTG, txtMaTG, btnTimKiem, dgvKetQua });
        }

        private void BtnTimKiem_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaTG.Text))
            {
                MessageBox.Show("Vui lòng nhập mã tác giả!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaTG", txtMaTG.Text.Trim())
            };

            DataTable dt = DatabaseHelper.ExecuteStoredProcedure("SP_Query2_SachTacGiaMuon", parameters);
            dgvKetQua.DataSource = dt;

            if (dt.Rows.Count > 0)
            {
                dgvKetQua.Columns["MaSach"].HeaderText = "Mã sách";
                dgvKetQua.Columns["TenSach"].HeaderText = "Tên sách";
            }
        }
    }
}
