namespace WindowsFormsApp1
{
    partial class FormMain
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.menuHeThong = new System.Windows.Forms.ToolStripMenuItem();
            this.menuGioiThieu = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.menuQLDanhMuc = new System.Windows.Forms.ToolStripMenuItem();
            this.menuNhaXB = new System.Windows.Forms.ToolStripMenuItem();
            this.menuTacGia = new System.Windows.Forms.ToolStripMenuItem();
            this.menuSach = new System.Windows.Forms.ToolStripMenuItem();
            this.menuDocGia = new System.Windows.Forms.ToolStripMenuItem();
            this.menuMuonSach = new System.Windows.Forms.ToolStripMenuItem();
            this.menuTruyVan = new System.Windows.Forms.ToolStripMenuItem();
            this.menuQuery1 = new System.Windows.Forms.ToolStripMenuItem();
            this.menuQuery2 = new System.Windows.Forms.ToolStripMenuItem();
            this.menuQuery3 = new System.Windows.Forms.ToolStripMenuItem();
            this.menuThoat = new System.Windows.Forms.ToolStripMenuItem();
            this.lblTitle = new System.Windows.Forms.Label();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.menuHeThong,
            this.menuQLDanhMuc,
            this.menuTruyVan,
            this.menuThoat});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1000, 24);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // menuHeThong
            // 
            this.menuHeThong.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.menuGioiThieu,
            this.toolStripSeparator1});
            this.menuHeThong.Name = "menuHeThong";
            this.menuHeThong.Size = new System.Drawing.Size(69, 20);
            this.menuHeThong.Text = "Hệ thống";
            // 
            // menuGioiThieu
            // 
            this.menuGioiThieu.Name = "menuGioiThieu";
            this.menuGioiThieu.Size = new System.Drawing.Size(180, 22);
            this.menuGioiThieu.Text = "Giới thiệu đề tài";
            this.menuGioiThieu.Click += new System.EventHandler(this.menuGioiThieu_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(177, 6);
            // 
            // menuQLDanhMuc
            // 
            this.menuQLDanhMuc.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.menuNhaXB,
            this.menuTacGia,
            this.menuSach,
            this.menuDocGia,
            this.menuMuonSach});
            this.menuQLDanhMuc.Name = "menuQLDanhMuc";
            this.menuQLDanhMuc.Size = new System.Drawing.Size(115, 20);
            this.menuQLDanhMuc.Text = "Quản lý danh mục";
            // 
            // menuNhaXB
            // 
            this.menuNhaXB.Name = "menuNhaXB";
            this.menuNhaXB.Size = new System.Drawing.Size(180, 22);
            this.menuNhaXB.Text = "Nhà xuất bản";
            this.menuNhaXB.Click += new System.EventHandler(this.menuNhaXB_Click);
            // 
            // menuTacGia
            // 
            this.menuTacGia.Name = "menuTacGia";
            this.menuTacGia.Size = new System.Drawing.Size(180, 22);
            this.menuTacGia.Text = "Tác giả";
            this.menuTacGia.Click += new System.EventHandler(this.menuTacGia_Click);
            // 
            // menuSach
            // 
            this.menuSach.Name = "menuSach";
            this.menuSach.Size = new System.Drawing.Size(180, 22);
            this.menuSach.Text = "Sách";
            this.menuSach.Click += new System.EventHandler(this.menuSach_Click);
            // 
            // menuDocGia
            // 
            this.menuDocGia.Name = "menuDocGia";
            this.menuDocGia.Size = new System.Drawing.Size(180, 22);
            this.menuDocGia.Text = "Độc giả";
            this.menuDocGia.Click += new System.EventHandler(this.menuDocGia_Click);
            // 
            // menuMuonSach
            // 
            this.menuMuonSach.Name = "menuMuonSach";
            this.menuMuonSach.Size = new System.Drawing.Size(180, 22);
            this.menuMuonSach.Text = "Mượn sách";
            this.menuMuonSach.Click += new System.EventHandler(this.menuMuonSach_Click);
            // 
            // menuTruyVan
            // 
            this.menuTruyVan.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.menuQuery1,
            this.menuQuery2,
            this.menuQuery3});
            this.menuTruyVan.Name = "menuTruyVan";
            this.menuTruyVan.Size = new System.Drawing.Size(118, 20);
            this.menuTruyVan.Text = "Truy vấn toàn cục";
            // 
            // menuQuery1
            // 
            this.menuQuery1.Name = "menuQuery1";
            this.menuQuery1.Size = new System.Drawing.Size(270, 22);
            this.menuQuery1.Text = "Số lượng sách năm 1998 theo NXB";
            this.menuQuery1.Click += new System.EventHandler(this.menuQuery1_Click);
            // 
            // menuQuery2
            // 
            this.menuQuery2.Name = "menuQuery2";
            this.menuQuery2.Size = new System.Drawing.Size(270, 22);
            this.menuQuery2.Text = "Sách của tác giả được mượn";
            this.menuQuery2.Click += new System.EventHandler(this.menuQuery2_Click);
            // 
            // menuQuery3
            // 
            this.menuQuery3.Name = "menuQuery3";
            this.menuQuery3.Size = new System.Drawing.Size(270, 22);
            this.menuQuery3.Text = "Cập nhật thành phố NXB KHKT";
            this.menuQuery3.Click += new System.EventHandler(this.menuQuery3_Click);
            // 
            // menuThoat
            // 
            this.menuThoat.Name = "menuThoat";
            this.menuThoat.Size = new System.Drawing.Size(50, 20);
            this.menuThoat.Text = "Thoát";
            this.menuThoat.Click += new System.EventHandler(this.menuThoat_Click);
            // 
            // lblTitle
            // 
            this.lblTitle.Dock = System.Windows.Forms.DockStyle.Fill;
            this.lblTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTitle.Location = new System.Drawing.Point(0, 24);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(1000, 576);
            this.lblTitle.TabIndex = 1;
            this.lblTitle.Text = "HỆ THỐNG QUẢN LÝ THƯ VIỆN PHÂN TÁN\r\n\r\nChọn chức năng từ menu";
            this.lblTitle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1000, 600);
            this.Controls.Add(this.lblTitle);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "FormMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Quản Lý Thư Viện Phân Tán - CSDLPT";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem menuHeThong;
        private System.Windows.Forms.ToolStripMenuItem menuGioiThieu;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripMenuItem menuQLDanhMuc;
        private System.Windows.Forms.ToolStripMenuItem menuNhaXB;
        private System.Windows.Forms.ToolStripMenuItem menuTacGia;
        private System.Windows.Forms.ToolStripMenuItem menuSach;
        private System.Windows.Forms.ToolStripMenuItem menuDocGia;
        private System.Windows.Forms.ToolStripMenuItem menuMuonSach;
        private System.Windows.Forms.ToolStripMenuItem menuTruyVan;
        private System.Windows.Forms.ToolStripMenuItem menuQuery1;
        private System.Windows.Forms.ToolStripMenuItem menuQuery2;
        private System.Windows.Forms.ToolStripMenuItem menuQuery3;
        private System.Windows.Forms.ToolStripMenuItem menuThoat;
        private System.Windows.Forms.Label lblTitle;
    }
}
