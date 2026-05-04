package com.project.artconnect.persistence;

import com.project.artconnect.config.DatabaseConfig;

import java.sql.*;

public class JdbcWorkshopDao  {

    public Connection getConnection() throws SQLException {
        return DatabaseConfig.getConnection();
    }
}