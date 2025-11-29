using System;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class FormMain : Form
    {
        public FormMain()
        {
            InitializeComponent();
        }

        private void menuNhaXB_Click(object sender, EventArgs e)
        {
            FormNhaXB form = new FormNhaXB();
            form.ShowDialog();
        }

        private void menuTacGia_Click(object sender, EventArgs e)
        {
            FormTacGia form = new FormTacGia();
            form.ShowDialog();
        }

        private void menuSach_Click(object sender, EventArgs e)
        {
            FormSach form = new FormSach();
            form.ShowDialog();
        }

        private void menuDocGia_Click(object sender, EventArgs e)
        {
            FormDocGia form = new FormDocGia();
            form.ShowDialog();
        }

        private void menuMuonSach_Click(object sender, EventArgs e)
        {
            FormMuon form = new FormMuon();
            form.ShowDialog();
        }

        private void menuQuery1_Click(object sender, EventArgs e)
        {
            FormQuery1 form = new FormQuery1();
            form.ShowDialog();
        }

        private void menuQuery2_Click(object sender, EventArgs e)
        {
            FormQuery2 form = new FormQuery2();
            form.ShowDialog();
        }

        private void menuQuery3_Click(object sender, EventArgs e)
        {
            FormQuery3 form = new FormQuery3();
            form.ShowDialog();
        }

        private void menuThoat_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Bạn có chắc muốn thoát?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void menuGioiThieu_Click(object sender, EventArgs e)
        {
            FormAbout form = new FormAbout();
            form.ShowDialog();
        }
    }
}
