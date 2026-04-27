package com.project.artconnect.test;

import com.project.artconnect.model.CommunityMember;
import com.project.artconnect.persistence.JdbcCommunityMemberDao;

import java.util.List;
import java.util.Optional;

public class MainTestDao {

    public static void main(String[] args) {

        JdbcCommunityMemberDao dao = new JdbcCommunityMemberDao();

        // FIND ALL
        List<CommunityMember> all = dao.findAll();
        System.out.println("All members:");
        for (CommunityMember cm : all) {
            System.out.println(cm.getName() + " - " + cm.getEmail());
        }

        // FIND BY ID
        Optional<CommunityMember> opt = dao.findById(4L);
        if (opt.isPresent()) {
            System.out.println("Found: " + opt.get().getName());
        } else {
            System.out.println("Not found");
        }
    }
}