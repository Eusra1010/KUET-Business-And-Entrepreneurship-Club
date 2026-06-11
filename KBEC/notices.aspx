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
    <style>
        .notices-page {
            padding-top: 110px;
            max-width: 760px;
            margin: 0 auto;
            padding-left: 24px;
            padding-right: 24px;
            padding-bottom: 80px;
        }
        .notices-header {
            margin-bottom: 32px;
        }
        .notices-header h1 {
            font-size: 2rem;
            color: #fff;
            margin-bottom: 6px;
        }
        .notices-header p {
            color: #666;
            font-size: 0.9rem;
        }
        .notice-item {
            background: #111;
            border: 1px solid #f5c51820;
            border-radius: 14px;
            padding: 22px 24px;
            margin-bottom: 16px;
            transition: 0.2s;
        }
        .notice-item:hover {
            border-color: #f5c51844;
        }
        .notice-item h3 {
            color: #f5c518;
            font-size: 1.05rem;
            margin-bottom: 8px;
        }
        .notice-item p {
            color: #bbb;
            font-size: 0.9rem;
            line-height: 1.6;
            margin-bottom: 10px;
            white-space: pre-line;
        }
        .notice-item-meta {
            color: #555;
            font-size: 0.78rem;
        }
        .notices-empty {
            text-align: center;
            padding: 60px 0;
            color: #555;
        }
    </style>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
            Response.Redirect("member-login.aspx");

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Notices WHERE IsActive=1 ORDER BY CreatedAt DESC", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            bool any = false;
            while (reader.Read())
            {
                any = true;
                sb.Append("<div class='notice-item'>");
                sb.Append("<h3>" + reader["Title"].ToString() + "</h3>");
                sb.Append("<p>" + reader["Content"].ToString() + "</p>");
                sb.Append("<span class='notice-item-meta'>Posted by " + reader["PostedBy"].ToString() + " on " + Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy") + "</span>");
                sb.Append("</div>");
            }
            reader.Close();

            if (!any)
                sb.Append("<div class='notices-empty'><p>No notices posted yet.</p></div>");

            noticesList.InnerHtml = sb.ToString();
        }
    }
</script>
</head>
<body>

<header class="navbar">
    <div class="nav-left">
        <img src="logo.jpg" alt="Logo" />
        <h2>KBEC</h2>
    </div>
    <nav class="nav-links">
        <a href="kbec.aspx">Home</a>
        <a href="#">About</a>
        <a href="events.aspx">Events</a>
        <a href="executives.aspx">Alumni</a>
    </nav>
    <div class="nav-right">
        <div style="position:relative;">
            <button class="profile-btn" id="profileMenuButton" type="button">
                <svg class="profile-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2c-4.42 0-8 2-8 4.5A1.5 1.5 0 0 0 5.5 20h13A1.5 1.5 0 0 0 20 18.5C20 16 16.42 14 12 14Z" />
                </svg>
                <span class="profile-user-dot"></span>
            </button>
            <div class="profile-menu" id="profileMenu" hidden>
                <div class="profile-menu-title"><%= Session["UserName"] %></div>
                <button type="button" class="profile-menu-item" onclick="window.location.href='member-profile.aspx'">My Profile</button>
                <div class="profile-menu-divider"></div>
                <button type="button" class="profile-menu-item profile-menu-logout" onclick="window.location.href='member-logout.aspx'">Logout</button>
            </div>
        </div>
    </div>
</header>

<div class="notices-page">
    <div class="notices-header">
        <h1>📢 Notices</h1>
        <p>Latest announcements from KBEC</p>
    </div>
    <div id="noticesList" runat="server"></div>
</div>

<script src="kbec.js"></script>
</body>
</html>