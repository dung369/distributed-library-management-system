using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class FormNhaXB : Form
    {
        public FormNhaXB()
        {
            InitializeComponent();
        }

        private void FormNhaXB_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void LoadData()
        {
            string query = "SELECT MaNXB, TenNXB, ThanhPho, SiteLocation FROM V_NhaXB ORDER BY MaNXB";
            DataTable dt = DatabaseHelper.ExecuteQuery(query);
            dgvNhaXB.DataSource = dt;

            // Đặt tên cột hiển thị
            if (dgvNhaXB.Columns["MaNXB"] != null)
                dgvNhaXB.Columns["MaNXB"].HeaderText = "Mã NXB";
            if (dgvNhaXB.Columns["TenNXB"] != null)
                dgvNhaXB.Columns["TenNXB"].HeaderText = "Tên nhà xuất bản";
            if (dgvNhaXB.Columns["ThanhPho"] != null)
                dgvNhaXB.Columns["ThanhPho"].HeaderText = "Thành phố";
            if (dgvNhaXB.Columns["SiteLocation"] != null)
                dgvNhaXB.Columns["SiteLocation"].HeaderText = "Site lưu trữ";
        }

        private void dgvNhaXB_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dgvNhaXB.Rows[e.RowIndex];
                txtMaNXB.Text = row.Cells["MaNXB"].Value.ToString();
                txtTenNXB.Text = row.Cells["TenNXB"].Value.ToString();
                txtThanhPho.Text = row.Cells["ThanhPho"].Value.ToString();
            }
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaNXB.Text) || 
                string.IsNullOrWhiteSpace(txtTenNXB.Text) || 
                string.IsNullOrWhiteSpace(txtThanhPho.Text))
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (txtThanhPho.Text.Trim() != "T1" && txtThanhPho.Text.Trim() != "T2")
            {
                MessageBox.Show("Thành phố phải là T1 hoặc T2!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaNXB", txtMaNXB.Text.Trim()),
                new SqlParameter("@TenNXB", txtTenNXB.Text.Trim()),
                new SqlParameter("@ThanhPho", txtThanhPho.Text.Trim())
            };

            if (DatabaseHelper.ExecuteNonQuery("SP_INSERT_NHAXB", parameters))
            {
                MessageBox.Show("Thêm nhà xuất bản thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
                ClearFields();
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaNXB.Text))
            {
                MessageBox.Show("Vui lòng chọn nhà xuất bản cần sửa!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtTenNXB.Text) || string.IsNullOrWhiteSpace(txtThanhPho.Text))
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (txtThanhPho.Text.Trim() != "T1" && txtThanhPho.Text.Trim() != "T2")
            {
                MessageBox.Show("Thành phố phải là T1 hoặc T2!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@MaNXB", txtMaNXB.Text.Trim()),
                new SqlParameter("@TenNXB", txtTenNXB.Text.Trim()),
                new SqlParameter("@ThanhPho", txtThanhPho.Text.Trim())
            };

            if (DatabaseHelper.ExecuteNonQuery("SP_UPDATE_NHAXB", parameters))
            {
                MessageBox.Show("Cập nhật nhà xuất bản thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData();
                ClearFields();
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaNXB.Text))
            {
                MessageBox.Show("Vui lòng chọn nhà xuất bản cần xóa!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DialogResult result = MessageBox.Show(
                "Bạn có chắc muốn xóa nhà xuất bản này?",
                "Xác nhận",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@MaNXB", txtMaNXB.Text.Trim()),
                    new SqlParameter("@ThanhPho", txtThanhPho.Text.Trim())
                };

                if (DatabaseHelper.ExecuteNonQuery("SP_DELETE_NHAXB", parameters))
                {
                    MessageBox.Show("Xóa nhà xuất bản thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    LoadData();
                    ClearFields();
                }
            }
        }

        private void btnLamMoi_Click(object sender, EventArgs e)
        {
            ClearFields();
            LoadData();
        }

        private void ClearFields()
        {
            txtMaNXB.Clear();
            txtTenNXB.Clear();
            txtThanhPho.Clear();
            txtMaNXB.Focus();
        }

        private void btnDong_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
