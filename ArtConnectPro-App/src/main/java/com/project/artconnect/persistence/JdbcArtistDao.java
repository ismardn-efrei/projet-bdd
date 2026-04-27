package com.project.artconnect.persistence;

import com.project.artconnect.dao.ArtistDao;
import com.project.artconnect.model.Artist;
import com.project.artconnect.config.DatabaseConfig;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class JdbcArtistDao implements ArtistDao {

    private Connection getConnection() throws SQLException {
        return DatabaseConfig.getConnection();
    }

    private Artist mapArtist(ResultSet r) throws SQLException {
        Artist artist = new Artist();
        artist.setName(r.getString("name"));
        artist.setBio(r.getString("bio"));
        artist.setSocialMedia(r.getString("email"));
        artist.setCity(r.getString("city"));
        artist.setBirthYear(r.getInt("birthYear"));
        artist.setActive(r.getBoolean("isActive"));
        return artist;
    }

    @Override
    public List<Artist> findAll() {
        List<Artist> artists = new ArrayList<>();
        String sql = "SELECT * FROM artist";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                artists.add(mapArtist(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching artists ", e);
        }

        return artists;
    }

    @Override
    public void save(Artist artist) {
        String sql = "INSERT INTO Artist (name, bio, email, city, birthYear, isActive) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, artist.getName());
            stmt.setString(2, artist.getBio());
            stmt.setString(3, artist.getSocialMedia());
            stmt.setString(4, artist.getCity());
            stmt.setInt(5, artist.getBirthYear());
            stmt.setBoolean(6, artist.isActive());

            stmt.executeUpdate();

        } catch (SQLIntegrityConstraintViolationException e) {
            throw new RuntimeException("Email already exists ", e);

        } catch (SQLException e) {
            throw new RuntimeException("Error saving artist ", e);
        }
    }

    @Override
    public void update(Artist artist) {
        String sql = "UPDATE Artist SET bio = ?, email = ?, city = ?, birthYear = ?, isActive = ? WHERE name = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, artist.getBio());
            stmt.setString(2, artist.getSocialMedia());
            stmt.setString(3, artist.getCity());
            stmt.setInt(4, artist.getBirthYear());
            stmt.setBoolean(5, artist.isActive());
            stmt.setString(6, artist.getName());

            stmt.executeUpdate();

        } catch (SQLIntegrityConstraintViolationException e) {
            throw new RuntimeException("Email already exists ", e);

        } catch (SQLException e) {
            throw new RuntimeException("Error updating artist ", e);
        }
    }

    @Override
    public void delete(String artistName) {
        String sql = "DELETE FROM Artist WHERE name = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, artistName);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error deleting artist ", e);
        }
    }

    @Override
    public List<Artist> findByCity(String city) {
        List<Artist> artists = new ArrayList<>();
        String sql = "SELECT * FROM Artist WHERE city = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, city);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    artists.add(mapArtist(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error finding artists by city ", e);
        }

        return artists;
    }
}