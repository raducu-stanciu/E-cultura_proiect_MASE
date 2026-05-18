<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Înregistrare | E-Cultura</title>
    <style>
        body { font-family: sans-serif; background: #2c3e50; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 30px; border-radius: 10px; width: 300px; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #27ae60; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h2 style="text-align: center;">Cont Nou</h2>
        <form action="RegisterServlet" method="post">
            <input type="text" name="nume" placeholder="Nume Complet" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="parola" placeholder="Parolă" required>
            <button type="submit">Creează Cont</button>
        </form>
        <p style="text-align: center;"><a href="login.jsp">Ai deja cont? Loghează-te</a></p>
    </div>
</body>
</html>