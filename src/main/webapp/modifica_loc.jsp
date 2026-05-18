<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.ecultura.dao.DBConnection" %>
<%
    Integer uID = (Integer) session.getAttribute("userID");
    if (uID == null) { response.sendRedirect("login.jsp"); return; }

    String idRez = request.getParameter("id");
    
    // Dacă formularul a fost trimis (metoda POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int noulRand = Integer.parseInt(request.getParameter("rand"));
        int noulLoc = Integer.parseInt(request.getParameter("loc"));
        int idR = Integer.parseInt(request.getParameter("id_rezervare"));

        try (Connection con = DBConnection.getConnection()) {
            // Verificăm dacă noul loc e liber
            PreparedStatement psCheck = con.prepareStatement("SELECT id FROM rezervari WHERE rand=? AND loc=? AND id_eveniment=(SELECT id_eveniment FROM rezervari WHERE id=?)");
            psCheck.setInt(1, noulRand);
            psCheck.setInt(2, noulLoc);
            psCheck.setInt(3, idR);
            if (psCheck.executeQuery().next()) {
                out.println("<script>alert('Locul e deja ocupat!'); window.history.back();</script>");
            } else {
                PreparedStatement psUpd = con.prepareStatement("UPDATE rezervari SET rand=?, loc=? WHERE id=? AND id_utilizator=?");
                psUpd.setInt(1, noulRand);
                psUpd.setInt(2, noulLoc);
                psUpd.setInt(3, idR);
                psUpd.setInt(4, uID);
                psUpd.executeUpdate();
                response.sendRedirect("bilete.jsp");
            }
        } catch(Exception e) { out.print(e.getMessage()); }
    }
%>
<!DOCTYPE html>
<html>
<head><title>Schimbă Locul</title></head>
<body style="font-family: sans-serif; padding: 40px; text-align: center;">
    <div style="background: white; display: inline-block; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
        <h2>Alege un alt loc</h2>
        <form method="post">
            <input type="hidden" name="id_rezervare" value="<%= idRez %>">
            Rând nou: <input type="number" name="rand" required style="width: 50px;">
            Loc nou: <input type="number" name="loc" required style="width: 50px;">
            <br><br>
            <button type="submit" style="background: #2980b9; color: white; padding: 10px; border: none; cursor: pointer;">Actualizează Locul</button>
        </form>
        <br><a href="bilete.jsp">Anulează</a>
    </div>
</body>
</html>