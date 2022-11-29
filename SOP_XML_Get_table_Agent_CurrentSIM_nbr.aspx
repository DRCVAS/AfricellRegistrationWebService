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
            'http://87.238.116.200/SOP_XML_Get_table_Agent_CurrentSIM_nbr.aspx?TableUser=
            
            
            If Request.QueryString("TableUser") IsNot Nothing Then
                _TableUser = Request.QueryString("TableUser").ToString
                If _TableUser.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<table_supply>")
                    Response.Write("<Error>Invalid table user</Error>")
                    Response.Write("</table_supply>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<table_supply>")
                Response.Write("<Error>Invalid table user</Error>")
                Response.Write("</table_supply>")
                Exit Sub
            End If
            
            strSql = "select count(1) as nbrOfSIMs, " & _
                        " isnull((select top 1 us_table_agent_SIMs from afr_sl_registration.dbo.tbl_user where us_login = '" & _TableUser.Trim & "'),0)  as userLimit " & _
                        " from afr_sl_registration.dbo.tbl_table_supply_detail " & _
                        " where tsd_table_user = '" & _TableUser.Trim & "' " & _
                        " and isnull(tss_registration_status, 0) = 0"

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
                    Response.Write("<SIMCount>" & dsetLogin.Tables("LoginCheck").Rows(0).Item("nbrOfSIMs") & "</SIMCount>")
                    Response.Write("<userLimit>" & dsetLogin.Tables("LoginCheck").Rows(0).Item("userLimit") & "</userLimit>")
                    
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