package com.project.artconnect.service.impl;

import com.project.artconnect.dao.WorkshopDao;
import com.project.artconnect.dao.impl.WorkshopDaoImpl;
import com.project.artconnect.model.Workshop;
import com.project.artconnect.model.Booking;
import com.project.artconnect.model.CommunityMember;
import com.project.artconnect.service.WorkshopService;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

public class WorkshopServiceImpl implements WorkshopService {

    private WorkshopDao workshopdao = new WorkshopDaoImpl();

    @Override
    public List<Workshop> getAllWorkshops() {
        return workshopdao.findAll();
    }

    @Override
    public Optional<Workshop> getWorkshopByTitle(String title){
        return workshopdao.findAll().stream()
                .filter(m -> m.getTitle().equals(title))
                .findFirst();
    }

    @Override
    public void bookWorkshop(Workshop workshop, CommunityMember member) {
        if (workshop == null || member == null)
            return;
        Booking b = new Booking(workshop, member);
        member.addBooking(b);
    }

    @Override
    public List<Booking> getBookingsByMember(CommunityMember member)  {
        if (member == null)
            return Collections.emptyList();
        return member.getBookings();
    }
}
