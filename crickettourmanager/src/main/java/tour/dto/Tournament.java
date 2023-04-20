package tour.dto;

import java.util.ArrayList;
import java.util.HashSet;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Serializable;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class Tournament implements Serializable{
    private String name;
    private int noOfTeams;
    // private HashSet<Team> teams;
    private int noOfRounds;
    private Round[] rounds;
    private int currentRound;
    private String champion;
//    private String host;
    transient private JSONArray tourJson;

    public Tournament(String path, String name, int noOfTeams, HashSet<Team> teams) {
//    	host = username;
        this.name = name;
        this.noOfTeams = noOfTeams;
        addTeams(teams, path);
        // log*****************
    }

    public void addTeams(HashSet<Team> teams, String path) {
        champion = "N/A";
        int noOfTeams = this.noOfTeams;
        while (noOfTeams > 1) {
            noOfTeams = noOfTeams >> 1;
            noOfRounds++;
        }
        rounds = new Round[noOfRounds];
        currentRound = noOfRounds - 1;
        noOfTeams = this.noOfTeams;
        for (int i=noOfRounds-1; i>=0; i--) {
            String roundName = null;
            switch (i) {
                case 0:
                    roundName = "Final";
                    break;
                case 1:
                    roundName = "Semi-final";
                    break;
                case 2:
                    roundName = "Quarter-final";
                    break;
                default:
                    roundName = "Round of " + noOfTeams;
            }
            rounds[i] = new Round(i, noOfTeams, roundName);
            noOfTeams = noOfTeams >> 1;
        }
        boolean home = true;
        for (Team team : teams) {
            rounds[currentRound].addTeamsInMatch(team, home);
            home = !home;
        }
        writeJson(path);
    }

    @SuppressWarnings("unchecked")
    void writeJson(String path) {
        tourJson = new JSONArray();
        for (int i = rounds.length - 1; i >= 0; i--) {
            JSONArray roundArray = new JSONArray();
            Match[] match = rounds[i].getMatches();
            for (int j = 0; j < match.length; j++) {
                JSONObject matchObj = new JSONObject();
                matchObj.put("Home", match[j].getHomeTeam());
                matchObj.put("Away", match[j].getAwayTeam());
                matchObj.put("Home-score", match[j].getHomeScore());
                matchObj.put("Away-score", match[j].getAwayScore());
                matchObj.put("Winner", match[j].getWinnerName());
                roundArray.add(matchObj);
            }
            JSONObject roundObject = new JSONObject();
            roundObject.put(rounds[i].getRoundName(), roundArray);
            tourJson.add(roundObject);
        }
        try {
            File file = new File(path+name + ".json");
            file.createNewFile();
            FileWriter writer = new FileWriter(file);
            writer.write(tourJson.toJSONString());
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        tourJson = null;
        // System.out.println(tourJson.toJSONString());
    }

    public String getName() {
        return name;
    }

    public void updateScore(String homeRun, String homeOvers, String awayRun, String awayOvers) {
        int remainingGames = rounds[currentRound].updateScore(homeRun, homeOvers, awayRun, awayOvers);
        if (remainingGames == 0) {
            if (currentRound > 0) {
                currentRound--;
                ArrayList<Team> winners = rounds[currentRound + 1].getWinners();
                boolean home = true;
                for (Team team : winners) {
                    rounds[currentRound].addTeamsInMatch(team, home);
                    home = !home;
                }
            } else if (currentRound == 0) {
                champion = rounds[currentRound].getWinners().get(0).toString();
                currentRound--;
            }
        }
    }

    public String toString() {
        return String.format("%-26s", name) + String.format("%-15s", noOfTeams) + champion;
    }

    public String getRoundName() {
        if (currentRound < 0)
            return null;
        return rounds[currentRound].getRoundName();
    }

    public String getCurrentMatch() {

        return rounds[currentRound].getCurrentMatch();
    }

    public void printTournament() {
        for (int i = noOfRounds - 1; i >= 0; i--) {
            System.out.println(rounds[i].getRoundName());
            System.out.println("--------------------");
            for (Match match : rounds[i].getMatches()) {
                System.out.println(match);
                System.out.println("--------------------");
            }
        }
    }
}
