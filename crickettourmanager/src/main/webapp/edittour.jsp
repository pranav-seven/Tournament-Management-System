<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        if(session.getAttribute("username")==null)
            response.sendRedirect("login.jsp"); %>
    <title>Tournament Manager</title>
    <link rel="stylesheet" href="body.css">
</head>
<body>
<h1 style="color: #fff;">Yet to be implemented</h1>
</body>
</html>