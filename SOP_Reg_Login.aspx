<%@ Page Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim strSql As String
        Try
            
            'http://87.238.116.200/SOP_Reg_login.aspx?login=&password=&IMEI=&ICC=&IP=&location=
            
            Dim _ll_login, _ll_password, _ll_IMEI, _ll_ICC, _ll_IP, ll_location As String
            Dim _status_id, _status_description, _new_registration, _daiyStats As String
            Dim _us_registration_query, _us_user_registration_stats, _us_offline_registration, _us_synchronize_registration, _us_sim_creation, _us_sim_change As String
            Dim _us_APP_Version_Code, _us_is_table_agent, _us_table_agent_SIMs As String
            Dim lngCount As Long
            If Request.QueryString("login") IsNot Nothing Then
                _ll_login = Request.QueryString("login").ToString
            Else
                _ll_login = ""
            End If
            If Request.QueryString("password") IsNot Nothing Then
                _ll_password = Request.QueryString("password").ToString
            Else
                _ll_password = ""
            End If
            If Request.QueryString("IMEI") IsNot Nothing Then
                _ll_IMEI = Request.QueryString("IMEI").ToString
            Else
                _ll_IMEI = ""
            End If
            If Request.QueryString("ICC") IsNot Nothing Then
                _ll_ICC = Request.QueryString("ICC").ToString
            Else
                _ll_ICC = ""
            End If
            If Request.QueryString("IP") IsNot Nothing Then
                _ll_IP = Request.QueryString("IP").ToString
            Else
                _ll_IP = ""
            End If
            If Request.QueryString("location") IsNot Nothing Then
                ll_location = Request.QueryString("location").ToString
            Else
                ll_location = ""
            End If
            
            strSql = "afr_sl_registration.dbo.usp_user_login " & _
                    " '" & _ll_login.Trim & "' " & _
                    " ,'" & _ll_password.Trim & "' " & _
                    " ,'" & _ll_IMEI.Trim & "' " & _
                    " ,'" & _ll_ICC.Trim & "' " & _
                    " ,'" & _ll_IP.Trim & "' " & _
                    " ,'" & ll_location.Trim & "' "
            lngCount = 0
            Dim dsetLogin As Data.DataSet
            Dim cnLogin As New clsMSSQLOledb("sa", "@fricell2014", "10.100.11.10", "afr_sl_registration")
            If cnLogin.blnOpenConn = True Then
                dsetLogin = cnLogin.dSetOpenDataSet(strSql, "LoginCheck")
                lngCount = dsetLogin.Tables("LoginCheck").Rows.Count
                If lngCount > 0 Then
                    _status_id = dsetLogin.Tables("LoginCheck").Rows(0).Item("ll_status") & ""
                    _status_description = dsetLogin.Tables("LoginCheck").Rows(0).Item("ll_status_description") & ""
                    _new_registration = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_new_registration") & ""
                    _daiyStats = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_daily_stats") & ""
                    _us_registration_query = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_registration_query") & ""
                    _us_user_registration_stats = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_user_registration_stats") & ""
                    _us_offline_registration = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_offline_registration") & ""
                    _us_synchronize_registration = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_synchronize_registration") & ""
                    _us_sim_creation = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_sim_creation") & ""
                    _us_sim_change = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_sim_change") & ""
                    _us_APP_Version_Code = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_APP_Version_Code") & ""
                    _us_is_table_agent = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_is_table_agent") & ""
                    _us_table_agent_SIMs = dsetLogin.Tables("LoginCheck").Rows(0).Item("us_table_agent_SIMs") & ""
                    
                    Response.Clear()
                    Response.ContentType = "text/xml"
                    Response.ContentEncoding = Encoding.UTF8
                    Response.Write("<Login>")
                    Response.Write("<Error> </Error>")
                    Response.Write("<StatusId>" & _status_id.Trim & "</StatusId>")
                    Response.Write("<StatusDescription>" & _status_description.Trim & "</StatusDescription>")
                    Response.Write("<new_registration>" & _new_registration.Trim & "</new_registration>")
                    Response.Write("<daiyStats>" & _daiyStats.Trim & "</daiyStats>")
                    Response.Write("<us_registration_query>" & _us_registration_query.Trim & "</us_registration_query>")
                    Response.Write("<us_user_registration_stats>" & _us_user_registration_stats.Trim & "</us_user_registration_stats>")
                    Response.Write("<us_offline_registration>" & _us_offline_registration.Trim & "</us_offline_registration>")
                    Response.Write("<us_synchronize_registration>" & _us_synchronize_registration.Trim & "</us_synchronize_registration>")
                    Response.Write("<us_sim_creation>" & _us_sim_creation.Trim & "</us_sim_creation>")
                    Response.Write("<us_sim_change>" & _us_sim_change.Trim & "</us_sim_change>")
                    Response.Write("<us_APP_Version_Code>" & _us_APP_Version_Code.Trim & "</us_APP_Version_Code>")
                    Response.Write("<us_is_table_agent>" & _us_is_table_agent.Trim & "</us_is_table_agent>")
                    Response.Write("<us_table_agent_SIMs>" & _us_table_agent_SIMs.Trim & "</us_table_agent_SIMs>")
                    Response.Write("</Login>")
                    dsetLogin = Nothing
                    cnLogin.sCloseConn()
                Else
                    GoTo ConnectionError
                End If
            Else
