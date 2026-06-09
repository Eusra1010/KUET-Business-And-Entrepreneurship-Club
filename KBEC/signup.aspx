<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - KBEC</title>
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
        string name = txtName.Text.Trim();
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text;
        string confirm = txtConfirm.Text;

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) ||
            string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirm))
        {
            message = "All fields are required.";
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

        // TODO: Save to database
        message = "Account created successfully! You can now log in.";
        messageClass = "auth-server-msg success";
    }
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="auth-wrapper">
        <div class="auth-box">

            <div class="auth-logo">
                <img src="logo.jpg" alt="KBEC Logo" />
                <h2>KBEC</h2>
            </div>

            <h1 class="auth-title">Create Account</h1>
            <p class="auth-subtitle">Join the KUET Business &amp; Entrepreneurship Club</p>

            <% if (!string.IsNullOrEmpty(message)) { %>
                <div class="<%= messageClass %>"><%= message %></div>
            <% } %>

            <div class="auth-form">
                <div class="form-group">
                    <label>Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="Enter your full name" />
                    <span id="nameError" class="field-error"></span>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email" placeholder="Enter your email" />
                    <span id="emailError" class="field-error"></span>
                </div>
                <div class="form-group">
                    <label>New Password</label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Create a strong password" />
                        <button type="button" class="toggle-pw" onclick="togglePassword('<%=txtPassword.ClientID%>', this)">Show</button>
                    </div>
                    <div class="strength-bar-wrap">
                        <div class="strength-bar" id="strengthBar"></div>
                    </div>
                    <span id="strengthMsg" class="strength-msg"></span>
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-input" TextMode="Password" placeholder="Re-enter your password" />
                        <button type="button" class="toggle-pw" onclick="togglePassword('<%=txtConfirm.ClientID%>', this)">Show</button>
                    </div>
                    <div class="strength-bar-wrap">
                        <div class="strength-bar" id="strengthBarConfirm"></div>
                    </div>
                    <span id="matchMsg" class="strength-msg"></span>
                </div>

                <asp:Button ID="btnSignup" runat="server" Text="Create Account"
                    CssClass="auth-btn" OnClick="btnSignup_Click"
                    OnClientClick="return validateForm()" />

                <p class="auth-switch">Already have an account? <a href="login.aspx">Log in</a></p>
            </div>
        </div>
    </div>
    </form>
    <script>
        var pwId = '<%=txtPassword.ClientID%>';
        var confirmId = '<%=txtConfirm.ClientID%>';

        document.getElementById(pwId).addEventListener('input', function () {
            checkStrength(this.value, 'strengthBar', 'strengthMsg');
        });
        document.getElementById(confirmId).addEventListener('input', function () {
            checkConfirm(this.value);
        });

        function checkStrength(password, barId, msgId) {
            var bar = document.getElementById(barId);
            var msg = document.getElementById(msgId);
            var score = 0;
            var suggestions = [];
            if (password.length >= 8) score++; else suggestions.push('8+ characters');
            if (/[A-Z]/.test(password)) score++; else suggestions.push('uppercase letter');
            if (/[0-9]/.test(password)) score++; else suggestions.push('a number');
            if (/[^A-Za-z0-9]/.test(password)) score++; else suggestions.push('a symbol (@,#,!)');
            bar.className = 'strength-bar';
            if (password.length === 0) { bar.style.width = '0%'; msg.textContent = ''; return; }
            if (score <= 1) {
                bar.style.width = '25%'; bar.classList.add('weak');
                msg.textContent = '✗ Weak — Add: ' + suggestions.join(', ');
                msg.className = 'strength-msg weak';
            } else if (score === 2) {
                bar.style.width = '50%'; bar.classList.add('fair');
                msg.textContent = '~ Fair — Add: ' + suggestions.join(', ');
                msg.className = 'strength-msg fair';
            } else if (score === 3) {
                bar.style.width = '75%'; bar.classList.add('good');
                msg.textContent = '✓ Good — Add: ' + suggestions.join(', ');
                msg.className = 'strength-msg good';
            } else {
                bar.style.width = '100%'; bar.classList.add('strong');
                msg.textContent = '✓ Strong password!';
                msg.className = 'strength-msg strong';
            }
        }

        function checkConfirm(value) {
            var pw = document.getElementById(pwId).value;
            var bar = document.getElementById('strengthBarConfirm');
            var msg = document.getElementById('matchMsg');
            if (value.length === 0) { bar.style.width = '0%'; bar.className = 'strength-bar'; msg.textContent = ''; return; }
            if (pw !== value) {
                bar.style.width = '50%'; bar.className = 'strength-bar weak';
                msg.textContent = '✗ Passwords do not match';
                msg.className = 'strength-msg weak';
            } else {
                bar.style.width = '100%'; bar.className = 'strength-bar strong';
                msg.textContent = '✓ Passwords match';
                msg.className = 'strength-msg strong';
            }
        }

        function togglePassword(fieldId, btn) {
            var field = document.getElementById(fieldId);
            if (field.type === 'password') { field.type = 'text'; btn.textContent = 'Hide'; }
            else { field.type = 'password'; btn.textContent = 'Show'; }
        }

        function validateForm() {
            var name = document.getElementById('<%=txtName.ClientID%>').value.trim();
            var email = document.getElementById('<%=txtEmail.ClientID%>').value.trim();
            var pw = document.getElementById(pwId).value;
            var confirm = document.getElementById(confirmId).value;
            if (!name) { document.getElementById('nameError').textContent = 'Name is required.'; return false; }
            else { document.getElementById('nameError').textContent = ''; }
            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('emailError').textContent = 'Enter a valid email.'; return false;
            } else { document.getElementById('emailError').textContent = ''; }
            var score = 0;
            if (pw.length >= 8) score++;
            if (/[A-Z]/.test(pw)) score++;
            if (/[0-9]/.test(pw)) score++;
            if (/[^A-Za-z0-9]/.test(pw)) score++;
            if (score < 3) {
                document.getElementById('strengthMsg').textContent = '✗ Password not strong enough!';
                document.getElementById('strengthMsg').className = 'strength-msg weak';
                return false;
            }
            if (pw !== confirm) {
                document.getElementById('matchMsg').textContent = '✗ Passwords do not match';
                document.getElementById('matchMsg').className = 'strength-msg weak';
                return false;
            }
            return true;
        }
    </script>
</body>
</html>