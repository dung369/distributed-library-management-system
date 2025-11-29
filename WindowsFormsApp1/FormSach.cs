using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace WindowsFormsApp1
{
    public class FormSach : Form
    {
        private TextBox txtMaSach;
        private TextBox txtTenSach;
        private TextBox txtNamXB;
        private ComboBox cboMaNXB;
        private ComboBox cboMaTG;
        private DataGridView dgvSach;
        private Button btnThem;
        private Button btnSua;
        private Button btnXoa;
        private Button btnLamMoi;
        private Button btnThoat;

        public FormSach()
        {
            InitializeComponent();
            InitializeCustomComponents();
            LoadData();
            LoadComboBoxes();
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(900, 600);
            this.Name = "FormSach";
            this.Text = "Quản lý Sách";
            this.StartPosition = FormStartPosition.CenterScreen;
            this.ResumeLayout(false);
        }

        private void InitializeCustomComponents()
        {
            this.Text = "Quản lý Sách";
            this.Size = new Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;

            // GroupBox Thông tin
            GroupBox grpThongTin = new GroupBox();
            grpThongTin.Text = "Thông tin Sách";
            grpThongTin.Location = new Point(20, 20);
            grpThongTin.Size = new Size(850, 150);

            // Labels
            Label lblMaSach = new Label() { Text = "Mã sách:", Location = new Point(20, 30), Size = new Size(100, 20) };
            Label lblTenSach = new Label() { Text = "Tên sách:", Location = new Point(20, 60), Size = new Size(100, 20) };
            Label lblNamXB = new Label() { Text = "Năm XB:", Location = new Point(20, 90), Size = new Size(100, 20) };
            Label lblMaNXB = new Label() { Text = "Nhà XB:", Location = new Point(450, 30), Size = new Size(100, 20) };
            Label lblMaTG = new Label() { Text = "Tác giả:", Location = new Point(450, 60), Size = new Size(100, 20) };

            // TextBoxes
            txtMaSach = new TextBox() { Location = new Point(130, 30), Size = new Size(250, 20), MaxLength = 5 };
            txtTenSach = new TextBox() { Location = new Point(130, 60), Size = new Size(250, 20), MaxLength = 100 };
            txtNamXB = new TextBox() { Location = new Point(130, 90), Size = new Size(250, 20) };

            // ComboBoxes
            cboMaNXB = new ComboBox() { Location = new Point(560, 30), Size = new Size(250, 20), DropDownStyle = ComboBoxStyle.DropDownList };
            cboMaTG = new ComboBox() { Location = new Point(560, 60), Size = new Size(250, 20), DropDownStyle = ComboBoxStyle.DropDownList };

            // Add controls to GroupBox
            grpThongTin.Controls.AddRange(new Control[] { 
                lblMaSach, lblTenSach, lblNamXB, lblMaNXB, lblMaTG,
                txtMaSach, txtTenSach, txtNamXB, cboMaNXB, cboMaTG
            });

            // Buttons
            btnThem = new Button() { Text = "Thêm", Location = new Point(20, 180), Size = new Size(100, 30) };
            btnSua = new Button() { Text = "Sửa", Location = new Point(130, 180), Size = new Size(100, 30) };
            btnXoa = new Button() { Text = "Xóa", Location = new Point(240, 180), Size = new Size(100, 30) };
            btnLamMoi = new Button() { Text = "Làm mới", Location = new Point(350, 180), Size = new Size(100, 30) };
            btnThoat = new Button() { Text = "Thoát", Location = new Point(460, 180), Size = new Size(100, 30) };

            btnThem.Click += BtnThem_Click;
            btnSua.Click += BtnSua_Click;
            btnXoa.Click += BtnXoa_Click;
            btnLamMoi.Click += BtnLamMoi_Click;
            btnThoat.Click += (s, e) => this.Close();

            // DataGridView
            dgvSach = new DataGridView();
            dgvSach.Location = new Point(20, 220);
            dgvSach.Size = new Size(850, 320);
            dgvSach.ReadOnly = true;
            dgvSach.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvSach.AllowUserToAddRows = false;
            dgvSach.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvSach.SelectionChanged += DgvSach_SelectionChanged;

            // Add to Form
            this.Controls.AddRange(new Control[] { 
                grpThongTin, btnThem, btnSua, btnXoa, btnLamMoi, btnThoat, dgvSach 
            });
        }

        private void LoadComboBoxes()
        {
            try
            {
                // Load Nhà xuất bản
                string sqlNXB = "SELECT MaNXB, TenNXB FROM V_NhaXB ORDER BY TenNXB";
                DataTable dtNXB = DatabaseHelper.ExecuteQuery(sqlNXB);
                cboMaNXB.DataSource = dtNXB;
                cboMaNXB.DisplayMember = "TenNXB";
                cboMaNXB.ValueMember = "MaNXB";

                // Load Tác giả
                string sqlTG = "SELECT MaTG, TenTG FROM V_TacGia ORDER BY TenTG";
                DataTable dtTG = DatabaseHelper.ExecuteQuery(sqlTG);
                cboMaTG.DataSource = dtTG;
                cboMaTG.DisplayMember = "TenTG";
                cboMaTG.ValueMember = "MaTG";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi load danh sách: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void LoadData()
        {
            try
            {
                string sql = "SELECT MaSach, TenSach, NamXB, MaNXB, MaTG, SiteLocation FROM V_Sach ORDER BY MaSach";
                DataTable dt = DatabaseHelper.ExecuteQuery(sql);
                dgvSach.DataSource = dt;

                // Đặt tên cột
                if (dgvSach.Columns.Count > 0)
                {
                    dgvSach.Columns["MaSach"].HeaderText = "Mã sách";
                    dgvSach.Columns["TenSach"].HeaderText = "Tên sách";
                    dgvSach.Columns["NamXB"].HeaderText = "Năm XB";
                    dgvSach.Columns["MaNXB"].HeaderText = "Mã NXB";
                    dgvSach.Columns["MaTG"].HeaderText = "Mã TG";
                    dgvSach.Columns["SiteLocation"].HeaderText = "Site";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi load dữ liệu: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void DgvSach_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvSach.CurrentRow != null && dgvSach.CurrentRow.Index >= 0)
            {
                DataGridViewRow row = dgvSach.CurrentRow;
                txtMaSach.Text = row.Cells["MaSach"].Value?.ToString() ?? "";
                txtTenSach.Text = row.Cells["TenSach"].Value?.ToString() ?? "";
                txtNamXB.Text = row.Cells["NamXB"].Value?.ToString() ?? "";
                cboMaNXB.SelectedValue = row.Cells["MaNXB"].Value;
                cboMaTG.SelectedValue = row.Cells["MaTG"].Value;
            }
        }

        private void BtnThem_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtMaSach.Text) || string.IsNullOrWhiteSpace(txtTenSach.Text))
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                if (!int.TryParse(txtNamXB.Text, out int namXB) || namXB < 1900 || namXB > DateTime.Now.Year)
                {
                    MessageBox.Show("Năm xuất bản không hợp lệ!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@MaSach", txtMaSach.Text.Trim()),
                    new SqlParameter("@TenSach", txtTenSach.Text.Trim()),
                    new SqlParameter("@NamXB", namXB),
                    new SqlParameter("@MaNXB", cboMaNXB.SelectedValue),
                    new SqlParameter("@MaTG", cboMaTG.SelectedValue)
                };

                DatabaseHelper.ExecuteStoredProcedure("SP_INSERT_SACH", parameters);
                MessageBox.Show("Thêm sách thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
                ClearInputs();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnSua_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtMaSach.Text))
                {
                    MessageBox.Show("Vui lòng chọn sách cần sửa!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                if (!int.TryParse(txtNamXB.Text, out int namXB) || namXB < 1900 || namXB > DateTime.Now.Year)
                {
                    MessageBox.Show("Năm xuất bản không hợp lệ!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@MaSach", txtMaSach.Text.Trim()),
                    new SqlParameter("@TenSach", txtTenSach.Text.Trim()),
                    new SqlParameter("@NamXB", namXB),
                    new SqlParameter("@MaNXB", cboMaNXB.SelectedValue),
                    new SqlParameter("@MaTG", cboMaTG.SelectedValue)
                };

                DatabaseHelper.ExecuteStoredProcedure("SP_UPDATE_SACH", parameters);
                MessageBox.Show("Cập nhật sách thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnXoa_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtMaSach.Text))
                {
                    MessageBox.Show("Vui lòng chọn sách cần xóa!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                DialogResult result = MessageBox.Show(
                    $"Bạn có chắc muốn xóa sách '{txtTenSach.Text}'?",
                    "Xác nhận xóa",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question
                );

                if (result == DialogResult.Yes)
                {
                    SqlParameter[] parameters = new SqlParameter[]
                    {
                        new SqlParameter("@MaSach", txtMaSach.Text.Trim())
                    };

                    DatabaseHelper.ExecuteStoredProcedure("SP_DELETE_SACH", parameters);
                    MessageBox.Show("Xóa sách thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    LoadData();
                    ClearInputs();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnLamMoi_Click(object sender, EventArgs e)
        {
            ClearInputs();
            LoadData();
            LoadComboBoxes();
        }

        private void ClearInputs()
        {
            txtMaSach.Clear();
            txtTenSach.Clear();
            txtNamXB.Clear();
            if (cboMaNXB.Items.Count > 0) cboMaNXB.SelectedIndex = 0;
            if (cboMaTG.Items.Count > 0) cboMaTG.SelectedIndex = 0;
            txtMaSach.Focus();
        }
    }
}
