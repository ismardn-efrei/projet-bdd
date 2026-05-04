package com.project.artconnect.service.impl;

import com.project.artconnect.dao.CommunityMemberDao;
import com.project.artconnect.dao.impl.CommunityMemberDaoImpl;
import com.project.artconnect.model.CommunityMember;
import com.project.artconnect.model.Review;
import com.project.artconnect.service.CommunityService;

import java.util.*;

public class CommunityServiceImpl implements CommunityService {

    private CommunityMemberDao communitydao = new CommunityMemberDaoImpl();

    @Override
    public List<CommunityMember> getAllMembers() { return communitydao.findAll(); }

    @Override
    public Optional<CommunityMember> getMemberByName(String name) {
        return communitydao.findAll().stream()
                .filter(m -> m.getName().equals(name))
                .findFirst();
    }

    @Override
    public List<Review> getReviewsByMember(CommunityMember member) {
        if (member == null) return Collections.emptyList();
        return member.getReviews();
    }
}
