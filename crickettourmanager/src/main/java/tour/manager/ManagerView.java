package com.conapp.tournament.manager;

import java.util.Scanner;
import java.util.List;
import java.util.HashSet;

import com.conapp.tournament.dto.Admin;
import com.conapp.tournament.dto.Team;
import com.conapp.tournament.dto.Tournament;

public class ManagerView implements ManagerControllerToView{

    private Scanner sc;
    private ManagerViewToController managerController;

    public ManagerView(Admin admin, Scanner sc)
    {
        managerController = new ManagerController(this);
        this.sc = sc;
        startManager();
    }

    void startManager()
    {
        char choice = 0;
        do{
            System.out.println("----------------------");
            System.out.println("1 - Add tournament");
            System.out.println("2 - View tournaments");
            System.out.println("3 - View a single tournament");
            System.out.println("4 - Edit tournament");
            System.out.println("5 - Delete tournament");
            System.out.println("0 - Log out");
            System.out.print("Enter choice: ");
            choice = sc.nextLine().charAt(0);
            switch(choice)
            {
                case '1': addTournament(); break;
                case '2': viewTournaments(); break;
                case '3': viewTournament(); break;
                case '4': editTournament(); break;
                case '5': deleteTournament(); break;
                case '0': break;
                default: System.out.println("Invalid choice, try again.");
            }
        }while(choice!='0');
    }

    //add tournament*********************
    void addTournament()
    {
        System.out.print("Tournament name: ");
        String name = sc.nextLine();
        int number = getNumberOfTeams();
        HashSet<Team> teams = new HashSet<Team>();
        for(int i=1; i<=number; i++)
        {
            System.out.print("Team "+i+": ");
            teams.add(new Team(sc.nextLine()));
        }
        managerController.addTournament(name, number, teams);
    }

    int getNumberOfTeams()
    {
        System.out.print("Number of teams (2, 4, 8, 16,...): ");
        int n = sc.nextInt();
        sc.nextLine();
        if(!managerController.isValidNoOfTeams(n))
        {
            System.out.println("Enter a valid number! (must be a power of two)");
            n = getNumberOfTeams();
        }
        return n;
    }

    //view tournaments********************
    boolean viewTournaments()
    {
        boolean isEmpty = managerController.getTournaments();
        return isEmpty;
    }

    public boolean printTournaments(List<Tournament> list)
    {
        boolean isEmpty = false;
        if(list.isEmpty())
            System.out.println("No tournaments available");
        else
        {
            isEmpty = true;
            System.out.println(String.format("%-5s", "No.")+String.format("%-26s", "Name")+String.format("%-15s", "No. of teams")+"Winner");
            int i=1;
            for(Tournament tournament : list)
            {
                System.out.println(String.format("%-5s", i)+tournament);
                i++;
            }     
        }
        return isEmpty;
    }

    // view a single tournament
    void viewTournament()
    {
        if(viewTournaments())
        {
            System.out.print("Enter tournament number: ");
            int n = Integer.parseInt(sc.nextLine());
            if(managerController.checkTournamentExists(n-1))
                managerController.viewTournament(n-1);
        }
    }

    //edit tournament*********************
    void editTournament()
    {
        if(viewTournaments())
        {
            System.out.print("Enter tournament number: ");
            int n = Integer.parseInt(sc.nextLine());
            if(managerController.checkTournamentExists(n-1))
            {
                char choice = 0;
                do{
                    String round = managerController.getRoundName();
                    if(round!=null)
                    {
                        System.out.println("----------------------");
                        System.out.println("Current round: "+round);
                        managerController.getCurrentMatch();
                        System.out.println("----------------------");
                        System.out.println(managerController.getCurrentMatch());
                        System.out.println("Enter score (runs-wickets):");
                        getScore();
                        System.out.print("Do you want to update next match?\n(Y/y - yes, any other key - no): ");
                        choice = sc.next().charAt(0);
                    }
                    else
                    {
                        editFailure("Tournament Over :)");
                        break;
                    }
                }while(choice=='Y' || choice=='y');
                sc.nextLine();
            }
        }
    }

    void getScore()
    {
        String homeScore, homeOvers, awayScore, awayOvers;
        System.out.print("Home score: ");
        homeScore = sc.next();
        System.out.print("Overs: ");
        homeOvers = sc.next();
        System.out.print("Away score: ");
        awayScore = sc.next();
        System.out.print("Overs: ");
        awayOvers = sc.next();
        if(!managerController.updateScore(homeScore, homeOvers, awayScore, awayOvers))
        {
            System.out.println("Invalid score / overs!");
            System.out.println("Enter valid score.");
            getScore();
        }
    }

    public void editFailure(String message)
    {
        //either tournament unavailable or has ended
        System.out.println(message);
    }

    void deleteTournament()
    {
        if(viewTournaments())
        {
            System.out.print("Enter tournament number to remove (0 to go back): ");
            int n = Integer.parseInt(sc.nextLine());
            if(n!=0)
            {
                if(!managerController.deleteTournament(n-1))
                    System.out.println("Invalid tournament number!");
                else
                    System.out.println("Tournament deleted!");
            }

        }
    }
}
