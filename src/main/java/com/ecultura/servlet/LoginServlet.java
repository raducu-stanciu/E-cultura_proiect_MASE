package com.ecultura.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.ecultura.dao.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String parola = request.getParameter("parola");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM utilizatori WHERE email=? AND parola=?");
            ps.setString(1, email);
            ps.setString(2, parola);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Salvăm datele utilizatorului în sesiune
                HttpSession session = request.getSession();
                session.setAttribute("userID", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("nume"));
                session.setAttribute("userType", rs.getString("tip_utilizator"));

                String tip = rs.getString("tip_utilizator");
                if ("admin".equals(tip)) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("evenimente.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}