package com.conapp.tournament.manager;

import java.util.HashSet;

import com.conapp.tournament.dto.Team;

public interface ManagerViewToController {

    boolean isValidNoOfTeams(int n);

    void addTournament(String name, int number, HashSet<Team> teams);

    boolean getTournaments();

    boolean checkTournamentExists(int i);

    String getRoundName();

    String getCurrentMatch();

    boolean updateScore(String homeScore, String homeOvers, String awayScore, String awayOvers);

    void viewTournament(int i);

    boolean deleteTournament(int i);

}
