<%@ Page Language="C#" %>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("kbec.aspx");
    }
</script>