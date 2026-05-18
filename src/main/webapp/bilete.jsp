<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.ecultura.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head><title>Biletele Mele</title></head>
<body style="font-family: sans-serif; padding: 20px;">
    <h2>Istoric Rezervări</h2>
    <table border="1" cellpadding="10" style="width:100%; border-collapse: collapse;">
        <tr style="background: #eee;">
            <th>Eveniment</th>
            <th>Rând</th>
            <th>Loc</th>
            <th>Acțiuni</th>
        </tr>
        <%
            int uID = (int)session.getAttribute("userID");
            try (Connection con = DBConnection.getConnection()) {
                String sql = "SELECT r.id, e.titlu, r.rand, r.loc FROM rezervari r " +
                             "JOIN evenimente e ON r.id_eveniment = e.id WHERE r.id_utilizator = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, uID);
                ResultSet rs = ps.executeQuery();
                while(rs.next()){
        %>
            <tr>
                <td><%= rs.getString("titlu") %></td>
                <td><%= rs.getInt("rand") %></td>
                <td><%= rs.getInt("loc") %></td>
                <td>
                    <a href="AnuleazaBiletServlet?id=<%= rs.getInt("id") %>" onclick="return confirm('Renunți la bilet?')">Renunță</a>
                    | 
                    <a href="modifica_loc.jsp?id=<%= rs.getInt("id") %>">Schimbă Locul</a>
                </td>
            </tr>
        <% } } catch(Exception e) { out.print(e.getMessage()); } %>
    </table>
    <br><a href="evenimente.jsp">Înapoi la evenimente</a>
</body>
</html>