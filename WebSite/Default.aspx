<%@ Page Language="C#"%>
<%
    Response.RedirectLocation = "http://localhost/BlackBoxDev/imports.aspx";
    Response.StatusCode = 307;   //   301 = Moved Permanently   |   302 = Object moved   |   307 = Temporary redirect
%>