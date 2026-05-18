package com.ecultura.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// IMPORTURILE CRUCIALE PE CARE TREBUIE SĂ LE AI:
import com.ecultura.dao.DBConnection;

@WebServlet("/AdaugaEvenimentServlet")
public class AdaugaEvenimentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Setăm codificarea pentru a nu avea probleme cu diacriticele
        request.setCharacterEncoding("UTF-8");
        
        try {
            String titlu = request.getParameter("titlu");
            String desc = request.getParameter("descriere");
            String loc = request.getParameter("locatie");
            double pret = Double.parseDouble(request.getParameter("pret"));
            int locuri = Integer.parseInt(request.getParameter("locuri"));
            
            // Conversie format dată din HTML (2026-03-28T19:30) în MySQL (2026-03-28 19:30:00)
            String dataStr = request.getParameter("data").replace("T", " ") + ":00";

            try (Connection con = DBConnection.getConnection()) {
                String sql = "INSERT INTO evenimente (titlu, descriere, data_eveniment, locatie, pret, locuri_disponibile) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, titlu);
                ps.setString(2, desc);
                ps.setString(3, dataStr);
                ps.setString(4, loc);
                ps.setDouble(5, pret);
                ps.setInt(6, locuri);
                
                ps.executeUpdate();
                
                // După salvare, ne întoarcem la panoul de admin să vedem lista actualizată
                response.sendRedirect("admin.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Eroare la adaugare: " + e.getMessage());
        }
    }
}