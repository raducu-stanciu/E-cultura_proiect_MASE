package com.ecultura.servlet; // PACHETUL TĂU

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// IMPORTUL PENTRU CONEXIUNEA TA
import com.ecultura.dao.DBConnection;

@WebServlet("/UpdateEvenimentServlet")
public class UpdateEvenimentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Setăm UTF-8 pentru a nu avea probleme cu diacriticele la editare
        request.setCharacterEncoding("UTF-8");

        try {
            // Preluăm datele din formularul de editare (edit_eveniment.jsp)
            int id = Integer.parseInt(request.getParameter("id"));
            String titlu = request.getParameter("titlu");
            String locatie = request.getParameter("locatie");
            double pret = Double.parseDouble(request.getParameter("pret"));
            int locuri = Integer.parseInt(request.getParameter("locuri"));

            try (Connection con = DBConnection.getConnection()) {
                // SQL UPDATE: Modificăm rândul existent în funcție de ID
                String sql = "UPDATE evenimente SET titlu=?, locatie=?, pret=?, locuri_disponibile=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                
                ps.setString(1, titlu);
                ps.setString(2, locatie);
                ps.setDouble(3, pret);
                ps.setInt(4, locuri);
                ps.setInt(5, id);
                
                ps.executeUpdate();
                
                // După salvare, ne întoarcem la panoul de admin
                response.sendRedirect("admin.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Eroare la actualizare: " + e.getMessage());
        }
    }
}