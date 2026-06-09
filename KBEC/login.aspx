<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="auth.css">
<script runat="server">
    string message = "";
    string messageClass = "";

    void btnLogin_Click(object sender, EventArgs e)
    {
        string name = txtName.Text.Trim();
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text;

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
        {
            message = "All fields are required.";
            messageClass = "auth-server-msg error";
            return;
        }

        // TODO: Check against database
        message = "Login successful! Welcome, " + name + ".";
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

            <h1 class="auth-title">Welcome Back</h1>
            <p class="auth-subtitle">Log in to your KBEC account</p>

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
                    <label>Password</label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter your password" />
                        <button type="button" class="toggle-pw" onclick="togglePassword('<%=txtPassword.ClientID%>', this)">Show</button>
                    </div>
                    <span id="pwStrength" class="strength-msg"></span>
                    <span id="pwError" class="field-error"></span>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Log In"
                    CssClass="auth-btn" OnClick="btnLogin_Click"
                    OnClientClick="return validateForm()" />

                <p class="auth-switch">Don't have an account? <a href="signup.aspx">Sign up</a></p>
            </div>
        </div>
    </div>
    </form>
    <script>
        document.getElementById('<%=txtPassword.ClientID%>').addEventListener('input', function () {
            var pw = this.value;
            var msg = document.getElementById('pwStrength');
            if (pw.length === 0) { msg.textContent = ''; return; }
            var suggestions = [];
            if (pw.length < 8) suggestions.push('at least 8 characters');
            if (!/[A-Z]/.test(pw)) suggestions.push('an uppercase letter');
            if (!/[0-9]/.test(pw)) suggestions.push('a number');
            if (!/[^A-Za-z0-9]/.test(pw)) suggestions.push('a symbol like @, #, !');
            if (suggestions.length === 0) {
                msg.textContent = '✓ Strong password';
                msg.className = 'strength-msg strong';
            } else {
                msg.textContent = 'Tip: Add ' + suggestions.join(', ');
                msg.className = 'strength-msg fair';
            }
        });

        function togglePassword(fieldId, btn) {
            var field = document.getElementById(fieldId);
            if (field.type === 'password') { field.type = 'text'; btn.textContent = 'Hide'; }
            else { field.type = 'password'; btn.textContent = 'Show'; }
        }

        function validateForm() {
            var valid = true;
            var name = document.getElementById('<%=txtName.ClientID%>').value.trim();
            var email = document.getElementById('<%=txtEmail.ClientID%>').value.trim();
            var pw = document.getElementById('<%=txtPassword.ClientID%>').value;
            if (!name) { document.getElementById('nameError').textContent = 'Name is required.'; valid = false; }
            else { document.getElementById('nameError').textContent = ''; }
            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('emailError').textContent = 'Enter a valid email.'; valid = false;
            } else { document.getElementById('emailError').textContent = ''; }
            if (!pw) { document.getElementById('pwError').textContent = 'Password is required.'; valid = false; }
            else { document.getElementById('pwError').textContent = ''; }
            return valid;
        }
    </script>
</body>
</html>