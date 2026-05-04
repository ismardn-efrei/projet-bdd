package com.project.artconnect.test;

import com.project.artconnect.model.Workshop;
import com.project.artconnect.persistence.JdbcWorkshopDao;

import java.util.List;
import java.util.Optional;

public class MainTestDao {

    public static void main(String[] args) {

        JdbcWorkshopDao dao = new JdbcWorkshopDao();

        // FIND ALL
        List<Workshop> list = dao.findAll();
        System.out.println("All workshops:");
        for (Workshop w : list) {
            System.out.println(w.getTitle() + " - " + w.getInstructor().getName());
        }

        // FIND BY ID (mets un id existant en DB)
        Optional<Workshop> opt = dao.findById(1L);

        if (opt.isPresent()) {
            Workshop w = opt.get();
            System.out.println("Found:");
            System.out.println(w.getTitle() + " - " + w.getInstructor().getName());
        } else {
            System.out.println("Workshop not found");
        }
    }
}