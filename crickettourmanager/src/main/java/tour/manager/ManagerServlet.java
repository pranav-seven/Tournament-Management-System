package tour.manager;

import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;

import tour.dto.Tournament;

@WebServlet("/ManagerServlet")
public class ManagerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private ManagerControllerToModel managerModel;
	private HttpServletRequest request;
	private HttpServletResponse response;

	public void init() throws ServletException {
		managerModel = new ManagerModel();
	}

	// public boolean isValidNoOfTeams(int n)
	// {
	// if(n<2)
	// return false;
	// for(int i=2; i<=n; i=i<<1)
	// if(i==n)
	// return true;
	// return false;
	// }
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		this.request = request;
		this.response = response;
		String type = request.getParameter("action");
		switch (type) {
			case "checktour":
				checkTournamentExists();
				break;
			case "viewall":
				getTournaments();
				break;
			case "edittour":
				getTournament();
		}
		this.request = null;
		this.response = null;
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		this.request = request;
		this.response = response;
		String type = request.getParameter("action");
		switch (type) {
			case "addtour":
				addTournament();
				break;
			case "savetour":
				saveTournament();
				break;
		}
		this.request = null;
		this.response = null;
	}

	void checkTournamentExists() throws IOException {
		String name = request.getParameter("tourName");
		if (managerModel.checkTournamentExists(name))
			response.getWriter().append('1');
		else
			response.getWriter().append('0');
	}

	// void addTournament() throws IOException {
	// System.out.println(request.getQueryString());
	// String name = request.getParameter("tourName");
	// int count = Integer.parseInt(request.getParameter("count"));
	// boolean done = managerModel.addTournament(name, count);
	// String url = "http://localhost:8080/crickettourmanager/addteams.jsp";
	// if (done)
	// response.getWriter().append(url + "?name=" + name + "&count=" + count);
	// else
	// response.getWriter().append("0");
	// return;
	// }

	void addTournament() {
		String name = request.getParameter("tourName");
		String[] teams = request.getParameter("teamlist").split(",");
		String username = (String)request.getSession().getAttribute("username");
		managerModel.addTournament(username, name, teams.length, teams);
	}

	// public void addTournament(String name, int numberOfTeams, HashSet<Team>
	// teams)
	// {
	// managerModel.addTournament(name, numberOfTeams, teams);
	// }

	@SuppressWarnings("unchecked")
	void getTournaments() throws IOException {
		List<Tournament> list = managerModel.getTournaments();
		JSONArray array = new JSONArray();
		for (Tournament tour : list)
			array.add(tour.getName());
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().append(array.toString());
	}

	void getTournament() throws IOException {
		String name = request.getParameter("tourname");
		String tourJson = managerModel.getTournament(name);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().append(tourJson);
	}
	
	void saveTournament()
	{
		String username = (String)request.getSession().getAttribute("username");
		String name = request.getParameter("tourName");
		String jsonString = request.getParameter("json");
		managerModel.saveTournament(username, name,jsonString);
	}

	// public boolean printTournaments(List<Tournament> tournamentList)
	// {
	// return managerView.printTournaments(tournamentList);
	// }

	// public boolean checkTournamentExists(int n) {
	// if(n<0)
	// {
	// editFailure("Tournament does not exist");
	// return false;
	// }
	// else
	// return managerModel.checkTournamentExists(n);
	// }

	String getRoundName() {
		return managerModel.getRoundName();
	}

	String getCurrentMatch() {
		return managerModel.getCurrentMatch();
	}

	boolean updateScore(String homeScore, String homeOvers, String awayScore, String awayOvers) {
		if (isValidScore(homeScore, homeOvers) && isValidScore(awayScore, awayOvers)) {
			managerModel.updateScore(homeScore, homeOvers, awayScore, awayOvers);
			return true;
		}
		return false;
	}

	boolean isValidScore(String score, String overs) {
		return Pattern.matches("[1-9][0-9]*-([0-9]|10)", score)
				&& Pattern.matches("(([1]?[0-9])(.[0-5])?)|20", overs);
	}

	// public void editFailure(String message)
	// {
	// managerView.editFailure(message);
	// }

	// void viewTournament(int n) {
	// managerModel.viewTournament(n);
	// }

	boolean deleteTournament(int n) {
		return managerModel.deleteTournament(n);
	}
}
