using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class FormQuery1 : Form
    {
        private Label lblTenNXB;
        private ComboBox cboNXB;
        private Button btnTimKiem;
        private DataGridView dgvKetQua;

        public FormQuery1()
        {
            InitializeComponent();
            this.Text = "Truy vấn 1: Số lượng sách năm 1998 theo NXB";
            this.Size = new System.Drawing.Size(600, 400);
            this.StartPosition = FormStartPosition.CenterScreen;

            InitializeControls();
            LoadNhaXuatBan();
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(600, 400);
            this.Name = "FormQuery1";
            this.Text = "FormQuery1";
            this.ResumeLayout(false);
        }

        private void InitializeControls()
        {
            lblTenNXB = new Label { Text = "Chọn nhà xuất bản:", Location = new System.Drawing.Point(20, 20), Width = 130 };
            cboNXB = new ComboBox { 
                Location = new System.Drawing.Point(160, 20), 
                Width = 300,
                DropDownStyle = ComboBoxStyle.DropDownList
            };
            btnTimKiem = new Button { Text = "Tìm kiếm", Location = new System.Drawing.Point(470, 18), Width = 100 };
            btnTimKiem.Click += BtnTimKiem_Click;

            dgvKetQua = new DataGridView
            {
                Location = new System.Drawing.Point(20, 60),
                Size = new System.Drawing.Size(550, 280),
                ReadOnly = true,
                AllowUserToAddRows = false,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            };

            this.Controls.AddRange(new Control[] { lblTenNXB, cboNXB, btnTimKiem, dgvKetQua });
        }

        private void LoadNhaXuatBan()
        {
            try
            {
                string sql = "SELECT MaNXB, TenNXB FROM V_NhaXB ORDER BY TenNXB";
                DataTable dt = DatabaseHelper.ExecuteQuery(sql);
                cboNXB.DataSource = dt;
                cboNXB.DisplayMember = "TenNXB";
                cboNXB.ValueMember = "TenNXB";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi load danh sách NXB: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnTimKiem_Click(object sender, EventArgs e)
        {
            try
            {
                if (cboNXB.SelectedValue == null)
                {
                    MessageBox.Show("Vui lòng chọn nhà xuất bản!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                string tenNXB = cboNXB.SelectedValue.ToString();
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@TenNXB", tenNXB)
                };

                DataTable dt = DatabaseHelper.ExecuteStoredProcedure("SP_Query1_SachNam1998", parameters);
                dgvKetQua.DataSource = dt;

                if (dgvKetQua.Columns.Count > 0)
                {
                    dgvKetQua.Columns["SoLuongSach"].HeaderText = "Số lượng sách năm 1998";
                }

                if (dt.Rows.Count > 0)
                {
                    int soLuong = Convert.ToInt32(dt.Rows[0]["SoLuongSach"]);
                    MessageBox.Show(
                        $"Nhà xuất bản '{tenNXB}' có {soLuong} sách xuất bản năm 1998",
                        "Kết quả",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show(
                        $"Nhà xuất bản '{tenNXB}' không có sách nào xuất bản năm 1998",
                        "Kết quả",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
