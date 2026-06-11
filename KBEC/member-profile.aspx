<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="profile.css">
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
            Response.Redirect("member-login.aspx");

        if (!IsPostBack)
            LoadProfile();
    }

    void LoadProfile()
    {
        string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "";
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            if (role == "Executive")
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM MemberAdmins WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", Session["UserId"].ToString());
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtName.Text = reader["Name"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPosition.Text = reader["Position"].ToString();
                    txtDepartment.Text = reader["Department"] == DBNull.Value ? "" : reader["Department"].ToString();
                    txtBatch.Text = reader["Batch"] == DBNull.Value ? "" : reader["Batch"].ToString();
                    txtContact.Text = reader["ContactNumber"] == DBNull.Value ? "" : reader["ContactNumber"].ToString();

                    string pic = reader["ProfilePicturePath"] == DBNull.Value ? "" : reader["ProfilePicturePath"].ToString();
                    profilePic.Src = string.IsNullOrEmpty(pic) ? "images/members/default.jpg" : pic;

                    lblName.InnerText = reader["Name"].ToString();
                    lblPosition.InnerText = reader["Position"].ToString();
                    lblEmail.InnerText = reader["Email"].ToString();
                    lblDept.InnerText = reader["Department"] == DBNull.Value ? "Not provided" : reader["Department"].ToString();
                    lblBatch.InnerText = reader["Batch"] == DBNull.Value ? "Not provided" : "Batch " + reader["Batch"].ToString();
                    lblContact.InnerText = reader["ContactNumber"] == DBNull.Value ? "Not provided" : reader["ContactNumber"].ToString();

                    cgpaRow.Visible = false;
                    aboutRow.Visible = false;
                    positionGroup.Visible = true;
                }
            }
            else // Member
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Members WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", Session["UserId"].ToString());
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string fullName = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                    txtName.Text = fullName;
                    txtEmail.Text = reader["Email"].ToString();
                    txtPosition.Text = "";
                    txtDepartment.Text = reader["Department"] == DBNull.Value ? "" : reader["Department"].ToString();
                    txtBatch.Text = reader["Batch"] == DBNull.Value ? "" : reader["Batch"].ToString();
                    txtContact.Text = reader["ContactNumber"] == DBNull.Value ? "" : reader["ContactNumber"].ToString();

                    string pic = reader["ProfilePicturePath"] == DBNull.Value ? "" : reader["ProfilePicturePath"].ToString();
                    profilePic.Src = string.IsNullOrEmpty(pic) ? "images/members/default.jpg" : pic;

                    lblName.InnerText = fullName;
                    lblPosition.InnerText = "Member";
                    lblEmail.InnerText = reader["Email"].ToString();
                    lblDept.InnerText = reader["Department"] == DBNull.Value ? "Not provided" : reader["Department"].ToString();
                    lblBatch.InnerText = reader["Batch"] == DBNull.Value ? "Not provided" : "Batch " + reader["Batch"].ToString();
                    lblContact.InnerText = reader["ContactNumber"] == DBNull.Value ? "Not provided" : reader["ContactNumber"].ToString();

                    string cgpa = reader["CGPA"] == DBNull.Value ? "" : reader["CGPA"].ToString();
                    string about = reader["AboutYourself"] == DBNull.Value ? "" : reader["AboutYourself"].ToString();
                    lblCgpa.InnerText = string.IsNullOrEmpty(cgpa) ? "Not provided" : cgpa;
                    lblAbout.InnerText = string.IsNullOrEmpty(about) ? "" : about;

                    cgpaRow.Visible = true;
                    aboutRow.Visible = !string.IsNullOrEmpty(about);
                    positionGroup.Visible = false;
                }
            }
        }
    }

    void btnSave_Click(object sender, EventArgs e)
    {
        string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "";

        string picturePath = null;
        if (fileUpload.HasFile)
        {
            string ext = Path.GetExtension(fileUpload.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "err",
                    "showModal(); document.getElementById('modalMsg').textContent='Only JPG and PNG allowed.'; document.getElementById('modalMsg').style.display='block';", true);
                return;
            }
            if (fileUpload.PostedFile.ContentLength > 2 * 1024 * 1024)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "err",
                    "showModal(); document.getElementById('modalMsg').textContent='Image must be under 2MB.'; document.getElementById('modalMsg').style.display='block';", true);
                return;
            }
            string membersFolder = Server.MapPath("~/images/members/");
            if (!Directory.Exists(membersFolder))
                Directory.CreateDirectory(membersFolder);
            string fileName = Guid.NewGuid().ToString() + ext;
            fileUpload.SaveAs(membersFolder + fileName);
            picturePath = "images/members/" + fileName;
        }

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            if (role == "Executive")
            {
                string query = picturePath != null
                    ? "UPDATE MemberAdmins SET Name=@Name, Position=@Position, Department=@Dept, Batch=@Batch, ContactNumber=@Contact, ProfilePicturePath=@Pic WHERE Id=@Id"
                    : "UPDATE MemberAdmins SET Name=@Name, Position=@Position, Department=@Dept, Batch=@Batch, ContactNumber=@Contact WHERE Id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Position", txtPosition.Text.Trim());
                cmd.Parameters.AddWithValue("@Dept", txtDepartment.Text.Trim());
                cmd.Parameters.AddWithValue("@Batch", txtBatch.Text.Trim());
                cmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                if (picturePath != null) cmd.Parameters.AddWithValue("@Pic", picturePath);
                cmd.Parameters.AddWithValue("@Id", Session["UserId"].ToString());
                cmd.ExecuteNonQuery();
                Session["UserName"] = txtName.Text.Trim();
            }
            else // Member
            {
                string fullName = txtName.Text.Trim();
                string firstName = fullName;
                string lastName = "";
                int spaceIdx = fullName.IndexOf(' ');
                if (spaceIdx > 0)
                {
                    firstName = fullName.Substring(0, spaceIdx);
                    lastName = fullName.Substring(spaceIdx + 1);
                }

                string query = picturePath != null
                    ? "UPDATE Members SET FirstName=@First, LastName=@Last, Department=@Dept, Batch=@Batch, ContactNumber=@Contact, ProfilePicturePath=@Pic WHERE Id=@Id"
                    : "UPDATE Members SET FirstName=@First, LastName=@Last, Department=@Dept, Batch=@Batch, ContactNumber=@Contact WHERE Id=@Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@First", firstName);
                cmd.Parameters.AddWithValue("@Last", lastName);
                cmd.Parameters.AddWithValue("@Dept", txtDepartment.Text.Trim());
                cmd.Parameters.AddWithValue("@Batch", txtBatch.Text.Trim());
                cmd.Parameters.AddWithValue("@Contact", txtContact.Text.Trim());
                if (picturePath != null) cmd.Parameters.AddWithValue("@Pic", picturePath);
                cmd.Parameters.AddWithValue("@Id", Session["UserId"].ToString());
                cmd.ExecuteNonQuery();
                Session["UserName"] = txtName.Text.Trim();
            }
        }

        LoadProfile();
        ScriptManager.RegisterStartupScript(this, GetType(), "saved",
            "showModal(); document.getElementById('saveSuccessMsg').style.display='block';", true);
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

