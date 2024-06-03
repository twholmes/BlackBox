<%@ Page Language="C#"%>
<%
    Response.RedirectLocation = "http://localhost/BlackBoxDev/home/default.aspx";
    Response.StatusCode = 301;   //   301 = Moved Permanently   |   302 = Object moved   |   307 = Temporary redirect
%>