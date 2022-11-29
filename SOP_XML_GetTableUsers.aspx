<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim strSql As String
        Dim lngCount As Long
        Dim strUser As String
        Try
            'http://87.238.116.200/SOP_XML_GetTableUsers.aspx
            
            strSql = "SELECT us_login " & _
                    "FROM [afr_sl_registration].[dbo].[tbl_user]" & _
                    "where isnull(us_is_table_agent, 0) = 1" & _
                    "order by us_login asc"

            lngCount = 0
            Dim dsetLogin As Data.DataSet
            Dim cnLogin As New clsMSSQLOledb("sa", "@fricell2014", "10.100.11.10", "afr_sl_registration")
            If cnLogin.blnOpenConn = True Then
                dsetLogin = cnLogin.dSetOpenDataSet(strSql, "LoginCheck")
                lngCount = dsetLogin.Tables("LoginCheck").Rows.Count
                If lngCount > 0 Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<table_agent>")
                    Response.Write("<Error> </Error>")
                    For i = 0 To lngCount - 1
                        strUser = dsetLogin.Tables("LoginCheck").Rows(i).Item("us_login") & ""
                        Response.Write("<user>")
                        Response.Write("<login>" & strUser.Trim & "</login>")
                        Response.Write("</user>")
                    Next
                    Response.Write("</table_agent>")
                    dsetLogin = Nothing
                    cnLogin.sCloseConn()
                Else
                    GoTo ConnectionError
                End If
            Else
ConnectionError:
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<table_agent>")
                Response.Write("<Error>Unable to connect to database server.</Error>")
                Response.Write("</table_agent>")
            End If
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<table_agent>")
            Response.Write("<Error>" & ex.ToString & "</Error>")

            Response.Write("</table_agent>")
        End Try
    End Sub   
</script>