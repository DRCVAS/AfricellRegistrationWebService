<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(sender As Object, e As EventArgs)
        Dim _MSISDN, _Amount, _OperatorId, _CUG As String
        Dim strSql As String
        
        _MSISDN = ""
        _Amount = ""
        _OperatorId = ""
        _CUG = ""
        strSql = ""

        Try
            If Request.QueryString("MSISDN") IsNot Nothing Then
                _MSISDN = Request.QueryString("MSISDN").ToString
                If blnValidateMSISDN(_MSISDN) = False Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<CreateAccount>")
                    Response.Write("<Error>Invalid MSISDN</Error>")
                    Response.Write("</CreateAccount>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<CreateAccount>")
                Response.Write("<Error>Invalid MSISDN</Error>")
                Response.Write("</CreateAccount>")
                Exit Sub
            End If
            
            If Request.QueryString("Amount") IsNot Nothing Then
                _Amount = Request.QueryString("Amount").ToString
                If IsNumeric(_Amount) = False Or _Amount.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<CreateAccount>")
                    Response.Write("<Error>Invalid Amount</Error>")
                    Response.Write("</CreateAccount>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<CreateAccount>")
                Response.Write("<Error>Invalid Amount</Error>")
                Response.Write("</CreateAccount>")
                Exit Sub
            End If
            
            If Request.QueryString("OperatorId") IsNot Nothing Then
                _OperatorId = Request.QueryString("OperatorId").ToString
                If _OperatorId.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<CreateAccount>")
                    Response.Write("<Error>Invalid OperatorId</Error>")
                    Response.Write("</CreateAccount>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<CreateAccount>")
                Response.Write("<Error>Invalid OperatorId</Error>")
                Response.Write("</CreateAccount>")
                Exit Sub
            End If
            
            If Request.QueryString("cug") IsNot Nothing Then
                _CUG = Request.QueryString("cug").ToString
                If _CUG.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<CreateAccount>")
                    Response.Write("<Error>Invalid CUG</Error>")
                    Response.Write("</CreateAccount>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<CreateAccount>")
                Response.Write("<Error>Invalid CUG</Error>")
                Response.Write("</CreateAccount>")
                Exit Sub
            End If
            

            Dim cnCreateAccount As New clSybaseODBC("sa", "vsdadmin", "CDN", "vsd")
            strSql = "CreateAccount '" & _MSISDN & "', " & _Amount & ",'" & _CUG & "','','','" & _OperatorId & "'"
            If cnCreateAccount.blnOpenConn = True Then
                cnCreateAccount.lngExecuteNoQuery(strSql, False)
                'set joining date
                strSql = "update db_subscriber_tbl set first_used = last_credited where subscriber_id = '" & _MSISDN & "'"
                cnCreateAccount.lngExecuteNoQuery(strSql, False)
                cnCreateAccount.sCloseConn()
                
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<CreateAccount>")
                Response.Write("<Error></Error>")
                Response.Write("<MSISDN>" & _MSISDN.Trim & "</MSISDN>")
                Response.Write("<COS>" & _CUG.Trim & "</COS>")
                Response.Write("</CreateAccount>")
                Exit Sub
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<CreateAccount>")
                Response.Write("<Error>Unable to connect to database server</Error>")
                Response.Write("</CreateAccount>")
                Exit Sub
            End If
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<CreateAccount>")
            Response.Write("<Error>" & ex.ToString & "</Error>")
            Response.Write("</CreateAccount>")
        End Try
    End Sub
    
    Private Function blnValidateMSISDN(ByVal strMSISDN As String) As Boolean
        blnValidateMSISDN = False
        If IsNumeric(strMSISDN) = False Then
            Exit Function
        End If
        If Len(strMSISDN) <> 12 Then
            Exit Function
        End If
        Select Case Left(strMSISDN, 5)
            Case "24390"
                blnValidateMSISDN = True
            Case "24391"
                blnValidateMSISDN = True
            Case Else
                Exit Function
        End Select
    End Function
    
</script>
