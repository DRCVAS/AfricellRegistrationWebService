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
            'http://87.238.116.200/SOP_XML_validate_IMSI_MSISDN.aspx?IMSI=&MSISDN=
            
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
                Response.Write("<ValidateSIM>")
                Response.Write("<Error>IMSI or MSISDN must be supplied</Error>")
                Response.Write("</ValidateSIM>")
                Exit Sub
            End If
                
            strSql = "select top 1 MSISDN, IMSI_ia from iafricust.dbo.vw_dump21 "
            If _IMSI.Trim = "" Then
                strSql = strSql + " where MSISDN = '" & _MSISDN.Trim & "' "
            Else
                strSql = strSql + " where IMSI_ia = '" & _IMSI.Trim & "' "
            End If
         

            lngCount = 0
            Dim dsetLogin As Data.DataSet
            Dim cnLogin As New clsMSSQLOledb("vas", "vas123", "10.100.11.2", "iafricust")
            If cnLogin.blnOpenConn = True Then
                dsetLogin = cnLogin.dSetOpenDataSet(strSql, "LoginCheck")
                lngCount = dsetLogin.Tables("LoginCheck").Rows.Count
                If lngCount > 0 Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<ValidateSIM>")
                    Response.Write("<Error> </Error>")
                    Response.Write("<IMSI>" & dsetLogin.Tables("LoginCheck").Rows(0).Item("IMSI_ia") & "</IMSI>")
                    Response.Write("<MSISDN>" & dsetLogin.Tables("LoginCheck").Rows(0).Item("MSISDN") & "</MSISDN>")
                    Response.Write("</ValidateSIM>")
                    dsetLogin = Nothing
                    cnLogin.sCloseConn()
                Else
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<ValidateSIM>")
                    Response.Write("<Error>Invalid.</Error>")
                    Response.Write("</ValidateSIM>")
                End If
            Else
ConnectionError:
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<ValidateSIM>")
                Response.Write("<Error>Unable to connect to database server.</Error>")
                Response.Write("</ValidateSIM>")
            End If
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<ValidateSIM>")
            Response.Write("<Error>" & ex.ToString & "</Error>")
            Response.Write("</ValidateSIM>")
        End Try
    End Sub   
</script>