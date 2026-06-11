<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event - KBEC</title>
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
            if (string.IsNullOrEmpty(id)) Response.Redirect("admin-events.aspx");

            ViewState["EventId"] = id;

            string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Events WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtTitle.Text = reader["Title"].ToString();
                    txtKey.Text = reader["EventKey"].ToString();
                    txtImage.Text = reader["ImagePath"].ToString();
                    txtLocation.Text = reader["Location"].ToString();
                    txtDesc.Text = reader["Description"].ToString();
                    txtRegLink.Text = reader["RegisterLink"].ToString();
                    txtFbLink.Text = reader["FacebookLink"].ToString();
                }
            }
        }
    }

    void btnSave_Click(object sender, EventArgs e)
    {
        string id = ViewState["EventId"].ToString();
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "UPDATE Events SET Title=@Title, EventKey=@Key, ImagePath=@Image, Location=@Location, Description=@Desc, RegisterLink=@Reg, FacebookLink=@Fb WHERE Id=@Id", conn);
            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
            cmd.Parameters.AddWithValue("@Key", txtKey.Text.Trim());
            cmd.Parameters.AddWithValue("@Image", txtImage.Text.Trim());
            cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
            cmd.Parameters.AddWithValue("@Desc", txtDesc.Text.Trim());
            cmd.Parameters.AddWithValue("@Reg", txtRegLink.Text.Trim());
            cmd.Parameters.AddWithValue("@Fb", txtFbLink.Text.Trim());
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.ExecuteNonQuery();
        }

        message = "Event updated successfully!";
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
            <a href="admin-dashboard.aspx" class="sidebar-item"><span class="sidebar-icon">🏠</span><span>Dashboard</span></a>
            <a href="admin-events.aspx" class="sidebar-item active"><span class="sidebar-icon">📅</span><span>Manage Events</span></a>
            <a href="admin-add-notice.aspx" class="sidebar-item"><span class="sidebar-icon">📢</span><span>Notices</span></a>
            <a href="admin-sponsors.aspx" class="sidebar-item"><span class="sidebar-icon">🏆</span><span>Manage Sponsors</span></a>
         
            <% if (Session["AdminRole"] != null && Session["AdminRole"].ToString() == "SuperAdmin") { %>
            <a href="admin-member-admins.aspx" class="sidebar-item"><span class="sidebar-icon">🔐</span><span>Member Admins</span></a>
            <% } %>
        </nav>
        <div class="sidebar-bottom">
            <a href="admin-logout.aspx" class="sidebar-item sidebar-logout"><span class="sidebar-icon">🚪</span><span>Logout</span></a>
        </div>
    </aside>

    <div class="admin-main">

        <header class="admin-topbar">
            <a href="admin-events.aspx" class="admin-back-btn">&#8592; Back</a>
            <div class="admin-topbar-center">
                <img src="logo.jpg" alt="Logo" />
                <div>
                    <div class="topbar-kbec">KBEC</div>
                    <div class="topbar-panel">Admin Panel</div>
                </div>
            </div>
            <div class="admin-topbar-right">
                <span class="admin-topbar-name"><%= Session["AdminName"] %></span>
                <span class="admin-topbar-role"><%= Session["AdminRole"] %></span>
            </div>
        </header>

        <div class="admin-content">

            <h1 class="admin-page-title">✏️ Edit Event</h1>
            <p class="admin-page-sub">Changes apply to the public site immediately after saving.</p>

            <div class="notice-form-card">

                <% if (!string.IsNullOrEmpty(message)) { %>
                    <div class="<%= messageClass %>"><%= message %></div>
                <% } %>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>Event Title</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="notice-input" />
                    </div>
                    <div class="notice-form-group">
                        <label>Event Key</label>
                        <asp:TextBox ID="txtKey" runat="server" CssClass="notice-input" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>Image Filename</label>
                        <asp:TextBox ID="txtImage" runat="server" CssClass="notice-input" />
                    </div>
                    <div class="notice-form-group">
                        <label>Location</label>
                        <asp:TextBox ID="txtLocation" runat="server" CssClass="notice-input" />
                    </div>
                </div>

                <div class="notice-form-group">
                    <label>Description</label>
                    <asp:TextBox ID="txtDesc" runat="server" CssClass="notice-textarea" TextMode="MultiLine" Rows="5" />
                </div>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>Registration Link</label>
                        <asp:TextBox ID="txtRegLink" runat="server" CssClass="notice-input" />
                    </div>
                    <div class="notice-form-group">
                        <label>Facebook Event Link</label>
                        <asp:TextBox ID="txtFbLink" runat="server" CssClass="notice-input" />
                    </div>
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Save Changes"
                    CssClass="notice-publish-btn" OnClick="btnSave_Click" />
            </div>

        </div>
    </div>
</div>
</form>
</body>
</html>