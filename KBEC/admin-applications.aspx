<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applications - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="admin.css">
    <style>
        .app-card { cursor: pointer; }
        .app-card:hover { border-color: #f5c51866; }
        .app-view-link { color: #f5c518; font-size: 0.78rem; font-weight: 600; }
    </style>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");

        string action = Request.QueryString["action"];
        string memberId = Request.QueryString["id"];

        if (!string.IsNullOrEmpty(action) && !string.IsNullOrEmpty(memberId))
        {
            string newStatus = action == "approve" ? "Approved" : "Rejected";
            string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Members SET Status=@Status WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@Id", memberId);
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("admin-applications.aspx");
        }

        LoadApplications();
    }
void LoadApplications()
{
    string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
    using (SqlConnection conn = new SqlConnection(connStr))
    {
        conn.Open();
        SqlCommand cmd = new SqlCommand(
            "SELECT * FROM Members ORDER BY CASE Status WHEN 'Pending' THEN 0 WHEN 'Approved' THEN 1 ELSE 2 END, CreatedAt DESC", conn);
        SqlDataReader reader = cmd.ExecuteReader();

        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        while (reader.Read())
        {
            string id = reader["Id"].ToString();
            string name = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
            string email = reader["Email"].ToString();
            string dept = reader["Department"].ToString();
            string batch = reader["Batch"].ToString();
            string status = reader["Status"].ToString();
            string date = Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy");
            string badgeClass = status == "Approved" ? "badge-approved" : status == "Rejected" ? "badge-rejected" : "badge-pending";
            string pic = reader["ProfilePicturePath"] == DBNull.Value || string.IsNullOrEmpty(reader["ProfilePicturePath"].ToString())
                ? "images/members/default.jpg"
                : reader["ProfilePicturePath"].ToString();

            sb.Append("<div class='app-card' onclick='loadMember(" + id + ")'>");
            sb.Append("<div class='app-card-left'>");
            sb.Append("<img src='" + pic + "' alt='" + name + "' onerror=\"this.onerror=null;this.src='images/members/default.jpg';\" />");
            sb.Append("</div>");
            sb.Append("<div class='app-card-body'>");
            sb.Append("<div class='app-card-head'>");
            sb.Append("<h3>" + name + "</h3>");
            sb.Append("<span class='app-status-badge " + badgeClass + "'>" + status + "</span>");
            sb.Append("</div>");
            sb.Append("<div class='app-card-meta'>");
            sb.Append("<span>" + email + "</span>");
            sb.Append("<span>" + dept + " &middot; Batch " + batch + "</span>");
            sb.Append("</div>");
            sb.Append("<div class='app-card-footer'>");
            sb.Append("<span class='app-date'>Applied: " + date + "</span>");
            sb.Append("<span class='app-view-link'>Click to view details</span>");
            sb.Append("</div>");
            sb.Append("</div>");
            sb.Append("</div>"); // close app-card
        }
        reader.Close();

        if (sb.Length == 0)
            sb.Append("<div class='events-empty'><p>No applications yet.</p></div>");

        applicationsList.InnerHtml = sb.ToString();
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
            <a href="admin-dashboard.aspx" class="sidebar-item"><span class="sidebar-icon">&#127968;</span><span>Dashboard</span></a>
            <a href="admin-events.aspx" class="sidebar-item"><span class="sidebar-icon">&#128197;</span><span>Manage Events</span></a>
            <a href="admin-add-notice.aspx" class="sidebar-item"><span class="sidebar-icon">&#128226;</span><span>Notices</span></a>
            <a href="admin-sponsors.aspx" class="sidebar-item"><span class="sidebar-icon">&#127942;</span><span>Manage Sponsors</span></a>
            <a href="admin-applications.aspx" class="sidebar-item active"><span class="sidebar-icon">&#128203;</span><span>Applications</span></a>
          
        </nav>
        <div class="sidebar-bottom">
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
            <h1 class="admin-page-title">Member Applications</h1>
            <p class="admin-page-sub">Click any application to view full details and approve or reject.</p>
            <div id="applicationsList" runat="server"></div>
        </div>
    </div>
</div>

<!-- MEMBER DETAIL MODAL -->
<div id="memberModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.75);z-index:2000;align-items:center;justify-content:center;backdrop-filter:blur(4px);">
    <div style="background:#111;border:1px solid #f5c51833;border-radius:18px;width:100%;max-width:520px;max-height:90vh;overflow-y:auto;box-shadow:0 24px 60px rgba(0,0,0,0.6);margin:20px;">

        <div style="display:flex;justify-content:space-between;align-items:center;padding:22px 28px 16px;">
            <h2 id="mName" style="color:#fff;font-size:1.2rem;"></h2>
            <button type="button" onclick="document.getElementById('memberModal').style.display='none'"
                style="width:32px;height:32px;border-radius:8px;border:1px solid #2a2a2a;background:transparent;color:#888;cursor:pointer;font-size:1rem;">&#10005;</button>
        </div>

        <div style="margin:0 28px 16px;padding:11px 16px;border-radius:10px;background:rgba(245,197,24,0.08);border:1px solid rgba(245,197,24,0.25);" id="mStatusWrap"></div>

        <div style="display:flex;gap:16px;align-items:flex-start;padding:0 28px 16px;">
            <img id="mPic" src="" alt="Profile" onerror="this.src='images/members/default.jpg'"
                style="width:80px;height:80px;border-radius:12px;object-fit:cover;border:2px solid #f5c51833;flex-shrink:0;" />
            <div style="color:#666;font-size:0.82rem;" id="mDate"></div>
        </div>

        <div style="margin:0 28px 16px;background:#0e0e0e;border:1px solid #1e1e1e;border-radius:12px;padding:18px;display:flex;flex-direction:column;gap:12px;">
            <div style="display:flex;justify-content:space-between;">
                <span style="color:#666;font-size:0.82rem;">Email</span>
                <span id="mEmail" style="color:#ddd;font-size:0.88rem;font-weight:500;"></span>
            </div>
            <div style="display:flex;justify-content:space-between;">
                <span style="color:#666;font-size:0.82rem;">Department</span>
                <span id="mDept" style="color:#ddd;font-size:0.88rem;font-weight:500;"></span>
            </div>
            <div style="display:flex;justify-content:space-between;">
                <span style="color:#666;font-size:0.82rem;">Batch</span>
                <span id="mBatch" style="color:#ddd;font-size:0.88rem;font-weight:500;"></span>
            </div>
            <div style="display:flex;justify-content:space-between;">
                <span style="color:#666;font-size:0.82rem;">CGPA</span>
                <span id="mCgpa" style="color:#ddd;font-size:0.88rem;font-weight:500;"></span>
            </div>
            <div style="display:flex;justify-content:space-between;">
                <span style="color:#666;font-size:0.82rem;">Contact</span>
                <span id="mContact" style="color:#ddd;font-size:0.88rem;font-weight:500;"></span>
            </div>
        </div>

        <div id="mAboutWrap" style="display:none;margin:0 28px 16px;">
            <div style="color:#666;font-size:0.82rem;margin-bottom:6px;">About</div>
            <p id="mAbout" style="color:#bbb;font-size:0.88rem;line-height:1.6;background:#0e0e0e;border:1px solid #1e1e1e;border-radius:10px;padding:14px;"></p>
        </div>

        <div id="mActions" style="display:flex;justify-content:flex-end;gap:12px;padding:16px 28px 24px;border-top:1px solid #1a1a1a;"></div>

    </div>
</div>

</form>

<script>
    function loadMember(id) {
        fetch('get-member.aspx?id=' + id)
            .then(function (r) { return r.json(); })
            .then(function (m) {
                document.getElementById('mName').textContent = m.name;
                document.getElementById('mEmail').textContent = m.email;
                document.getElementById('mDept').textContent = m.dept;
                document.getElementById('mBatch').textContent = 'Batch ' + m.batch;
                document.getElementById('mCgpa').textContent = m.cgpa || 'Not provided';
                document.getElementById('mContact').textContent = m.contact || 'Not provided';
                document.getElementById('mDate').textContent = 'Applied: ' + m.date;
                document.getElementById('mPic').src = m.pic;

                var badgeColor = m.status === 'Approved' ? '#2ecc71' : m.status === 'Rejected' ? '#e74c3c' : '#f5c518';
                document.getElementById('mStatusWrap').innerHTML =
                    '<span style="color:' + badgeColor + ';font-weight:700;font-size:0.85rem;">' + m.status + '</span>';

                if (m.about) {
                    document.getElementById('mAbout').textContent = m.about;
                    document.getElementById('mAboutWrap').style.display = 'block';
                } else {
                    document.getElementById('mAboutWrap').style.display = 'none';
                }

                var footer = document.getElementById('mActions');
                if (m.status === 'Pending') {
                    footer.innerHTML =
                        '<button type="button" class="modal-cancel-btn" onclick="document.getElementById(\'memberModal\').style.display=\'none\'">Close</button>' +
                        '<a href="admin-applications.aspx?action=reject&id=' + m.id + '" class="btn-reject" onclick="return confirm(\'Reject this application?\')">Reject</a>' +
                        '<a href="admin-applications.aspx?action=approve&id=' + m.id + '" class="btn-approve" onclick="return confirm(\'Approve this member?\')">Approve</a>';
                } else {
                    footer.innerHTML =
                        '<button type="button" class="modal-cancel-btn" onclick="document.getElementById(\'memberModal\').style.display=\'none\'">Close</button>';
                }

                document.getElementById('memberModal').style.display = 'flex';
            });
    }

    document.getElementById('memberModal').addEventListener('click', function (e) {
        if (e.target === this) this.style.display = 'none';
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape')
            document.getElementById('memberModal').style.display = 'none';
    });
</script>

</body>
</html>