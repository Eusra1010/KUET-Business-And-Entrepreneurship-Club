<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Member - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="admin.css">
<script runat="server">
    string message = "";
    string messageClass = "";

    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");

        if (!IsPostBack)
        {
            string id = Request.QueryString["id"];
            if (string.IsNullOrEmpty(id)) Response.Redirect("executives.aspx");
            ViewState["MemberId"] = id;

            string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Members WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtFirstName.Text = reader["FirstName"].ToString();
                    txtLastName.Text = reader["LastName"].ToString();
                    txtDepartment.Text = reader["Department"].ToString();
                    txtBatch.Text = reader["Batch"].ToString();
                    txtPic.Text = reader["ProfilePicturePath"] == DBNull.Value ? "" : reader["ProfilePicturePath"].ToString();
                }
            }
        }
    }

    void btnSave_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "UPDATE Members SET FirstName=@FN, LastName=@LN, Department=@Dept, Batch=@Batch, ProfilePicturePath=@Pic WHERE Id=@Id", conn);
            cmd.Parameters.AddWithValue("@FN", txtFirstName.Text.Trim());
            cmd.Parameters.AddWithValue("@LN", txtLastName.Text.Trim());
            cmd.Parameters.AddWithValue("@Dept", txtDepartment.Text.Trim());
            cmd.Parameters.AddWithValue("@Batch", txtBatch.Text.Trim());
            cmd.Parameters.AddWithValue("@Pic", txtPic.Text.Trim());
            cmd.Parameters.AddWithValue("@Id", ViewState["MemberId"].ToString());
            cmd.ExecuteNonQuery();
        }

        message = "Member updated successfully!";
        messageClass = "notice-form-msg success";
    }
</script>
</head>
<body class="admin-body">
<form id="form1" runat="server">
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
            <a href="admin-sponsors.aspx" class="sidebar-item"><span class="sidebar-icon">&#127942;</span><span>Manage Sponsors</span></a>
            <a href="admin-applications.aspx" class="sidebar-item"><span class="sidebar-icon">&#128203;</span><span>Applications</span></a>
           
        </nav>
        <div class="sidebar-bottom">
            <a href="admin-logout.aspx" class="sidebar-item sidebar-logout"><span class="sidebar-icon">&#128682;</span><span>Logout</span></a>
        </div>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <a href="executives.aspx" class="admin-back-btn">&#8592; Back</a>
            <div class="admin-topbar-center">
                <img src="logo.jpg" alt="Logo" />
                <div>
                    <div class="topbar-kbec">KBEC</div>
                    <div class="topbar-panel">Admin Panel</div>
                </div>
            </div>
            <div class="admin-topbar-right">
                <span class="admin-topbar-name"><%= Session["AdminName"] %></span>
                <span class="admin-topbar-role">Admin</span>
            </div>
        </header>

        <div class="admin-content">
            <h1 class="admin-page-title">Edit Member</h1>
            <p class="admin-page-sub">Update member information. Changes appear on the Alumni page immediately.</p>

            <div class="notice-form-card">
                <% if (!string.IsNullOrEmpty(message)) { %>
                    <div class="<%= messageClass %>"><%= message %></div>
                <% } %>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>First Name</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="notice-input" placeholder="First name" />
                    </div>
                    <div class="notice-form-group">
                        <label>Last Name</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="notice-input" placeholder="Last name" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>Department</label>
                        <asp:TextBox ID="txtDepartment" runat="server" CssClass="notice-input" placeholder="e.g. Industrial Engineering" />
                    </div>
                    <div class="notice-form-group">
                        <label>Batch</label>
                        <asp:TextBox ID="txtBatch" runat="server" CssClass="notice-input" placeholder="e.g. 2021" />
                    </div>
                </div>

                <div class="notice-form-group">
                    <label>Profile Picture Path</label>
                    <asp:TextBox ID="txtPic" runat="server" CssClass="notice-input" placeholder="images/members/photo.jpg" />
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Save Changes"
                    CssClass="notice-publish-btn" OnClick="btnSave_Click" />

                <p style="margin-top:16px;">
                    <a href="executives.aspx" style="color:#555;font-size:0.85rem;text-decoration:none;">&#8592; Back to Alumni page</a>
                </p>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>