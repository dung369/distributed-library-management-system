// Tạo các forms còn lại với cấu trúc tương tự FormNhaXB

using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    // Form quản lý Tác giả - Tương tự FormNhaXB
    public partial class FormTacGia : Form
    {
        private TextBox txtMaTG, txtTenTG, txtChuyenMon;
        private DataGridView dgvTacGia;
        private Button btnThem, btnSua, btnXoa, btnLamMoi, btnDong;

        public FormTacGia()
        {
            InitializeComponent();
            this.Text = "Quản lý Tác giả";
            this.Size = new System.Drawing.Size(850, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
            InitializeControls();
            LoadData();
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.ResumeLayout(false);
        }

        private void InitializeControls()
        {
            // Group thông tin
            GroupBox grpThongTin = new GroupBox { Text = "Thông tin tác giả", Location = new System.Drawing.Point(12, 12), Size = new System.Drawing.Size(810, 120) };
            
            Label lblMaTG = new Label { Text = "Mã tác giả:", Location = new System.Drawing.Point(20, 25), Width = 100 };
            txtMaTG = new TextBox { Location = new System.Drawing.Point(130, 22), Width = 150, MaxLength = 5 };
            
            Label lblTenTG = new Label { Text = "Tên tác giả:", Location = new System.Drawing.Point(20, 55), Width = 100 };
            txtTenTG = new TextBox { Location = new System.Drawing.Point(130, 52), Width = 400 };
            
            Label lblChuyenMon = new Label { Text = "Chuyên môn:", Location = new System.Drawing.Point(20, 85), Width = 100 };
            txtChuyenMon = new TextBox { Location = new System.Drawing.Point(130, 82), Width = 200 };
            
            grpThongTin.Controls.AddRange(new Control[] { lblMaTG, txtMaTG, lblTenTG, txtTenTG, lblChuyenMon, txtChuyenMon });

            // Buttons
            btnThem = new Button { Text = "Thêm", Location = new System.Drawing.Point(12, 148), Size = new System.Drawing.Size(100, 30) };
            btnThem.Click += btnThem_Click;
            
            btnSua = new Button { Text = "Sửa", Location = new System.Drawing.Point(128, 148), Size = new System.Drawing.Size(100, 30) };
            btnSua.Click += btnSua_Click;
            
            btnXoa = new Button { Text = "Xóa", Location = new System.Drawing.Point(244, 148), Size = new System.Drawing.Size(100, 30) };
            btnXoa.Click += btnXoa_Click;
            
            btnLamMoi = new Button { Text = "Làm mới", Location = new System.Drawing.Point(360, 148), Size = new System.Drawing.Size(100, 30) };
            btnLamMoi.Click += (s, e) => { ClearFields(); LoadData(); };
            
            btnDong = new Button { Text = "Đóng", Location = new System.Drawing.Point(722, 148), Size = new System.Drawing.Size(100, 30) };
            btnDong.Click += (s, e) => this.Close();

            // DataGridView
            GroupBox grpDanhSach = new GroupBox { Text = "Danh sách tác giả", Location = new System.Drawing.Point(12, 188), Size = new System.Drawing.Size(810, 250) };
            dgvTacGia = new DataGridView
            {
                Dock = DockStyle.Fill,
                ReadOnly = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            };
            dgvTacGia.CellClick += (s, e) =>
            {
                if (e.RowIndex >= 0)
                {
                    DataGridViewRow row = dgvTacGia.Rows[e.RowIndex];
                    txtMaTG.Text = row.Cells["MaTG"].Value.ToString();
                    txtTenTG.Text = row.Cells["TenTG"].Value.ToString();
                    txtChuyenMon.Text = row.Cells["ChuyenMon"].Value.ToString();
                }
            };
            grpDanhSach.Controls.Add(dgvTacGia);

            this.Controls.AddRange(new Control[] { grpThongTin, grpDanhSach, btnThem, btnSua, btnXoa, btnLamMoi, btnDong });
        }

        private void LoadData()
        {
            dgvTacGia.DataSource = DatabaseHelper.ExecuteQuery("SELECT MaTG, TenTG, ChuyenMon, SiteLocation FROM V_TacGia ORDER BY MaTG");
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaTG.Text) || string.IsNullOrWhiteSpace(txtTenTG.Text) || string.IsNullOrWhiteSpace(txtChuyenMon.Text))
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (txtChuyenMon.Text.Trim() != "Điện tử" && txtChuyenMon.Text.Trim() != "Máy tính")
            {
                MessageBox.Show("Chuyên môn phải là 'Điện tử' hoặc 'Máy tính'!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaTG", txtMaTG.Text.Trim()),
                new SqlParameter("@TenTG", txtTenTG.Text.Trim()),
                new SqlParameter("@ChuyenMon", txtChuyenMon.Text.Trim())
            };

            if (DatabaseHelper.ExecuteNonQuery("SP_INSERT_TACGIA", parameters))
            {
                MessageBox.Show("Thêm tác giả thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
                ClearFields();
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaTG.Text))
            {
                MessageBox.Show("Vui lòng chọn tác giả cần sửa!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaTG", txtMaTG.Text.Trim()),
                new SqlParameter("@TenTG", txtTenTG.Text.Trim()),
                new SqlParameter("@ChuyenMon", txtChuyenMon.Text.Trim())
            };

            if (DatabaseHelper.ExecuteNonQuery("SP_UPDATE_TACGIA", parameters))
            {
                MessageBox.Show("Cập nhật tác giả thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
                ClearFields();
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaTG.Text))
            {
                MessageBox.Show("Vui lòng chọn tác giả cần xóa!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (MessageBox.Show("Bạn có chắc muốn xóa tác giả này?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                if (DatabaseHelper.ExecuteNonQuery("SP_DELETE_TACGIA", new SqlParameter[] { new SqlParameter("@MaTG", txtMaTG.Text.Trim()) }))
                {
                    MessageBox.Show("Xóa tác giả thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    LoadData();
                    ClearFields();
                }
            }
        }

        private void ClearFields()
        {
            txtMaTG.Clear();
            txtTenTG.Clear();
            txtChuyenMon.Clear();
            txtMaTG.Focus();
        }
    }

    // Form quản lý Độc giả
    public partial class FormDocGia : Form
    {
        private TextBox txtMaDG, txtTenDG, txtDoiTuong;
        private DataGridView dgvDocGia;
        private Button btnThem, btnSua, btnXoa, btnLamMoi, btnDong;

        public FormDocGia()
        {
            InitializeComponent();
            this.Text = "Quản lý Độc giả";
            this.Size = new System.Drawing.Size(850, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
            InitializeControls();
            LoadData();
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.ResumeLayout(false);
        }

        private void InitializeControls()
        {
            // Group thông tin
            GroupBox grpThongTin = new GroupBox { Text = "Thông tin độc giả", Location = new System.Drawing.Point(12, 12), Size = new System.Drawing.Size(810, 100) };
            
            Label lblMaDG = new Label { Text = "Mã độc giả:", Location = new System.Drawing.Point(20, 25), Width = 100 };
            txtMaDG = new TextBox { Location = new System.Drawing.Point(130, 22), Width = 150, MaxLength = 5 };
            
            Label lblTenDG = new Label { Text = "Tên độc giả:", Location = new System.Drawing.Point(20, 55), Width = 100 };
            txtTenDG = new TextBox { Location = new System.Drawing.Point(130, 52), Width = 400 };
            
            Label lblDoiTuong = new Label { Text = "Đối tượng (HS/SV):", Location = new System.Drawing.Point(20, 85), Width = 120 };
            txtDoiTuong = new TextBox { Location = new System.Drawing.Point(150, 82), Width = 100, MaxLength = 2 };
            
            grpThongTin.Controls.AddRange(new Control[] { lblMaDG, txtMaDG, lblTenDG, txtTenDG, lblDoiTuong, txtDoiTuong });

            // Buttons
            btnThem = new Button { Text = "Thêm", Location = new System.Drawing.Point(12, 128), Size = new System.Drawing.Size(100, 30) };
            btnThem.Click += btnThem_Click;
            
            btnSua = new Button { Text = "Sửa", Location = new System.Drawing.Point(128, 128), Size = new System.Drawing.Size(100, 30) };
            btnSua.Click += btnSua_Click;
            
            btnXoa = new Button { Text = "Xóa", Location = new System.Drawing.Point(244, 128), Size = new System.Drawing.Size(100, 30) };
            btnXoa.Click += btnXoa_Click;
            
            btnLamMoi = new Button { Text = "Làm mới", Location = new System.Drawing.Point(360, 128), Size = new System.Drawing.Size(100, 30) };
            btnLamMoi.Click += (s, e) => { ClearFields(); LoadData(); };
            
            btnDong = new Button { Text = "Đóng", Location = new System.Drawing.Point(722, 128), Size = new System.Drawing.Size(100, 30) };
            btnDong.Click += (s, e) => this.Close();

            // DataGridView
            GroupBox grpDanhSach = new GroupBox { Text = "Danh sách độc giả", Location = new System.Drawing.Point(12, 168), Size = new System.Drawing.Size(810, 270) };
            dgvDocGia = new DataGridView
            {
                Dock = DockStyle.Fill,
                ReadOnly = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            };
            dgvDocGia.CellClick += (s, e) =>
            {
                if (e.RowIndex >= 0)
                {
                    DataGridViewRow row = dgvDocGia.Rows[e.RowIndex];
                    txtMaDG.Text = row.Cells["MaDG"].Value.ToString();
                    txtTenDG.Text = row.Cells["TenDG"].Value.ToString();
                    txtDoiTuong.Text = row.Cells["DoiTuong"].Value.ToString();
                }
            };
            grpDanhSach.Controls.Add(dgvDocGia);

            this.Controls.AddRange(new Control[] { grpThongTin, grpDanhSach, btnThem, btnSua, btnXoa, btnLamMoi, btnDong });
        }

        private void LoadData()
        {
            dgvDocGia.DataSource = DatabaseHelper.ExecuteQuery("SELECT MaDG, TenDG, DoiTuong, SiteLocation FROM V_DocGia ORDER BY MaDG");
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaDG.Text) || string.IsNullOrWhiteSpace(txtTenDG.Text) || string.IsNullOrWhiteSpace(txtDoiTuong.Text))
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (txtDoiTuong.Text.Trim() != "HS" && txtDoiTuong.Text.Trim() != "SV")
            {
                MessageBox.Show("Đối tượng phải là 'HS' hoặc 'SV'!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaDG", txtMaDG.Text.Trim()),
                new SqlParameter("@TenDG", txtTenDG.Text.Trim()),
                new SqlParameter("@DoiTuong", txtDoiTuong.Text.Trim())
            };

            if (DatabaseHelper.ExecuteNonQuery("SP_INSERT_DOCGIA", parameters))
            {
                MessageBox.Show("Thêm độc giả thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
                ClearFields();
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaDG.Text))
            {
                MessageBox.Show("Vui lòng chọn độc giả cần sửa!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (txtDoiTuong.Text.Trim() != "HS" && txtDoiTuong.Text.Trim() != "SV")
            {
                MessageBox.Show("Đối tượng phải là 'HS' hoặc 'SV'!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaDG", txtMaDG.Text.Trim()),
                new SqlParameter("@TenDG", txtTenDG.Text.Trim()),
                new SqlParameter("@DoiTuong", txtDoiTuong.Text.Trim())
            };

            if (DatabaseHelper.ExecuteNonQuery("SP_UPDATE_DOCGIA", parameters))
            {
                MessageBox.Show("Cập nhật độc giả thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
                ClearFields();
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaDG.Text))
            {
                MessageBox.Show("Vui lòng chọn độc giả cần xóa!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (MessageBox.Show("Bạn có chắc muốn xóa độc giả này?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                if (DatabaseHelper.ExecuteNonQuery("SP_DELETE_DOCGIA", new SqlParameter[] { new SqlParameter("@MaDG", txtMaDG.Text.Trim()) }))
                {
                    MessageBox.Show("Xóa độc giả thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    LoadData();
                    ClearFields();
                }
            }
        }

        private void ClearFields()
        {
            txtMaDG.Clear();
            txtTenDG.Clear();
            txtDoiTuong.Clear();
            txtMaDG.Focus();
        }
    }
}
