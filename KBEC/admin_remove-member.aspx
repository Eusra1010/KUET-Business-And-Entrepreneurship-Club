<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
        {
            Response.Redirect("admin-login.aspx");
            return;
        }

        string id = Request.QueryString["id"];
        if (!string.IsNullOrEmpty(id))
        {
            string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Members SET Status='Removed' WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();
            }
        }
        Response.Redirect("executives.aspx");
    }
</script>