<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            
            'http://87.238.116.200/SOP_XML_Insert_Table_Supply.aspx?salesUser=maher&TableUser=maher1&FromIMSI=630900207853983&TillIMSI=630900207853990
                
            Dim strSql As String

            Dim _salesUser As String = ""
            Dim _TableUser As String = ""
            Dim _FromIMSI As String = ""
            Dim _TillIMSI As String = ""
        
            If Request.QueryString("salesUser") IsNot Nothing Then
                _salesUser = Request.QueryString("salesUser").ToString
                If _salesUser.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<table_supply>")
                    Response.Write("<Error>Invalid User</Error>")
                    Response.Write("</table_supply>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<table_supply>")
                Response.Write("<Error>Invalid User</Error>")
                Response.Write("</table_supply>")
                Exit Sub
            End If
        
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
        
            If Request.QueryString("FromIMSI") IsNot Nothing Then
                _FromIMSI = Request.QueryString("FromIMSI").ToString
                If _FromIMSI.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<table_supply>")
                    Response.Write("<Error>Invalid From IMSI</Error>")
                    Response.Write("</table_supply>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<table_supply>")
                Response.Write("<Error>Invalid From IMSI</Error>")
                Response.Write("</table_supply>")
                Exit Sub
            End If
        
            If Request.QueryString("TillIMSI") IsNot Nothing Then
                _TillIMSI = Request.QueryString("TillIMSI").ToString
                If _TillIMSI.Trim = "" Then
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<table_supply>")
                    Response.Write("<Error>Invalid Till IMSI</Error>")
                    Response.Write("</table_supply>")
                    Exit Sub
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<table_supply>")
                Response.Write("<Error>Invalid Till IMSI</Error>")
                Response.Write("</table_supply>")
                Exit Sub
            End If
            
            strSql = "afr_sl_registration.dbo.usp_insert_table_supply "
            strSql = strSql & " '" & _salesUser & "'"
            strSql = strSql & " ,'" & _TableUser & "'"
            strSql = strSql & " ,'" & _FromIMSI & "'"
            strSql = strSql & " ,'" & _TillIMSI & "'"


            Dim cnInsertRegistration As New clsMSSQLOledb("sa", "@fricell2014", "10.100.11.10", "afr_sl_registration")
            
            If cnInsertRegistration.blnOpenConn = True Then
                cnInsertRegistration.lngExecuteNoQuery(strSql, False)
                cnInsertRegistration.sCloseConn()
                cnInsertRegistration = Nothing
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<table_supply>")
                Response.Write("<MESSAGE>Failed</MESSAGE>")
                Response.Write("</table_supply>")
                Exit Sub
            End If
        
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<table_supply>")
            Response.Write("<MESSAGE>Successful</MESSAGE>")
            Response.Write("</table_supply>")
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<table_supply>")
            Response.Write("<MESSAGE>" & ex.ToString & "</MESSAGE>")
            Response.Write("</table_supply>")
        End Try
    End Sub


    

</script>

