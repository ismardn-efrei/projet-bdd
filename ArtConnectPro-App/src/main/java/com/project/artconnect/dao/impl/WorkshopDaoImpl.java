package com.project.artconnect.dao.impl;

import com.project.artconnect.dao.WorkshopDao;
import com.project.artconnect.model.Workshop;
import com.project.artconnect.model.Artist;
import com.project.artconnect.persistence.JdbcWorkshopDao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class WorkshopDaoImpl implements WorkshopDao {

    private final JdbcWorkshopDao jdbcWorkshopDao = new JdbcWorkshopDao();

    private Workshop mapArtist(ResultSet r) throws SQLException {
        Workshop w = new Workshop();

        w.setTitle(r.getString("title"));
        w.setDate(r.getTimestamp("date").toLocalDateTime());
        w.setMaxParticipants(r.getInt("maxParticipants"));
        w.setPrice(r.getDouble("price"));
        w.setLevel(r.getString("level"));

        Artist artist = new Artist();
        artist.setName(r.getString("artist_name")); // via JOIN
        w.setInstructor(artist);

        return w;
    }

    @Override
    public Optional<Workshop> findById(Long id) {

        String sql =
                "SELECT w.*, a.name AS artist_name " +
                        "FROM Workshop w " +
                        "JOIN Artist a ON w.id_artist = a.id_artist " +
                        "WHERE w.id_workshop = ?";

        try (Connection conn = jdbcWorkshopDao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return Optional.of(mapArtist(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return Optional.empty();
    }

    @Override
    public List<Workshop> findAll() {

        List<Workshop> list = new ArrayList<>();

        String sql =
                "SELECT w.*, a.name AS artist_name " +
                        "FROM Workshop w " +
                        "JOIN Artist a ON w.id_artist = a.id_artist";

        try (Connection conn = jdbcWorkshopDao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapArtist(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return list;
    }
}