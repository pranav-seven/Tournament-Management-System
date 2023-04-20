package tour.login;

import java.util.List;

import tour.dto.User;

import tour.repository.TournamentRepository;

public class LoginModel implements LoginServletToModel {
  private TournamentRepository repo;

  LoginModel() {
    repo = TournamentRepository.getInstance();
  }

  @Override
  public boolean checkLoginDetails(String username, String password) {
    List<? extends User> list = null;
    // login for users yet to be implemented
    // if(type=='u')
    // list = repo.getUsers();
    // else
    list = repo.getAdmins();
    for (User user : list)
      if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
        return true;
      }
    return false;
  }

}
