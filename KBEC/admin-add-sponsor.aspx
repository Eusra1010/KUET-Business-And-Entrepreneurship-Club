<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Sponsor - KBEC</title>
    <link rel="stylesheet" href="auth.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { background: #0a0a0a; min-height: 100vh; display: flex; align-items: center; justify-content: center; }

        .auth-wrapper {
            background: linear-gradient(135deg, #0a0a0a 0%, #111 60%, #1a1200 100%);
            min-height: 100vh;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .sponsor-preview-wrap {
            display: none;
            margin-top: 12px;
            text-align: center;
        }
        .sponsor-preview-wrap img {
            height: 70px;
            object-fit: contain;
            border-radius: 10px;
            background: #1a1a1a;
            padding: 10px 16px;
            border: 1px solid #2a2a2a;
        }
        .form-hint { color: #555; font-size: 0.78rem; margin-top: 4px; }
        .section-divider { border: none; border-top: 1px solid #1e1e1e; margin: 6px 0; }
        .section-label {
            color: #555;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 2px;
        }
        input.form-input, textarea.form-input {
            width: 100%;
            background: #1a1a1a !important;
            border: 1px solid #2a2a2a !important;
            border-radius: 8px !important;
            padding: 12px 14px !important;
            color: #fff !important;
            font-size: 0.95rem !important;
            font-family: 'Segoe UI', sans-serif !important;
            outline: none !important;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        input.form-input:focus, textarea.form-input:focus {
            border-color: #f5c518 !important;
            box-shadow: 0 0 0 3px rgba(245,197,24,0.08) !important;
        }
        input.form-input::placeholder { color: #555 !important; }
    </style>
<script runat="server">
    string message = "";
    string messageClass = "";

    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");
    }

    void btnSave_Click(object sender, EventArgs e)
    {
        string name = txtName.Text.Trim();
        string url = txtUrl.Text.Trim();
        int displayOrder = 0;
        int.TryParse(txtOrder.Text.Trim(), out displayOrder);

        if (string.IsNullOrEmpty(name))
        {
            message = "Sponsor name is required.";
            messageClass = "auth-server-msg error";
            return;
        }
        if (!fileUpload.HasFile)
        {
            message = "Please upload a sponsor logo.";
            messageClass = "auth-server-msg error";
            return;
        }

        string ext = Path.GetExtension(fileUpload.FileName).ToLower();
        if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp")
        {
            message = "Only JPG, PNG, GIF or WEBP allowed.";
            messageClass = "auth-server-msg error";
            return;
        }
        if (fileUpload.PostedFile.ContentLength > 2 * 1024 * 1024)
        {
            message = "Image must be under 2MB.";
            messageClass = "auth-server-msg error";
            return;
        }

        string folder = Server.MapPath("~/images/sponsors/");
        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
        string fileName = Guid.NewGuid().ToString() + ext;
        fileUpload.SaveAs(folder + fileName);
        string logoPath = "images/sponsors/" + fileName;

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "INSERT INTO Sponsors (Name, LogoPath, WebsiteUrl, DisplayOrder, IsActive) VALUES (@Name,@Logo,@Url,@Order,1)", conn);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Logo", logoPath);
            cmd.Parameters.AddWithValue("@Url", string.IsNullOrEmpty(url) ? (object)DBNull.Value : url);
            cmd.Parameters.AddWithValue("@Order", displayOrder);
            cmd.ExecuteNonQuery();
        }

        Response.Redirect("admin-sponsors.aspx");
    }
</script>
</head>
<body>
<form id="form1" runat="server" enctype="multipart/form-data">
<div class="auth-wrapper">
    <div class="auth-box auth-box-wide">

        <div class="auth-logo">
            <img src="logo.jpg" alt="KBEC Logo" />
            <h2>KBEC</h2>
        </div>

        <h1 class="auth-title">Add New Sponsor</h1>
        <p class="auth-subtitle">Upload a sponsor logo to display on the homepage marquee</p>

        <% if (!string.IsNullOrEmpty(message)) { %>
        <div class="<%= messageClass %>"><%= message %></div>
        <% } %>

        <div class="auth-form">

            <div class="section-label">Sponsor Details</div>
            <hr class="section-divider" />

            <div class="signup-row">
                <div class="form-group">
                    <label>Sponsor Name <span class="req">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-input"
                        placeholder="e.g. Walton" />
                    <span id="nameError" class="field-error"></span>
                </div>
                <div class="form-group">
                    <label>Display Order</label>
                    <asp:TextBox ID="txtOrder" runat="server" CssClass="form-input"
                        placeholder="e.g. 1" Text="0" />
                    <span class="form-hint">Lower number = appears first in marquee</span>
                </div>
            </div>

            <div class="form-group">
                <label>Website URL <span style="color:#555;font-size:0.8rem;">(optional)</span></label>
                <asp:TextBox ID="txtUrl" runat="server" CssClass="form-input"
                    placeholder="https://example.com" />
            </div>

            <div class="section-label" style="margin-top:8px;">Logo Upload</div>
            <hr class="section-divider" />

            <div class="form-group">
                <label>Sponsor Logo <span class="req">*</span></label>
                <div class="signup-upload-box" id="uploadBox">
                    <span class="signup-upload-icon">
                        <svg viewBox="0 0 24 24" width="32" height="32" fill="none" stroke="#555" stroke-width="1.5">
                            <rect x="3" y="3" width="18" height="18" rx="3"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <path d="M21 15l-5-5L5 21"/>
                        </svg>
                    </span>
                    <span class="signup-upload-text">Click to upload sponsor logo</span>
                    <span class="signup-upload-hint">JPG, PNG, GIF or WEBP &nbsp;&#183;&nbsp; Max 2MB</span>
                    <span id="fileName" class="signup-upload-filename"></span>
                </div>
                <asp:FileUpload ID="fileUpload" runat="server" Style="display:none;"
                    accept=".jpg,.jpeg,.png,.gif,.webp" />
                <span id="logoError" class="field-error"></span>
                <div class="sponsor-preview-wrap" id="previewWrap">
                    <img id="previewImg" src="" alt="Preview" />
                </div>
            </div>

            <div class="signup-action-row" style="margin-top:8px;">
                <a href="admin-sponsors.aspx" class="signup-cancel-btn"
                    style="display:inline-block;text-align:center;text-decoration:none;">
                    &#8592; Cancel
                </a>
                <button type="button" class="auth-btn signup-submit-btn" onclick="submitForm()">
                    Add Sponsor
                </button>
            </div>

            <asp:Button ID="btnSave" runat="server" Style="display:none;" OnClick="btnSave_Click" />

        </div>
    </div>
</div>
</form>

<script>
    document.getElementById('uploadBox').addEventListener('click', function () {
        document.getElementById('<%=fileUpload.ClientID%>').click();
    });

    document.getElementById('<%=fileUpload.ClientID%>').addEventListener('change', function () {
        var file = this.files[0];
        if (!file) return;
        document.getElementById('fileName').textContent = '\u2713 ' + file.name;
        var reader = new FileReader();
        reader.onload = function (e) {
            document.getElementById('previewImg').src = e.target.result;
            document.getElementById('previewWrap').style.display = 'block';
        };
        reader.readAsDataURL(file);
    });

    function submitForm() {
        var name = document.getElementById('<%=txtName.ClientID%>').value.trim();
        var hasFile = document.getElementById('<%=fileUpload.ClientID%>').files.length > 0;
        var valid = true;
        if (!name) { document.getElementById('nameError').textContent = 'Sponsor name is required.'; valid = false; }
        else { document.getElementById('nameError').textContent = ''; }
        if (!hasFile) { document.getElementById('logoError').textContent = 'Please upload a logo.'; valid = false; }
        else { document.getElementById('logoError').textContent = ''; }
        if (!valid) return;
        document.getElementById('<%=btnSave.ClientID%>').click();
    }
</script>
</body>
</html>