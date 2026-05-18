package com.ecultura.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.ecultura.dao.DBConnection;

@WebServlet("/UpdateNewsletterServlet")
public class UpdateNewsletterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");

        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int noulStatus = Integer.parseInt(request.getParameter("noulStatus"));

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE utilizatori SET newsletter = ? WHERE id = ?");
            ps.setInt(1, noulStatus);
            ps.setInt(2, userID);
            ps.executeUpdate();
            
            // Ne întoarcem la pagina de evenimente
            response.sendRedirect("evenimente.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Eroare: " + e.getMessage());
        }
    }
}