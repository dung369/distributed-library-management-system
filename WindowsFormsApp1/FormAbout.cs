using System;
using System.Drawing;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class FormAbout : Form
    {
        public FormAbout()
        {
            InitializeComponent();
            InitializeCustomComponents();
        }

        private void InitializeCustomComponents()
        {
            this.Text = "Giới thiệu đề tài";
            this.Size = new Size(700, 650);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;

            // Panel chính
            Panel pnlMain = new Panel();
            pnlMain.Location = new Point(10, 10);
            pnlMain.Size = new Size(660, 550);
            pnlMain.AutoScroll = true;
            pnlMain.BorderStyle = BorderStyle.FixedSingle;

            // Title
            Label lblTitle = new Label();
            lblTitle.Text = "ĐỒ ÁN MÔN HỌC 10:\nCƠ SỞ DỮ LIỆU PHÂN TÁN";
            lblTitle.Font = new Font("Arial", 16, FontStyle.Bold);
            lblTitle.ForeColor = Color.DarkBlue;
            lblTitle.Location = new Point(20, 20);
            lblTitle.Size = new Size(600, 80);
            lblTitle.TextAlign = ContentAlignment.MiddleCenter;

            // Giới thiệu
            Label lblGioiThieu = new Label();
            lblGioiThieu.Text = "🎯 Giới thiệu đề tài";
            lblGioiThieu.Font = new Font("Arial", 12, FontStyle.Bold);
            lblGioiThieu.ForeColor = Color.DarkGreen;
            lblGioiThieu.Location = new Point(20, 110);
            lblGioiThieu.Size = new Size(600, 25);

            Label lblGioiThieuContent = new Label();
            lblGioiThieuContent.Text = @"Đề tài mô phỏng hệ thống quản lý thư viện phân tán, bao gồm nhà xuất bản, 
sách, tác giả, độc giả và việc mượn sách. Ứng dụng được triển khai trong môi trường 
cơ sở dữ liệu phân tán, cho phép người dùng thực hiện CRUD và 3 truy vấn toàn cục 
minh họa các mức trong suốt.";
            lblGioiThieuContent.Font = new Font("Arial", 10);
            lblGioiThieuContent.Location = new Point(20, 140);
            lblGioiThieuContent.Size = new Size(600, 80);

            // Lược đồ CSDL
            Label lblSchema = new Label();
            lblSchema.Text = "📊 Lược đồ cơ sở dữ liệu";
            lblSchema.Font = new Font("Arial", 12, FontStyle.Bold);
            lblSchema.ForeColor = Color.DarkGreen;
            lblSchema.Location = new Point(20, 230);
            lblSchema.Size = new Size(600, 25);

            Label lblSchemaContent = new Label();
            lblSchemaContent.Text = @"• NhaXB(MaNXB, TenNXB, ThanhPho)
• Sach(MaSach, TenSach, NamXB, MaNXB, MaTG)
• DocGia(MaDG, TenDG, DoiTuong)
• TacGia(MaTG, TenTG, ChuyenMon)
• Muon(MaDG, MaSach, NgayMuon, NgayTra)";
            lblSchemaContent.Font = new Font("Consolas", 9);
            lblSchemaContent.Location = new Point(40, 260);
            lblSchemaContent.Size = new Size(600, 100);

            // Chức năng
            Label lblChucNang = new Label();
            lblChucNang.Text = "⚙️ Chức năng của ứng dụng";
            lblChucNang.Font = new Font("Arial", 12, FontStyle.Bold);
            lblChucNang.ForeColor = Color.DarkGreen;
            lblChucNang.Location = new Point(20, 370);
            lblChucNang.Size = new Size(600, 25);

            Label lblChucNangContent = new Label();
            lblChucNangContent.Text = @"✓ Quản lý CRUD cho 5 bảng: Nhà xuất bản, Sách, Tác giả, Độc giả, Mượn sách
✓ 3 truy vấn toàn cục:
   1. Số lượng sách xuất bản năm 1998 theo nhà xuất bản
   2. Sách của tác giả được mượn trong khoảng thời gian
   3. Cập nhật thành phố nhà xuất bản KHKT từ T2 sang T1";
            lblChucNangContent.Font = new Font("Arial", 10);
            lblChucNangContent.Location = new Point(40, 400);
            lblChucNangContent.Size = new Size(600, 90);

            // Mức trong suốt
            Label lblTrongSuot = new Label();
            lblTrongSuot.Text = "🔍 Mức trong suốt được thể hiện";
            lblTrongSuot.Font = new Font("Arial", 12, FontStyle.Bold);
            lblTrongSuot.ForeColor = Color.DarkGreen;
            lblTrongSuot.Location = new Point(20, 500);
            lblTrongSuot.Size = new Size(600, 25);

            Label lblTrongSuotContent = new Label();
            lblTrongSuotContent.Text = @"• Trong suốt phân mảnh: Người dùng thao tác như thể chỉ có một bảng duy nhất
  (View toàn cục sử dụng UNION ALL)

• Trong suốt vị trí: Người dùng không cần biết dữ liệu ở site nào
  (View tham chiếu trực tiếp đến database site)";
            lblTrongSuotContent.Font = new Font("Arial", 10);
            lblTrongSuotContent.Location = new Point(40, 530);
            lblTrongSuotContent.Size = new Size(600, 80);

            // Thêm tất cả vào panel
            pnlMain.Controls.AddRange(new Control[] {
                lblTitle, lblGioiThieu, lblGioiThieuContent,
                lblSchema, lblSchemaContent,
                lblChucNang, lblChucNangContent,
                lblTrongSuot, lblTrongSuotContent
            });

            // Button Đóng
            Button btnClose = new Button();
            btnClose.Text = "Đóng";
            btnClose.Location = new Point(290, 570);
            btnClose.Size = new Size(100, 35);
            btnClose.Click += (s, e) => this.Close();

            this.Controls.Add(pnlMain);
            this.Controls.Add(btnClose);
        }
    }
}
