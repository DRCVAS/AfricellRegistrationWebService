Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.Odbc

Public Class clSybaseODBC
    Private strLogin As String
    Private strPassword As String
    Private strDSN As String
    Private strDatabase As String
    Public strError As String
    Private cnConn As OdbcConnection
    Private trTrans As OdbcTransaction

    Public Sub New(ByVal Login As String, ByVal Password As String, ByVal DSN As String, ByVal Database As String)
        strLogin = Login
        strPassword = Password
        strDSN = DSN
        strDatabase = Database
    End Sub

    Private Function StrConnect() As String
        StrConnect = "DSN=" & strDSN & _
                    ";UID=" & strLogin & _
                    ";PWD=" & strPassword & _
                    ";DatabaseName=" & strDatabase & _
                    ";AutoStop=No;Integrated=No;"
    End Function

    Public Function blnTestConn() As Boolean
        cnConn = New OdbcConnection(StrConnect)
        strError = ""
        blnTestConn = False
        Try
            cnConn.Open()
            blnTestConn = True
        Catch ex As Exception
            strError = ex.Message
        Finally
            If cnConn.State = ConnectionState.Open Then
                cnConn.Close()
                cnConn = Nothing
            Else
                cnConn = Nothing
            End If
        End Try
    End Function

    Public Function blnOpenConn() As Boolean
        cnConn = New OdbcConnection(StrConnect)
        strError = ""
        Try
            cnConn.Open()
            blnOpenConn = True
        Catch ex As Exception
            blnOpenConn = False
            strError = ex.Message
        End Try
    End Function

    Public Sub sCloseConn()
        strError = ""
        Try
            If cnConn.State = ConnectionState.Open Then
                cnConn.Close()
                cnConn = Nothing
            Else
                cnConn = Nothing
            End If
        Catch ex As Exception
            strError = ex.Message
        End Try
    End Sub

    Public Function dSetOpenDataSet(ByVal strSelect As String, ByVal strRecSetName As String) As DataSet
        Dim dAdapter As OdbcDataAdapter
        strError = ""
        dSetOpenDataSet = Nothing
        Try
            dAdapter = New OdbcDataAdapter(strSelect, cnConn)
            dSetOpenDataSet = New DataSet
            dAdapter.SelectCommand.CommandTimeout = 600
            dAdapter.Fill(dSetOpenDataSet, strRecSetName)
            dAdapter.Dispose()
            dAdapter = Nothing
        Catch ex As Exception
            strError = ex.Message
        End Try
    End Function

    Public Function blnAddTableToDataSet(ByVal strSelect As String, ByVal dSet As DataSet, ByVal strRecSetName As String) As Boolean
        Dim dAdapter As OdbcDataAdapter
        strError = ""
        blnAddTableToDataSet = False
        Try
            dAdapter = New OdbcDataAdapter(strSelect, cnConn)
            dAdapter.Fill(dSet, strRecSetName)
            dAdapter.Dispose()
            dAdapter = Nothing
            dAdapter = Nothing
            blnAddTableToDataSet = True
        Catch ex As Exception
            strError = ex.Message
        End Try
    End Function

    Public Function lngExecuteNoQuery(ByVal strSql As String, ByVal blnIsSp As Boolean) As Long
        Dim cmComm As OdbcCommand
        strError = ""
        lngExecuteNoQuery = 0
        Try
            cmComm = New OdbcCommand(strSql, cnConn)
            cmComm.CommandTimeout = 0
            If Not trTrans Is Nothing Then
                cmComm.Transaction = trTrans
            End If
            If blnIsSp = True Then
                cmComm.CommandType = CommandType.StoredProcedure
            Else
                cmComm.CommandType = CommandType.Text
            End If
            lngExecuteNoQuery = cmComm.ExecuteNonQuery()
            cmComm.Dispose()
            cmComm = Nothing
        Catch ex As Exception
            strError = ex.Message
        End Try
    End Function

    Public Function strExecScalaire(ByVal strSql As String, ByVal blnIsSp As Boolean) As String
        Dim cmComm As OdbcCommand
        Dim retObject As Object
        strError = ""
        strExecScalaire = ""
        Try
            cmComm = New OdbcCommand(strSql, cnConn)
            cmComm.CommandTimeout = 0
            If blnIsSp = True Then
                cmComm.CommandType = CommandType.StoredProcedure
            Else
                cmComm.CommandType = CommandType.Text
            End If
            retObject = cmComm.ExecuteScalar()
            If retObject Is Nothing Then
                strExecScalaire = ""
            ElseIf retObject Is System.DBNull.Value Then
                strExecScalaire = ""
            Else
                strExecScalaire = retObject.ToString
            End If
            cmComm.Dispose()
            cmComm = Nothing
        Catch ex As Exception
            strError = ex.Message
        End Try
    End Function

    Public Sub BeginTransaction()
        trTrans = Nothing
        If Not cnConn.State = ConnectionState.Closed Then cnConn.Close()
        cnConn.Open()
        trTrans = cnConn.BeginTransaction
    End Sub

    Public Sub CommitTransaction()
        If Not trTrans Is Nothing Then
            trTrans.Commit()
            trTrans = Nothing
            sCloseConn()
        End If
    End Sub

    Public Sub RollbackTransaction()
        If Not trTrans Is Nothing Then
            trTrans.Rollback()
            trTrans = Nothing
            sCloseConn()
        End If
    End Sub
End Class
