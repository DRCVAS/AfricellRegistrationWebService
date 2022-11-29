<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim strSql As String
        Dim _TableUser As String = ""
        Dim _IMSI As String = ""
        Dim _MSISDN As String = ""
        
        Dim lngCount As Long = 0
        Try
            'http://87.238.116.200/SOP_XML_ValidateTableSIM.aspx?TableUser=&IMSI=&MSISDN=
            
            If Request.QueryString("TableUser") IsNot Nothing Then
                _TableUser = Request.QueryString("TableUser").ToString
                If _TableUser.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<ValidateTableSIM>")
                    Response.Write("<Error>Invalid table user</Error>")
                    Response.Write("</ValidateTableSIM>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<ValidateTableSIM>")
                Response.Write("<Error>Invalid table user</Error>")
                Response.Write("</ValidateTableSIM>")
                Exit Sub
            End If
            
            If Request.QueryString("IMSI") IsNot Nothing Then
                _IMSI = Request.QueryString("IMSI").ToString
            End If
            
            If Request.QueryString("MSISDN") IsNot Nothing Then
                _MSISDN = Request.QueryString("MSISDN").ToString
            End If
            
            If (_IMSI.Trim + _MSISDN.Trim) = "" Then
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<ValidateTableSIM>")
                Response.Write("<Error>IMSI or MSISDN must be supplied</Error>")
                Response.Write("</ValidateTableSIM>")
                Exit Sub
            End If
                
            strSql = "select top 1 tss_IMSI, tss_MSISDN from afr_sl_registration.dbo.tbl_table_supply_detail " & _
                        "  where tsd_table_user = '" & _TableUser.Trim & "' " & _
                        "  and isnull(tss_registration_status, 0) = 0 "
            If _IMSI.Trim = "" Then
                strSql = strSql + " and tss_MSISDN = '" & _MSISDN.Trim & "' "
            Else
                strSql = strSql + " and tss_IMSI = '" & _IMSI.Trim & "' "
            End If
         

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
                    Response.Write("<ValidateTableSIM>")
                    Response.Write("<Error> </Error>")
                    Response.Write("<IMSI>" & dsetLogin.Tables("LoginCheck").Rows(0).Item("tss_IMSI") & "</IMSI>")
                    Response.Write("<MSISDN>" & dsetLogin.Tables("LoginCheck").Rows(0).Item("tss_MSISDN") & "</MSISDN>")
                    
                    Response.Write("</ValidateTableSIM>")
                    dsetLogin = Nothing
                    cnLogin.sCloseConn()
                Else
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<ValidateTableSIM>")
                    Response.Write("<Error>Access to this SIM is denied.</Error>")
                    Response.Write("</ValidateTableSIM>")
                End If
            Else
ConnectionError:
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<ValidateTableSIM>")
                Response.Write("<Error>Unable to connect to database server.</Error>")
                Response.Write("</ValidateTableSIM>")
            End If
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<ValidateTableSIM>")
            Response.Write("<Error>" & ex.ToString & "</Error>")
            Response.Write("</ValidateTableSIM>")
        End Try
    End Sub   
</script>