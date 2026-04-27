package com.project.artconnect.persistence;

import com.project.artconnect.dao.ArtworkDao;
import com.project.artconnect.model.Artist;
import com.project.artconnect.model.Artwork;
import com.project.artconnect.config.DatabaseConfig;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class JdbcArtworkDao implements ArtworkDao {

    private Connection getConnection() throws SQLException {
        return DatabaseConfig.getConnection();
    }

    private Artwork mapArtwork(ResultSet r) throws SQLException {
        Artwork artwork = new Artwork();
        artwork.setTitle(r.getString("title"));
        artwork.setType(r.getString("type"));
        artwork.setMedium(r.getString("medium"));
        artwork.setPrice(r.getDouble("price"));
        artwork.setStatus(Artwork.Status.valueOf(r.getString("status")));
        Artist artist = new Artist();
        artist.setName(r.getString("artist_name"));
        artwork.setArtist(artist);

        return artwork;
    }

    @Override
    public List<Artwork> findAll() {
        List<Artwork> artworks = new ArrayList<>();
        String sql =
                "SELECT a.*, ar.name AS artist_name " +
                        "FROM Artwork a " +
                        "JOIN Artist ar ON a.id_artist = ar.id_artist";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                artworks.add(mapArtwork(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching artworks ", e);
        }

        return artworks;
    }

    @Override
    public void save(Artwork artwork) {

        String findIdArtist = "SELECT id_artist FROM Artist WHERE name = ?";
        String insertSql = "INSERT INTO Artwork (title, type, medium, price, status, id_artist) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement findstmt = conn.prepareStatement(findIdArtist)) {

            findstmt.setString(1, artwork.getArtist().getName());

            ResultSet rs = findstmt.executeQuery();

            if (!rs.next()) {
                throw new RuntimeException("Artist not found");
            }

            int idArtist = rs.getInt("id_artist");

            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {

                stmt.setString(1, artwork.getTitle());
                stmt.setString(2, artwork.getType());
                stmt.setString(3, artwork.getMedium());
                stmt.setDouble(4, artwork.getPrice());
                stmt.setString(5, artwork.getStatus().name());
                stmt.setInt(6, idArtist);

                stmt.executeUpdate();
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void update(Artwork artwork) {
        String findIdSql = "SELECT id_artist FROM Artist WHERE name = ?";
        String sql = "UPDATE Artwork SET type=?, medium=?, price=?, status=?, id_artist=? WHERE title=?";

        try (Connection conn = getConnection();
             PreparedStatement findStmt = conn.prepareStatement(findIdSql)) {

            findStmt.setString(1, artwork.getArtist().getName());

            ResultSet rs = findStmt.executeQuery();

            if (!rs.next()) {
                throw new RuntimeException("Artist not found");
            }

            int idArtist = rs.getInt("id_artist");

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, artwork.getType());
                stmt.setString(2, artwork.getMedium());
                stmt.setDouble(3, artwork.getPrice());
                stmt.setString(4, artwork.getStatus().name());
                stmt.setInt(5, idArtist);
                stmt.setString(6, artwork.getTitle());

                stmt.executeUpdate();
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(String title) {
        String sql = "DELETE FROM Artwork WHERE title = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, title);
            stmt.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Artwork> findByArtistName(String artistName) {
        List<Artwork> list = new ArrayList<>();

        String sql = "SELECT a.*, ar.name AS artist_name " +
                "FROM Artwork a " +
                "JOIN Artist ar ON a.id_artist = ar.id_artist " +
                "WHERE ar.name = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, artistName);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapArtwork(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return list;
    }

}