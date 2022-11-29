<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            Dim strSql As String
            Dim strTimeStamp As String
            Dim strPath As String
            strTimeStamp = "-" & Now.Hour.ToString & "-" & Now.Minute.ToString & "-" & Now.Second.ToString
            strPath = "E:\Africell POS\ImageUpload\" & Now.Year.ToString & Right("0" & Now.Month.ToString, 2) & Right("0" & Now.Day.ToString, 2) & "\"
            Dim diDestination As New IO.DirectoryInfo(strPath)
            If diDestination.Exists = False Then diDestination.Create()
            
            Dim _FirstName, _FatherName, _LastName, _Gender, _BirthDate, _Email, _Education As String
            Dim _Nationality, _IDType, _ReferenceNbr, _residenceTown, _residenceStreet As String
            Dim _category, _subcategory, _Employer, _OccupationTown, _OccupationStreet As String
            Dim _SIMNDC, _SIMMSISDN, _SIMICC As String
            Dim _user, _cellid As String
            Dim _PersonalPhoto, _IdCardSide1, _IdCardSide2 As String
            Dim _PersonalPhotoPath, _IdCardSide1Path, _IdCardSide2Path As String
            Dim _FingerPrint, _FingerPrintPath As String
            
            _FirstName = ""
            _FatherName = ""
            _LastName = ""
            _Gender = ""
            _BirthDate = ""
            _Email = ""
            _Education = ""
            
            _Nationality = ""
            _IDType = ""
            _ReferenceNbr = ""
            _residenceTown = ""
            _residenceStreet = ""
            
            _category = ""
            _subcategory = ""
            _Employer = ""
            _OccupationTown = ""
            _OccupationStreet = ""
            
            _SIMNDC = ""
            _SIMMSISDN = ""
            _SIMICC = ""
            
            _user = ""
            _cellid = ""
            
            _PersonalPhoto = ""
            _PersonalPhotoPath = ""
            
            _FingerPrint = ""
            _FingerPrintPath = ""
            
            _IdCardSide1 = ""
            _IdCardSide2 = ""
            
            _IdCardSide1Path = ""
            _IdCardSide2Path = ""
            
            
          
            
            'get XML request
            'If Request.ContentType.ToString <> "text/xml" Then Throw New HttpException(500, "Unexpected Content-Type")
            Page.Response.ContentType = "text/xml"
            Dim xmlStream As New System.IO.StreamReader(Page.Request.InputStream)
            Dim xmlData As String = xmlStream.ReadToEnd
            
            ' ''get and save the image
            Dim xml As New StringReader(xmlData)
            Dim reader As XmlReader
            Dim strImage1 As String = ""
            reader = XmlReader.Create(xml)
            While reader.Read()
                  
                If reader.Name = "firstname" Then
                    reader.Read()
                    If _FirstName.Trim = "" Then
                        _FirstName = reader.Value
                    End If
                End If
                If reader.Name = "fathername" Then
                    reader.Read()
                    If _FatherName.Trim = "" Then
                        _FatherName = reader.Value
                    End If
                End If
                If reader.Name = "familyname" Then
                    reader.Read()
                    If _LastName.Trim = "" Then
                        _LastName = reader.Value
                    End If
                End If
                If reader.Name = "gender" Then
                    reader.Read()
                    If _Gender.Trim = "" Then
                        _Gender = reader.Value
                    End If
                End If
                If reader.Name = "birthdate" Then
                    reader.Read()
                    If _BirthDate.Trim = "" Then
                        _BirthDate = reader.Value
                    End If
                End If
                If reader.Name = "email" Then
                    reader.Read()
                    If _Email.Trim = "" Then
                        _Email = reader.Value
                    End If
                End If
                If reader.Name = "education" Then
                    reader.Read()
                    If _Education.Trim = "" Then
                        _Education = reader.Value
                    End If
                End If
               
                If reader.Name = "nationality" Then
                    reader.Read()
                    If _Nationality.Trim = "" Then
                        _Nationality = reader.Value
                    End If
                End If
                If reader.Name = "idtype" Then
                    reader.Read()
                    If _IDType.Trim = "" Then
                        _IDType = reader.Value
                    End If
                End If
                If reader.Name = "referencenbr" Then
                    reader.Read()
                    If _ReferenceNbr.Trim = "" Then
                        _ReferenceNbr = reader.Value
                    End If
                End If
                If reader.Name = "residencetown" Then
                    reader.Read()
                    If _residenceTown.Trim = "" Then
                        _residenceTown = reader.Value
                    End If
                End If
                If reader.Name = "residencestreet" Then
                    reader.Read()
                    If _residenceStreet.Trim = "" Then
                        _residenceStreet = reader.Value
                    End If
                End If
                
                If reader.Name = "category" Then
                    reader.Read()
                    If _category.Trim = "" Then
                        _category = reader.Value
                    End If
                End If
                If reader.Name = "subcategory" Then
                    reader.Read()
                    If _subcategory.Trim = "" Then
                        _subcategory = reader.Value
                    End If
                End If
                If reader.Name = "employer" Then
                    reader.Read()
                    If _Employer.Trim = "" Then
                        _Employer = reader.Value
                    End If
                End If
                If reader.Name = "occupationtown" Then
                    reader.Read()
                    If _OccupationTown.Trim = "" Then
                        _OccupationTown = reader.Value
                    End If
                End If
                If reader.Name = "occupationstreet" Then
                    reader.Read()
                    If _OccupationStreet.Trim = "" Then
                        _OccupationStreet = reader.Value
                    End If
                End If
                
                If reader.Name = "ndc" Then
                    reader.Read()
                    If _SIMNDC.Trim = "" Then
                        _SIMNDC = reader.Value
                    End If
                End If
                If reader.Name = "msisdn" Then
                    reader.Read()
                    If _SIMMSISDN.Trim = "" Then
                        _SIMMSISDN = reader.Value
                    End If
                End If
                If reader.Name = "icc" Then
                    reader.Read()
                    If _SIMICC.Trim = "" Then
                        _SIMICC = reader.Value
                    End If
                End If
                
                If reader.Name = "user" Then
                    reader.Read()
                    If _user.Trim = "" Then
                        _user = reader.Value
                    End If
                End If
                If reader.Name = "cellid" Then
                    reader.Read()
                    If _cellid.Trim = "" Then
                        _cellid = reader.Value
                    End If
                End If
                
                If reader.Name = "personalphoto" Then
                    reader.Read()
                    If _PersonalPhoto.Trim = "" Then
                        _PersonalPhoto = reader.Value
                        _PersonalPhotoPath = strPath & _SIMNDC & _SIMMSISDN & strTimeStamp & "P"
                        If _PersonalPhoto.Trim <> "" Then strStringToImage(_PersonalPhoto, _PersonalPhotoPath)
                    End If
                End If
                If reader.Name = "idcardside1" Then
                    reader.Read()
                    If _IdCardSide1.Trim = "" Then
                        _IdCardSide1 = reader.Value
                        _IdCardSide1Path = strPath & _SIMNDC & _SIMMSISDN & strTimeStamp & "S1"
                        If _IdCardSide1.Trim <> "" Then strStringToImage(_IdCardSide1, _IdCardSide1Path)
                    End If
                End If
                If reader.Name = "idcardside2" Then
                    reader.Read()
                    If _IdCardSide2.Trim = "" Then
                        _IdCardSide2 = reader.Value
                        _IdCardSide2Path = strPath & _SIMNDC & _SIMMSISDN & strTimeStamp & "S2"
                        If _IdCardSide2.Trim <> "" Then strStringToImage(_IdCardSide2, _IdCardSide2Path)
                    End If
                End If
                
                'FingerPrint
                If reader.Name = "personalEmpreinte" Then
                    reader.Read()
                    If _FingerPrint.Trim = "" Then
                        _FingerPrint = reader.Value
                        'sWriteErrorLog1("fg= " & _FingerPrint)
                        _FingerPrintPath = strPath & _SIMNDC & _SIMMSISDN & strTimeStamp & "F"
                        
                        '' active below code if you wanna generate image fingerprint
                         If _FingerPrint.Trim <> "" Then strStringToImage(_FingerPrint, _FingerPrintPath)  
                    End If
                End If
            End While
  
            
            
            strSql = "afr_sl_registration.dbo.usp_insert_registration "
            strSql = strSql & " '" & _FirstName & "'"
            strSql = strSql & " ,'" & _FatherName & "'"
            strSql = strSql & " ,'" & _LastName & "'"
            strSql = strSql & " ,'" & _Gender & "'"
            strSql = strSql & " ,'" & _BirthDate & "'"
            strSql = strSql & " ,'" & _Email & "'"
            strSql = strSql & " ,'" & _Education & "'"
            strSql = strSql & " ,'" & _PersonalPhotoPath & "'"
            
            strSql = strSql & " ,'" & _Nationality & "'"
            strSql = strSql & " ,'" & _IDType & "'"
            strSql = strSql & " ,'" & _ReferenceNbr & "'"
            strSql = strSql & " ,'" & _IdCardSide1Path & "'"
            strSql = strSql & " ,'" & _IdCardSide2Path & "'"
   
            strSql = strSql & " ,'" & _residenceTown & "'"
            strSql = strSql & " ,'" & _residenceStreet & "'"
 
            strSql = strSql & " ,'" & _category & "'"
            strSql = strSql & " ,'" & _subcategory & "'"
            strSql = strSql & " ,'" & _Employer & "'"
            strSql = strSql & " ,'" & _OccupationTown & "'"
            strSql = strSql & " ,'" & _OccupationStreet & "'"

            strSql = strSql & " ,'" & _SIMNDC & "'"
            strSql = strSql & " ,'" & _SIMMSISDN & "'"
            strSql = strSql & " ,'" & _SIMICC & "'"

            strSql = strSql & " ,'" & _user & "'"
            strSql = strSql & " ,'" & _cellid & "'"
            
            'add finger
            strSql = strSql & " ,'" & _FingerPrintPath & "'"
            strSql = strSql & " ,'" & _FingerPrint & "'"
            
            
            Dim cnInsertRegistration As New clsMSSQLOledb("sa", "@fricell2014", "10.100.11.10", "afr_sl_registration")
            
            If cnInsertRegistration.blnOpenConn = True Then
                cnInsertRegistration.lngExecuteNoQuery(strSql, False)
                cnInsertRegistration.sCloseConn()
                cnInsertRegistration = Nothing
                 ' sWriteErrorLog1("strSql= " & strSql)
            Else
                sWriteErrorLog1("Error connecting to DB. " & strSql)
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
            sWriteErrorLog1(ex.ToString)
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<Reply>")
            Response.Write("<MESSAGE>" & ex.ToString & "</MESSAGE>")
            Response.Write("</Reply>")
        End Try
    End Sub

    Private Sub strStringToImage(ByVal strString As String, ByVal strFileName As String)
        'convert String to Image and save
        Dim image As System.Drawing.Image
        Dim byteArray As Byte()
        byteArray = System.Convert.FromBase64String(strString)
        Dim imgStream As MemoryStream = New MemoryStream(byteArray)
        image = image.FromStream(imgStream)
        Dim image1 As System.Drawing.Image
        image1 = image
        image1.Save(strFileName & ".jpg")
    End Sub
    
    Private Sub sWriteErrorLog1(ByVal strError As String)
        Dim oWrite As System.IO.StreamWriter
        Try
            If File.Exists("E:\Africell POS\ImageUpload\" & Now.Day.ToString & Now.Month.ToString & Now.Year.ToString & " " & Now.Hour.ToString & Now.Minute.ToString & Now.Second.ToString & "1.log") Then
                File.Delete("E:\Africell POS\ImageUpload\" & Now.Day.ToString & Now.Month.ToString & Now.Year.ToString & " " & Now.Hour.ToString & Now.Minute.ToString & Now.Second.ToString & "1.log")
            End If
            oWrite = File.CreateText("E:\Africell POS\ImageUpload\" & Now.Day.ToString & Now.Month.ToString & Now.Year.ToString & " " & Now.Hour.ToString & Now.Minute.ToString & Now.Second.ToString & "1.log")
            oWrite.WriteLine(Now.ToString & "   " & strError)
            oWrite.Close()
        Catch ex As Exception
            Console.WriteLine("Unable to create error log")
            Console.WriteLine(ex.ToString)
            Exit Sub
        End Try
    End Sub
</script>

