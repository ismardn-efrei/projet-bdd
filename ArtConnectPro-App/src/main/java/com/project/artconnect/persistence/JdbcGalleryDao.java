package com.project.artconnect.persistence;

import com.project.artconnect.dao.GalleryDao;
import com.project.artconnect.model.Gallery;
import com.project.artconnect.config.DatabaseConfig;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcGalleryDao implements GalleryDao {

    private Connection getConnection() throws SQLException {
        return DatabaseConfig.getConnection();
    }

    private Gallery mapGallery(ResultSet r) throws SQLException {
        Gallery g = new Gallery();

        g.setName(r.getString("name"));
        g.setAddress(r.getString("address"));
        g.setRating(r.getDouble("rating"));

        return g;
    }

    @Override
    public Optional<Gallery> findById(Long id) {

        String sql = "SELECT * FROM Gallery WHERE id_gallery = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return Optional.of(mapGallery(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return Optional.empty();
    }

    @Override
    public List<Gallery> findAll() {

        List<Gallery> list = new ArrayList<>();
        String sql = "SELECT * FROM Gallery";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapGallery(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return list;
    }
}