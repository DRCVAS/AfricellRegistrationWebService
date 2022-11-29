Imports System.Net
Imports System.Net.Sockets
Imports System.Text

Public Class clsHlr
    'Telnet Variables
    Private _hostname As String
    Private _username As String
    Private _password As String
    Private _port As Integer
    Private _client As TcpClient
    Private _data As String
    Private _sendbuffer(1024) As Byte
    Private _readbuffer(5000) As Byte
    Private _bytecount As Integer
    Private _stream As NetworkStream
    'Telnet status variables
    Private _TelnetStatus, _TelnetError As String

    'HLR variables
    Private _SI_MSISDN, _SI_IMSI, _SI_STATE, _SI_AUTHD, _NAM, _IMEI As String
    Public _SUD()(), _BSG()() As String
    Private _VLR_ADDRESS, _MSC_NUMBER, _SGSN_NUMBER As String

    'Internal Variables
    'Dim myStrings() As String
    Dim intSUDElements As Integer = 0
    Dim intBSGElements As Integer = 0

    Public Function Get_SGSN_NUMBER() As String
        Get_SGSN_NUMBER = _SGSN_NUMBER
    End Function

    Public Function Get_MSC_NUMBER() As String
        Get_MSC_NUMBER = _MSC_NUMBER
    End Function

    Public Function Get_VLR_ADDRESS() As String
        Get_VLR_ADDRESS = _VLR_ADDRESS
    End Function

    Public Function Get_SI_MSISDN() As String
        Get_SI_MSISDN = _SI_MSISDN
    End Function

    Public Function Get_SI_IMSI() As String
        Get_SI_IMSI = _SI_IMSI
    End Function

    Public Function Get_SI_STATE() As String
        Get_SI_STATE = _SI_STATE
    End Function

    Public Function Get_SI_AUTHD() As String
        Get_SI_AUTHD = _SI_AUTHD
    End Function

    Public Function Get_NAM() As String
        Get_NAM = _NAM
    End Function

    Public Function Get_IMEI() As String
        Get_IMEI = _IMEI
    End Function

    Public Function Get_TelnetStatus() As String
        Get_TelnetStatus = _TelnetStatus
    End Function


    Public Sub New(ByVal MSISDN_ As String)
        'Telnet Variables
        _hostname = "10.212.0.41"
        _username = "sog_adm"
        _password = "Africell123"
        _port = 23 '23
        _SI_MSISDN = MSISDN_
    End Sub

    Public Sub GetDisplay()
        If blnTelnetConnect() = True Then
            sTelnetReadDisp(_SI_MSISDN)
            sTelnetCloseConection()
        End If
    End Sub

    Public Sub GetDisplayByIMSI(ByVal strIMSI As String)
        If blnTelnetConnect() = True Then
            sTelnetReadDispByIMSI(strIMSI)
            sTelnetCloseConection()
        End If
    End Sub

    Public Sub sPrint()
        Console.WriteLine(Now.ToString)
        Console.WriteLine("-------------------------")
        Console.WriteLine("----Telnet----:")
        Console.WriteLine("-------------------------")
        Console.WriteLine("")
        Console.WriteLine("Variables")
        Console.WriteLine("---------")
        Console.WriteLine("hostname: 10.212.0.41")
        Console.WriteLine("username: sog_adm")
        Console.WriteLine("password: **********")
        Console.WriteLine("")
        Console.WriteLine("Connection Status")
        Console.WriteLine("-----------------")
        Console.WriteLine("Status: " & _TelnetStatus)
        Console.WriteLine("Error: " & _TelnetError)
        Console.WriteLine("")
        Console.WriteLine("---------------------")
        Console.WriteLine("----HLR variables----")
        Console.WriteLine("---------------------")
        Console.WriteLine("")
        Console.WriteLine("SUBSCRIBER IDENTITY")
        Console.WriteLine("-------------------")
        Console.WriteLine("SI_MSISDN: " & _SI_MSISDN)
        Console.WriteLine("SI_IMSI: " & _SI_IMSI)
        Console.WriteLine("SI_STATE: " & _SI_STATE)
        Console.WriteLine("SI_AUTHD: " & _SI_AUTHD)
        Console.WriteLine("")
        Console.WriteLine("PERMANENT SUBSCRIBER DATA")
        Console.WriteLine("-------------------------")
        For lngSUDCount = 0 To _SUD.GetUpperBound(0)
            Console.WriteLine(_SUD(lngSUDCount)(0) & ": " & _SUD(lngSUDCount)(1))
        Next
        Console.WriteLine("")
        Console.WriteLine("SUPPLEMENTARY SERVICE DATA")
        Console.WriteLine("--------------------------")
        For lngBSGCount = 0 To _BSG.GetUpperBound(0)
            Console.WriteLine(_BSG(lngBSGCount)(0) & " - " & _BSG(lngBSGCount)(1) & ": " & _BSG(lngBSGCount)(2))
        Next

    End Sub

    Private Sub sTelnetSend(ByVal Text As String)
        ReDim _sendbuffer(1024)
        _sendbuffer = Encoding.ASCII.GetBytes(Text)
        _stream.Write(_sendbuffer, 0, _sendbuffer.Length)
    End Sub

    Private Sub sTelnetRead()
        Threading.Thread.Sleep(50)
        ReDim _readbuffer(5000)
        _data = ""
        _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
        _data = Encoding.ASCII.GetString(_readbuffer)
        'Console.WriteLine(_data.ToString.Trim)
    End Sub

    Private Function blnTelnetConnect() As Boolean
        Try
            blnTelnetConnect = True
            _client = New TcpClient(_hostname, _port)
            _stream = _client.GetStream
            sTelnetSend(_username & vbCrLf & _password & vbCrLf & "" & vbCrLf)
            _TelnetStatus = "Connected"
            _TelnetError = ""
            sTelnetRead()
            Threading.Thread.Sleep(100)
        Catch ex As Exception
            blnTelnetConnect = False
            _TelnetStatus = "Connection failed"
            _TelnetError = ex.ToString
        End Try
    End Function

    Private Sub sTelnetCloseConection()
        Try
            _stream.Close()
            _client.Close()
        Catch ex As Exception
            Exit Sub
        End Try
    End Sub

    Private Sub sTelnetReadDisp(ByVal MSISDN_ As String)
        Dim lngRowNumber As Long
        Dim lngStringLen As Long

        sTelnetSend("mml HGSDP:MSISDN=" & MSISDN_ & ",all;" & vbCrLf) '23277120001
        Threading.Thread.Sleep(100)
        ReDim _readbuffer(5000)
        _data = ""
        _VLR_ADDRESS = ""
        _MSC_NUMBER = ""
        _SGSN_NUMBER = ""

        _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
        _data = Encoding.ASCII.GetString(_readbuffer)
        'Console.WriteLine(_data.ToString.Trim)
        Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
        For lngRowNumber = 0 To TextLines.GetUpperBound(0)
            If TextLines(lngRowNumber).Trim <> "" Then

                'SUBSCRIBER IDENTITY
                If TextLines(lngRowNumber).Trim = "SUBSCRIBER IDENTITY" Then
                    lngRowNumber = lngRowNumber + 1
                    If TextLines(lngRowNumber).Trim = "MSISDN           IMSI             STATE          AUTHD" Then
                        lngRowNumber = lngRowNumber + 1
                        lngStringLen = Len(TextLines(lngRowNumber))
                        _SI_MSISDN = TextLines(lngRowNumber).Substring(0, 17)
                        _SI_IMSI = TextLines(lngRowNumber).Substring(17, 17)
                        If lngStringLen < 50 Then
                            _SI_STATE = TextLines(lngRowNumber).Substring(34, lngStringLen - 34)
                            _SI_AUTHD = ""
                        Else
                            _SI_STATE = TextLines(lngRowNumber).Substring(34, 15)
                            _SI_AUTHD = TextLines(lngRowNumber).Substring(49, lngStringLen - 49)
                        End If
                    End If
                End If

                'NAM
                If TextLines(lngRowNumber).Trim = "NAM" Then
                    lngRowNumber = lngRowNumber + 1
                    _NAM = TextLines(lngRowNumber).Trim
                End If
                If TextLines(lngRowNumber).Trim = "NAM  IMEISV" Then
                    lngRowNumber = lngRowNumber + 1
                    _NAM = TextLines(lngRowNumber).Trim.Substring(0, 5)
                    _IMEI = TextLines(lngRowNumber).Trim.Substring(5, Len(TextLines(lngRowNumber).Trim) - 5)
                End If

                'PERMANENT SUBSCRIBER DATA
                If TextLines(lngRowNumber).Trim = "PERMANENT SUBSCRIBER DATA" Then
                    lngRowNumber = lngRowNumber + 1
                    If TextLines(lngRowNumber).Trim = "SUD" Then
                        lngRowNumber = lngRowNumber + 1
                        While Not TextLines(lngRowNumber).Trim = "AMSISDN            BS       BC"
                            lngStringLen = Len(TextLines(lngRowNumber).Trim)
                            Dim TempSUD() As String = TextLines(lngRowNumber).Split(" ")
                            For lngSUDCount = 0 To TempSUD.GetUpperBound(0)
                                If TempSUD(lngSUDCount) <> "" Then
                                    Dim TempSUDSplit() As String = TempSUD(lngSUDCount).Split("-")
                                    If TempSUDSplit.GetUpperBound(0) = 1 Then
                                        sAddSUDToStringArray(TempSUDSplit(0), TempSUDSplit(1))
                                    Else
                                        If TempSUDSplit.GetUpperBound(0) = 2 Then
                                            sAddSUDToStringArray(TempSUDSplit(0), TempSUDSplit(1) & "-" & TempSUDSplit(2))
                                        Else
                                            If TempSUDSplit.GetUpperBound(0) = 2 Then
                                                sAddSUDToStringArray(TempSUDSplit(0), TempSUDSplit(1) & "-" & TempSUDSplit(2) & "-" & TempSUDSplit(3))
                                            End If
                                        End If
                                    End If
                                End If
                            Next
                            lngRowNumber = lngRowNumber + 1
                        End While
                    End If
                End If

                'SUPPLEMENTARY SERVICE DATA
                If TextLines(lngRowNumber).Trim = "SUPPLEMENTARY SERVICE DATA" Then
                    Dim strBSG As String = ""
                    lngRowNumber = lngRowNumber + 1
                    While Not TextLines(lngRowNumber).Trim = "LOCATION DATA"
                        If TextLines(lngRowNumber).Trim = "BSG" Then
                            lngRowNumber = lngRowNumber + 1
                            strBSG = TextLines(lngRowNumber).Trim
                            lngRowNumber = lngRowNumber + 2
                        End If
                        If TextLines(lngRowNumber).Trim = "SS       STATUS        FNUM                 TIME" Then
                            lngRowNumber = lngRowNumber + 1
                        End If
                        If TextLines(lngRowNumber).Trim = "SADD" Then
                            lngRowNumber = lngRowNumber + 1
                        End If
                        'TextLines(lngRowNumber) = TextLines(lngRowNumber).Replace(" ", String.Empty)
                        lngStringLen = Len(TextLines(lngRowNumber).Trim)
                        If lngStringLen > 10 Then
                            sAddBSGToStringArray(strBSG, TextLines(lngRowNumber).Trim.Substring(0, 9).Trim, TextLines(lngRowNumber).Trim.Substring(9, lngStringLen - 9).Trim)
                        End If
                        lngRowNumber = lngRowNumber + 1
                        Console.WriteLine(TextLines(lngRowNumber).Trim)
                    End While
                    'lngRowNumber = lngRowNumber - 1
                End If
            End If

            'LOCATION DATA
            If TextLines(lngRowNumber).Trim = "VLR ADDRESS       MSRN            MSC NUMBER          LMSID" Then
                lngRowNumber = lngRowNumber + 1
                If Len(TextLines(lngRowNumber).Trim) >= 18 Then
                    _VLR_ADDRESS = Left(TextLines(lngRowNumber).Trim, 18).Trim
                End If
                If Len(TextLines(lngRowNumber).Trim) > 35 Then
                    _MSC_NUMBER = TextLines(lngRowNumber).Trim.Substring(34, Len(TextLines(lngRowNumber).Trim) - 34)
                End If

            End If
            If TextLines(lngRowNumber).Trim = "SGSN NUMBER" Then
                '_VLR_ADDRESS, _MSC_NUMBER, _SGSN_NUMBER
                lngRowNumber = lngRowNumber + 1
                _SGSN_NUMBER = TextLines(lngRowNumber).Trim
            End If
        Next
    End Sub

    Private Sub sTelnetReadDispByIMSI(ByVal strIMSI As String)
        Dim lngRowNumber As Long
        Dim lngStringLen As Long

        sTelnetSend("mml HGSDP:IMSI=" & strIMSI & ",all;" & vbCrLf) '23277120001
        Threading.Thread.Sleep(100)
        ReDim _readbuffer(5000)
        _data = ""
        _VLR_ADDRESS = ""
        _MSC_NUMBER = ""
        _SGSN_NUMBER = ""
        _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
        _data = Encoding.ASCII.GetString(_readbuffer)
        'Console.WriteLine(_data.ToString.Trim)
        Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
        For lngRowNumber = 0 To TextLines.GetUpperBound(0)
            If TextLines(lngRowNumber).Trim <> "" Then

                'SUBSCRIBER IDENTITY
                If TextLines(lngRowNumber).Trim = "SUBSCRIBER IDENTITY" Then
                    lngRowNumber = lngRowNumber + 1
                    If TextLines(lngRowNumber).Trim = "MSISDN           IMSI             STATE          AUTHD" Then
                        lngRowNumber = lngRowNumber + 1
                        lngStringLen = Len(TextLines(lngRowNumber))
                        _SI_MSISDN = TextLines(lngRowNumber).Substring(0, 17)
                        _SI_IMSI = TextLines(lngRowNumber).Substring(17, 17)
                        If lngStringLen < 50 Then
                            _SI_STATE = TextLines(lngRowNumber).Substring(34, lngStringLen - 34)
                            _SI_AUTHD = ""
                        Else
                            _SI_STATE = TextLines(lngRowNumber).Substring(34, 15)
                            _SI_AUTHD = TextLines(lngRowNumber).Substring(49, lngStringLen - 49)
                        End If
                    End If
                End If

                'NAM
                If TextLines(lngRowNumber).Trim = "NAM" Then
                    lngRowNumber = lngRowNumber + 1
                    _NAM = TextLines(lngRowNumber).Trim
                End If
                If TextLines(lngRowNumber).Trim = "NAM  IMEISV" Then
                    lngRowNumber = lngRowNumber + 1
                    _NAM = TextLines(lngRowNumber).Trim.Substring(0, 5)
                    _IMEI = TextLines(lngRowNumber).Trim.Substring(5, Len(TextLines(lngRowNumber).Trim) - 5)
                End If

                'PERMANENT SUBSCRIBER DATA
                If TextLines(lngRowNumber).Trim = "PERMANENT SUBSCRIBER DATA" Then
                    lngRowNumber = lngRowNumber + 1
                    If TextLines(lngRowNumber).Trim = "SUD" Then
                        lngRowNumber = lngRowNumber + 1
                        While Not TextLines(lngRowNumber).Trim = "AMSISDN            BS       BC"
                            lngStringLen = Len(TextLines(lngRowNumber).Trim)
                            Dim TempSUD() As String = TextLines(lngRowNumber).Split(" ")
                            For lngSUDCount = 0 To TempSUD.GetUpperBound(0)
                                If TempSUD(lngSUDCount) <> "" Then
                                    Dim TempSUDSplit() As String = TempSUD(lngSUDCount).Split("-")
                                    If TempSUDSplit.GetUpperBound(0) = 1 Then
                                        sAddSUDToStringArray(TempSUDSplit(0), TempSUDSplit(1))
                                    Else
                                        If TempSUDSplit.GetUpperBound(0) = 2 Then
                                            sAddSUDToStringArray(TempSUDSplit(0), TempSUDSplit(1) & "-" & TempSUDSplit(2))
                                        Else
                                            If TempSUDSplit.GetUpperBound(0) = 2 Then
                                                sAddSUDToStringArray(TempSUDSplit(0), TempSUDSplit(1) & "-" & TempSUDSplit(2) & "-" & TempSUDSplit(3))
                                            End If
                                        End If
                                    End If
                                End If
                            Next
                            lngRowNumber = lngRowNumber + 1
                        End While
                    End If
                End If

                'SUPPLEMENTARY SERVICE DATA
                If TextLines(lngRowNumber).Trim = "SUPPLEMENTARY SERVICE DATA" Then
                    Dim strBSG As String = ""
                    lngRowNumber = lngRowNumber + 1
                    While Not TextLines(lngRowNumber).Trim = "LOCATION DATA"
                        If TextLines(lngRowNumber).Trim = "BSG" Then
                            lngRowNumber = lngRowNumber + 1
                            strBSG = TextLines(lngRowNumber).Trim
                            lngRowNumber = lngRowNumber + 2
                        End If
                        If TextLines(lngRowNumber).Trim = "SS       STATUS        FNUM                 TIME" Then
                            lngRowNumber = lngRowNumber + 1
                        End If
                        If TextLines(lngRowNumber).Trim = "SADD" Then
                            lngRowNumber = lngRowNumber + 1
                        End If
                        'TextLines(lngRowNumber) = TextLines(lngRowNumber).Replace(" ", String.Empty)
                        lngStringLen = Len(TextLines(lngRowNumber).Trim)
                        If lngStringLen > 10 Then
                            sAddBSGToStringArray(strBSG, TextLines(lngRowNumber).Trim.Substring(0, 9).Trim, TextLines(lngRowNumber).Trim.Substring(9, lngStringLen - 9).Trim)
                        End If
                        lngRowNumber = lngRowNumber + 1
                        Console.WriteLine(TextLines(lngRowNumber).Trim)
                    End While
                    'lngRowNumber = lngRowNumber - 1
                End If
            End If

            'LOCATION DATA
            If TextLines(lngRowNumber).Trim = "VLR ADDRESS       MSRN            MSC NUMBER          LMSID" Then
                lngRowNumber = lngRowNumber + 1
                If Len(TextLines(lngRowNumber).Trim) >= 18 Then
                    _VLR_ADDRESS = Left(TextLines(lngRowNumber).Trim, 18).Trim
                End If
                If Len(TextLines(lngRowNumber).Trim) > 35 Then
                    _MSC_NUMBER = TextLines(lngRowNumber).Trim.Substring(34, Len(TextLines(lngRowNumber).Trim) - 34)
                End If

            End If
            If TextLines(lngRowNumber).Trim = "SGSN NUMBER" Then
                '_VLR_ADDRESS, _MSC_NUMBER, _SGSN_NUMBER
                lngRowNumber = lngRowNumber + 1
                _SGSN_NUMBER = TextLines(lngRowNumber).Trim
            End If
        Next
    End Sub

    Private Sub sAddSUDToStringArray(ByVal strSud As String, ByVal strSudValue As String)
        ReDim Preserve _SUD(intSUDElements)
        ReDim Preserve _SUD(intSUDElements)(0)
        ReDim Preserve _SUD(intSUDElements)(1)
        _SUD(intSUDElements)(0) = strSud
        _SUD(intSUDElements)(1) = strSudValue
        intSUDElements += 1
    End Sub

    Private Sub sAddBSGToStringArray(ByVal strBSG As String, ByVal strSS As String, ByVal strSSStatus As String)
        ReDim Preserve _BSG(intBSGElements)
        ReDim Preserve _BSG(intBSGElements)(0)
        ReDim Preserve _BSG(intBSGElements)(1)
        ReDim Preserve _BSG(intBSGElements)(2)
        _BSG(intBSGElements)(0) = strBSG
        _BSG(intBSGElements)(1) = strSS
        _BSG(intBSGElements)(2) = strSSStatus
        intBSGElements += 1
    End Sub

    Public Function strSIMChange(ByVal StrOIMSI As String, ByVal strNIMSI As String) As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strSIMChange = ""
        If blnTelnetConnect() = True Then
            strSIMChange = sTelnetSIMChange(StrOIMSI, strNIMSI)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetSIMChange(ByVal StrOIMSI As String, ByVal strNIMSI As String) As String
        Try
            sTelnetSIMChange = ""
            sTelnetSend("HGICI:IMSI=" & StrOIMSI & ",NIMSI=" & strNIMSI & ";" & vbCrLf & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetSIMChange = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetSIMChange = "EXECUTED"
                        If strCleanOSIMFromAUC(StrOIMSI) = "EXECUTED" Then
                            sTelnetSIMChange = "EXECUTED"
                        Else
                            sTelnetSIMChange = "EXECUTED, Old SIM Cleaning failed."
                        End If
                        If strCleanOSIMAllReferences(StrOIMSI) = "EXECUTED" Then
                            sTelnetSIMChange = "EXECUTED"
                        Else
                            sTelnetSIMChange = "EXECUTED, Old SIM References Cleaning failed."
                        End If
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetSIMChange = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetSIMChange = "Unexpected error"
        End Try
    End Function

    Private Function strCleanOSIMAllReferences(ByVal StrOIMSI As String) As String
        Try
            strCleanOSIMAllReferences = ""
            sTelnetSend("HGIRI:IMSI=" & StrOIMSI & ";" & vbCrLf & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            strCleanOSIMAllReferences = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        strCleanOSIMAllReferences = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        strCleanOSIMAllReferences = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            strCleanOSIMAllReferences = "Unexpected error"
        End Try
    End Function

    Private Function strCleanOSIMFromAUC(ByVal StrOIMSI As String) As String
        Try
            strCleanOSIMFromAUC = ""
            sTelnetSend("AGSUE:imsi=" & StrOIMSI & ";" & vbCrLf & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            strCleanOSIMFromAUC = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        strCleanOSIMFromAUC = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        strCleanOSIMFromAUC = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            strCleanOSIMFromAUC = "Unexpected error"
        End Try
    End Function

    Public Function strChangeGPRS(ByVal blnActivate As Boolean) As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strChangeGPRS = ""
        Dim intValue As Integer = 1
        If blnActivate = True Then intValue = 0
        If blnTelnetConnect() = True Then
            strChangeGPRS = sTelnetChangeGPRS(_SI_MSISDN, intValue)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetChangeGPRS(ByVal strMSISDN As String, ByVal intValue As Integer) As String
        Try
            sTelnetChangeGPRS = ""
            sTelnetSend("HGSNC:MSISDN=" & strMSISDN & ",NAM=" & intValue.ToString & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetChangeGPRS = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetChangeGPRS = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetChangeGPRS = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetChangeGPRS = "Unexpected error"
        End Try
    End Function

    'Public Function strChangeCRBT(ByVal blnActivate As Boolean) As String
    '    _hostname = "192.168.160.10"
    '    _username = "sog_adm"
    '    _password = "Africell_013"
    '    _port = 5000 '23
    '    strChangeCRBT = ""
    '    Dim intValue As Integer = 0
    '    If blnActivate = True Then intValue = 1
    '    If blnTelnetConnect() = True Then
    '        strChangeCRBT = sTelnetChangeCRBT(_SI_MSISDN, intValue)
    '        sTelnetCloseConection()
    '    End If
    'End Function

    'Private Function sTelnetChangeCRBT(ByVal strMSISDN As String, ByVal intValue As Integer) As String
    '    Try
    '        sTelnetChangeCRBT = ""
    '        sTelnetSend("HGSDC:MSISDN=" & strMSISDN.Trim & ",SUD=PRBT-" & intValue & ";" & vbCrLf)
    '        Threading.Thread.Sleep(100)
    '        ReDim _readbuffer(5000)
    '        _data = ""
    '        _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
    '        _data = Encoding.ASCII.GetString(_readbuffer)
    '        sTelnetChangeCRBT = _data.ToString.Trim
    '        Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
    '        For lngRowNumber = 0 To TextLines.GetUpperBound(0)
    '            If TextLines(lngRowNumber).Trim <> "" Then
    '                Console.WriteLine(TextLines(lngRowNumber))
    '                If TextLines(lngRowNumber) = "EXECUTED" Then
    '                    sTelnetChangeCRBT = "EXECUTED"
    '                    Exit For
    '                End If
    '                If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
    '                    sTelnetChangeCRBT = "NOT ACCEPTED"
    '                    Exit For
    '                End If
    '            End If
    '        Next
    '    Catch ex As Exception
    '        sTelnetChangeCRBT = "Unexpected error"
    '    End Try
    'End Function

    'Public Function strChangeRoam(ByVal blnActivate As Boolean) As String
    '    _hostname = "192.168.160.10"
    '    _username = "sog_adm"
    '    _password = "Africell_013"
    '    _port = 5000 '23
    '    strChangeRoam = ""
    '    Dim intValue As Integer = 2
    '    If blnActivate = True Then intValue = 0
    '    If blnTelnetConnect() = True Then
    '        strChangeRoam = sTelnetChangeRoam(_SI_MSISDN, intValue)
    '        sTelnetCloseConection()
    '    End If
    'End Function

    'Private Function sTelnetChangeRoam(ByVal strMSISDN As String, ByVal intValue As Integer) As String
    '    Try
    '        sTelnetChangeRoam = ""
    '        sTelnetSend("HGSDC:MSISDN=" & strMSISDN.Trim & ",SUD=OBR-" & intValue & ";" & vbCrLf)
    '        Threading.Thread.Sleep(100)
    '        ReDim _readbuffer(5000)
    '        _data = ""
    '        _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
    '        _data = Encoding.ASCII.GetString(_readbuffer)
    '        sTelnetChangeRoam = _data.ToString.Trim
    '        Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
    '        For lngRowNumber = 0 To TextLines.GetUpperBound(0)
    '            If TextLines(lngRowNumber).Trim <> "" Then
    '                Console.WriteLine(TextLines(lngRowNumber))
    '                If TextLines(lngRowNumber) = "EXECUTED" Then
    '                    sTelnetChangeRoam = "EXECUTED"
    '                    Exit For
    '                End If
    '                If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
    '                    sTelnetChangeRoam = "NOT ACCEPTED"
    '                    Exit For
    '                End If
    '            End If
    '        Next
    '    Catch ex As Exception
    '        sTelnetChangeRoam = "Unexpected error"
    '    End Try
    'End Function

    Public Function strDisplayAc(ByVal strIMSI As String) As String
        Try
            strDisplayAc = ""
            If blnTelnetConnect() = True Then
                sTelnetSend("mml AGSUP:IMSIS=" & strIMSI & ";" & vbCrLf)
                Threading.Thread.Sleep(100)
                ReDim _readbuffer(5000)
                _data = ""
                _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
                _data = Encoding.ASCII.GetString(_readbuffer)
                Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
                For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                    If TextLines(lngRowNumber).Trim() = "IMSI             EKI                               KIND  A3A8IND  A4IND" Then
                        lngRowNumber = lngRowNumber + 1
                        If TextLines(lngRowNumber).Trim().Length > 40 Then
                            strDisplayAc = TextLines(lngRowNumber).Trim().Substring(17, 32)
                        End If
                        Exit For
                    End If
                Next
                sTelnetCloseConection()
            End If
        Catch ex As Exception
            strDisplayAc = "Unexpected error"
        End Try

    End Function

    Public Function strDeleteAUC(ByVal strIMSI As String) As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strDeleteAUC = ""
        If blnTelnetConnect() = True Then
            strDeleteAUC = sTelnetDeleteAUC(strIMSI)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetDeleteAUC(ByVal strIMSI As String) As String
        Try
            sTelnetDeleteAUC = ""
            sTelnetSend("AGSUE:imsi=" & strIMSI & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetDeleteAUC = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetDeleteAUC = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetDeleteAUC = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetDeleteAUC = "Unexpected error"
        End Try
    End Function

    Public Function strCreateAUC(ByVal strIMSI As String, ByVal strKI As String) As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strCreateAUC = ""
        If blnTelnetConnect() = True Then
            strCreateAUC = sTelnetCreateAUC(strIMSI, strKI)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetCreateAUC(ByVal strIMSI As String, ByVal strKI As String) As String
        Try
            sTelnetCreateAUC = ""
            sTelnetSend("AGSUI:imsi=" & strIMSI & ",EKI=" & strKI & ",KIND=1,A3A8IND=2;" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetCreateAUC = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetCreateAUC = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetCreateAUC = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetCreateAUC = "Unexpected error"
        End Try
    End Function

    Public Function strDeleteHLR() As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strDeleteHLR = ""
        If blnTelnetConnect() = True Then
            strDeleteHLR = sTelnetDeleteHLR(_SI_MSISDN)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetDeleteHLR(ByVal strIMSI As String) As String
        Try
            sTelnetDeleteHLR = ""
            sTelnetSend("HGSUE:MSISDN=" & strIMSI & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetDeleteHLR = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetDeleteHLR = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetDeleteHLR = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetDeleteHLR = "Unexpected error"
        End Try
    End Function

    Public Function strCreateHLR(ByVal strIMSI As String, ByVal strProfile As String) As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strCreateHLR = ""
        If blnTelnetConnect() = True Then
            strCreateHLR = sTelnetCreateHLR(_SI_MSISDN, strIMSI, strProfile)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetCreateHLR(ByVal strMSISDN As String, ByVal strIMSI As String, ByVal strProfile As String) As String
        Try
            sTelnetCreateHLR = ""
            sTelnetSend("HGSUI:MSISDN=" & strMSISDN & ",imsi=" & strIMSI & ",profile=" & strProfile & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetCreateHLR = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetCreateHLR = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetCreateHLR = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetCreateHLR = "Unexpected error"
        End Try
    End Function

    Public Function strPurgeVLR() As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strPurgeVLR = ""
        Dim intValue As Integer = 1
        If blnTelnetConnect() = True Then
            strPurgeVLR = sTelnetPurgeVLR(_SI_MSISDN)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetPurgeVLR(ByVal strMSISDN As String) As String
        Try
            sTelnetPurgeVLR = ""
            sTelnetSend("HGSLR:MSISDN=" & strMSISDN & ";" & vbCrLf & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetPurgeVLR = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetPurgeVLR = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetPurgeVLR = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetPurgeVLR = "Unexpected error"
        End Try
    End Function

    Public Function strSUD(ByVal SUD_ As String) As String
        _hostname = "192.168.160.10"
        _username = "sog_adm"
        _password = "Africell_013"
        _port = 5000 '23
        strSUD = ""
        If blnTelnetConnect() = True Then
            strSUD = sTelnetSUD(_SI_MSISDN, SUD_)
            sTelnetCloseConection()
        End If
    End Function

    Private Function sTelnetSUD(ByVal strMSISDN As String, ByVal strSUD As String) As String
        Try
            sTelnetSUD = ""
            sTelnetSend("HGSDC:MSISDN=" & strMSISDN & ",SUD=" & strSUD & ";" & vbCrLf)
            Threading.Thread.Sleep(100)
            ReDim _readbuffer(5000)
            _data = ""
            _bytecount = _stream.Read(_readbuffer, 0, _readbuffer.Length)
            _data = Encoding.ASCII.GetString(_readbuffer)
            sTelnetSUD = _data.ToString.Trim
            Dim TextLines() As String = _data.Split(Environment.NewLine.ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
            For lngRowNumber = 0 To TextLines.GetUpperBound(0)
                If TextLines(lngRowNumber).Trim <> "" Then
                    Console.WriteLine(TextLines(lngRowNumber))
                    If TextLines(lngRowNumber) = "EXECUTED" Then
                        sTelnetSUD = "EXECUTED"
                        Exit For
                    End If
                    If TextLines(lngRowNumber) = "NOT ACCEPTED" Then
                        sTelnetSUD = "NOT ACCEPTED"
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            sTelnetSUD = "Unexpected error"
        End Try
    End Function




End Class