<form id="form1" runat="server" enctype="multipart/form-data">
<div class="profile-page">
    <div class="profile-container">
        <div class="profile-card">

            <div class="profile-avatar-wrap">
                <img id="profilePic" runat="server" src="images/members/default.jpg" alt="Profile" class="profile-avatar" />
            </div>

            <h2 class="profile-name" id="lblName" runat="server"></h2>
            <span class="profile-position-badge" id="lblPosition" runat="server"></span>
            <span class="profile-status-badge">Active Member</span>

            <div class="profile-info-grid">
                <div class="profile-info-item">
                    <span class="profile-info-label">Email</span>
                    <span class="profile-info-value" id="lblEmail" runat="server"></span>
                </div>
                <div class="profile-info-item">
                    <span class="profile-info-label">Department</span>
                    <span class="profile-info-value" id="lblDept" runat="server"></span>
                </div>
                <div class="profile-info-item">
                    <span class="profile-info-label">Batch</span>
                    <span class="profile-info-value" id="lblBatch" runat="server"></span>
                </div>
                <div class="profile-info-item">
                    <span class="profile-info-label">Contact</span>
                    <span class="profile-info-value" id="lblContact" runat="server"></span>
                </div>
                <div class="profile-info-item" id="cgpaRow" runat="server" visible="false">
                    <span class="profile-info-label">CGPA</span>
                    <span class="profile-info-value" id="lblCgpa" runat="server"></span>
                </div>
            </div>

            <div id="aboutRow" runat="server" visible="false"
                style="margin-top:20px;padding:16px;background:#111;border:1px solid #1e1e1e;border-radius:12px;">
                <div style="color:#666;font-size:0.82rem;margin-bottom:6px;">About</div>
                <p id="lblAbout" runat="server" style="color:#bbb;font-size:0.88rem;line-height:1.6;margin:0;"></p>
            </div>

            <div class="profile-btn-row">
                <a href="kbec.aspx" class="profile-back-btn">&#8592; Back</a>
                <button type="button" class="profile-edit-btn" onclick="showModal()">Edit Profile</button>
            </div>

        </div>
    </div>
