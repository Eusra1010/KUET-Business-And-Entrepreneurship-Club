<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Login - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="auth.css">
<script runat="server">
    string message = "";
    string messageClass = "";

    void btnLogin_Click(object sender, EventArgs e)
    {
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text;

        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
        {
            message = "Email and password are required.";
            messageClass = "auth-server-msg error";
            return;
        }

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            // Check MemberAdmins (executives)
            SqlCommand cmd1 = new SqlCommand(
                "SELECT Id, Name, Position FROM MemberAdmins WHERE Email=@Email AND PasswordHash=@Password", conn);
            cmd1.Parameters.AddWithValue("@Email", email);
            cmd1.Parameters.AddWithValue("@Password", password);
            SqlDataReader r1 = cmd1.ExecuteReader();
            if (r1.Read())
            {
                Session.Clear();
                Session["UserId"] = r1["Id"].ToString();
                Session["UserName"] = r1["Name"].ToString();
                Session["UserRole"] = "Executive";
                Session["UserPosition"] = r1["Position"].ToString();
                r1.Close();
                Response.Redirect("kbec.aspx");
                return;
            }
            r1.Close();

            // Check Members (approved new members)
            SqlCommand cmd2 = new SqlCommand(
                "SELECT Id, FirstName, LastName FROM Members WHERE Email=@Email AND PasswordHash=@Password AND Status='Approved'", conn);
            cmd2.Parameters.AddWithValue("@Email", email);
            cmd2.Parameters.AddWithValue("@Password", password);
            SqlDataReader r2 = cmd2.ExecuteReader();
            if (r2.Read())
            {
                Session.Clear();
                Session["UserId"] = r2["Id"].ToString();
                Session["UserName"] = r2["FirstName"].ToString() + " " + r2["LastName"].ToString();
                Session["UserRole"] = "Member";
                r2.Close();
                Response.Redirect("kbec.aspx");
                return;
            }
            r2.Close();

            // Check if pending
            SqlCommand checkCmd = new SqlCommand(
                "SELECT Status FROM Members WHERE Email=@Email", conn);
            checkCmd.Parameters.AddWithValue("@Email", email);
            object status = checkCmd.ExecuteScalar();
            if (status != null && status.ToString() == "Pending")
                message = "Your application is pending admin approval.";
            else
                message = "Invalid email or password.";

            messageClass = "auth-server-msg error";
        }
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
            <h1 class="auth-title">Member Login</h1>
            <p class="auth-subtitle">Welcome back, KBEC executive</p>
            <% if (!string.IsNullOrEmpty(message)) { %>
                <div class="<%= messageClass %>"><%= message %></div>
            <% } %>
            <div class="auth-form">
                <div class="form-group">
                    <label>Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input"
                        TextMode="Email" placeholder="Enter your email" />
                    <span id="emailError" class="field-error"></span>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input"
                            TextMode="Password" placeholder="Enter your password" />
                        <button type="button" class="toggle-pw"
                            onclick="togglePassword('<%=txtPassword.ClientID%>', this)">Show</button>
                    </div>
                    <span id="pwError" class="field-error"></span>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Log In"
                    CssClass="auth-btn" OnClick="btnLogin_Click"
                    OnClientClick="return validateForm()" />

              <p class="auth-switch">Are you a new member? <a href="member-signup.aspx">Sign up</a></p>
<div class="auth-back-row">
    <a href="kbec.aspx" class="auth-back-link">&#8592; Back to Website</a>
</div>            </div>
        </div>
    </div>
    </form>
    <script>
        function togglePassword(fieldId, btn) {
            var field = document.getElementById(fieldId);
            if (field.type === 'password') { field.type = 'text'; btn.textContent = 'Hide'; }
            else { field.type = 'password'; btn.textContent = 'Show'; }
        }

        function validateForm() {
            var valid = true;
            var email = document.getElementById('<%=txtEmail.ClientID%>').value.trim();
            var pw = document.getElementById('<%=txtPassword.ClientID%>').value;
            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('emailError').textContent = 'Enter a valid email.';
                valid = false;
            } else { document.getElementById('emailError').textContent = ''; }
            if (!pw) {
                document.getElementById('pwError').textContent = 'Password is required.';
                valid = false;
            } else { document.getElementById('pwError').textContent = ''; }
            return valid;
        }
    </script>
</body>
</html>