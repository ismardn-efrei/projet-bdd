package com.project.artconnect.persistence;

import com.project.artconnect.dao.CommunityMemberDao;
import com.project.artconnect.model.CommunityMember;
import com.project.artconnect.config.DatabaseConfig;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcCommunityMemberDao implements CommunityMemberDao {

    private Connection getConnection() throws SQLException {
        return DatabaseConfig.getConnection();
    }

    private CommunityMember mapCM(ResultSet r) throws SQLException {
        CommunityMember m = new CommunityMember();

        m.setName(r.getString("name"));
        m.setEmail(r.getString("email"));
        m.setCity(r.getString("city"));
        m.setMembershipType(r.getString("membershipType"));

        return m;
    }

    @Override
    public Optional<CommunityMember> findById(Long id) {

        String sql = "SELECT * FROM CommunityMember WHERE id_member = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapCM(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return Optional.empty();
    }

    @Override
    public List<CommunityMember> findAll() {

        List<CommunityMember> list = new ArrayList<>();
        String sql = "SELECT * FROM CommunityMember";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapCM(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return list;
    }

}