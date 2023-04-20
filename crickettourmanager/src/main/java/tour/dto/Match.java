package tour.dto;

public class Match {
    private Team home, away;
    private int homeScore, awayScore;
    private int homeWickets, awayWickets;
    private String homeOvers, awayOvers;
    private String result;
    private Team winner;

    class Score {
        static int runs;
        static int wickets;
    }

    Match() {
        homeScore = homeWickets = awayScore = awayWickets = -1;
        result = "Match yet to be played";
    }

    public int getHomeScore() {
        return homeScore;
    }

    public int getAwayScore() {
        return awayScore;
    }

    public String getWinnerName() {
        return winner == null ? null : winner.toString();
    }

    public void setHomeTeam(Team team) {
        home = team;
    }

    public void setawayTeam(Team team) {
        away = team;
    }

    public String getHomeTeam() {
        return home == null ? null : home.toString();
    }

    public String getAwayTeam() {
        return away == null ? null : away.toString();
    }

    public void setScore(String homeRun, String homeOvers, String awayRun, String awayOvers) {
        convertScore(homeRun);
        this.homeScore = Score.runs;
        this.homeWickets = Score.wickets;
        this.homeOvers = homeOvers;
        convertScore(awayRun);
        this.awayScore = Score.runs;
        this.awayWickets = Score.wickets;
        this.awayOvers = awayOvers;
        winner = homeScore > awayScore ? home : away;
        result = winner + " won";
    }

    void convertScore(String score) {
        int index = score.indexOf('-');
        Score.runs = Integer.parseInt(score.substring(0, index));
        Score.wickets = Integer.parseInt(score.substring(index + 1));
    }

    public String preMatch() {
        return home + " (Home) vs " + away + " (Away)";
    }

    public String toString() {
        String homescore = (home != null ? home : "TBD") + " "
                + (homeScore >= 0 ? (homeScore + "-" + homeWickets) : "N/A")
                + (homeOvers == null ? "" : " (" + homeOvers + ")");
        String awayscore = (away != null ? away : "TBD") + " "
                + (awayScore >= 0 ? (awayScore + "-" + awayWickets) : "N/A")
                + (awayOvers == null ? "" : " (" + awayOvers + ")");
        return homescore + "\n" + awayscore + "\n" + result;
    }

    public Team getWinner() {
        return winner;
    }
}
