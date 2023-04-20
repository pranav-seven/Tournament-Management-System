package com.conapp.tournament.manager;

import java.util.List;

import com.conapp.tournament.dto.Tournament;

public interface ManagerControllerToView {

    boolean printTournaments(List<Tournament> tournamentList);

    void editFailure(String string);

}
