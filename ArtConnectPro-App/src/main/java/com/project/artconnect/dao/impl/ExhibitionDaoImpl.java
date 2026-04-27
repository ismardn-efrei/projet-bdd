package com.project.artconnect.dao.impl;

import com.project.artconnect.dao.ExhibitionDao;
import com.project.artconnect.model.Exhibition;
import com.project.artconnect.persistence.JdbcExhibitionDao;

import java.util.List;

public class ExhibitionDaoImpl implements ExhibitionDao {

    private JdbcExhibitionDao jdbcExhibitionDao = new JdbcExhibitionDao();

    @Override
    public List<Exhibition> findAll() {
        return jdbcExhibitionDao.findAll();
    }

    @Override
    public void save(Exhibition exhibition) {
        jdbcExhibitionDao.save(exhibition);
    }

    @Override
    public void update(Exhibition exhibition) {
        jdbcExhibitionDao.update(exhibition);
    }

    @Override
    public void delete(String title) {
        jdbcExhibitionDao.delete(title);
    }
}