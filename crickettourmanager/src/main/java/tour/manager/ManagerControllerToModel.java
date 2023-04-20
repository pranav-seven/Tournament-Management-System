package tour.manager;

import java.util.HashSet;
import java.util.List;

import tour.dto.Team;
import tour.dto.Tournament;

public interface ManagerControllerToModel {

//    void addTournament(String name, int numberOfTeams, HashSet<Team> teams);

    List<Tournament> getTournaments();

//    boolean checkTournamentExists(int n);

    String getRoundName();

    String getCurrentMatch();

    void updateScore(String homeScore, String homeOvers, String awayScore, String awayOvers);

    void viewTournament(int n);

    boolean deleteTournament(int n);

//	boolean addTournament(String name, int count);

	void addTournament(String username, String name, int count, String[] teams);

	boolean checkTournamentExists(String name);

	String getTournament(String name);

	void saveTournament(String username, String name, String jsonString);

}
