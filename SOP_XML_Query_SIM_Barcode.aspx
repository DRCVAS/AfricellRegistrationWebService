<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Dim _strReserved As String
    Dim _strCategory As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim _strIMSI, _strNDC, _strMSISDN, strMSISDN, _strKI As String
        Dim clRequest As clsHlr
        
        
        'http://87.238.116.200/SOP_XML_Query_SIM_Barcode.aspx?IMSI=630900117003717&NDC=&MSISDN=
        'http://87.238.116.200/SOP_XML_Query_SIM_Barcode.aspx?IMSI=&NDC=90&MSISDN=0100661
        'http://87.238.116.200/SOP_XML_Query_SIM_Barcode.aspx?IMSI=619050110054924&NDC=77&MSISDN=944808
        _strNDC = ""
        _strMSISDN = ""
        _strKI = ""
        _strReserved = ""
        _strCategory = ""
        
        If Request.QueryString("IMSI") IsNot Nothing Then
            _strIMSI = Request.QueryString("IMSI").ToString
        Else
            _strIMSI = ""
        End If
        If Request.QueryString("NDC") IsNot Nothing Then
            _strNDC = Request.QueryString("NDC").ToString
        Else
            _strNDC = ""
        End If
        If Request.QueryString("MSISDN") IsNot Nothing Then
            _strMSISDN = Request.QueryString("MSISDN").ToString
        Else
            _strMSISDN = ""
        End If

        Try
            clRequest = New clsHlr("")
            If _strNDC.Trim <> "" And _strMSISDN.Trim <> "" Then
                'display by MSISDN
                clRequest = New clsHlr("243" & _strNDC.Trim & _strMSISDN.Trim)
                clRequest.GetDisplay()
                strMSISDN = "0" & Right(clRequest.Get_SI_MSISDN().Trim, 9)
                _strIMSI = clRequest.Get_SI_IMSI.Trim
                _strKI = clRequest.strDisplayAc(_strIMSI.Trim).Trim
                clRequest.GetDisplayByIMSI(_strIMSI.Trim)
            Else
                'display by IMSI
                _strKI = clRequest.strDisplayAc(_strIMSI.Trim).Trim
                clRequest.GetDisplayByIMSI(_strIMSI.Trim)
                strMSISDN = "0" & Right(clRequest.Get_SI_MSISDN().Trim, 9)
                _strIMSI = clRequest.Get_SI_IMSI.Trim
            End If
            
            If strMSISDN.Length > 9 Then
                _strNDC = Left(strMSISDN, 3)
                _strMSISDN = Right(strMSISDN, 7)
                'blnReserved(_strNDC, _strMSISDN)
            End If
            
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<Subscriber>")
            Response.Write("<Error> </Error>")
            Response.Write("<IMSI>" & _strIMSI.Trim & "</IMSI>")
            Response.Write("<KI>" & _strKI.Trim & "</KI>")
            Response.Write("<NDC>" & _strNDC.Trim & "</NDC>")
            Response.Write("<MSISDN>" & _strMSISDN.Trim & "</MSISDN>")
            Response.Write("<RESERVED>" & _strReserved & "</RESERVED>")
            Response.Write("<CATEGORY>" & _strCategory & "</CATEGORY>")
            Response.Write("</Subscriber>")
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<Subscriber>")
            Response.Write("<Error>" & ex.ToString & "</Error>")
            Response.Write("<IMSI> </IMSI>")
            Response.Write("<KI> </KI>")
            Response.Write("<NDC> </NDC>")
            Response.Write("<MSISDN> </MSISDN>")
            Response.Write("<RESERVED> </RESERVED>")
            Response.Write("<CATEGORY> </CATEGORY>")        
            Response.Write("</Subscriber>")
        End Try

        
    End Sub
    
    'Private Function blnReserved(ByVal strNDC As String, ByVal strMSISDN As String) As Boolean
    '    blnReserved = True
    '    Try
    '        Dim lngCC As Long
    '        Dim dsetGetReply As Data.DataSet
    '        Dim cnGetReply As New clsMSSQLOledb("sa", "1412", "192.168.1.38", "msisdntest")
    '        If cnGetReply.blnOpenConn = True Then
    '            dsetGetReply = cnGetReply.dSetOpenDataSet("msisdntest..usp_checkIfReserved '" & strNDC.Trim & "', '" & strMSISDN.Trim & "' ", "GetReply")
    '            lngCC = dsetGetReply.Tables("GetReply").Rows.Count
    '            If lngCC > 0 Then
    '                _strReserved = dsetGetReply.Tables("GetReply").Rows(0).Item("Reserved_desc") & ""
    '                _strCategory = dsetGetReply.Tables("GetReply").Rows(0).Item("MSISDN_type") & ""
    '            End If
    '        Else
    '            blnReserved = False
    '            Exit Function
    '        End If
    '    Catch ex As Exception
    '        blnReserved = False
    '        Exit Function
    '    End Try
    'End Function
    
</script>

