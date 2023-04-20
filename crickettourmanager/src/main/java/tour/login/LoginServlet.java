package tour.login;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private LoginServletToModel loginModel;

	public void init() throws ServletException {
		loginModel = new LoginModel();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String action = request.getParameter("action");
		switch (action) {
			case "logout":
				HttpSession session = request.getSession();
				session.removeAttribute("username");
				response.getWriter().append("login.jsp");
				break;
		}
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
//		System.out.println(password);
		boolean isValidUser = loginModel.checkLoginDetails(username, password);
		if (isValidUser) {
			response.getWriter().append('a');
			HttpSession session = request.getSession();
			session.setAttribute("username", username);
		} else
			response.getWriter().append('0');
	}
}
