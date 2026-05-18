<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.ecultura.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head><title>Editează Eveniment</title></head>
<body style="font-family: sans-serif; padding: 50px; background: #eee;">
    <div style="background: white; padding: 30px; max-width: 500px; margin: auto; border-radius: 10px;">
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM evenimente WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
    %>
        <h2>Modifică Spectacolul #<%= id %></h2>
        <form action="UpdateEvenimentServlet" method="post">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
            Titlu: <input type="text" name="titlu" value="<%= rs.getString("titlu") %>" style="width:100%; margin-bottom:10px;"><br>
            Locație: <input type="text" name="locatie" value="<%= rs.getString("locatie") %>" style="width:100%; margin-bottom:10px;"><br>
            Preț: <input type="number" name="pret" value="<%= rs.getDouble("pret") %>" step="0.01" style="width:100%; margin-bottom:10px;"><br>
            Locuri: <input type="number" name="locuri" value="<%= rs.getInt("locuri_disponibile") %>" style="width:100%; margin-bottom:10px;"><br>
            <button type="submit" style="background: #2980b9; color: white; padding: 10px; width: 100%; border: none;">Salvează Modificările</button>
        </form>
    <%
            }
        } catch(Exception e) { out.print(e.getMessage()); }
    %>
    </div>
</body>
</html>