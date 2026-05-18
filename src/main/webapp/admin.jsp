<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.ecultura.dao.DBConnection" %>
<%
    // SECURITATE: Verificăm dacă user-ul este logat ȘI dacă este admin
    String tip = (String) session.getAttribute("userType");
    if (tip == null || !tip.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Panel Admin | E-Culture</title>
    <style>
        body { font-family: sans-serif; background: #f4f4f4; margin: 0; }
        .header { background: #c0392b; color: white; padding: 20px; text-align: center; }
        .container { padding: 20px; max-width: 1000px; margin: auto; }
        table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background: #2c3e50; color: white; }
        tr:nth-child(even) { background: #f2f2f2; }
        .badge { background: #27ae60; color: white; padding: 5px 10px; border-radius: 4px; font-size: 0.8em; }
    </style>
</head>
<body>

<div class="header">
    <h1>Panou Administrare E-Culture</h1>
    <p>Salut, <%= session.getAttribute("userName") %> | <a href="evenimente.jsp" style="color:white;">Vezi Site</a> | 
    <a href="logout.jsp" style="color:white;">Ieșire</a></p>
</div>

<div class="container">

<div style="background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; border: 1px solid #ddd;">
    <h3>Adaugă un eveniment nou</h3>
    <form action="AdaugaEvenimentServlet" method="post" style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px;">
        <input type="text" name="titlu" placeholder="Titlu Spectacol" required style="padding: 8px;">
        <input type="text" name="locatie" placeholder="Locație" required style="padding: 8px;">
        <input type="datetime-local" name="data" required style="padding: 8px;">
        <input type="number" name="pret" placeholder="Preț (RON)" step="0.01" required style="padding: 8px;">
        <input type="number" name="locuri" placeholder="Nr. Locuri" required style="padding: 8px;">
        <textarea name="descriere" placeholder="Descriere" style="grid-column: span 3; padding: 8px;"></textarea>
        <button type="submit" style="grid-column: span 3; background: #27ae60; color: white; padding: 10px; border: none; cursor: pointer;
         font-weight: bold;">
            Salvează Evenimentul pe Site
        </button>
    </form>
</div>
 <div class="container">
    <h2>Gestiune Evenimente (Modifică / Șterge)</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Titlu</th>
                <th>Locație</th>
                <th>Preț</th>
                <th>Locuri</th>
                <th>Acțiuni</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection con = DBConnection.getConnection()) {
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM evenimente ORDER BY id DESC");
                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><strong><%= rs.getString("titlu") %></strong></td>
                    <td><%= rs.getString("locatie") %></td>
                    <td><%= rs.getDouble("pret") %> RON</td>
                    <td><%= rs.getInt("locuri_disponibile") %></td>
                    <td>
                        <a href="StergeEvenimentServlet?id=<%= rs.getInt("id") %>" 
                           onclick="return confirm('Sigur vrei să ștergi acest eveniment?')" 
                           style="color: #c0392b; text-decoration: none; font-weight: bold;">[ Șterge ]</a>
                        
                        <a href="edit_eveniment.jsp?id=<%= rs.getInt("id") %>" 
                           style="color: #2980b9; text-decoration: none; font-weight: bold; margin-left: 10px;">[ Editează ]</a>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) { out.println(e.getMessage()); }
            %>
        </tbody>
    </table>
</div>
 


    <h2>Toate Rezervările Efectuate</h2>
    
    
    <table>
        <thead>
            <tr>
                <th>ID Rezervare</th>
                <th>Client</th>
                <th>Email</th>
                <th>Spectacol</th>
                <th>Bilete</th>
                <th>Data Rezervării</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection con = DBConnection.getConnection()) {
                    // SQL JOIN: Combinăm 3 tabele pentru a vedea numele omului și numele spectacolului
                    String sql = "SELECT r.id, u.nume, u.email, e.titlu, r.cantitate, r.data_rezervarii " +
                                 "FROM rezervari r " +
                                 "JOIN utilizatori u ON r.id_utilizator = u.id " +
                                 "JOIN evenimente e ON r.id_eveniment = e.id " +
                                 "ORDER BY r.data_rezervarii DESC";
                    
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    while (rs.next()) {
            %>
                <tr>
                    <td>#<%= rs.getInt("id") %></td>
                    <td><strong><%= rs.getString("nume") %></strong></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("titlu") %></td>
                    <td><span class="badge"><%= rs.getInt("cantitate") %> buc.</span></td>
                    <td><%= rs.getTimestamp("data_rezervarii") %></td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("Eroare: " + e.getMessage());
                }
            %>
        </tbody>
    </table>
<div class="container" style="margin-top: 50px;">
    <h2>Gestionare Clienți și Newsletter</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nume Client</th>
                <th>Email</th>
                <th>Status Newsletter</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection con = DBConnection.getConnection()) {
                    // Am eliminat data_creare din SELECT
                    String sqlUsers = "SELECT id, nume, email, newsletter FROM utilizatori WHERE tip_utilizator = 'client' ORDER BY nume ASC";
                    Statement stmtUser = con.createStatement();
                    ResultSet rsUser = stmtUser.executeQuery(sqlUsers);
                    
                    while (rsUser.next()) {
                        int isAbonat = rsUser.getInt("newsletter");
            %>
                <tr>
                    <td>#<%= rsUser.getInt("id") %></td>
                    <td><strong><%= rsUser.getString("nume") %></strong></td>
                    <td><%= rsUser.getString("email") %></td>
                    <td>
                        <% if (isAbonat == 1) { %>
                            <span style="color: #27ae60; font-weight: bold;">✅ Abonat</span>
                        <% } else { %>
                            <span style="color: #95a5a6;">❌ Nealocat</span>
                        <% } %>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("Eroare la încărcarea clienților: " + e.getMessage());
                }
            %>
        </tbody>
    </table>
</div>  
</div>

</body>
</html>