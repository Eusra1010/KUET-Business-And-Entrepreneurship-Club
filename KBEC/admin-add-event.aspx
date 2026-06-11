<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Event - KBEC</title>
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

    void btnAdd_Click(object sender, EventArgs e)
    {
        string title = txtTitle.Text.Trim();
        string eventKey = txtKey.Text.Trim().ToLower().Replace(" ", "");
        string image = txtImage.Text.Trim();
        string location = txtLocation.Text.Trim();
        string desc = txtDesc.Text.Trim();
        string regLink = txtRegLink.Text.Trim();
        string fbLink = txtFbLink.Text.Trim();

        if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(image) || string.IsNullOrEmpty(location) || string.IsNullOrEmpty(desc))
        {
            message = "Title, image, location and description are required.";
            messageClass = "notice-form-msg error";
            return;
        }

        if (string.IsNullOrEmpty(eventKey)) eventKey = Guid.NewGuid().ToString("N").Substring(0, 8);
        if (string.IsNullOrEmpty(regLink)) regLink = "#";

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "INSERT INTO Events (Title, EventKey, ImagePath, Location, Description, RegisterLink, FacebookLink) VALUES (@Title, @Key, @Image, @Location, @Desc, @Reg, @Fb)", conn);
            cmd.Parameters.AddWithValue("@Title", title);
            cmd.Parameters.AddWithValue("@Key", eventKey);
            cmd.Parameters.AddWithValue("@Image", image);
            cmd.Parameters.AddWithValue("@Location", location);
            cmd.Parameters.AddWithValue("@Desc", desc);
            cmd.Parameters.AddWithValue("@Reg", regLink);
            cmd.Parameters.AddWithValue("@Fb", fbLink);
            cmd.ExecuteNonQuery();
        }

        message = "Event added! It is now live on the public site.";
        messageClass = "notice-form-msg success";
        txtTitle.Text = ""; txtKey.Text = ""; txtImage.Text = "";
        txtLocation.Text = ""; txtDesc.Text = ""; txtRegLink.Text = ""; txtFbLink.Text = "";
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

            <h1 class="admin-page-title">📅 Add New Event</h1>
            <p class="admin-page-sub">The event will appear on the public events page immediately.</p>

            <div class="notice-form-card">

                <% if (!string.IsNullOrEmpty(message)) { %>
                    <div class="<%= messageClass %>"><%= message %></div>
                <% } %>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>Event Title <span class="req">*</span></label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="notice-input" placeholder="e.g. KBEC NEXUS Season 3" />
                    </div>
                    <div class="notice-form-group">
                        <label>Event Key <span class="opt">(optional, no spaces)</span></label>
                        <asp:TextBox ID="txtKey" runat="server" CssClass="notice-input" placeholder="e.g. nexusSeason3" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>Image Filename <span class="req">*</span></label>
                        <asp:TextBox ID="txtImage" runat="server" CssClass="notice-input" placeholder="e.g. nexus3.jpg (paste image in project folder first)" />
                    </div>
                    <div class="notice-form-group">
                        <label>Location <span class="req">*</span></label>
                        <asp:TextBox ID="txtLocation" runat="server" CssClass="notice-input" placeholder="e.g. KUET Auditorium" />
                    </div>
                </div>

                <div class="notice-form-group">
                    <label>Description <span class="req">*</span></label>
                    <asp:TextBox ID="txtDesc" runat="server" CssClass="notice-textarea" TextMode="MultiLine" Rows="5"
                        placeholder="e.g. KBEC NEXUS returns for its third season — the flagship business case competition of KUET. Open to all departments. Form your team of 3-5 members and compete for the championship!" />
                </div>

                <div class="form-row">
                    <div class="notice-form-group">
                        <label>Registration Link <span class="opt">(optional)</span></label>
                        <asp:TextBox ID="txtRegLink" runat="server" CssClass="notice-input" placeholder="https://forms.google.com/..." />
                    </div>
                    <div class="notice-form-group">
                        <label>Facebook Event Link <span class="opt">(optional)</span></label>
                        <asp:TextBox ID="txtFbLink" runat="server" CssClass="notice-input" placeholder="https://facebook.com/events/..." />
                    </div>
                </div>

                <asp:Button ID="btnAdd" runat="server" Text="Publish Event"
                    CssClass="notice-publish-btn" OnClick="btnAdd_Click" />
            </div>

        </div>
    </div>
</div>
</form>
</body>
</html>