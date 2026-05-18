<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.ecultura.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Evenimente Culturale</title>
    <style>
        body { font-family: sans-serif; padding: 0; margin: 0; background: #f9f9f9; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: white; text-decoration: none; margin-left: 10px; }
        .container { padding: 20px; }
        .card { background: white; border: 1px solid #ddd; padding: 15px; margin-bottom: 10px; border-radius: 8px; box-shadow: 2px 2px 5px rgba(0,0,0,0.1); }
        .pret { color: #27ae60; font-weight: bold; }
        .btn { background: #2c3e50; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>

<div class="navbar">
    <div style="font-size: 1.5em; font-weight: bold;">E-Culture</div>
    <div>
        <%
            String numeUtilizator = (String) session.getAttribute("userName");
            String tipUtilizator = (String) session.getAttribute("userType");
            
            if (numeUtilizator != null) {
        %>
            Salut, <strong><%= numeUtilizator %></strong>! 
            
            <a href="bilete.jsp" style="background: #3498db; color: white; padding: 8px 15px; border-radius: 4px; text-decoration: none; margin-left: 15px; font-weight: bold;">
               🎫 Biletele Mele
            </a>

            <% if ("admin".equals(tipUtilizator)) { %>
                <a href="admin.jsp" style="background: #e74c3c; padding: 8px 15px; border-radius: 4px; margin-left: 10px; text-decoration: none; font-weight: bold;">
                   ⚙️ ADMIN
                </a>
            <% } %>

            <a href="logout.jsp" style="color: #bdc3c7; margin-left: 15px;">[ Ieșire ]</a>
        <% } else { %>
            <a href="login.jsp">Autentificare</a>
        <% } %>
    </div>
</div>

    <div class="container">
        <h1>Spectacole Disponibile</h1>
        <%
            try (Connection con = DBConnection.getConnection()) {
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM evenimente");
                while (rs.next()) {
        %>
                    <div class="card">
                        <h3><%= rs.getString("titlu") %></h3>
                        <p><%= rs.getString("descriere") %></p>
                        <p>Locație: <strong><%= rs.getString("locatie") %></strong> | Data: <%= rs.getTimestamp("data_eveniment") %></p>
                        <p class="pret">Preț: <%= rs.getDouble("pret") %> RON</p>
                        <a href="rezervare.jsp?id=<%= rs.getInt("id") %>" class="btn">Rezervă Locuri</a>
                    </div>
        <%
                }
            } catch (Exception e) {
                out.println("Eroare la încărcarea evenimentelor: " + e.getMessage());
            }
        %>       
   <hr>
<div style="background: #fff; padding: 20px; border-radius: 8px; border: 1px solid #ddd; margin-top: 30px;">
    <h3>Setări Profil</h3>
    <%
        // Luăm starea actuală din bază ca să știm ce să afișăm în buton
        int statusNewsletter = 0;
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT newsletter FROM utilizatori WHERE id = ?");
            ps.setInt(1, (int)session.getAttribute("userID"));
            ResultSet rsStatus = ps.executeQuery();
            if(rsStatus.next()) statusNewsletter = rsStatus.getInt("newsletter");
        } catch(Exception e) {}
    %>   
    <p>Status Newsletter: 
        <strong><%= (statusNewsletter == 1) ? "Abonat ✅" : "Dezabonat ❌" %></strong>
    </p>

    <form action="UpdateNewsletterServlet" method="post">
        <input type="hidden" name="noulStatus" value="<%= (statusNewsletter == 1) ? 0 : 1 %>">
        <button type="submit" style="background: #34495e; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer;">
            <%= (statusNewsletter == 1) ? "Dezactivează Newsletter" : "Abonează-te la Newsletter" %>
        </button>
    </form>
</div>             
    </div>
</body>
</html>