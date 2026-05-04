package com.project.artconnect.dao.impl;

import com.project.artconnect.dao.ExhibitionDao;
import com.project.artconnect.model.Exhibition;
import com.project.artconnect.persistence.JdbcExhibitionDao;
import com.project.artconnect.model.Gallery;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExhibitionDaoImpl implements ExhibitionDao {

    private final JdbcExhibitionDao jdbcExhibitionDao = new JdbcExhibitionDao();

    private Exhibition mapExhibition(ResultSet r) throws SQLException {

        Exhibition e = new Exhibition();

        e.setTitle(r.getString("title"));
        e.setStartDate(r.getDate("startDate").toLocalDate());
        e.setEndDate(r.getDate("endDate") != null ? r.getDate("endDate").toLocalDate() : null);
        e.setTheme(r.getString("theme"));
        e.setCuratorName(r.getString("curatorName"));
        Gallery gallery = new Gallery();
        gallery.setName(r.getString("gallery_name"));
        e.setGallery(gallery);

        return e;
    }


    @Override
    public List<Exhibition> findAll() {

        List<Exhibition> list = new ArrayList<>();
        String sql =
                "SELECT e.*, g.name AS gallery_name " +
                        "FROM Exhibition e " +
                        "JOIN Gallery g ON e.id_gallery = g.id_gallery";

        try (Connection conn = jdbcExhibitionDao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapExhibition(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching exhibitions ", e);
        }

        return list;
    }

    @Override
    public void save(Exhibition e) {

        String findIdGallery = "SELECT id_gallery FROM Gallery WHERE name = ?";
        String insertSql = "INSERT INTO Exhibition (title, startDate, endDate, theme, curatorName, id_gallery) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = jdbcExhibitionDao.getConnection();
             PreparedStatement findstmt = conn.prepareStatement(findIdGallery)) {

            findstmt.setString(1, e.getGallery().getName());

            ResultSet rs = findstmt.executeQuery();

            if (!rs.next()) {
                throw new RuntimeException("Gallery not found");
            }

            int idGallery = rs.getInt("id_gallery");

            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {

                stmt.setString(1, e.getTitle());
                stmt.setDate(2, Date.valueOf(e.getStartDate()));
                stmt.setDate(3, e.getEndDate() != null ? Date.valueOf(e.getEndDate()) : null);
                stmt.setString(4, e.getTheme());
                stmt.setString(5, e.getCuratorName());
                stmt.setInt(6, idGallery);

                stmt.executeUpdate();
            }

        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
    }

    @Override
    public void update(Exhibition e) {

        String findIdGallery = "SELECT id_gallery FROM Gallery WHERE name = ?";
        String sql = "UPDATE Exhibition SET startDate=?, endDate=?, theme=?, curatorName=?, id_gallery=? WHERE title=?";

        try (Connection conn = jdbcExhibitionDao.getConnection();
             PreparedStatement findStmt = conn.prepareStatement(findIdGallery)) {

            findStmt.setString(1, e.getGallery().getName());

            ResultSet rs = findStmt.executeQuery();

            if(!rs.next()) {
                throw new RuntimeException("Gallery not found");
            }

            int idGallery = rs.getInt("id_gallery");

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setDate(1, Date.valueOf(e.getStartDate()));
                stmt.setDate(2, e.getEndDate() != null ? Date.valueOf(e.getEndDate()) : null);
                stmt.setString(3, e.getTheme());
                stmt.setString(4, e.getCuratorName());
                stmt.setInt(5, idGallery);
                stmt.setString(6, e.getTitle());

                stmt.executeUpdate();
            }

        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
    }

    @Override
    public void delete(String title) {

        String sql = "DELETE FROM Exhibition WHERE title = ?";

        try (Connection conn = jdbcExhibitionDao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, title);
            stmt.executeUpdate();

        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
    }

}