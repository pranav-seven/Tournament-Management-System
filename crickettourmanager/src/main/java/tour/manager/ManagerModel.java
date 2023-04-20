package tour.manager;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import tour.dto.Team;
import tour.dto.Tournament;
import tour.repository.TournamentRepository;

public class ManagerModel implements ManagerControllerToModel {

    private ManagerModelToController managerController;
    private TournamentRepository repo;
    private Tournament currentTour;

    ManagerModel() {
        repo = TournamentRepository.getInstance();
    }

//    @Override
//    public boolean addTournament(String name, int count) {
//        List<Tournament> tourList = repo.getTournaments();
//        for (Tournament t : tourList)
//            if (t.getName().equals(name))
//                return false;
//        currentTour = repo.addTournament(name, count);
//        return true;
//    }

    @Override
    public void addTournament(String username, String name, int count, String[] teams) {
        repo.addTournament(username, name, count, teams);
    }

    // public void addTournament(String name, int noOfTeams, HashSet<Team> teams)
    // {
    // repo.addTournament(name, noOfTeams, teams);
    // }

    public List<Tournament> getTournaments() {
        return repo.getTournaments();// managerController.printTournaments(repo.getTournaments());
    }


	@Override
	public String getTournament(String name) {
		// TODO Auto-generated method stub
		return repo.getTournament(name);
	}
//    @Override
//    public boolean checkTournamentExists(int n) {
//        currentTour = repo.getTournament(n);
//        boolean b = currentTour != null;
//        if (!b)
//            managerController.editFailure("Tournament does not exist");
//        return currentTour != null;
//    }

	public void saveTournament(String username, String name, String json)
	{

        try {
            /*****
            Change path here
            *****/
            File file = new File("____\\eclipse-workspace\\crickettourmanager\\src\\main\\webapp\\"+name + ".json");
            file.createNewFile();
            System.out.println("file exists? "+file.exists());
            FileWriter writer = new FileWriter(file);
            writer.write(json);
            writer.flush();
            writer.close();
            System.out.println("file exists? "+file.exists());

        } catch (IOException e) {
            e.printStackTrace();
        }
	}
    @Override
    public String getRoundName() {
        return currentTour.getRoundName();
    }

    @Override
    public String getCurrentMatch() {
        return currentTour.getCurrentMatch();
    }

    @Override
    public void updateScore(String homeScore, String homeOvers, String awayScore, String awayOvers) {
        currentTour.updateScore(homeScore, homeOvers, awayScore, awayOvers);
    }

    @Override
    public void viewTournament(int n) {
        currentTour.printTournament();
    }

    @Override
    public boolean deleteTournament(int n) {
        if (n >= 0 && n < repo.getTournaments().size()) {
            repo.deleteTournament(n);
            return true;
        }
        return false;
    }

	@Override
	public boolean checkTournamentExists(String name) {
        List<Tournament> tourList = repo.getTournaments();
        for (Tournament t : tourList)
            if (t.getName().equalsIgnoreCase(name))
                return true;
        return false;
	}

}
