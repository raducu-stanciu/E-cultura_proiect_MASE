<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login | E-Cultura</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #2c3e50; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 10px 20px rgba(0,0,0,0.2); width: 300px; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #e74c3c; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .footer-links { text-align: center; margin-top: 15px; font-size: 0.9em; }
        .success-msg { color: green; font-size: 0.8em; text-align: center; font-weight: bold; }
        .error-msg { color: red; font-size: 0.8em; text-align: center; font-weight: bold; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2 style="text-align: center; color: #2c3e50;">E-Cultura</h2>
        
        <form action="LoginServlet" method="post">
            <input type="email" name="email" placeholder="Email (ex: radu@test.com)" required>
            <input type="password" name="parola" placeholder="Parolă" required>
            <button type="submit">Autentificare</button>
        </form>

        <div class="footer-links">
            Nu ai cont? <a href="register.jsp" style="color: #e74c3c; text-decoration: none; font-weight: bold;">Creează cont nou</a>
        </div>

        <hr style="border: 0; border-top: 1px solid #eee; margin: 15px 0;">

        <% if(request.getParameter("error") != null) { %>
            <p class="error-msg">Email sau parolă greșită!</p>
        <% } %>

        <% if(request.getParameter("success") != null) { %>
            <p class="success-msg">Cont creat cu succes! Te poți loga.</p>
        <% } %>
    </div>
</body>
</html>