package com.project.artconnect.service.impl;

import com.project.artconnect.dao.GalleryDao;
import com.project.artconnect.dao.impl.GalleryDaoImpl;
import com.project.artconnect.model.Exhibition;
import com.project.artconnect.model.Gallery;
import com.project.artconnect.service.GalleryService;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

public class GalleryServiceImpl implements GalleryService {

    private GalleryDao gallerydao = new GalleryDaoImpl();

    @Override
    public List<Gallery> getAllGalleries() {
        return gallerydao.findAll();
    }

    @Override
    public Optional<Gallery> getGalleryByName(String name) {
        return gallerydao.findAll().stream()
                .filter(m -> m.getName().equals(name))
                .findFirst();
    }

    @Override
    public List<Exhibition> getExhibitionsByGallery(Gallery gallery) {
        if (gallery == null) return Collections.emptyList();
        return gallery.getExhibitions();
    }
}
