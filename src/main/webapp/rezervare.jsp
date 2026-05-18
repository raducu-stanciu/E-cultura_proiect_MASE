<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.ecultura.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>E-Cultura | Rezervare Bilete</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f7f6; padding: 40px; }
        .box { background: white; max-width: 500px; margin: auto; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .info { margin: 20px 0; color: #555; }
        .pret { font-size: 1.2em; color: #27ae60; font-weight: bold; }
        .input-group { margin: 20px 0; }
        input[type="number"] { width: 60px; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn-submit { background: #e74c3c; color: white; border: none; padding: 12px 20px; width: 100%; border-radius: 6px; cursor: pointer; font-size: 1em; font-weight: bold; }
        .btn-submit:hover { background: #c0392b; }
    </style>
</head>
<body>

<div class="box">
    <%
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement("SELECT * FROM evenimente WHERE id = ?");
                ps.setInt(1, Integer.parseInt(idParam));
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2><%= rs.getString("titlu") %></h2>
                    <div class="info">
                        <p>📍 Locație: <strong><%= rs.getString("locatie") %></strong></p>
                        <p>📅 Data: <%= rs.getTimestamp("data_eveniment") %></p>
                        <p>🪑 Locuri disponibile: <strong><%= rs.getInt("locuri_disponibile") %></strong></p>
                        <p class="pret">Preț: <%= rs.getDouble("pret") %> RON / bilet</p>
                    </div>

<form action="ProceseazaRezervare" method="post">
    <input type="hidden" name="idEveniment" value="<%= rs.getInt("id") %>">
    
    <div class="input-group">
        <label><strong>Selectați locul dorit:</strong></label><br><br>
        Rând: <input type="number" name="rand" min="1" max="20" required style="width:50px; margin-right:10px;">
        Loc: <input type="number" name="loc" min="1" max="50" required style="width:50px;">
    </div>

    <button type="submit" class="btn-submit">Confirmă și Rezervă Locul</button>
</form>
    <%
                } else {
                    out.println("<p>Evenimentul nu a fost găsit.</p>");
                }
            } catch (Exception e) {
                out.println("Eroare: " + e.getMessage());
            }
        } else {
            out.println("<p>ID eveniment lipsă.</p>");
        }
    %>
    <br>
    <a href="evenimente.jsp" style="color: #7f8c8d; text-decoration: none; font-size: 0.9em;">← Înapoi la listă</a>
</div>

</body>
</html>