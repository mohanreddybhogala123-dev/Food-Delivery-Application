package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.tap.dao.UserDAO;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    @Override
    public boolean isEmailExists(String email) {
        if (email == null) return false;
        email = email.trim().toLowerCase();
        
        String[] queries = {
            "SELECT * FROM user WHERE LOWER(email) = ?",
            "SELECT * FROM user WHERE LOWER(userEmail) = ?",
            "SELECT * FROM user WHERE LOWER(user_email) = ?",
            "SELECT * FROM users WHERE LOWER(email) = ?"
        };

        for (String q : queries) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement pstmt = con.prepareStatement(q)) {
                pstmt.setString(1, email);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        return true;
                    }
                }
            } catch (Exception ignored) {}
        }
        return false;
    }

    @Override
    public User loginUser(String email, String password) {
        if (email == null || password == null) return null;

        email = email.trim().toLowerCase();
        password = password.trim();

        String[] queries = {
            "SELECT * FROM user WHERE LOWER(email) = ? AND password = ?",
            "SELECT * FROM user WHERE LOWER(userEmail) = ? AND password = ?",
            "SELECT * FROM user WHERE LOWER(user_email) = ? AND password = ?",
            "SELECT * FROM users WHERE LOWER(email) = ? AND password = ?",
            "SELECT * FROM user WHERE LOWER(email) = ? AND pass = ?"
        };

        for (String q : queries) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement pstmt = con.prepareStatement(q)) {
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        try { user.setUserId(rs.getInt("userId")); } catch (Exception e) { try { user.setUserId(rs.getInt("user_id")); } catch (Exception ignored) {} }
                        try { user.setName(rs.getString("username")); } catch (Exception e) { try { user.setName(rs.getString("name")); } catch (Exception ignored) {} }
                        user.setEmail(email);
                        try { user.setPhone(rs.getString("phone")); } catch (Exception e) { try { user.setPhone(rs.getString("mobile")); } catch (Exception ignored) {} }
                        try { user.setAddress(rs.getString("address")); } catch (Exception ignored) {}
                        return user;
                    }
                }
            } catch (Exception ignored) {}
        }
        return null;
    }

    @Override
    public boolean registerUser(User user) {
        if (user == null) return false;
        
        String email = user.getEmail() != null ? user.getEmail().trim().toLowerCase() : "";
        String password = user.getPassword() != null ? user.getPassword().trim() : "";
        String name = user.getName() != null ? user.getName().trim() : "User";
        String phone = user.getPhone() != null ? user.getPhone().trim() : "9876543210";
        String address = user.getAddress() != null ? user.getAddress().trim() : "MG Road, Bangalore";

        String[] insertQueries = {
            "INSERT INTO user (username, email, password, phone, address) VALUES (?, ?, ?, ?, ?)",
            "INSERT INTO user (name, userEmail, password, phone, address) VALUES (?, ?, ?, ?, ?)",
            "INSERT INTO user (name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)",
            "INSERT INTO users (username, email, password, phone, address) VALUES (?, ?, ?, ?, ?)"
        };

        for (String q : insertQueries) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement pstmt = con.prepareStatement(q)) {
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, password);
                pstmt.setString(4, phone);
                pstmt.setString(5, address);
                int rows = pstmt.executeUpdate();
                if (rows > 0) return true;
            } catch (Exception ignored) {}
        }
        return false;
    }
}