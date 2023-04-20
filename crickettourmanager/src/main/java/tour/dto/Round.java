package tour.dto;

import java.util.ArrayList;

public class Round {

    private String name;
    private int noOfTeams;
    // private int roundNo;
    private Match[] matches;
    private int noOfMatches;
    private int matchIndex;

    Round(int round, int numOfTeams, String name)
    {
        this.name = name;
        noOfTeams = numOfTeams;
        // roundNo = round;
        // matchIndex = -1;
        noOfMatches = numOfTeams>>1;
        matches = new Match[noOfMatches];
        for(int i=0; i<matches.length; i++)
            matches[i] = new Match();
    }

    public void addTeamsInMatch(Team team, boolean home)
    {
        if(home)
            matches[matchIndex].setHomeTeam(team);
        else
        {
            matches[matchIndex].setawayTeam(team);
            matchIndex++;
        }
    }

    public int updateScore(String homeRun, String homeOvers, String awayRun, String awayOvers)
    {
        matches[noOfMatches-matchIndex].setScore(homeRun, homeOvers, awayRun, awayOvers);
        matchIndex--;
        return matchIndex;
    }

    public String getRoundName()
    {
        return name;
    }

    public String getCurrentMatch() {
        return matches[noOfMatches-matchIndex].preMatch();
    }

    public int getNoOfTeams() {
        return noOfTeams;
    }

    public ArrayList<Team> getWinners() {
        ArrayList<Team> winners = new ArrayList<>();
        for(int i=0; i<noOfMatches; i++)
            winners.add(matches[i].getWinner());
        return winners;
    }

    public Match[] getMatches()
    {
        return matches;
    }
}
