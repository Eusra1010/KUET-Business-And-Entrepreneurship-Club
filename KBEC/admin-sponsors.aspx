<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Sponsor - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="admin.css">
<script runat="server">
    string message = "";
    string messageClass = "";

    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");
    }

    void btnSave_Click(object sender, EventArgs e)
    {
        string name = txtName.Text.Trim();
        string url = txtUrl.Text.Trim();
        int displayOrder = 0;
        int.TryParse(txtOrder.Text.Trim(), out displayOrder);

        if (string.IsNullOrEmpty(name))
        {
            message = "Sponsor name is required.";
            messageClass = "admin-msg error";
            return;
        }

        if (!fileUpload.HasFile)
        {
            message = "Please upload a sponsor logo.";
            messageClass = "admin-msg error";
            return;
        }

        string ext = Path.GetExtension(fileUpload.FileName).ToLower();
        if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp")
        {
            message = "Only JPG, PNG, GIF or WEBP allowed.";
            messageClass = "admin-msg error";
            return;
        }
        if (fileUpload.PostedFile.ContentLength > 2 * 1024 * 1024)
        {
            message = "Image must be under 2MB.";
            messageClass = "admin-msg error";
            return;
        }

        string folder = Server.MapPath("~/images/sponsors/");
        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
        string fileName = Guid.NewGuid().ToString() + ext;
        fileUpload.SaveAs(folder + fileName);
        string logoPath = "images/sponsors/" + fileName;

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "INSERT INTO Sponsors (Name, LogoPath, WebsiteUrl, DisplayOrder, IsActive) VALUES (@Name,@Logo,@Url,@Order,1)", conn);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Logo", logoPath);
            cmd.Parameters.AddWithValue("@Url", string.IsNullOrEmpty(url) ? (object)DBNull.Value : url);
            cmd.Parameters.AddWithValue("@Order", displayOrder);
            cmd.ExecuteNonQuery();
        }

        Response.Redirect("admin-sponsors.aspx");
    }
</script>
</head>
<body class="admin-body">
<form id="form1" runat="server" enctype="multipart/form-data">
<div class="admin-layout">
    <aside class="admin-sidebar">
        <div class="sidebar-logo">
            <img src="logo.jpg" alt="KBEC Logo" />
            <div class="sidebar-logo-text">
                <span class="sidebar-kbec">KBEC</span>
                <span class="sidebar-panel">Admin Panel</span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="admin-dashboard.aspx" class="sidebar-item"><span class="sidebar-icon">&#127968;</span><span>Dashboard</span></a>
            <a href="admin-events.aspx" class="sidebar-item"><span class="sidebar-icon">&#128197;</span><span>Manage Events</span></a>
            <a href="admin-add-notice.aspx" class="sidebar-item"><span class="sidebar-icon">&#128226;</span><span>Notices</span></a>
            <a href="admin-sponsors.aspx" class="sidebar-item active"><span class="sidebar-icon">&#127942;</span><span>Manage Sponsors</span></a>
            <a href="admin-applications.aspx" class="sidebar-item"><span class="sidebar-icon">&#128203;</span><span>Applications</span></a>
        </nav>
        <div class="sidebar-bottom">
            <a href="admin-logout.aspx" class="sidebar-item sidebar-logout"><span class="sidebar-icon">&#128682;</span><span>Logout</span></a>
        </div>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <a href="admin-sponsors.aspx" class="admin-back-btn">&#8592; Back</a>
            <div class="admin-topbar-center">
                <img src="logo.jpg" alt="Logo" />
                <div>
                    <div class="topbar-kbec">KBEC</div>
                    <div class="topbar-panel">Admin Panel</div>
                </div>
            </div>
            <div class="admin-topbar-right">
                <div class="topbar-profile">
                    <div class="topbar-avatar">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2c-4.42 0-8 2-8 4.5A1.5 1.5 0 0 0 5.5 20h13A1.5 1.5 0 0 0 20 18.5C20 16 16.42 14 12 14Z" />
                        </svg>
                    </div>
                    <div class="topbar-profile-info">
                        <span class="admin-topbar-name"><%= Session["AdminName"] %></span>
                        <span class="admin-topbar-role">Admin</span>
                    </div>
                </div>
            </div>
        </header>

        <div class="admin-content">
            <h1 class="admin-page-title">Add Sponsor</h1>
            <p class="admin-page-sub">Upload a new sponsor to display on the homepage.</p>

            <% if (!string.IsNullOrEmpty(message)) { %>
            <div class="<%= messageClass %>"><%= message %></div>
            <% } %>

            <div class="admin-form-box">
                <div class="form-group">
                    <label>Sponsor Name <span style="color:#e74c3c;">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="e.g. Walton" />
                </div>
                <div class="form-group">
                    <label>Website URL <span style="color:#555;font-size:0.8rem;">(optional)</span></label>
                    <asp:TextBox ID="txtUrl" runat="server" CssClass="form-input" placeholder="https://example.com" />
                </div>
                <div class="form-group">
                    <label>Display Order <span style="color:#555;font-size:0.8rem;">(lower = appears first)</span></label>
                    <asp:TextBox ID="txtOrder" runat="server" CssClass="form-input" placeholder="e.g. 1" Text="0" />
                </div>
                <div class="form-group">
                    <label>Sponsor Logo <span style="color:#e74c3c;">*</span></label>
                    <div class="upload-box" onclick="document.getElementById('<%=fileUpload.ClientID%>').click()">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#f5c518" stroke-width="1.5" style="margin-bottom:6px;">
                            <rect x="3" y="3" width="18" height="18" rx="3"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <path d="M21 15l-5-5L5 21"/>
                        </svg>
                        <div class="upload-text">Click to upload logo</div>
                        <div class="upload-hint">JPG, PNG, GIF or WEBP, max 2MB</div>
                        <span id="picFileName" class="upload-filename"></span>
                    </div>
                    <asp:FileUpload ID="fileUpload" runat="server" Style="display:none;"
                        accept=".jpg,.jpeg,.png,.gif,.webp" onchange="showFileName(this)" />
                </div>
                <div class="admin-form-actions">
                    <a href="admin-sponsors.aspx" class="modal-cancel-btn">Cancel</a>
                    <asp:Button ID="btnSave" runat="server" Text="Add Sponsor"
                        CssClass="admin-save-btn" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>
</div>
</form>
<script>
    function showFileName(input) {
        var name = input.files[0] ? input.files[0].name : '';
        document.getElementById('picFileName').textContent = name ? '&#10003; ' + name : '';
    }
</script>
</body>
</html>