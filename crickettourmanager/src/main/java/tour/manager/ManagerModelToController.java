package com.conapp.tournament.manager;

import java.util.List;

import com.conapp.tournament.dto.Tournament;

public interface ManagerModelToController {

    boolean printTournaments(List<Tournament> tournaments);

    void editFailure(String string);

}
