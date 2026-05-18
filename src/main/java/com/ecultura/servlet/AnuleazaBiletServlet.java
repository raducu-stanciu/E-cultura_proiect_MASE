package com.ecultura.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Dependența internă către conexiunea bazei de date
import com.ecultura.dao.DBConnection;

@WebServlet("/AnuleazaBiletServlet")
public class AnuleazaBiletServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idUtilizator = (Integer) session.getAttribute("userID");

        // Securitate: Verificăm dacă utilizatorul este logat
        if (idUtilizator == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idRezervareParam = request.getParameter("id");
        if (idRezervareParam == null) {
            response.sendRedirect("bilete.jsp");
            return;
        }

        int idRezervare = Integer.parseInt(idRezervareParam);

        try (Connection con = DBConnection.getConnection()) {
            // PASUL 1: Aflăm ID-ul evenimentului înainte de a șterge rezervarea
            // (Asta ne trebuie ca să știm unde să adunăm locul înapoi în inventar)
            int idEveniment = -1;
            PreparedStatement psFind = con.prepareStatement("SELECT id_eveniment FROM rezervari WHERE id = ? AND id_utilizator = ?");
            psFind.setInt(1, idRezervare);
            psFind.setInt(2, idUtilizator); // Siguranță: un user poate șterge doar biletele LUI
            ResultSet rs = psFind.executeQuery();

            if (rs.next()) {
                idEveniment = rs.getInt("id_eveniment");

                // PASUL 2: Ștergem rezervarea din tabelul 'rezervari'
                PreparedStatement psDelete = con.prepareStatement("DELETE FROM rezervari WHERE id = ?");
                psDelete.setInt(1, idRezervare);
                psDelete.executeUpdate();

                // PASUL 3: Incrementăm locurile disponibile (+1) în tabelul 'evenimente'
                PreparedStatement psUpdate = con.prepareStatement(
                    "UPDATE evenimente SET locuri_disponibile = locuri_disponibile + 1 WHERE id = ?");
                psUpdate.setInt(1, idEveniment);
                psUpdate.executeUpdate();
            }

            // Ne întoarcem la pagina cu bilete, care acum va fi actualizată
            response.sendRedirect("bilete.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Eroare la anularea biletului: " + e.getMessage());
        }
    }
}