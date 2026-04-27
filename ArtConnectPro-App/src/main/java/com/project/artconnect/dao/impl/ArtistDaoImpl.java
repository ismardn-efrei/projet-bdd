package com.project.artconnect.dao.impl;

import com.project.artconnect.dao.ArtistDao;
import com.project.artconnect.model.Artist;
import com.project.artconnect.persistence.JdbcArtistDao;

import java.util.List;

public class ArtistDaoImpl implements ArtistDao {

    private JdbcArtistDao jdbcArtistDao = new JdbcArtistDao();

    @Override
    public List<Artist> findAll() {
        return jdbcArtistDao.findAll();
    }

    @Override
    public void save(Artist artist) {

        if (artist != null) {
            jdbcArtistDao.save(artist);
        } else {
            throw new IllegalArgumentException("Artist is null.");
        }
    }

    @Override
    public void update(Artist artist) {
        if (artist != null) {
            jdbcArtistDao.update(artist);
        } else {
            throw new IllegalArgumentException("Artist is null.");
        }
    }

    @Override
    public void delete(String artistName) {
        if (artistName != null) {
            jdbcArtistDao.delete(artistName);
        } else {
            throw new IllegalArgumentException("ArtistName is null.");
        }
    }


    @Override
    public List<Artist> findByCity(String city) {
        if (city != null) {
            return jdbcArtistDao.findByCity(city);
        } else {
            throw new IllegalArgumentException("City is null.");
        }
    }
}