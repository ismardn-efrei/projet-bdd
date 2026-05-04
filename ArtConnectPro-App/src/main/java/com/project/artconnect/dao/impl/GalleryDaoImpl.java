package com.project.artconnect.dao.impl;

import com.project.artconnect.dao.GalleryDao;
import com.project.artconnect.model.Exhibition;
import com.project.artconnect.model.Gallery;
import com.project.artconnect.persistence.JdbcGalleryDao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class GalleryDaoImpl implements GalleryDao {

    private final JdbcGalleryDao jdbcGalleryDao = new JdbcGalleryDao();

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

        try (Connection conn = jdbcGalleryDao.getConnection();
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
        String sql = "SELECT g.*, e.title as ex_title, e.startDate, e.endDate, e.theme, e.curatorName " +
                "FROM Gallery g " +
                "LEFT JOIN Exhibition e ON g.id_gallery = e.id_gallery";

        try (Connection conn = jdbcGalleryDao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            Gallery current = null;
            while (rs.next()) {
                String name = rs.getString("name");
                if (current == null || !current.getName().equals(name)) {
                    current = mapGallery(rs);
                    list.add(current);
                }
                String exTitle = rs.getString("ex_title");
                if (exTitle != null) {
                    Exhibition ex = new Exhibition();
                    ex.setTitle(exTitle);
                    ex.setStartDate(rs.getDate("startDate").toLocalDate());
                    Date endDate = rs.getDate("endDate");
                    if (endDate != null) ex.setEndDate(endDate.toLocalDate());
                    ex.setTheme(rs.getString("theme"));
                    ex.setCuratorName(rs.getString("curatorName"));
                    ex.setGallery(current);
                    current.getExhibitions().add(ex);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return list;
    }
}