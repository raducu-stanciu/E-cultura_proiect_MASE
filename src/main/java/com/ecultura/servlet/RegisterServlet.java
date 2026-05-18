package com.ecultura.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.ecultura.dao.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Citim datele trimise de formularul din register.jsp
        String nume = request.getParameter("nume");
        String email = request.getParameter("email");
        String parola = request.getParameter("parola");

        try (Connection con = DBConnection.getConnection()) {
            // Pregătim comanda SQL pentru inserare
            String sql = "INSERT INTO utilizatori (nume, email, parola, tip_utilizator) VALUES (?, ?, ?, 'client')";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setString(1, nume);
            ps.setString(2, email);
            ps.setString(3, parola);
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                // Dacă s-a salvat cu succes, mergem la pagina de login
                response.sendRedirect("login.jsp?success=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Dacă apare o eroare (ex: email duplicat), afișăm un mesaj
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h3>Eroare la înregistrare: Email-ul există deja sau baza de date este oprită!</h3>");
            response.getWriter().println("<a href='register.jsp'>Încearcă din nou</a>");
        }
    }
}