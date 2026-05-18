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
import com.ecultura.dao.DBConnection;

@WebServlet("/ProceseazaRezervare")
public class ProceseazaRezervareServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idUtilizator = (Integer) session.getAttribute("userID");

        // 1. Verificăm dacă utilizatorul este logat
        if (idUtilizator == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Preluăm datele de la formular (Rând și Loc)
        String idParam = request.getParameter("idEveniment");
        String randParam = request.getParameter("rand");
        String locParam = request.getParameter("loc");

        if (idParam == null || randParam == null || locParam == null) {
            response.sendRedirect("evenimente.jsp");
            return;
        }

        int idEveniment = Integer.parseInt(idParam);
        int rand = Integer.parseInt(randParam);
        int loc = Integer.parseInt(locParam);

        try (Connection con = DBConnection.getConnection()) {
            // PASUL A: Verificăm dacă locul specific (rând/loc) este deja ocupat de altcineva
            PreparedStatement psCheckLoc = con.prepareStatement(
                "SELECT id FROM rezervari WHERE id_eveniment = ? AND rand = ? AND loc = ?");
            psCheckLoc.setInt(1, idEveniment);
            psCheckLoc.setInt(2, rand);
            psCheckLoc.setInt(3, loc);
            ResultSet rsLoc = psCheckLoc.executeQuery();

            if (rsLoc.next()) {
                // Locul este ocupat! Îl anunțăm pe utilizator
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<h3 style='color:red;'>Ne pare rău, locul " + loc + " de pe rândul " + rand + " este deja ocupat!</h3>");
                response.getWriter().println("<a href='rezervare.jsp?id=" + idEveniment + "'>Înapoi la selecție locuri</a>");
            } else {
                // PASUL B: Locul e liber, salvăm rezervarea biletului individual
                PreparedStatement psInsert = con.prepareStatement(
                    "INSERT INTO rezervari (id_utilizator, id_eveniment, rand, loc) VALUES (?, ?, ?, ?)");
                psInsert.setInt(1, idUtilizator);
                psInsert.setInt(2, idEveniment);
                psInsert.setInt(3, rand);
                psInsert.setInt(4, loc);
                psInsert.executeUpdate();

                // PASUL C: Scădem numărul total de locuri disponibile pentru acest eveniment
                PreparedStatement psUpdate = con.prepareStatement(
                    "UPDATE evenimente SET locuri_disponibile = locuri_disponibile - 1 WHERE id = ?");
                psUpdate.setInt(1, idEveniment);
                psUpdate.executeUpdate();

                // Totul e ok, îl trimitem la pagina cu biletele lui
                response.sendRedirect("bilete.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Eroare la procesarea rezervării: " + e.getMessage());
        }
    }
}