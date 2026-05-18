<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Invalidăm sesiunea (ștergem toate datele salvate: userID, userType etc.)
    session.invalidate();

    // 2. Redirecționăm utilizatorul către pagina de login
    response.sendRedirect("login.jsp");
%>