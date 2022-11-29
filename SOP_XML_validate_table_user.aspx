<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim strSql As String
        Dim _TableUser As String = ""
        
        Dim lngCount As Long = 0
        Try
            'http://87.238.116.200/SOP_XML_validate_table_user.aspx?TableUser=
            
            If Request.QueryString("TableUser") IsNot Nothing Then
                _TableUser = Request.QueryString("TableUser").ToString
                If _TableUser.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<ValidateTableUSER>")
                    Response.Write("<Error>Invalid table user</Error>")
                    Response.Write("</ValidateTableUSER>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<ValidateTableUSER>")
                Response.Write("<Error>Invalid table user</Error>")
                Response.Write("</ValidateTableUSER>")
                Exit Sub
            End If
            
            strSql = "SELECT TOP 1 1 FROM [afr_sl_registration].[dbo].[tbl_user] where us_is_table_agent = 1 " & _
                        "  and us_login = '" & _TableUser.Trim & "' "

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
                    Response.Write("<ValidateTableUSER>")
                    Response.Write("<Error> </Error>")
                    Response.Write("<valid>true</valid>")
                    Response.Write("</ValidateTableUSER>")
                    dsetLogin = Nothing
                    cnLogin.sCloseConn()
                Else
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<ValidateTableUSER>")
                    Response.Write("<Error> </Error>")
                    Response.Write("<valid>false</valid>")
                    Response.Write("</ValidateTableUSER>")
                End If
            Else
ConnectionError:
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<ValidateTableUSER>")
                Response.Write("<Error>Unable to connect to database server.</Error>")
                Response.Write("</ValidateTableUSER>")
            End If
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<ValidateTableUSER>")
            Response.Write("<Error>" & ex.ToString & "</Error>")
            Response.Write("</ValidateTableUSER>")
        End Try
    End Sub   
</script>