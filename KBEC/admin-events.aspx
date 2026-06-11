<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="admin.css">
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;

        // Handle delete
        string del = Request.QueryString["del"];
        if (!string.IsNullOrEmpty(del))
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Events SET IsActive=0 WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", del);
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("admin-events.aspx");
        }

        // Handle toggle visibility
        string toggle = Request.QueryString["toggle"];
        if (!string.IsNullOrEmpty(toggle))
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Events SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", toggle);
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("admin-events.aspx");
        }

        LoadEvents();
    }

    void LoadEvents()
    {
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Events ORDER BY CreatedAt DESC", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            while (reader.Read())
            {
                string id = reader["Id"].ToString();
                string title = reader["Title"].ToString();
                string location = reader["Location"].ToString();
                string image = reader["ImagePath"].ToString();
                bool isActive = Convert.ToBoolean(reader["IsActive"]);
                string created = Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy");

                sb.Append("<div class='event-manage-card'>");
                sb.Append("<div class='event-manage-img'><img src='" + image + "' alt='" + title + "' /></div>");
                sb.Append("<div class='event-manage-info'>");
                sb.Append("<div class='event-manage-head'>");
                sb.Append("<h3>" + title + "</h3>");
                sb.Append(isActive
                    ? "<span class='event-badge active'>● Live</span>"
                    : "<span class='event-badge hidden'>● Hidden</span>");
                sb.Append("</div>");
                sb.Append("<p class='event-manage-meta'>📍 " + location + " &nbsp;·&nbsp; Added " + created + "</p>");
                sb.Append("<div class='event-manage-btns'>");
                sb.Append("<a href='admin-edit-event.aspx?id=" + id + "' class='btn-edit'>Edit</a>");
                sb.Append(isActive
                    ? "<a href='admin-events.aspx?toggle=" + id + "' class='btn-toggle'>Hide from site</a>"
                    : "<a href='admin-events.aspx?toggle=" + id + "' class='btn-toggle show'>Show on site</a>");
                sb.Append("<a href='admin-events.aspx?del=" + id + "' class='btn-delete' onclick=\"return confirm('Delete this event permanently?')\">Delete</a>");
                sb.Append("</div></div></div>");
            }
            reader.Close();

            if (sb.Length == 0)
                sb.Append("<div class='events-empty'><span>📅</span><p>No events yet. Add your first event to see it here and on the public site.</p></div>");

            eventsList.InnerHtml = sb.ToString();
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
            <a href="kbec.aspx" class="admin-back-btn">&#8592; Back</a>
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

            <div class="page-head-row">
                <div>
                    <h1 class="admin-page-title">📅 Manage Events</h1>
                    <p class="admin-page-sub">Events shown here appear on the public site when live.</p>
                </div>
                <a href="admin-add-event.aspx" class="btn-primary-glow">+ Add New Event</a>
            </div>

            <div id="eventsList" runat="server"></div>

        </div>
    </div>
</div>
</form>
</body>
</html>