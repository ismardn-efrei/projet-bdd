package com.project.artconnect.dao.impl;

import com.project.artconnect.dao.ArtworkDao;
import com.project.artconnect.model.Artwork;
import com.project.artconnect.persistence.JdbcArtworkDao;

import java.util.List;

public class ArtworkDaoImpl implements ArtworkDao {

    private JdbcArtworkDao jdbcArtworkDao = new JdbcArtworkDao();

    @Override
    public List<Artwork> findAll() {
        return jdbcArtworkDao.findAll();
    }

    @Override
    public void save(Artwork artwork) {
        if (artwork == null) {
            throw new IllegalArgumentException("Artwork is null");
        }
        jdbcArtworkDao.save(artwork);
    }

    @Override
    public void update(Artwork artwork) {
        if (artwork == null) {
            throw new IllegalArgumentException("Invalid artwork");
        }
        jdbcArtworkDao.update(artwork);
    }

    @Override
    public void delete(String title) {
        if (title == null) {
            throw new IllegalArgumentException("Title is null");
        }
        jdbcArtworkDao.delete(title);
    }

    @Override
    public List<Artwork> findByArtistName(String artistName) {
        return jdbcArtworkDao.findByArtistName(artistName);
    }
}