<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="admin.css">
<script runat="server">
    int totalEvents = 0;
    int totalNotices = 0;
    int totalExecutives = 0;
    int pendingApplications = 0;

    void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();

        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM Events WHERE IsActive=1", conn);
            totalEvents = (int)cmd1.ExecuteScalar();

            SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM Notices WHERE IsActive=1", conn);
            totalNotices = (int)cmd2.ExecuteScalar();

            SqlCommand cmd3 = new SqlCommand("SELECT COUNT(*) FROM Executives WHERE IsActive=1", conn);
            totalExecutives = (int)cmd3.ExecuteScalar();

            SqlCommand cmd4 = new SqlCommand("SELECT COUNT(*) FROM Members WHERE Status='Pending'", conn);
            pendingApplications = (int)cmd4.ExecuteScalar();
        }

        LoadPendingApplications();
    }

    void LoadPendingApplications()
    {
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "SELECT TOP 3 * FROM Members WHERE Status='Pending' ORDER BY CreatedAt DESC", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            while (reader.Read())
            {
                sb.Append("<div class='application-row'>");
                sb.Append("<div class='application-avatar'>");
                string pic = reader["ProfilePicturePath"] == DBNull.Value
                    ? "images/members/default.jpg"
                    : reader["ProfilePicturePath"].ToString();
                sb.Append("<img src='" + pic + "' alt='Profile' onerror=\"this.src='images/members/default.jpg'\" />");
                sb.Append("</div>");
                sb.Append("<div class='application-info'>");
                sb.Append("<strong>" + reader["FirstName"].ToString() + " " + reader["LastName"].ToString() + "</strong>");
                sb.Append("<span>" + reader["Department"].ToString() + " &middot; Batch " + reader["Batch"].ToString() + "</span>");
                sb.Append("</div>");
                sb.Append("<div class='application-meta'>");
                sb.Append("<span class='app-date'>" + Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy") + "</span>");
                sb.Append("<a href='admin-applications.aspx' class='app-view-btn'>View</a>");
                sb.Append("</div>");
                sb.Append("</div>");
            }
            reader.Close();

            if (sb.Length == 0)
                sb.Append("<p style='color:#666;padding:20px 0;'>No pending applications.</p>");

            pendingList.InnerHtml = sb.ToString();
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
            <a href="admin-dashboard.aspx" class="sidebar-item active"><span class="sidebar-icon">&#127968;</span><span>Dashboard</span></a>
            <a href="admin-events.aspx" class="sidebar-item"><span class="sidebar-icon">&#128197;</span><span>Manage Events</span></a>
            <a href="admin-add-notice.aspx" class="sidebar-item"><span class="sidebar-icon">&#128226;</span><span>Notices</span></a>
            <a href="admin-sponsors.aspx" class="sidebar-item"><span class="sidebar-icon">&#127942;</span><span>Manage Sponsors</span></a>
            <a href="admin-applications.aspx" class="sidebar-item"><span class="sidebar-icon">&#128203;</span><span>Applications</span></a>
           
        </nav>
        <div class="sidebar-bottom">
            <a href="kbec.aspx" class="sidebar-item"><span class="sidebar-icon">&#127760;</span><span>View Site</span></a>
            <a href="admin-logout.aspx" class="sidebar-item sidebar-logout"><span class="sidebar-icon">&#128682;</span><span>Logout</span></a>
        </div>
    </aside>

    <div class="admin-main">
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

        <div class="admin-content">

            <h1 class="admin-page-title">Dashboard</h1>
            <p class="admin-page-sub">Welcome back, <strong><%= Session["AdminName"] %></strong>.</p>

            <!-- STATS -->
            <div class="admin-stats">
                <div class="stat-card">
                    <div class="stat-icon">&#128197;</div>
                    <div class="stat-info"><h3>Total Events</h3><p><%= totalEvents %></p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">&#128226;</div>
                    <div class="stat-info"><h3>Total Notices</h3><p><%= totalNotices %></p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">&#128101;</div>
                    <div class="stat-info"><h3>Executives</h3><p><%= totalExecutives %></p></div>
                </div>
                <div class="stat-card pending-card">
                    <div class="stat-icon">&#128203;</div>
                    <div class="stat-info"><h3>Pending Applications</h3><p><%= pendingApplications %></p></div>
                </div>
            </div>

            <!-- QUICK ACTIONS -->
            <h2 class="admin-section-title">Quick Actions</h2>
            <div class="admin-actions">
                <a href="admin-add-event.aspx" class="action-card">
                    <span>&#128197;</span><h3>Add New Event</h3><p>Create a new event</p>
                </a>
                <a href="admin-add-notice.aspx" class="action-card">
                    <span>&#128226;</span><h3>Add Notice</h3><p>Post a new notice</p>
                </a>
                <a href="admin-applications.aspx" class="action-card">
                    <span>&#128203;</span><h3>Preview Applications</h3><p>Review pending members</p>
                </a>
                <a href="executives.aspx" class="action-card">
                    <span>&#128101;</span><h3>Manage Executives</h3><p>Edit club members</p>
                </a>
            </div>

            <!-- PENDING APPLICATIONS -->
            <div class="pending-section">
                <div class="pending-section-head">
                    <h2 class="admin-section-title" style="margin:0;">Pending Applications</h2>
                    <a href="admin-applications.aspx" class="btn-primary-glow"
                        style="font-size:0.82rem;padding:8px 18px;">View All</a>
                </div>
                <div id="pendingList" runat="server"></div>
            </div>

        </div>
    </div>
</div>
</form>
</body>
</html>