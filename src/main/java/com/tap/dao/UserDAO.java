package com.tap.dao;

import com.tap.model.User;

public interface UserDAO {
    boolean registerUser(User user);
    boolean isEmailExists(String email);
    User loginUser(String email, String password);
}