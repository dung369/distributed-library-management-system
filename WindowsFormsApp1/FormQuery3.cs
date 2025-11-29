using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class FormQuery3 : Form
    {
        private Label lblInfo;
        private Label lblThanhPhoHienTai;
        private Button btnCapNhat;
        private DataGridView dgvKetQua;

        public FormQuery3()
        {
            InitializeComponent();
            this.Text = "Truy vấn 3: Cập nhật thành phố NXB KHKT";
            this.Size = new System.Drawing.Size(650, 400);
            this.StartPosition = FormStartPosition.CenterScreen;

            InitializeControls();
            LoadCurrentData();
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(650, 400);
            this.Name = "FormQuery3";
            this.Text = "FormQuery3";
            this.ResumeLayout(false);
        }

        private void InitializeControls()
        {
            lblInfo = new Label
            {
                Text = "Chuyển đổi thành phố của NXB 'KHKT' (T1 ↔ T2)",
                Location = new System.Drawing.Point(20, 20),
                Width = 400,
                Font = new System.Drawing.Font("Microsoft Sans Serif", 11F, System.Drawing.FontStyle.Bold)
            };

            lblThanhPhoHienTai = new Label
            {
                Text = "Thành phố hiện tại: ...",
                Location = new System.Drawing.Point(20, 50),
                Width = 400,
                Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular),
                ForeColor = System.Drawing.Color.Blue
            };

            btnCapNhat = new Button
            {
                Text = "Chuyển đổi thành phố",
                Location = new System.Drawing.Point(20, 85),
                Width = 180,
                Height = 40,
                Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold)
            };
            btnCapNhat.Click += BtnCapNhat_Click;

            dgvKetQua = new DataGridView
            {
                Location = new System.Drawing.Point(20, 140),
                Size = new System.Drawing.Size(600, 200),
                ReadOnly = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            };

            this.Controls.AddRange(new Control[] { lblInfo, lblThanhPhoHienTai, btnCapNhat, dgvKetQua });
        }

        private void LoadCurrentData()
        {
            try
            {
                string sql = "SELECT MaNXB, TenNXB, ThanhPho, SiteLocation FROM V_NhaXB WHERE TenNXB = N'KHKT'";
                DataTable dt = DatabaseHelper.ExecuteQuery(sql);
                dgvKetQua.DataSource = dt;

                if (dgvKetQua.Columns.Count > 0)
                {
                    dgvKetQua.Columns["MaNXB"].HeaderText = "Mã NXB";
                    dgvKetQua.Columns["TenNXB"].HeaderText = "Tên NXB";
                    dgvKetQua.Columns["ThanhPho"].HeaderText = "Thành phố";
                    dgvKetQua.Columns["SiteLocation"].HeaderText = "Site";
                }

                // Hiển thị thành phố hiện tại
                if (dt.Rows.Count > 0)
                {
                    string thanhPho = dt.Rows[0]["ThanhPho"].ToString();
                    lblThanhPhoHienTai.Text = $"Thành phố hiện tại: {thanhPho}";
                    
                    // Cập nhật text button
                    if (thanhPho == "T1")
                    {
                        btnCapNhat.Text = "Chuyển T1 → T2";
                    }
                    else if (thanhPho == "T2")
                    {
                        btnCapNhat.Text = "Chuyển T2 → T1";
                    }
                }
                else
                {
                    lblThanhPhoHienTai.Text = "Không tìm thấy NXB 'KHKT'";
                    btnCapNhat.Enabled = false;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi load dữ liệu: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnCapNhat_Click(object sender, EventArgs e)
        {
            try
            {
                // Lấy thành phố hiện tại
                string sql = "SELECT ThanhPho FROM V_NhaXB WHERE TenNXB = N'KHKT'";
                DataTable dt = DatabaseHelper.ExecuteQuery(sql);

                if (dt.Rows.Count == 0)
                {
                    MessageBox.Show("Không tìm thấy NXB 'KHKT'!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                string thanhPhoHienTai = dt.Rows[0]["ThanhPho"].ToString();
                string thanhPhoMoi = (thanhPhoHienTai == "T1") ? "T2" : "T1";

                DialogResult result = MessageBox.Show(
                    $"Bạn có chắc muốn chuyển thành phố của NXB KHKT từ '{thanhPhoHienTai}' sang '{thanhPhoMoi}'?",
                    "Xác nhận",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    // Cập nhật thành phố
                    string updateSql = $@"
                        UPDATE SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
                        SET ThanhPho = N'{thanhPhoMoi}'
                        WHERE TenNXB = N'KHKT' AND ThanhPho = N'{thanhPhoHienTai}';
                        
                        UPDATE SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
                        SET ThanhPho = N'{thanhPhoMoi}'
                        WHERE TenNXB = N'KHKT' AND ThanhPho = N'{thanhPhoHienTai}';
                    ";

                    bool success = DatabaseHelper.ExecuteNonQuery(updateSql, null, false);

                    if (success)
                    {
                        MessageBox.Show(
                            $"Cập nhật thành công!\nChuyển từ '{thanhPhoHienTai}' sang '{thanhPhoMoi}'",
                            "Thông báo",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Information);

                        // Reload dữ liệu
                        LoadCurrentData();
                    }
                    else
                    {
                        MessageBox.Show(
                            "Cập nhật thất bại!",
                            "Lỗi",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Error);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
