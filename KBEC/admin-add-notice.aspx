<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Notice - KBEC</title>
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
            LoadRecentNotices();
    }

    void btnPublish_Click(object sender, EventArgs e)
    {
        string title = txtTitle.Text.Trim();
        string content = txtContent.Text.Trim();

        if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(content))
        {
            message = "Notice title and message are required.";
            messageClass = "notice-form-msg error";
            LoadRecentNotices();
            return;
        }

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("INSERT INTO Notices (Title, Content, PostedBy) VALUES (@Title, @Content, @PostedBy)", conn);
            cmd.Parameters.AddWithValue("@Title", title);
            cmd.Parameters.AddWithValue("@Content", content);
            cmd.Parameters.AddWithValue("@PostedBy", Session["AdminName"].ToString());
            cmd.ExecuteNonQuery();
        }

        message = "Notice published successfully!";
        messageClass = "notice-form-msg success";
        txtTitle.Text = "";
        txtContent.Text = "";
        LoadRecentNotices();
    }

    void LoadRecentNotices()
    {
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT TOP 5 * FROM Notices WHERE IsActive=1 ORDER BY CreatedAt DESC", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            while (reader.Read())
            {
                sb.Append("<div class='notice-card'>");
                sb.Append("<div class='notice-card-head'>");
                sb.Append("<h3>" + reader["Title"].ToString() + "</h3>");
                sb.Append("<a href='admin-add-notice.aspx?del=" + reader["Id"].ToString() + "' class='notice-del-btn' onclick=\"return confirm('Delete this notice?')\">Delete</a>");
                sb.Append("</div>");
                sb.Append("<p>" + reader["Content"].ToString() + "</p>");
                sb.Append("<span class='notice-meta'>Posted by " + reader["PostedBy"].ToString() + " &middot; " + Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy, hh:mm tt") + "</span>");
                sb.Append("</div>");
            }
            reader.Close();

            if (sb.Length == 0)
                sb.Append("<p style='color:#666;text-align:center;padding:30px 0;'>No notices published yet. Your first notice will appear here.</p>");

            recentNotices.InnerHtml = sb.ToString();
        }

        // Handle delete via query string
        string del = Request.QueryString["del"];
        if (!string.IsNullOrEmpty(del) && !IsPostBack)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString))
            {
                conn.Open();
                SqlCommand delCmd = new SqlCommand("UPDATE Notices SET IsActive=0 WHERE Id=@Id", conn);
                delCmd.Parameters.AddWithValue("@Id", del);
                delCmd.ExecuteNonQuery();
            }
            Response.Redirect("admin-add-notice.aspx");
        }
    }
</script>
</head>
<body class="admin-body">
<form id="form1" runat="server">

<div class="admin-layout">

    <!-- SIDEBAR -->
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
            <a href="admin-events.aspx" class="sidebar-item"><span class="sidebar-icon">📅</span><span>Manage Events</span></a>
            <a href="admin-add-notice.aspx" class="sidebar-item active"><span class="sidebar-icon">📢</span><span>Notices</span></a>
            <a href="admin-sponsors.aspx" class="sidebar-item"><span class="sidebar-icon">🏆</span><span>Manage Sponsors</span></a>

            <% if (Session["AdminRole"] != null && Session["AdminRole"].ToString() == "SuperAdmin") { %>
            <a href="admin-member-admins.aspx" class="sidebar-item"><span class="sidebar-icon">🔐</span><span>Member Admins</span></a>
            <% } %>
        </nav>
        <div class="sidebar-bottom">
            <a href="admin-logout.aspx" class="sidebar-item sidebar-logout"><span class="sidebar-icon">🚪</span><span>Logout</span></a>
        </div>
    </aside>

    <!-- MAIN AREA -->
    <div class="admin-main">

        <!-- TOP BAR -->
       <header class="admin-topbar">
    <a href="kbec.aspx" class="admin-back-btn">&#8592; Back</a>
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

        <!-- CONTENT -->
        <div class="admin-content">

            <h1 class="admin-page-title">📢 Publish a Notice</h1>
            <p class="admin-page-sub">Share announcements and updates with all KBEC members.</p>

            <!-- NOTICE FORM CARD -->
            <div class="notice-form-card">

                <% if (!string.IsNullOrEmpty(message)) { %>
                    <div class="<%= messageClass %>"><%= message %></div>
                <% } %>

                <div class="notice-form-group">
                    <label>Notice Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="notice-input"
                        placeholder="e.g. KBEC NEXUS S3 Registration Now Open!" />
                </div>

                <div class="notice-form-group">
                    <label>Message</label>
                    <asp:TextBox ID="txtContent" runat="server" CssClass="notice-textarea"
                        TextMode="MultiLine" Rows="6"
                        placeholder="e.g. Dear members, registration for KBEC NEXUS Season 3 is now open. Visit the events page to register before the deadline on 25th June. Limited seats available!" />
                </div>

                <asp:Button ID="btnPublish" runat="server" Text="Publish Notice"
                    CssClass="notice-publish-btn" OnClick="btnPublish_Click" />
            </div>

            <!-- RECENT NOTICES -->
            <h2 class="admin-section-title" style="margin-top:48px;">Recently Published</h2>
            <div id="recentNotices" runat="server"></div>

        </div>
    </div>
</div>
</form>
</body>
</html>