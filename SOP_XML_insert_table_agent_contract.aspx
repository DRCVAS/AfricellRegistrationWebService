<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Try

            Dim _SIMNDC As String = ""
            Dim _SIMSN As String = ""
            Dim _contractImage As String = ""
        
        
            Page.Response.ContentType = "text/xml"
            Dim xmlStream As New System.IO.StreamReader(Page.Request.InputStream)
            Dim xmlData As String = xmlStream.ReadToEnd
            
            ' ''get and save the image
            Dim xml As New StringReader(xmlData)
            Dim reader As XmlReader
            Dim strImage1 As String = ""
            reader = XmlReader.Create(xml)
            While reader.Read()
                  
                If reader.Name = "SIMNDC" Then
                    reader.Read()
                    If _SIMNDC.Trim = "" Then
                        _SIMNDC = reader.Value
                    End If
                End If
                If reader.Name = "SIMSN" Then
                    reader.Read()
                    If _SIMSN.Trim = "" Then
                        _SIMSN = reader.Value
                    End If
                End If
                If reader.Name = "contractImage" Then
                    reader.Read()
                    If _contractImage.Trim = "" Then
                        _contractImage = reader.Value
                    End If
                End If
            End While
            
            Dim strSql As String = ""
            Dim strSql2 As String = "afr_sl_registration.dbo.usp_create_user_table_2 '" + Right(_SIMNDC, 2) + _SIMSN + "'"
            
            
            strSql = " insert into afr_sl_registration.dbo.tbl_table_agent_contract (SIMNDC, SIMSN, contractImage)"
            strSql = strSql & " select '" + _SIMNDC + "', '" + _SIMSN + "', '" + _contractImage + "'"
            
            Dim cnInsertContract As New clsMSSQLOledb("sa", "@fricell2014", "10.100.11.10", "afr_sl_registration")
            If cnInsertContract.blnOpenConn = True Then
                cnInsertContract.lngExecuteNoQuery(strSql, False)
                cnInsertContract.lngExecuteNoQuery(strSql2, False)
                
                cnInsertContract.sCloseConn()
                cnInsertContract = Nothing
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<Reply>")
                Response.Write("<MESSAGE>Failed</MESSAGE>")
                Response.Write("</Reply>")
                Exit Sub
            End If
            
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<Reply>")
            Response.Write("<MESSAGE>Successful</MESSAGE>")
            Response.Write("</Reply>")
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<Reply>")
            Response.Write("<MESSAGE>" & ex.ToString & "</MESSAGE>")
            Response.Write("</Reply>")
        End Try
    End Sub
</script>