</div>

<!-- EDIT MODAL -->
<div class="modal-overlay" id="modalOverlay" onclick="hideModal(event)">
    <div class="modal-box">

        <div class="modal-header">
            <h2>Edit Profile</h2>
            <button type="button" class="modal-close" onclick="closeModal()">&#10005;</button>
        </div>

        <div class="modal-warning">
            Changes will update your profile permanently.
        </div>

        <div id="saveSuccessMsg" class="modal-success" style="display:none;">
            Profile updated successfully!
        </div>

        <div id="modalMsg" class="modal-error" style="display:none;"></div>

        <div class="modal-body">

            <div class="form-group">
                <label>Full Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="Your name" />
            </div>

            <asp:PlaceHolder ID="positionGroup" runat="server">
            <div class="form-group">
                <label>Position</label>
                <asp:TextBox ID="txtPosition" runat="server" CssClass="form-input" placeholder="e.g. Senior Vice President" />
            </div>
            </asp:PlaceHolder>

            <div class="form-group">
                <label>Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" Enabled="false" />
                <span class="field-hint">Email cannot be changed</span>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>Department</label>
                    <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-input" placeholder="e.g. IPE" />
                </div>
                <div class="form-group">
                    <label>Batch</label>
                    <asp:TextBox ID="txtBatch" runat="server" CssClass="form-input" placeholder="e.g. 2021" />
                </div>
            </div>

            <div class="form-group">
                <label>Contact Number</label>
                <asp:TextBox ID="txtContact" runat="server" CssClass="form-input" placeholder="e.g. 01XXXXXXXXX" />
            </div>

            <div class="form-group">
                <label>Profile Picture</label>
                <div class="upload-box" onclick="document.getElementById('<%=fileUpload.ClientID%>').click()">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#f5c518" stroke-width="1.5" style="margin-bottom:6px;">
                        <rect x="3" y="3" width="18" height="18" rx="3"/>
                        <circle cx="8.5" cy="8.5" r="1.5"/>
                        <path d="M21 15l-5-5L5 21"/>
                    </svg>
                    <div class="upload-text">Click to change photo</div>
                    <div class="upload-hint">JPG or PNG, max 2MB</div>
                    <span id="picFileName" class="upload-filename"></span>
                </div>
                <asp:FileUpload ID="fileUpload" runat="server" Style="display:none;"
                    accept=".jpg,.jpeg,.png" onchange="showPicName(this)" />
            </div>

        </div>

        <div class="modal-footer">
            <button type="button" class="modal-cancel-btn" onclick="closeModal()">Cancel</button>
            <asp:Button ID="btnSave" runat="server" Text="Save Changes"
                CssClass="modal-save-btn" OnClick="btnSave_Click" />
        </div>

    </div>
</div>

</form>

<script src="kbec.js"></script>
<script>
    var profileBtn = document.getElementById('profileMenuButton');
    var profileMenu = document.getElementById('profileMenu');
    if (profileBtn && profileMenu) {
        profileBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            profileMenu.hidden = !profileMenu.hidden;
        });
        document.addEventListener('click', function (e) {
            if (!profileMenu.hidden && !profileMenu.contains(e.target) && e.target !== profileBtn)
                profileMenu.hidden = true;
        });
    }

    function showModal() {
        document.getElementById('modalOverlay').style.display = 'flex';
        document.getElementById('saveSuccessMsg').style.display = 'none';
        document.getElementById('modalMsg').style.display = 'none';
        document.getElementById('modalMsg').textContent = '';
    }

    function closeModal() {
        document.getElementById('modalOverlay').style.display = 'none';
    }

    function hideModal(e) {
        if (e.target === document.getElementById('modalOverlay'))
            closeModal();
    }

    function showPicName(input) {
        var name = input.files[0] ? input.files[0].name : '';
        document.getElementById('picFileName').textContent = name ? '&#10003; ' + name : '';
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeModal();
    });
</script>

</body>
</html>