<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Data.OleDb" %> 
<%@ Import Namespace="System.Web.SessionState" %>
 
 <script runat="server">
     string _FirstName, _FatherName, _LastName, _Gender, _BirthDate, _Email, _Education;
     string _Nationality, _IDType, _ReferenceNbr, _residenceTown, _residenceStreet;
     string _category, _subcategory, _Employer, _OccupationTown, _OccupationStreet;
     string _SIMNDC, _SIMMSISDN, _SIMICC;
     string _user, _cellid;
     string _PersonalPhoto, _IdCardSide1, _IdCardSide2;
     string _PersonalPhotoPath, _IdCardSide1Path, _IdCardSide2Path;
     string _FingerPrint, _FingerPrintPath;

     string strSql;
     string strTimeStamp;
     string strPath;

     string _SIMMSISDN2,_MSISDN;
     int PAYID = 12;
     string provideid = "101";
     string DOB;
     string _MPIN, _PIN;

     string DestinationPath=ConfigurationManager.AppSettings["DestinationPath"];
     string IPAdressAPITOKEN,IPAdressAPI ;

     public static string Right(string original, int numberCharacters)
     {
         return original.Substring(original.Length - numberCharacters);
     }
     public string getToken(string sKey) {
         string access_token = "";
         string expires_in = "";
         string result;

         try {
             var url = IPAdressAPITOKEN ;
             var httpRequest = (HttpWebRequest)WebRequest.Create(url);
             //httpRequest.ContentType = "application/xml";
             httpRequest.ContentType = "application/x-www-form-urlencoded";
             httpRequest.Method = "POST";
             httpRequest.Headers["Authorization"] = "Basic MUcyaDk2M2h0NGtzR19zZmRLZnVFWXByZmxRYTpsaFFrdWFLc1VTNnhTN1VmbXRUZHdQUEV3aThh";
             httpRequest.Headers["grant_type"] = "client_credentials";
             httpRequest.ContentType = "application/json";

             var httpResponse = (HttpWebResponse)httpRequest.GetResponse();
             string connectionStatus = httpResponse.StatusCode.ToString();

             using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
             {
                 result = streamReader.ReadToEnd();
             }

             return result;

         }
         catch (Exception e)
         {
             // Context.Response.Write(e.Message);
             return e.Message;
         }


     }
     public string Insert_registration(StringReader strXmlData) {
         try {

             String response = "";
             String strImage1 = "";

             XmlReader reader;
             reader = XmlReader.Create(strXmlData);

             while (reader.Read())
             {
                 switch (reader.NodeType)
                 {
                     case XmlNodeType.Element: //Display the text in each element.
                         if (reader.Name.Equals("firstname"))
                         {
                             reader.Read();
                             if (_FirstName.Trim().Equals("")) {
                                 _FirstName = reader.Value;
                             }

                         }
                         if (reader.Name.Equals("fathername"))
                         {
                             reader.Read();
                             if (_FatherName.Trim().Equals(""))
                             {
                                 _FatherName = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("familyname"))
                         {
                             reader.Read();
                             if (_LastName.Trim().Equals(""))
                             {
                                 _LastName = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("gender"))
                         {
                             reader.Read();
                             if (_Gender.Trim().Equals(""))
                             {
                                 _Gender = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("birthdate"))
                         {
                             reader.Read();
                             if (_BirthDate.Trim().Equals(""))
                             {
                                 _BirthDate = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("email"))
                         {
                             reader.Read();
                             if (_Email.Trim().Equals(""))
                             {
                                 _Email = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("education"))
                         {
                             reader.Read();
                             if (_Education.Trim().Equals(""))
                             {
                                 _Education = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("nationality"))
                         {
                             reader.Read();
                             if (_Nationality.Trim().Equals(""))
                             {
                                 _Nationality = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("idtype"))
                         {
                             reader.Read();
                             if (_IDType.Trim().Equals(""))
                             {
                                 _IDType = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("referencenbr"))
                         {
                             reader.Read();
                             if (_ReferenceNbr.Trim().Equals(""))
                             {
                                 _ReferenceNbr = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("residencetown"))
                         {
                             reader.Read();
                             if (_residenceTown.Trim().Equals(""))
                             {
                                 _residenceTown = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("residencestreet"))
                         {
                             reader.Read();
                             if (_residenceStreet.Trim().Equals(""))
                             {
                                 _residenceStreet = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("category"))
                         {
                             reader.Read();
                             if (_category.Trim().Equals(""))
                             {
                                 _category = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("subcategory"))
                         {
                             reader.Read();
                             if (_subcategory.Trim().Equals(""))
                             {
                                 _subcategory = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("employer"))
                         {
                             reader.Read();
                             if (_Employer.Trim().Equals(""))
                             {
                                 _Employer = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("occupationtown"))
                         {
                             reader.Read();
                             if (_OccupationTown.Trim().Equals(""))
                             {
                                 _OccupationTown = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("occupationstreet"))
                         {
                             reader.Read();
                             if (_OccupationStreet.Trim().Equals(""))
                             {
                                 _OccupationStreet = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("ndc"))
                         {
                             reader.Read();
                             if (_SIMNDC.Trim().Equals(""))
                             {
                                 _SIMNDC = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("msisdn"))
                         {
                             reader.Read();
                             if (_SIMMSISDN.Trim().Equals(""))
                             {
                                 _SIMMSISDN = reader.Value;
                             }
                         }
                         if (reader.Name.Equals("icc"))
                         {
                             reader.Read();
                             if (_SIMICC.Trim().Equals(""))
                             {
                                 _SIMICC = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("user"))
                         {
                             reader.Read();
                             if (_user.Trim().Equals(""))
                             {
                                 _user = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("cellid"))
                         {
                             reader.Read();
                             if (_cellid.Trim().Equals(""))
                             {
                                 _cellid = reader.Value;
                             }
                         }

                         if (reader.Name.Equals("personalphoto"))
                         {
                             reader.Read();
                             if (_PersonalPhoto.Trim().Equals(""))
                             {
                                 _PersonalPhoto = reader.Value;
                                 _PersonalPhotoPath = strPath + _SIMNDC + _SIMMSISDN + strTimeStamp + "P";

                                 if (!_PersonalPhoto.Trim().Equals("")) {
                                     strStringToImage(_PersonalPhoto, _PersonalPhotoPath);
                                 }

                             }

                         }

                         if (reader.Name.Equals("idcardside1"))
                         {
                             reader.Read();
                             if (_IdCardSide1.Trim().Equals(""))
                             {
                                 _IdCardSide1 = reader.Value;
                                 _IdCardSide1Path = strPath + _SIMNDC + _SIMMSISDN + strTimeStamp + "S1";

                                 if (!_IdCardSide1.Trim().Equals("")) {
                                     strStringToImage(_IdCardSide1, _IdCardSide1Path);
                                 }

                             }
                         }

                         if (reader.Name.Equals("idcardside2"))
                         {
                             reader.Read();
                             if (_IdCardSide2.Trim().Equals(""))
                             {
                                 _IdCardSide2 = reader.Value;
                                 _IdCardSide2Path = strPath + _SIMNDC + _SIMMSISDN + strTimeStamp + "S2";

                                 if (!_IdCardSide2.Trim().Equals("")) {
                                     strStringToImage(_IdCardSide2, _IdCardSide2Path);
                                 }

                             }
                         }


                         if (reader.Name.Equals("personalEmpreinte"))
                         {
                             reader.Read();
                             if (_FingerPrint.Trim().Equals(""))
                             {
                                 _FingerPrint = reader.Value;
                                 _FingerPrintPath = strPath + _SIMNDC + _SIMMSISDN + strTimeStamp + "F";

                                 if (!_FingerPrint.Trim().Equals("")) {
                                     strStringToImage(_FingerPrint, _FingerPrintPath);
                                 }

                             }
                         }
                         break;
                 }
             }

             if (_BirthDate.Equals("")){
                 _BirthDate = "1900-01-01";
             }

             strSql = "dbo.usp_insert_registration ";
             strSql = strSql + " '"  + _FirstName + "'"         ;
             strSql = strSql + " ,'" + _FatherName + "'"       ;
             strSql = strSql + " ,'" + _LastName + "'"         ;
             strSql = strSql + " ,'" + _Gender + "'"           ;
             strSql = strSql + " ,'" + _BirthDate + "'"        ;
             strSql = strSql + " ,'" + _Email + "'"            ;
             strSql = strSql + " ,'" + _Education + "'"        ;
             strSql = strSql + " ,'" + _PersonalPhotoPath + "'";

             strSql = strSql + " ,'" + _Nationality + "'"      ;
             strSql = strSql + " ,'" + _IDType + "'"           ;
             strSql = strSql + " ,'" + _ReferenceNbr + "'"     ;
             strSql = strSql + " ,'" + _IdCardSide1Path + "'"  ;
             strSql = strSql + " ,'" + _IdCardSide2Path + "'"  ;

             strSql = strSql + " ,'" + _residenceTown + "'"    ;
             strSql = strSql + " ,'" + _residenceStreet + "'"  ;

             strSql = strSql + " ,'" + _category + "'"         ;
             strSql = strSql + " ,'" + _subcategory + "'"      ;
             strSql = strSql + " ,'" + _Employer + "'"         ;
             strSql = strSql + " ,'" + _OccupationTown+ "'"   ;
             strSql = strSql + " ,'" + _OccupationStreet + "'" ;

             strSql = strSql + " ,'" + _SIMNDC + "'"           ;
             strSql = strSql + " ,'" + _SIMMSISDN + "'"        ;
             strSql = strSql + " ,'" + _SIMICC + "'"           ;

             strSql = strSql + " ,'" + _user + "'"             ;
             strSql = strSql + " ,'" + _cellid + "'"           ;

             //add finger                                    
             strSql = strSql + " ,'" +_FingerPrintPath+ "'"  ;
             strSql = strSql + " ,'" + _FingerPrint + "'"      ;

             clsMSSQLOledb cnInsertRegistration = new clsMSSQLOledb();
             if (cnInsertRegistration.OpenConn()) {
                 cnInsertRegistration.lngExecuteNoQuery(strSql,false);
                 // cnInsertRegistration.sCloseConn();
                 cnInsertRegistration = null;

                 sWriteErrorLog1("strSql= " + strSql, "Sp");
             }
             else {
                 sWriteErrorLog1("Error connecting to DB. " +strSql, "ERR_CON");
                 //Context.Response.Clear();
                 //Context.Response.ContentType = "text/xml";
                 //Context.Response.ContentEncoding = Encoding.UTF8;
                 //Context.Response.Write("<Reply>");
                 //Context.Response.Write("<MESSAGE>Failed</MESSAGE>");
                 //Context.Response.Write("</Reply>");
                 return "Failed";
             }


             response = "Successful";
             // response = "failed:gsm";
             return response;

         }catch (Exception ee) {

             sWriteErrorLog1(ee.Message, "ERR_CON");
             //Context.Response.Clear();
             //Context.Response.ContentType = "text/xml";
             //Context.Response.ContentEncoding = Encoding.UTF8;
             //Context.Response.Write("<Reply>");
             //Context.Response.Write("<MESSAGE>Failed</MESSAGE>");
             //Context.Response.Write("</Reply>");

             return ee.Message;
         }
     }
     public string Insert_Registration_MM() {
         try
         {
             _SIMMSISDN2= "0"  + Right(_SIMNDC +_SIMMSISDN, 9);
             if (_BirthDate.Equals("")){
                 _BirthDate = "1900-01-01";
             }
             DateTime dateBOB =  Convert.ToDateTime(_BirthDate);
             DOB = dateBOB.AddDays(0).ToString("ddMMyyyy");//ToString() + dateBOB.Month.ToString() + dateBOB.Year.ToString();
             string _IDISSUEDATE = DateTime.Now.AddDays(0).ToString("ddMMyyyy"); //DateTime.Now.Day.ToString("dd") +  DateTime.Now.Day.ToString("MM") +  DateTime.Now.Day.ToString("yyyy");

             switch (_Gender.ToLower()) {
                 case "masculin":
                     _Gender = "Male";
                     break;
                 case "feminin":
                     _Gender = "Female";
                     break;
                 default:
                     _Gender = "Male";
                     break;
             }

             // var url = IPAdressAPI + @"/SOP_XML_ORA_Get_Registration.aspx";
             var url = IPAdressAPI ;
             var httpRequest = (HttpWebRequest)WebRequest.Create(url);
             httpRequest.ContentType = "text/plain";
             httpRequest.Method = "POST";

             httpRequest.Accept = "application/xml";

             //string  access_token= getToken("MUcyaDk2M2h0NGtzR19zZmRLZnVFWXByZmxRYTpsaFFrdWFLc1VTNnhTN1VmbXRUZHdQUEV3aThh");
             httpRequest.Headers["Authorization"] = "Bearer 8ce26afd-f06a-37eb-a152-58382d3cdf33";
             var data = @"<?xml version=""1.0"" encoding=""utf-8""?>" +
             "<COMMAND>" +
                  "<TYPE>RSUBREG</TYPE> " +
                  "<PROVIDER>"+provideid+"</PROVIDER> " +
                  "<PAYID>"+PAYID.ToString()+"</PAYID>" +
                  "<FNAME>"+_FirstName+"</FNAME>" +
                  "<LNAME>"+_LastName+"</LNAME>" +
                  "<MSISDN>"+_MSISDN+"</MSISDN>" +
                  "<PROVIDER2>"+provideid+"</PROVIDER2>" +
                  "<PAYID2>"+PAYID+"</PAYID2> " +
                  "<MSISDN2>"+_SIMMSISDN2 +"</MSISDN2>" +
                  "<IDNUMBER>"+_SIMMSISDN2 +"</IDNUMBER>" +
                  "<MPIN>"+_MPIN +"</MPIN>" +
                  "<PIN>"+_PIN +"</PIN>" +
                  "<DOB>"+DOB+"</DOB>" +
                  "<GENDER>"+_Gender+"</GENDER> " +
                  "<ADDRESS>"+ _residenceStreet+"</ADDRESS>" +
                  "<DISTRICT>"+ _residenceTown+"</DISTRICT>" +
                  "<CITY>"+ _residenceTown+"</CITY>" +
                  "<LOGINID></LOGINID>" +
                  "<PASSWORD></PASSWORD>" +
                  "<CPASSWORD></CPASSWORD> " +
                  "<LANGUAGE1>1</LANGUAGE1>" +
                  "<REGTYPEID>NO_KYC</REGTYPEID>" +
                  "<BLOCKSMS></BLOCKSMS>  " +
                  "<CELLID>"+ _cellid+"</CELLID>" +
                  "<FTXNID></FTXNID>" +
                  "<IDTYPE></IDTYPE>" +
                  "<ISIMTENABLE></ISIMTENABLE>" +
                  "<IMTIDTYPE></IMTIDTYPE>" +
                  "<IMTIDNO>"+ _ReferenceNbr +"</IMTIDNO>" +
                  "<IDISSUEPLACE>DRC</IDISSUEPLACE>" +
                  "<IDISSUECOUNTRY>DRC</IDISSUECOUNTRY>" +
                  "<RCOUNTRY>DRC</RCOUNTRY>" +
                  "<NATIONALITY>"+_Nationality +"</NATIONALITY>" +
                  "<IDISSUEDATE></IDISSUEDATE>" +
                  "<ISIDEXPIRES></ISIDEXPIRES>" +
                  "<IDEXPIRYDATE></IDEXPIRYDATE>" +
                  "<POSTAL_CODE></POSTAL_CODE>" +
                  "<EMPLOYER_NAME>"+_user+"</EMPLOYER_NAME>" +
                  "<OCCUPATION></OCCUPATION> " +
                  "<WUENABLE></WUENABLE>" +
                  "<MONEYGRAMENABLE></MONEYGRAMENABLE>" +
                  "<BIRTHCITY>KINSHASA</BIRTHCITY>" +
                  "<BIRTHCOUNTRY></BIRTHCOUNTRY>" +
                  "<PASSPORTISSUECOUNTRY></PASSPORTISSUECOUNTRY> " +
                  "<PASSPORTISSUECITY></PASSPORTISSUECITY>" +
                  "<PASSPORTISSUEDATE></PASSPORTISSUEDATE> " +
            " </COMMAND>";

             using (var streamWriter = new StreamWriter(httpRequest.GetRequestStream()))
             {
                 streamWriter.Write(data);
             }
             var httpResponse = (HttpWebResponse)httpRequest.GetResponse();
             string responseStr;
             if (httpResponse.StatusCode == HttpStatusCode.OK)
             {
                 Stream responseStream = httpResponse.GetResponseStream();
                 responseStr = new StreamReader(responseStream).ReadToEnd();

                 if  (!responseStr.ToLower().Contains("successful"))
                 {
                     //check the response and save the log
                     if  (!InsertRegistrationFailed(responseStr)){
                          responseStr = "MM_Reg_failed";
                     }
                     //sWriteErrorLog1(responseStr, "MM_Log");
                 }
                 //sWriteErrorLog1(responseStr, "MM_Log");
             }
             else
             {
                 responseStr = "echec connexion";
             }
             //Console.WriteLine(httpResponse.StatusCode);
             //Context.Response.Write(responseStr);
             return responseStr;
         }
         catch (Exception e)
         {
             // Context.Response.Write(e.Message);
             return e.Message;
         }
     }
     private Boolean InsertRegistrationFailed(string strXmlData) {

         try
         {
             Context.Response.ContentType = "text/xml";
             StringReader xml = new StringReader(strXmlData);
             XmlReader reader;
             reader = XmlReader.Create(xml);
             string _TYPE = "";
             string _TXNID = "";
             string _TXNSTATUS = "";
             string _MESSAGE = "";
             string _TRID = "";

             while (reader.Read())
             {
                 switch (reader.NodeType)
                 {
                     case XmlNodeType.Element: //Display the text in each element.

                         if (reader.Name.Equals("TYPE"))
                         {
                             reader.Read();
                             _TYPE = reader.Value;
                         }

                         if (reader.Name.Equals("TXNID"))
                         {
                             reader.Read();
                             _TXNID = reader.Value;
                         }

                         if (reader.Name.Equals("TXNSTATUS"))
                         {
                             reader.Read();
                             _TXNSTATUS = reader.Value;
                         }
                         if (reader.Name.Equals("MESSAGE"))
                         {
                             reader.Read();
                             _MESSAGE = reader.Value;
                         }
                         if (reader.Name.Equals("TRID"))
                         {
                             reader.Read();
                             _TRID = reader.Value;
                         }

                         break;
                 }
             }
             
             ///creation new subs
             //Context.Response.Clear();
             //Context.Response.ContentType = "text/xml";
             //Context.Response.ContentEncoding = Encoding.UTF8;

             strSql = " EXEC [dbo].[sp_Insert_Registration_Failed] ";
             strSql = strSql + "@tnxid = N'"+_TXNID +"',  " ;
             strSql = strSql + "@txnstatus = N'"+_TXNSTATUS +"', " ;
             strSql = strSql + "@message = N'"+_MESSAGE +"'," ;
             strSql = strSql + "@trid = N'"+_TRID +"', "   ;
             strSql = strSql + "@firstname = N'"+_FirstName +"', "  ;
             strSql = strSql + "@lastname = N'"+_LastName +"', " ;
             strSql = strSql + "@msisdnpayer = N'"+_MSISDN +"', "  ;
             strSql = strSql + "@msisdn = N'"+_SIMMSISDN2 +"', "  ;
             strSql = strSql + "@dateofbirthday = N'"+ DOB +"', " ;
             strSql = strSql + "@gender = N'"+_Gender +"', "  ;
             strSql = strSql + "@userid = N'"+_user +"'";

            sWriteErrorLog1(strSql, "Sp_MM");

             //clsMSSQLOledb cnInsertRegistration = new clsMSSQLOledb();
             //if (cnInsertRegistration.OpenConn())
             //{
             //    cnInsertRegistration.lngExecuteNoQuery(strSql, false);
             //    // cnInsertRegistration.sCloseConn();
             //    cnInsertRegistration = null;
             //    sWriteErrorLog1("strSql= " + strSql, "Sp_MM");
             //    return true;
             //}
             //else
             //{
             //    sWriteErrorLog1("Error execution " + strSql, "ERR_F_MM");
             //    return false;
             //}

             return true;

         }
         catch (Exception r) {
             return false;
         }

     }

     protected void Page_Load(object sender, EventArgs e)
     {
         // string DestinationPath = @"D:\Africell POS\ImageUpload\";
         strTimeStamp = "-" + DateTime.Now.Hour.ToString() + "-" + DateTime.Now.Minute.ToString() + "-" + DateTime.Now.Second.ToString();
         strPath = DestinationPath + DateTime.Now.AddDays(0).ToString("yyyyMMdd") + @"\";
         System.IO.DirectoryInfo diDestination = new System.IO.DirectoryInfo(strPath);

         if (!diDestination.Exists) {
             diDestination.Create();
         }
         if (!IsPostBack)
         {
             _FirstName = "";
             _FatherName = "";
             _LastName = "";
             _Gender = "";
             _BirthDate = "";
             _Email = "";
             _Education = "";

             _Nationality = "";
             _IDType = "";
             _ReferenceNbr = "";
             _residenceTown = "";
             _residenceStreet = "";

             _category = "";
             _subcategory = "";
             _Employer = "";
             _OccupationTown = "";
             _OccupationStreet = "";

             _SIMNDC = "";
             _SIMMSISDN = "";
             _SIMICC = "";

             _user = "";
             _cellid = "";

             _PersonalPhoto = "";
             _PersonalPhotoPath = "";

             _FingerPrint = "";
             _FingerPrintPath = "";

             _IdCardSide1 = "";
             _IdCardSide2 = "";

             _IdCardSide1Path = "";
             _IdCardSide2Path = "";

             try
             {
                 //check before
                 Context.Response.ContentType = "text/xml";
                 StreamReader xmlStream = new StreamReader(Context.Request.InputStream);
                 string xmlData = xmlStream.ReadToEnd();

                 StringReader xml = new StringReader(xmlData);
                 string regResponse = Insert_registration(xml);

                 _MPIN=ConfigurationManager.AppSettings["MPIN"];
                 _PIN=ConfigurationManager.AppSettings["PIN"];
                 IPAdressAPITOKEN=ConfigurationManager.AppSettings["IPAdressAPITOKEN"];
                 IPAdressAPI=ConfigurationManager.AppSettings["IPAdressAPI"];

                 IPAdressAPI=ConfigurationManager.AppSettings["IPAdressAPI"];

                 _MSISDN=ConfigurationManager.AppSettings["MsisdnPeyer"];

                 if  ( (regResponse.ToLower().Contains("successful")))
                 {
                     //Context.Response.Write(responseStr);
                     //send to API MM
                     string res = Insert_Registration_MM();
                     if (res.ToLower().Contains("successful"))
                     {
                         //MM registration successful
                         sWriteErrorLog1(res,"OK");
                     }
                     else
                     {
                         //MM registration failed
                         sWriteErrorLog1(res,"ERR_MM");
                         //insert to failled table
                     }

                     Context.Response.Clear();
                     Context.Response.ContentType = "text/xml";
                     Context.Response.ContentEncoding = Encoding.UTF8;

                     //string  xmlResponse = @"<?xml version=""1.0""?> 
                     string  xmlResponse = @"<Reply><MESSAGE>Successful</MESSAGE></Reply>";
                     Context.Response.Write(xmlResponse);
                     return;
                 }
                 else
                 {
                     Context.Response.Clear();
                     Context.Response.ContentType = "text/xml";
                     Context.Response.ContentEncoding = Encoding.UTF8;
                     Context.Response.Write("<Reply>");
                     Context.Response.Write("<MESSAGE>Failed</MESSAGE>");
                     Context.Response.Write("</Reply>");
                 }
             }
             catch (Exception ee)
             {
                 sWriteErrorLog1(ee.Message,"ERR");
                 Context.Response.Clear();
                 Context.Response.ContentType = "text/xml";
                 Context.Response.ContentEncoding = Encoding.UTF8;
                 Context.Response.Write("<Reply>");
                 Context.Response.Write("<MESSAGE>" + ee.Message + " </MESSAGE>");
                 Context.Response.Write("</Reply>");
             }
         }
     }
     private void sWriteErrorLog1(string strError,string status)
     {
         System.IO.StreamWriter oWrite;
         try
         {
             //string DestinationPath = @"D:\Africell POS\ImageUpload\";
             string xPath = DestinationPath + @"Log\";
             string sLogFile=status+"_"+ _SIMNDC+_SIMMSISDN+"_"+ DateTime.Now.Day.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Year.ToString() + "_" + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + "1.log";
             if (File.Exists(xPath + sLogFile))
                 File.Delete(xPath + sLogFile);
             oWrite = File.CreateText(xPath +sLogFile);

             if (status.ToLower().Contains("sp_mm"))
             {
                 oWrite.WriteLine(strError);
             }
             else {
                 oWrite.WriteLine(DateTime.Now.ToString() + "   " + strError);
             }
             // oWrite.WriteLine(DateTime.Now.ToString() + "   " + strError);
             oWrite.Close();
         }
         catch (Exception ex)
         {
             Console.WriteLine("Unable to create error log");
             Console.WriteLine(ex.ToString());
             return;
         }
     }
     private void strStringToImage(string strString, string strFileName)
     {
         // convert String to Image and save
         System.Drawing.Image image;
         byte[] byteArray;
         byteArray = System.Convert.FromBase64String(strString);
         MemoryStream imgStream = new MemoryStream(byteArray);
         image =  System.Drawing.Image.FromStream(imgStream);
         System.Drawing.Image image1;
         image1 = image;
         image1.Save(strFileName + ".jpg");
     }
     public void CallAPIRegXML()
     {
         try
         {
             //check before
             Context.Response.ContentType = "text/xml";
             // string strXmlData = Context.Request["strXmlData"];
             //StreamReader xmlStream = new StreamReader(strXmlData);
             StreamReader xmlStream = new StreamReader(Context.Request.InputStream);
             string xmlData = xmlStream.ReadToEnd();

             StringReader xml = new StringReader(xmlData);
             GetResponseFromAPIMM(xml);
         }
         catch (Exception e) {
             Context.Response.Write("Error SetRegXML:  " + e.Message);
         }
     }
     public void GetResponseFromAPIMM(StringReader strXmlData) {

         try {
             Context.Response.ContentType = "text/xml";
             //string strXmlData = Context.Request["strXmlData"];
             //StreamReader xmlStream = new StreamReader(strXmlData);

             //StreamReader xmlStream = new StreamReader(Context.Request.InputStream);
             //string xmlData = xmlStream.ReadToEnd();

             //StringReader xml = new StringReader(xmlData);
             XmlReader reader;
             reader = XmlReader.Create(strXmlData);
             string _TYPE = "";
             string _PROVIDER = "";
             string _FNAME = "";

             while (reader.Read())
             {
                 switch (reader.NodeType)
                 {
                     case XmlNodeType.Element: //Display the text in each element.
                         if (reader.Name.Equals("FNAME"))
                         {
                             reader.Read();
                             _FNAME = reader.Value;
                         }
                         if (reader.Name.Equals("PROVIDER"))
                         {
                             reader.Read();
                             _PROVIDER = reader.Value;
                         }

                         if (reader.Name.Equals("TYPE"))
                         {
                             reader.Read();
                             _TYPE = reader.Value;
                         }

                         break;
                 }
             }


             Context.Response.Clear();
             Context.Response.ContentType = "text/xml";
             Context.Response.ContentEncoding = Encoding.UTF8;

             string xmlDataResponse = "<?xml version=\"1.0\" ?> " +
                    "<COMMAND>" +
                      " <TYPE>" + _TYPE + "</TYPE>" +
                      "<TXNID>SS110722.1646.C00001</TXNID>" +
                      "<TXNSTATUS>200</TXNSTATUS> " +
                     " <MESSAGE>Registration of Account Number 7702078009 is successful.</MESSAGE> " +
                     " <TRID>" + _FNAME + "</TRID> " +
                  " </COMMAND>";

             Context.Response.Write(xmlDataResponse);

         }
         catch (Exception ex)
         {
             //sWriteErrorLog1(ex.ToString)
             Context.Response.Clear();
             Context.Response.ContentType = "text/xml";
             Context.Response.ContentEncoding = Encoding.UTF8;
             string  xmlData = @"<?xml version=""1.0""?> 
                <COMMAND><MESSAGE>failed : "+ ex.Message + "</MESSAGE><TRID> Transfer ID </TRID> </COMMAND>";
             Context.Response.Write(xmlData);
         }
     }
     public class clsMSSQLOledb {
         private string strLogin;
         private string strPassword;
         private string strServer;
         private string strDatabase;
         public string strError;
         private OleDbConnection cnConn;
         private OleDbTransaction trTrans;

         private string StrConnect(string strLogin,string strPassword,string strServer,string strDatabase)
         {
             string  StrConnect = "Provider=SQLoLeDB.1;Persist Security info=False;Data Source=" + strServer
                  + ";User ID=" + strLogin
                  + ";Password=" + strPassword
                  + ";InitiaL Catalog=" + strDatabase;
             return StrConnect;
         }
         public Boolean OpenConn()
         {

             cnConn = null;
             cnConn = new OleDbConnection(StrConnect("sa", "@fricell2014", "10.100.11.10", "afr_sl_registration"));
             strError = "";
             Boolean blnTestConn = false;
             try
             {

                 if (cnConn.State != ConnectionState.Open) {
                     cnConn.Open();
                     //blnTestConn = true;
                 }
                 blnTestConn = true;
                 return blnTestConn;
             }
             catch (Exception ex)
             {
                 strError = ex.Message;
                 return blnTestConn;
             }


         }
         public void sCloseConn()
         {
             strError = "";
             try
             {
                 if (cnConn.State == ConnectionState.Open)
                 {
                     cnConn.Close();
                     cnConn = null;
                 }
                 else
                     cnConn = null;
             }
             catch (Exception ex)
             {
                 strError = ex.Message;
             }
         }
         public int lngExecuteNoQuery(string strSql, bool blnIsSp)
         {
             OleDbCommand cmComm;
             strError = "";
             int lngExecuteNoQuery = 0;
             try
             {
                 if (OpenConn())
                 {

                     cmComm = new OleDbCommand(strSql, cnConn);
                     cmComm.CommandTimeout = 0;

                     if (blnIsSp == true)
                     {
                         cmComm.CommandType = CommandType.StoredProcedure;
                     }
                     else
                     {
                         cmComm.CommandType = CommandType.Text;
                     }

                     lngExecuteNoQuery = cmComm.ExecuteNonQuery();
                     cmComm.Dispose();
                     cmComm = null;
                     cnConn.Close();
                     sCloseConn();
                     return lngExecuteNoQuery;
                 }
                 else {
                     return 0;
                 }
             }
             catch (Exception ex)
             {
                 strError = ex.Message;
                 return lngExecuteNoQuery;
             }
         }




     }
</script>
 
