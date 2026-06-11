<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notices - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="admin.css">
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");

        string del = Request.QueryString["del"];
        if (!string.IsNullOrEmpty(del))
        {
            string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Notices SET IsActive=0 WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", del);
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("admin-notices.aspx");
        }

        LoadNotices();
    }

    void LoadNotices()
    {
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Notices WHERE IsActive=1 ORDER BY CreatedAt DESC", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            while (reader.Read())
            {
                sb.Append("<div class='notice-card'>");
                sb.Append("<div class='notice-card-head'>");
                sb.Append("<h3>" + reader["Title"].ToString() + "</h3>");
                sb.Append("<a href='admin-notices.aspx?del=" + reader["Id"].ToString() + "' class='notice-del-btn' onclick=\"return confirm('Delete this notice?')\">Delete</a>");
                sb.Append("</div>");
                sb.Append("<p>" + reader["Content"].ToString() + "</p>");
                sb.Append("<span class='notice-meta'>Posted by " + reader["PostedBy"].ToString() + " on " + Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy") + "</span>");
                sb.Append("</div>");
            }
            if (sb.Length == 0) sb.Append("<p style='color:#666;'>No notices posted yet.</p>");
            noticesList.InnerHtml = sb.ToString();
        }
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
            <a href="admin-events.aspx" class="sidebar-item"><span class="sidebar-icon">📅</span><span>Manage Events</span></a>
            <a href="admin-notices.aspx" class="sidebar-item active"><span class="sidebar-icon">📢</span><span>Notices</span></a>
            <a href="admin-sponsors.aspx" class="sidebar-item"><span class="sidebar-icon">🏆</span><span>Manage Sponsors</span></a>
            
            <a href="admin-member-admins.aspx" class="sidebar-item"><span class="sidebar-icon">🔐</span><span>Member Admins</span></a>
            <% } %>
        </nav>
        <div class="sidebar-bottom">
            <a href="admin-logout.aspx" class="sidebar-item sidebar-logout"><span class="sidebar-icon">🚪</span><span>Logout</span></a>
        </div>
    </aside>

    <div class="admin-main">
        <header class="admin-topbar">
            <a href="kbec.aspx" class="admin-back-btn">&#8592; Back</a>
            <div class="admin-topbar-center">
                <img src="logo.jpg" alt="Logo" />
                <div><div class="topbar-kbec">KBEC</div><div class="topbar-panel">Admin Panel</div></div>
            </div>
            <div class="admin-topbar-right">
                <span class="admin-topbar-name"><%= Session["AdminName"] %></span>
            </div>
        </header>

        <div class="admin-content">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
                <div>
                    <h1 class="admin-page-title">Notices</h1>
                    <p class="admin-page-sub">All posted notices.</p>
                </div>
                <a href="admin-add-notice.aspx" class="nav-login-btn" style="text-decoration:none;">+ Add Notice</a>
            </div>

            <div id="noticesList" runat="server"></div>
        </div>
    </div>
</div>
</form>
</body>
</html>