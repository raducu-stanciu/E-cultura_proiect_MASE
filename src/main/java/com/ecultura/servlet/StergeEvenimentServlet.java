package com.ecultura.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Importul pentru clasa ta de conexiune (asigură-te că pachetul e corect)
import com.ecultura.dao.DBConnection;

@WebServlet("/StergeEvenimentServlet")
public class StergeEvenimentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            int id = Integer.parseInt(idParam);

            try (Connection con = DBConnection.getConnection()) {
                // SQL: Ștergem evenimentul după ID
                // NOTĂ: Dacă ai eroare de Foreign Key, înseamnă că evenimentul are rezervări active.
                PreparedStatement ps = con.prepareStatement("DELETE FROM evenimente WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                
                // Ne întoarcem la admin.jsp să vedem lista actualizată
                response.sendRedirect("admin.jsp");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("text/html");
                response.getWriter().println("<h3>Eroare la ștergere!</h3>");
                response.getWriter().println("<p>Nu poți șterge un eveniment care are deja rezervări făcute.</p>");
                response.getWriter().println("<a href='admin.jsp'>Înapoi la Admin</a>");
            }
        }
    }
}