ConnectionError:
                Response.Clear()
                Response.ContentType = "text/xml"
                Response.ContentEncoding = Encoding.UTF8
                Response.Write("<Login>")
                Response.Write("<Error>Unable to connect to database server.</Error>")
                Response.Write("<StatusId> </StatusId>")
                Response.Write("<StatusDescription> </StatusDescription>")
                Response.Write("<new_registration> </new_registration>")
                Response.Write("<daiyStats> </daiyStats>")
                Response.Write("<us_registration_query> </us_registration_query>")
                Response.Write("<us_user_registration_stats> </us_user_registration_stats>")
                Response.Write("<us_offline_registration> </us_offline_registration>")
                Response.Write("<us_synchronize_registration> </us_synchronize_registration>")
                Response.Write("<us_sim_creation> </us_sim_creation>")
                Response.Write("<us_sim_change> </us_sim_change>")
                Response.Write("<us_APP_Version_Code> </us_APP_Version_Code>")
                Response.Write("<us_is_table_agent> </us_is_table_agent>")
                Response.Write("<us_table_agent_SIMs> </us_table_agent_SIMs>")
                Response.Write("</Login>")
            End If
        Catch ex As Exception
            Response.Clear()
            Response.ContentType = "text/xml"
            Response.ContentEncoding = Encoding.UTF8
            Response.Write("<Login>")
            Response.Write("<Error>" & ex.ToString & "</Error>")
            Response.Write("<StatusId> </StatusId>")
            Response.Write("<StatusDescription> </StatusDescription>")
            Response.Write("<new_registration> </new_registration>")
            Response.Write("<daiyStats> </daiyStats>")
            Response.Write("<us_registration_query> </us_registration_query>")
            Response.Write("<us_user_registration_stats> </us_user_registration_stats>")
            Response.Write("<us_offline_registration> </us_offline_registration>")
            Response.Write("<us_synchronize_registration> </us_synchronize_registration>")
            Response.Write("<us_sim_creation> </us_sim_creation>")
            Response.Write("<us_sim_change> </us_sim_change>")
            Response.Write("<us_APP_Version_Code> </us_APP_Version_Code>")
            Response.Write("<us_is_table_agent> </us_is_table_agent>")
            Response.Write("<us_table_agent_SIMs> </us_table_agent_SIMs>")
            Response.Write("</Login>")
        End Try
    End Sub
</script>

