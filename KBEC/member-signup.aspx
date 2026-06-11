<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Sign Up - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="auth.css">
<script runat="server">
    string message = "";
    string messageClass = "";

    bool IsStrongPassword(string password)
    {
        if (password.Length < 8) return false;
        bool hasUpper = false, hasDigit = false, hasSpecial = false;
        foreach (char c in password)
        {
            if (char.IsUpper(c)) hasUpper = true;
            if (char.IsDigit(c)) hasDigit = true;
            if (!char.IsLetterOrDigit(c)) hasSpecial = true;
        }
        return (hasUpper ? 1 : 0) + (hasDigit ? 1 : 0) + (hasSpecial ? 1 : 0) >= 2;
    }

    void btnSignup_Click(object sender, EventArgs e)
    {
        string firstName = txtFirstName.Text.Trim();
        string lastName = txtLastName.Text.Trim();
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text;
        string confirm = txtConfirm.Text;
        string department = txtDepartment.Text.Trim();
        string batch = txtBatch.Text.Trim();
        string cgpa = txtCGPA.Text.Trim();
        string contact = txtContact.Text.Trim();
        string about = txtAbout.Text.Trim();

        if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) ||
            string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) ||
            string.IsNullOrEmpty(department) || string.IsNullOrEmpty(batch))
        {
            message = "Please fill all required fields.";
            messageClass = "auth-server-msg error";
            return;
        }

        if (password != confirm)
        {
            message = "Passwords do not match.";
            messageClass = "auth-server-msg error";
            return;
        }

        if (!IsStrongPassword(password))
        {
            message = "Password not strong enough. Use 8+ characters with uppercase, numbers, and symbols.";
            messageClass = "auth-server-msg error";
            return;
        }

        string picturePath = "images/members/default.jpg";
        if (fileUpload.HasFile)
        {
            string ext = Path.GetExtension(fileUpload.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
            {
                message = "Only JPG and PNG images are allowed.";
                messageClass = "auth-server-msg error";
                return;
            }
            if (fileUpload.PostedFile.ContentLength > 2 * 1024 * 1024)
            {
                message = "Image size must be under 2MB.";
                messageClass = "auth-server-msg error";
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
            SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Members WHERE Email=@Email", conn);
            checkCmd.Parameters.AddWithValue("@Email", email);
            int exists = (int)checkCmd.ExecuteScalar();
            if (exists > 0)
            {
                message = "An application with this email already exists.";
                messageClass = "auth-server-msg error";
                return;
            }

            SqlCommand cmd = new SqlCommand(
                "INSERT INTO Members (FirstName, LastName, Email, PasswordHash, Department, Batch, CGPA, ContactNumber, AboutYourself, ProfilePicturePath) VALUES (@FN, @LN, @Email, @Pass, @Dept, @Batch, @CGPA, @Contact, @About, @Pic)", conn);
            cmd.Parameters.AddWithValue("@FN", firstName);
            cmd.Parameters.AddWithValue("@LN", lastName);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@Pass", password);
            cmd.Parameters.AddWithValue("@Dept", department);
            cmd.Parameters.AddWithValue("@Batch", batch);
            cmd.Parameters.AddWithValue("@CGPA", string.IsNullOrEmpty(cgpa) ? (object)DBNull.Value : cgpa);
            cmd.Parameters.AddWithValue("@Contact", string.IsNullOrEmpty(contact) ? (object)DBNull.Value : contact);
            cmd.Parameters.AddWithValue("@About", string.IsNullOrEmpty(about) ? (object)DBNull.Value : about);
            cmd.Parameters.AddWithValue("@Pic", picturePath);
            cmd.ExecuteNonQuery();
        }

        message = "Application submitted! The admin will review and approve your membership.";
        messageClass = "auth-server-msg success";
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

            <h1 class="auth-title">New Member Application</h1>
            <p class="auth-subtitle">Fill in your details to apply for KBEC membership</p>

            <% if (!string.IsNullOrEmpty(message)) { %>
                <div class="<%= messageClass %>"><%= message %></div>
            <% } %>

            <div class="auth-form">

                <!-- Name Row -->
                <div class="signup-row">
                    <div class="form-group">
                        <label>First Name *</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input"
                            placeholder="e.g. Nawad" />
                        <span id="fnError" class="field-error"></span>
                    </div>
                    <div class="form-group">
                        <label>Last Name *</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input"
                            placeholder="e.g. Ittamum" />
                        <span id="lnError" class="field-error"></span>
                    </div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label>Email Address *</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input"
                        TextMode="Email" placeholder="e.g. yourname@stud.kuet.ac.bd" />
                    <span id="emailError" class="field-error"></span>
                </div>

                <!-- Password Row -->
                <div class="signup-row">
                    <div class="form-group">
                        <label>New Password *</label>
                        <div class="input-wrap">
                            <input type="password" id="pwField" name="pwField" class="form-input"
                                placeholder="Min 8 chars, uppercase, number and symbol"
                                autocomplete="new-password" />
                            <button type="button" class="toggle-pw" onclick="togglePw('pwField', this)">Show</button>
                        </div>
                        <div class="strength-bar-wrap">
                            <div class="strength-bar" id="strengthBar"></div>
                        </div>
                        <span id="strengthMsg" class="strength-msg"></span>
                    </div>
                    <div class="form-group">
                        <label>Confirm Password *</label>
                        <div class="input-wrap">
                            <input type="password" id="confirmField" name="confirmField" class="form-input"
                                placeholder="Re-enter your password"
                                autocomplete="new-password" />
                            <button type="button" class="toggle-pw" onclick="togglePw('confirmField', this)">Show</button>
                        </div>
                        <div class="strength-bar-wrap">
                            <div class="strength-bar" id="strengthBarConfirm"></div>
                        </div>
                        <span id="matchMsg" class="strength-msg"></span>
                    </div>
                </div>

                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Style="display:none;" />
                <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" Style="display:none;" />

                <!-- Department + Batch -->
                <div class="signup-row">
                    <div class="form-group">
                        <label>Department *</label>
                        <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-input"
                            placeholder="e.g. Industrial Engineering" />
                    </div>
                    <div class="form-group">
                        <label>Batch *</label>
                        <asp:TextBox ID="txtBatch" runat="server" CssClass="form-input"
                            placeholder="e.g. 2021" />
                    </div>
                </div>

                <!-- CGPA + Contact -->
                <div class="signup-row">
                    <div class="form-group">
                        <label>CGPA (optional)</label>
                        <asp:TextBox ID="txtCGPA" runat="server" CssClass="form-input"
                            placeholder="e.g. 3.75" />
                    </div>
                    <div class="form-group">
                        <label>Contact Number (optional)</label>
                        <asp:TextBox ID="txtContact" runat="server" CssClass="form-input"
                            placeholder="e.g. 01XXXXXXXXX" />
                    </div>
                </div>

                <!-- About -->
                <div class="form-group">
                    <label>Tell us about yourself (optional)</label>
                    <asp:TextBox ID="txtAbout" runat="server" CssClass="form-input signup-textarea"
                        TextMode="MultiLine" Rows="4"
                        placeholder="e.g. I am a 3rd year IPE student passionate about entrepreneurship..." />
                </div>

                <!-- Profile Picture Upload -->
                <div class="form-group">
                    <label>Profile Picture (optional)</label>
                   <div class="signup-upload-box" id="uploadBox">
    <span class="signup-upload-icon">
        <svg viewBox="0 0 24 24" width="32" height="32" fill="none" stroke="#555" stroke-width="1.5">
            <rect x="3" y="3" width="18" height="18" rx="3"/>
            <circle cx="8.5" cy="8.5" r="1.5"/>
            <path d="M21 15l-5-5L5 21"/>
        </svg>
    </span>
    <span class="signup-upload-text">Click to upload image</span>
    <span class="signup-upload-hint">JPG or PNG &nbsp;&#183;&nbsp; Max size 2MB</span>
    <span id="fileName" class="signup-upload-filename"></span>
</div>
                    <asp:FileUpload ID="fileUpload" runat="server" Style="display:none;"
                        accept=".jpg,.jpeg,.png" />
                </div>

                <!-- Buttons -->
                <div class="signup-action-row">
                    <button type="button" class="signup-cancel-btn"
                        onclick="window.location.href='member-login.aspx'">
                        Cancel
                    </button>
                    <button type="button" class="auth-btn signup-submit-btn" onclick="submitForm()">
                        Submit Application
                    </button>
                </div>

                <asp:Button ID="btnSignup" runat="server" Style="display:none;"
                    OnClick="btnSignup_Click" />

                <p class="auth-switch" style="margin-top:16px;">
                    Already a member? <a href="member-login.aspx">Log in</a>
                </p>

            </div>
        </div>
    </div>
    </form>

    <script>
        document.getElementById('uploadBox').addEventListener('click', function () {
            document.getElementById('<%=fileUpload.ClientID%>').click();
        });

        document.getElementById('<%=fileUpload.ClientID%>').addEventListener('change', function () {
            var name = this.files[0] ? this.files[0].name : '';
            document.getElementById('fileName').textContent = name ? '✓ ' + name : '';
        });

        document.getElementById('pwField').addEventListener('input', function () { checkStrength(this.value); });
        document.getElementById('confirmField').addEventListener('input', function () { checkConfirm(this.value); });

        function checkStrength(password) {
            var bar = document.getElementById('strengthBar');
            var msg = document.getElementById('strengthMsg');
            var score = 0;
            var suggestions = [];
            if (password.length >= 8) score++; else suggestions.push('8+ characters');
            if (/[A-Z]/.test(password)) score++; else suggestions.push('an uppercase letter');
            if (/[0-9]/.test(password)) score++; else suggestions.push('a number');
            if (/[^A-Za-z0-9]/.test(password)) score++; else suggestions.push('a symbol like @, #, !');
            bar.className = 'strength-bar';
            if (password.length === 0) { bar.style.width = '0%'; msg.textContent = ''; return; }
            if (score <= 1) { bar.style.width = '25%'; bar.classList.add('weak'); msg.textContent = 'Weak - Add: ' + suggestions.join(', '); msg.className = 'strength-msg weak'; }
            else if (score === 2) { bar.style.width = '50%'; bar.classList.add('fair'); msg.textContent = 'Fair - Add: ' + suggestions.join(', '); msg.className = 'strength-msg fair'; }
            else if (score === 3) { bar.style.width = '75%'; bar.classList.add('good'); msg.textContent = 'Good - Add: ' + suggestions.join(', '); msg.className = 'strength-msg good'; }
            else { bar.style.width = '100%'; bar.classList.add('strong'); msg.textContent = 'Strong password!'; msg.className = 'strength-msg strong'; }
        }

        function checkConfirm(value) {
            var pw = document.getElementById('pwField').value;
            var bar = document.getElementById('strengthBarConfirm');
            var msg = document.getElementById('matchMsg');
            if (value.length === 0) { bar.style.width = '0%'; bar.className = 'strength-bar'; msg.textContent = ''; return; }
            if (pw !== value) { bar.style.width = '50%'; bar.className = 'strength-bar weak'; msg.textContent = 'Passwords do not match'; msg.className = 'strength-msg weak'; }
            else { bar.style.width = '100%'; bar.className = 'strength-bar strong'; msg.textContent = 'Passwords match'; msg.className = 'strength-msg strong'; }
        }

        function togglePw(fieldId, btn) {
            var field = document.getElementById(fieldId);
            if (field.type === 'password') { field.type = 'text'; btn.textContent = 'Hide'; }
            else { field.type = 'password'; btn.textContent = 'Show'; }
        }

        function submitForm() {
            var fn = document.getElementById('<%=txtFirstName.ClientID%>').value.trim();
            var ln = document.getElementById('<%=txtLastName.ClientID%>').value.trim();
            var email = document.getElementById('<%=txtEmail.ClientID%>').value.trim();
            var pw = document.getElementById('pwField').value;
            var confirm = document.getElementById('confirmField').value;

            if (!fn) { document.getElementById('fnError').textContent = 'First name is required.'; return; }
            else { document.getElementById('fnError').textContent = ''; }
            if (!ln) { document.getElementById('lnError').textContent = 'Last name is required.'; return; }
            else { document.getElementById('lnError').textContent = ''; }
            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('emailError').textContent = 'Enter a valid email.'; return;
            } else { document.getElementById('emailError').textContent = ''; }

            var score = 0;
            if (pw.length >= 8) score++;
            if (/[A-Z]/.test(pw)) score++;
            if (/[0-9]/.test(pw)) score++;
            if (/[^A-Za-z0-9]/.test(pw)) score++;
            if (score < 3) {
                document.getElementById('strengthMsg').textContent = 'Password is not strong enough!';
                document.getElementById('strengthMsg').className = 'strength-msg weak';
                return;
            }
            if (pw !== confirm) {
                document.getElementById('matchMsg').textContent = 'Passwords do not match';
                document.getElementById('matchMsg').className = 'strength-msg weak';
                return;
            }

            document.getElementById('<%=txtPassword.ClientID%>').value = pw;
            document.getElementById('<%=txtConfirm.ClientID%>').value = confirm;
            document.getElementById('<%=btnSignup.ClientID%>').click();
        }
    </script>
</body>
</html>