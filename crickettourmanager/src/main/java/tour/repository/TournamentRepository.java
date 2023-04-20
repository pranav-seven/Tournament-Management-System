package tour.repository;

import tour.dto.*;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.Comparator;
import java.util.HashSet;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;

public class TournamentRepository {
    private static TournamentRepository repository;
    private List<Admin> adminList;
    private List<User> userList;
    private List<Tournament> tournamentList;
    private Statement statement;
    private Connection connection;
    private ResultSet results;
    private String path;
    private File folder;

    private TournamentRepository() {
        adminList = new ArrayList<>();
        tournamentList = new ArrayList<>();
    }

    public static TournamentRepository getInstance() {
        try {
            if (repository == null) {
                repository = new TournamentRepository();
                repository.executeConnection();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return repository;
    }

    private void executeConnection() throws Exception {
        String url = "jdbc:mysql://localhost:3306/crickettournamentmanager";
        String username = "root";
        /*****
        Change db password here
        *****/
        String password = "_____";
        connection = DriverManager.getConnection(url, username, password);
        statement = connection.createStatement();
    }

 /*   public void setPath(String username) {
        path = "C:\\Users\\Bennos\\eclipse-workspace\\crickettourmanager\\src\\main\\webapp\\";
        folder = new File(path);
        System.out.println("folder " + folder.mkdir());
        // fileList = folder.listFiles();
        // comparator = new Comparator<File>(){
        // public int compare(File file1, File file2){
        // return file1.lastModified()>file2.lastModified()?-1:1;
        // }
        // };
        // if(fileList!=null)
        // Arrays.sort(fileList, comparator);
    } 
    */

    public List<Admin> getAdmins() {
        adminList.clear();
        try {
            results = statement.executeQuery("SELECT * FROM ADMIN");
            while (results.next())
                adminList.add(new Admin(null, null, results.getString(1), results.getString(2)));
        } catch (SQLException sql) {
            sql.printStackTrace();
        }
        return adminList;
    }

    // public boolean addTournament(String name, int noOfTeams, HashSet<Team> teams)
    // {
    // return tournamentList.add(new Tournament(name, noOfTeams, teams));
    // }

    // public Tournament addTournament(String name, int noOfTeams) {
    // Tournament tour = new Tournament(name, noOfTeams);
    // tournamentList.add(tour);
    // return tour;
    // }

    public void addTournament(String username, String name, int noOfTeams, String[] teams) {
        HashSet<Team> teamsSet = new HashSet<>();
        for (int i = 0; i < teams.length; i++)
            teamsSet.add(new Team(teams[i]));
        tournamentList.add(new Tournament(path, name, noOfTeams, teamsSet));
        // *********
        // for(int i=0; i<tournamentList.size(); i++)
        // System.out.println(tournamentList.get(i).getName());
    }

    public List<Tournament> getTournaments() {
        return tournamentList;
    }

    public String getTournament(String name) {
        File file = new File(path + name + ".json");
        JSONArray array = null;
        if (file.exists()) {
            JSONParser parser = new JSONParser();
            try {
                array = (JSONArray) parser.parse(new FileReader(file));
            } catch (IOException | ParseException exception) {
                exception.printStackTrace();
            }
            return array.toJSONString();
        }
        return null;
    }

    public Tournament getTournament(int n) {
        if (n >= tournamentList.size())
            return null;
        return tournamentList.get(n);
    }

    public List<User> getUsers() {
        return userList;
    }

    public void deleteTournament(int n) {
        tournamentList.remove(n);
    }

}
