<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="admin.css">
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null || Session["AdminRole"].ToString() != "MemberAdmin")
            Response.Redirect("admin-login.aspx");
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
            <a href="member-dashboard.aspx" class="sidebar-item active">
                <span class="sidebar-icon">🏠</span>
                <span>Dashboard</span>
            </a>
            <a href="admin-events.aspx" class="sidebar-item">
                <span class="sidebar-icon">📅</span>
                <span>Manage Events</span>
            </a>
            <a href="admin-notices.aspx" class="sidebar-item">
                <span class="sidebar-icon">📢</span>
                <span>Notices</span>
            </a>
            <a href="admin-sponsors.aspx" class="sidebar-item">
                <span class="sidebar-icon">🏆</span>
                <span>Manage Sponsors</span>
            </a>
            <a href="admin-edit-profile.aspx" class="sidebar-item">
                <span class="sidebar-icon">👤</span>
                <span>Edit Profile</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <a href="admin-logout.aspx" class="sidebar-item sidebar-logout">
                <span class="sidebar-icon">🚪</span>
                <span>Logout</span>
            </a>
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
                <span class="admin-topbar-name"><%= Session["AdminName"] %></span>
                <span class="admin-topbar-role"><%= Session["AdminPosition"] %></span>
            </div>
        </header>

        <!-- CONTENT -->
        <div class="admin-content">

            <h1 class="admin-page-title">Dashboard</h1>
            <p class="admin-page-sub">Welcome back, <strong><%= Session["AdminName"] %></strong>.</p>

            <div class="admin-stats">
                <div class="stat-card">
                    <div class="stat-icon">📅</div>
                    <div class="stat-info">
                        <h3>Total Events</h3>
                        <p>Coming soon</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📢</div>
                    <div class="stat-info">
                        <h3>Total Notices</h3>
                        <p>Coming soon</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-info">
                        <h3>Registered Users</h3>
                        <p>Coming soon</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🏆</div>
                    <div class="stat-info">
                        <h3>Sponsors</h3>
                        <p>Coming soon</p>
                    </div>
                </div>
            </div>

            <h2 class="admin-section-title">Quick Actions</h2>
            <div class="admin-actions">
                <a href="admin-add-event.aspx" class="action-card">
                    <span>📅</span>
                    <h3>Add New Event</h3>
                    <p>Create a new event</p>
                </a>
                <a href="admin-add-notice.aspx" class="action-card">
                    <span>📢</span>
                    <h3>Add Notice</h3>
                    <p>Post a new notice</p>
                </a>
                <a href="admin-sponsors.aspx" class="action-card">
                    <span>🏆</span>
                    <h3>Add Sponsor</h3>
                    <p>Add a new sponsor</p>
                </a>
            </div>

        </div>
    </div>
</div>
</form>
</body>
</html>