<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.ecultura.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Conexiune E-Cultura</title>
</head>
<body>
    <h1>Verificare stare bază de date</h1>
    <%
        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                out.println("<h2 style='color:green'>Succes! Eclipse s-a conectat la MySQL.</h2>");
                con.close();
            } else {
                out.println("<h2 style='color:red'>Eroare! Conexiunea este null. Verifică parola în DBConnection.java.</h2>");
            }
        } catch (Exception e) {
            out.println("<h2 style='color:red'>Eroare critică: " + e.getMessage() + "</h2>");
        }
    %>
</body>
</html>