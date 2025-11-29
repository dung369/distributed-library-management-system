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
    public class FormMuon : Form
    {
        private ComboBox cboMaDG;
        private ComboBox cboMaSach;
        private DateTimePicker dtpNgayMuon;
        private DateTimePicker dtpNgayTra;
        private DataGridView dgvMuon;
        private Button btnThem;
        private Button btnSua;
        private Button btnXoa;
        private Button btnLamMoi;
        private Button btnThoat;

        public FormMuon()
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
            this.Name = "FormMuon";
            this.Text = "Quản lý Mượn sách";
            this.StartPosition = FormStartPosition.CenterScreen;
            this.ResumeLayout(false);
        }

        private void InitializeCustomComponents()
        {
            this.Text = "Quản lý Mượn sách";
            this.Size = new Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;

            // GroupBox Thông tin
            GroupBox grpThongTin = new GroupBox();
            grpThongTin.Text = "Thông tin Mượn sách";
            grpThongTin.Location = new Point(20, 20);
            grpThongTin.Size = new Size(850, 150);

            // Labels
            Label lblMaDG = new Label() { Text = "Độc giả:", Location = new Point(20, 30), Size = new Size(100, 20) };
            Label lblMaSach = new Label() { Text = "Sách:", Location = new Point(20, 60), Size = new Size(100, 20) };
            Label lblNgayMuon = new Label() { Text = "Ngày mượn:", Location = new Point(450, 30), Size = new Size(100, 20) };
            Label lblNgayTra = new Label() { Text = "Ngày trả:", Location = new Point(450, 60), Size = new Size(100, 20) };

            // ComboBoxes
            cboMaDG = new ComboBox() { Location = new Point(130, 30), Size = new Size(250, 20), DropDownStyle = ComboBoxStyle.DropDownList };
            cboMaSach = new ComboBox() { Location = new Point(130, 60), Size = new Size(250, 20), DropDownStyle = ComboBoxStyle.DropDownList };

            // DateTimePickers
            dtpNgayMuon = new DateTimePicker() { Location = new Point(560, 30), Size = new Size(250, 20), Format = DateTimePickerFormat.Short };
            dtpNgayTra = new DateTimePicker() { Location = new Point(560, 60), Size = new Size(250, 20), Format = DateTimePickerFormat.Short };

            // Add controls to GroupBox
            grpThongTin.Controls.AddRange(new Control[] { 
                lblMaDG, lblMaSach, lblNgayMuon, lblNgayTra,
                cboMaDG, cboMaSach, dtpNgayMuon, dtpNgayTra
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
            dgvMuon = new DataGridView();
            dgvMuon.Location = new Point(20, 220);
            dgvMuon.Size = new Size(850, 320);
            dgvMuon.ReadOnly = true;
            dgvMuon.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvMuon.AllowUserToAddRows = false;
            dgvMuon.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvMuon.SelectionChanged += DgvMuon_SelectionChanged;

            // Add to Form
            this.Controls.AddRange(new Control[] { 
                grpThongTin, btnThem, btnSua, btnXoa, btnLamMoi, btnThoat, dgvMuon 
            });
        }

        private void LoadComboBoxes()
        {
            try
            {
                // Load Độc giả
                string sqlDG = "SELECT MaDG, TenDG FROM V_DocGia ORDER BY TenDG";
                DataTable dtDG = DatabaseHelper.ExecuteQuery(sqlDG);
                cboMaDG.DataSource = dtDG;
                cboMaDG.DisplayMember = "TenDG";
                cboMaDG.ValueMember = "MaDG";

                // Load Sách
                string sqlSach = "SELECT MaSach, TenSach FROM V_Sach ORDER BY TenSach";
                DataTable dtSach = DatabaseHelper.ExecuteQuery(sqlSach);
                cboMaSach.DataSource = dtSach;
                cboMaSach.DisplayMember = "TenSach";
                cboMaSach.ValueMember = "MaSach";
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
                string sql = "SELECT MaDG, MaSach, NgayMuon, NgayTra, SiteLocation FROM V_Muon ORDER BY NgayMuon DESC";
                DataTable dt = DatabaseHelper.ExecuteQuery(sql);
                dgvMuon.DataSource = dt;

                // Đặt tên cột
                if (dgvMuon.Columns.Count > 0)
                {
                    dgvMuon.Columns["MaDG"].HeaderText = "Mã ĐG";
                    dgvMuon.Columns["MaSach"].HeaderText = "Mã sách";
                    dgvMuon.Columns["NgayMuon"].HeaderText = "Ngày mượn";
                    dgvMuon.Columns["NgayTra"].HeaderText = "Ngày trả";
                    dgvMuon.Columns["SiteLocation"].HeaderText = "Site";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi load dữ liệu: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void DgvMuon_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvMuon.CurrentRow != null && dgvMuon.CurrentRow.Index >= 0)
            {
                DataGridViewRow row = dgvMuon.CurrentRow;
                cboMaDG.SelectedValue = row.Cells["MaDG"].Value;
                cboMaSach.SelectedValue = row.Cells["MaSach"].Value;
                
                if (row.Cells["NgayMuon"].Value != DBNull.Value)
                    dtpNgayMuon.Value = Convert.ToDateTime(row.Cells["NgayMuon"].Value);
                
                if (row.Cells["NgayTra"].Value != DBNull.Value)
                    dtpNgayTra.Value = Convert.ToDateTime(row.Cells["NgayTra"].Value);
            }
        }

        private void BtnThem_Click(object sender, EventArgs e)
        {
            try
            {
                if (cboMaDG.SelectedValue == null || cboMaSach.SelectedValue == null)
                {
                    MessageBox.Show("Vui lòng chọn độc giả và sách!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                if (dtpNgayTra.Value < dtpNgayMuon.Value)
                {
                    MessageBox.Show("Ngày trả phải sau ngày mượn!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@MaDG", cboMaDG.SelectedValue),
                    new SqlParameter("@MaSach", cboMaSach.SelectedValue),
                    new SqlParameter("@NgayMuon", dtpNgayMuon.Value),
                    new SqlParameter("@NgayTra", dtpNgayTra.Value)
                };

                DatabaseHelper.ExecuteStoredProcedure("SP_INSERT_MUON", parameters);
                MessageBox.Show("Thêm phiếu mượn thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
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
                if (dgvMuon.CurrentRow == null)
                {
                    MessageBox.Show("Vui lòng chọn phiếu mượn cần sửa!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                if (dtpNgayTra.Value < dtpNgayMuon.Value)
                {
                    MessageBox.Show("Ngày trả phải sau ngày mượn!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@MaDG", cboMaDG.SelectedValue),
                    new SqlParameter("@MaSach", cboMaSach.SelectedValue),
                    new SqlParameter("@NgayMuon", dtpNgayMuon.Value),
                    new SqlParameter("@NgayTra", dtpNgayTra.Value)
                };

                DatabaseHelper.ExecuteStoredProcedure("SP_UPDATE_MUON", parameters);
                MessageBox.Show("Cập nhật phiếu mượn thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
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
                if (dgvMuon.CurrentRow == null)
                {
                    MessageBox.Show("Vui lòng chọn phiếu mượn cần xóa!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                DialogResult result = MessageBox.Show(
                    "Bạn có chắc muốn xóa phiếu mượn này?",
                    "Xác nhận xóa",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question
                );

                if (result == DialogResult.Yes)
                {
                    SqlParameter[] parameters = new SqlParameter[]
                    {
                        new SqlParameter("@MaDG", cboMaDG.SelectedValue),
                        new SqlParameter("@MaSach", cboMaSach.SelectedValue),
                        new SqlParameter("@NgayMuon", dtpNgayMuon.Value)
                    };

                    DatabaseHelper.ExecuteStoredProcedure("SP_DELETE_MUON", parameters);
                    MessageBox.Show("Xóa phiếu mượn thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    LoadData();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnLamMoi_Click(object sender, EventArgs e)
        {
            LoadData();
            LoadComboBoxes();
            dtpNgayMuon.Value = DateTime.Now;
            dtpNgayTra.Value = DateTime.Now.AddDays(14);
        }
    }
}
