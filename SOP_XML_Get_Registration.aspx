<%@ Page Language="VB" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Net" %>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.web.ui" %>

<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim _NDC, _MSISDN, _ID, _WithImage As String
        Dim strSql As String
        Dim lngCount As String
        Dim _FirstName, _MiddleName, _lastName, _Gender, _DateOfBirth, _Email, _Education, _PersonalImage As String
        Dim _Nationality, _IdType, _RefNumber, _IdSide1Image, _IdSide2Image, _ResidenceRegion As String
        Dim _ResidenceDistrict, _ResidenceTown, _ResidenceStreet, _OccupationCategory, _OccupationSubCategory, _OccupationEmployer As String
        Dim _OccupationRegion, _OccupationDistrict, _OccupationTown, _OccupationStreet, _SIMNDC, _SIMMSISDN As String
        Dim _SIMICC, _CreateUser, _CreateDate, _CreateCellId As String
        
        If Request.QueryString("NDC") IsNot Nothing Then
            _NDC = Request.QueryString("NDC").ToString
        Else
            _NDC = "77"
        End If
        If Request.QueryString("MSISDN") IsNot Nothing Then
            _MSISDN = Request.QueryString("MSISDN").ToString
        Else
            _MSISDN = "928554"
        End If
        If Request.QueryString("ID") IsNot Nothing Then
            _ID = Request.QueryString("ID").ToString
        Else
            _ID = "0"
        End If
        If Request.QueryString("WithImage") IsNot Nothing Then
            _WithImage  = Request.QueryString("WithImage").ToString
        Else
            _WithImage = "1"
        End If
        
    
        Try
            strSql = "afr_sl_registration.dbo.usp_get_registration " & _
                     " '" & _NDC.Trim & "' " & _
                     " ,'" & _MSISDN.Trim & "' " & _
                     " ,'" & _ID.Trim & "' "
            lngCount = 0
            Dim dsetLogin As Data.DataSet
            Dim cnLogin As New clsMSSQLOledb("sa", "@fricell2014", "10.100.11.10", "afr_sl_registration")
            If cnLogin.blnOpenConn = True Then
                dsetLogin = cnLogin.dSetOpenDataSet(strSql, "RegistrationQuery")
                lngCount = dsetLogin.Tables("RegistrationQuery").Rows.Count
                If lngCount > 0 Then
                    _FirstName = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("FirstName") & ""
                    _MiddleName = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("MiddleName") & ""
                    _lastName = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("lastName") & ""
                    _Gender = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("Gender") & ""
                    _DateOfBirth = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("DateOfBirth") & ""
                    _Email = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("Email") & ""
                    _Education = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("Education") & ""
                    _PersonalImage = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("PersonalImage") & ""
                    _Nationality = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("Nationality") & ""
                    _IdType = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("IdType") & ""
                    _RefNumber = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("RefNumber") & ""
                    _IdSide1Image = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("IdSide1Image") & ""
                    _IdSide2Image = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("IdSide2Image") & ""
                    _ResidenceRegion = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("ResidenceRegion") & ""
                    _ResidenceDistrict = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("ResidenceDistrict") & ""
                    _ResidenceTown = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("ResidenceTown") & ""
                    _ResidenceStreet = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("ResidenceStreet") & ""
                    _OccupationCategory = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("OccupationCategory") & ""
                    _OccupationSubCategory = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("OccupationSubCategory") & ""
                    _OccupationEmployer = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("OccupationEmployer") & ""
                    _OccupationRegion = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("OccupationRegion") & ""
                    _OccupationDistrict = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("OccupationDistrict") & ""
                    _OccupationTown = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("OccupationTown") & ""
                    _OccupationStreet = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("OccupationStreet") & ""
                    _SIMNDC = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("SIMNDC") & ""
                    _SIMMSISDN = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("SIMMSISDN") & ""
                    _SIMICC = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("SIMICC") & ""
                    _CreateUser = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("CreateUser") & ""
                    _CreateDate = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("CreateDate") & ""
                    _CreateCellId = dsetLogin.Tables("RegistrationQuery").Rows(0).Item("CreateCellId") & ""

                    If _WithImage = "1" Then
                        If _PersonalImage.Trim <> "" Then
                            Dim strPersonalImagePath As String
                            strPersonalImagePath = _PersonalImage.Trim
                            _PersonalImage = ""
                            If File.Exists(strPersonalImagePath & ".jpg") Then
                                _PersonalImage = strImageToString(strPersonalImagePath & ".jpg")
                            End If
                        End If
                        
                        If _IdSide1Image.Trim <> "" Then
                            Dim strIdSide1ImagePath As String
                            strIdSide1ImagePath = _IdSide1Image.Trim
                            _IdSide1Image = ""
                            If File.Exists(strIdSide1ImagePath & ".jpg") Then
                                _IdSide1Image = strImageToString(strIdSide1ImagePath & ".jpg")
                            End If
                        End If
                        
                        If _IdSide2Image.Trim <> "" Then
                            Dim strIdSide2ImagePath As String
                            strIdSide2ImagePath = _IdSide2Image.Trim
                            _IdSide2Image = ""
                            If File.Exists(strIdSide2ImagePath & ".jpg") Then
                                _IdSide2Image = strImageToString(strIdSide2ImagePath & ".jpg")
                            End If
                        End If
                        
                    Else
                        _PersonalImage = ""
                        _IdSide1Image = ""
                        _IdSide2Image = ""
                    End If
                    
                    
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<Subscriber>")
                    Response.Write("<Error> </Error>")
                    Response.Write("<FirstName>" & _FirstName.Trim & "</FirstName>")
                    Response.Write("<MiddleName>" & _MiddleName.Trim & "</MiddleName>")
                    Response.Write("<lastName>" & _lastName.Trim & "</lastName>")
                    Response.Write("<Gender>" & _Gender.Trim & "</Gender>")
                    Response.Write("<DateOfBirth>" & _DateOfBirth.Trim & "</DateOfBirth>")
                    Response.Write("<Email>" & _Email.Trim & "</Email>")
                    Response.Write("<Education>" & _Education.Trim & "</Education>")
                    Response.Write("<PersonalImage>" & _PersonalImage.Trim & "</PersonalImage>")
                    Response.Write("<Nationality>" & _Nationality.Trim & "</Nationality>")
                    Response.Write("<IdType>" & _IdType.Trim & "</IdType>")
                    Response.Write("<RefNumber>" & _RefNumber.Trim & "</RefNumber>")
                    Response.Write("<IdSide1Image>" & _IdSide1Image.Trim & "</IdSide1Image>")
                    Response.Write("<IdSide2Image>" & _IdSide2Image.Trim & "</IdSide2Image>")
                    Response.Write("<ResidenceRegion>" & _ResidenceRegion.Trim & "</ResidenceRegion>")
                    Response.Write("<ResidenceDistrict>" & _ResidenceDistrict.Trim & "</ResidenceDistrict>")
                    Response.Write("<ResidenceTown>" & _ResidenceTown.Trim & "</ResidenceTown>")
                    Response.Write("<ResidenceStreet>" & _ResidenceStreet.Trim & "</ResidenceStreet>")
                    Response.Write("<OccupationCategory>" & _OccupationCategory.Trim & "</OccupationCategory>")
                    Response.Write("<OccupationSubCategory>" & _OccupationSubCategory.Trim & "</OccupationSubCategory>")
                    Response.Write("<OccupationEmployer>" & _OccupationEmployer.Trim & "</OccupationEmployer>")
                    Response.Write("<OccupationRegion>" & _OccupationRegion.Trim & "</OccupationRegion>")
                    Response.Write("<OccupationDistrict>" & _OccupationDistrict.Trim & "</OccupationDistrict>")
                    Response.Write("<OccupationTown>" & _OccupationTown.Trim & "</OccupationTown>")
                    Response.Write("<OccupationStreet>" & _OccupationStreet.Trim & "</OccupationStreet>")
                    Response.Write("<SIMNDC>" & _SIMNDC.Trim & "</SIMNDC>")
                    Response.Write("<SIMMSISDN>" & _SIMMSISDN.Trim & "</SIMMSISDN>")
                    Response.Write("<SIMICC>" & _SIMICC.Trim & "</SIMICC>")
                    Response.Write("<CreateUser>" & _CreateUser.Trim & "</CreateUser>")
                    Response.Write("<CreateDate>" & _CreateDate.Trim & "</CreateDate>")
                    Response.Write("<CreateCellId>" & _CreateCellId.Trim & "</CreateCellId>")
                    Response.Write("</Subscriber>")
                    dsetLogin = Nothing
                    cnLogin.sCloseConn()
                Else
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<Subscriber>")
                    Response.Write("<Error>Not Registered.</Error>")
                    Response.Write("<FirstName> </FirstName>")
                    Response.Write("<MiddleName> </MiddleName>")
                    Response.Write("<lastName> </lastName>")
                    Response.Write("<Gender> </Gender>")
                    Response.Write("<DateOfBirth> </DateOfBirth>")
                    Response.Write("<Email> </Email>")
                    Response.Write("<Education> </Education>")
                    Response.Write("<PersonalImage> </PersonalImage>")
                    Response.Write("<Nationality> </Nationality>")
                    Response.Write("<IdType> </IdType>")
                    Response.Write("<RefNumber> </RefNumber>")
                    Response.Write("<IdSide1Image> </IdSide1Image>")
                    Response.Write("<IdSide2Image> </IdSide2Image>")
                    Response.Write("<ResidenceRegion> </ResidenceRegion>")
                    Response.Write("<ResidenceDistrict> </ResidenceDistrict>")
                    Response.Write("<ResidenceTown> </ResidenceTown>")
                    Response.Write("<ResidenceStreet> </ResidenceStreet>")
                    Response.Write("<OccupationCategory> </OccupationCategory>")
                    Response.Write("<OccupationSubCategory> </OccupationSubCategory>")
                    Response.Write("<OccupationEmployer> </OccupationEmployer>")
                    Response.Write("<OccupationRegion> </OccupationRegion>")
                    Response.Write("<OccupationDistrict> </OccupationDistrict>")
                    Response.Write("<OccupationTown> </OccupationTown>")
                    Response.Write("<OccupationStreet> </OccupationStreet>")
                    Response.Write("<SIMNDC> </SIMNDC>")
                    Response.Write("<SIMMSISDN> </SIMMSISDN>")
                    Response.Write("<SIMICC> </SIMICC>")
                    Response.Write("<CreateUser> </CreateUser>")
                    Response.Write("<CreateDate> </CreateDate>")
                    Response.Write("<CreateCellId> </CreateCellId>")
                    Response.Write("</Subscriber>")
                End If
            Else
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<Subscriber>")
                Response.Write("<Error>Unable to connect to database server.</Error>")
                Response.Write("<FirstName> </FirstName>")
                Response.Write("<MiddleName> </MiddleName>")
                Response.Write("<lastName> </lastName>")
                Response.Write("<Gender> </Gender>")
                Response.Write("<DateOfBirth> </DateOfBirth>")
                Response.Write("<Email> </Email>")
                Response.Write("<Education> </Education>")
                Response.Write("<PersonalImage> </PersonalImage>")
                Response.Write("<Nationality> </Nationality>")
                Response.Write("<IdType> </IdType>")
                Response.Write("<RefNumber> </RefNumber>")
                Response.Write("<IdSide1Image> </IdSide1Image>")
                Response.Write("<IdSide2Image> </IdSide2Image>")
                Response.Write("<ResidenceRegion> </ResidenceRegion>")
                Response.Write("<ResidenceDistrict> </ResidenceDistrict>")
                Response.Write("<ResidenceTown> </ResidenceTown>")
                Response.Write("<ResidenceStreet> </ResidenceStreet>")
                Response.Write("<OccupationCategory> </OccupationCategory>")
                Response.Write("<OccupationSubCategory> </OccupationSubCategory>")
                Response.Write("<OccupationEmployer> </OccupationEmployer>")
                Response.Write("<OccupationRegion> </OccupationRegion>")
                Response.Write("<OccupationDistrict> </OccupationDistrict>")
                Response.Write("<OccupationTown> </OccupationTown>")
                Response.Write("<OccupationStreet> </OccupationStreet>")
                Response.Write("<SIMNDC> </SIMNDC>")
                Response.Write("<SIMMSISDN> </SIMMSISDN>")
                Response.Write("<SIMICC> </SIMICC>")
                Response.Write("<CreateUser> </CreateUser>")
                Response.Write("<CreateDate> </CreateDate>")
                Response.Write("<CreateCellId> </CreateCellId>")
                Response.Write("</Subscriber>")
            End If
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<Subscriber>")
            Response.Write("<Error>" & ex.ToString & "</Error>")
            Response.Write("<FirstName> </FirstName>")
            Response.Write("<MiddleName> </MiddleName>")
            Response.Write("<lastName> </lastName>")
            Response.Write("<Gender> </Gender>")
            Response.Write("<DateOfBirth> </DateOfBirth>")
            Response.Write("<Email> </Email>")
            Response.Write("<Education> </Education>")
            Response.Write("<PersonalImage> </PersonalImage>")
            Response.Write("<Nationality> </Nationality>")
            Response.Write("<IdType> </IdType>")
            Response.Write("<RefNumber> </RefNumber>")
            Response.Write("<IdSide1Image> </IdSide1Image>")
            Response.Write("<IdSide2Image> </IdSide2Image>")
            Response.Write("<ResidenceRegion> </ResidenceRegion>")
            Response.Write("<ResidenceDistrict> </ResidenceDistrict>")
            Response.Write("<ResidenceTown> </ResidenceTown>")
            Response.Write("<ResidenceStreet> </ResidenceStreet>")
            Response.Write("<OccupationCategory> </OccupationCategory>")
            Response.Write("<OccupationSubCategory> </OccupationSubCategory>")
            Response.Write("<OccupationEmployer> </OccupationEmployer>")
            Response.Write("<OccupationRegion> </OccupationRegion>")
            Response.Write("<OccupationDistrict> </OccupationDistrict>")
            Response.Write("<OccupationTown> </OccupationTown>")
            Response.Write("<OccupationStreet> </OccupationStreet>")
            Response.Write("<SIMNDC> </SIMNDC>")
            Response.Write("<SIMMSISDN> </SIMMSISDN>")
            Response.Write("<SIMICC> </SIMICC>")
            Response.Write("<CreateUser> </CreateUser>")
            Response.Write("<CreateDate> </CreateDate>")
            Response.Write("<CreateCellId> </CreateCellId>")
            Response.Write("</Subscriber>")
        End Try
    End Sub
    
    Private Function strImageToString(ByVal strImagePath As String) As String
        'Get the image from file
        Dim image As System.Drawing.Image
        image = image.FromFile(strImagePath)

        'Converting the image to a byte[] to later be converted to base64 string
        Dim imgStream As MemoryStream = New MemoryStream()
        image.Save(imgStream, System.Drawing.Imaging.ImageFormat.Jpeg)
        imgStream.Close()
        Dim byteArray As Byte() = imgStream.ToArray()
        imgStream.Dispose()

        'Convert the byte[] to base64 string for use with WebRequest to upload.
        Dim strFinal As String
        strFinal = Convert.ToBase64String(byteArray)
        
        strImageToString = strFinal
    End Function
</script>
