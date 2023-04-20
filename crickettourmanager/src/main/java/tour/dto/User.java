package tour.dto;

// import java.util.List;
// import java.util.ArrayList;
public class User {
    private String name;
    private String emailid;
    private String username;
    private String password;
    // private List<Bookings> bookings; 
    public User(String name, String emailid, String username, String password)
    {
        this.name = name;
        this.emailid = emailid;
        this.username = username;
        this.password = password;
        // bookings = new ArrayList<>();
    }
    public String getUsername()
    {
        return username;
    }
    public String getName()
    {
        return name;
    }
    public void setName(String name)
    {
        this.name = name;
    }
    public String getPassword()
    {
        return password;
    }
    public void setPassword(String password)
    {
        this.password = password;
    }
    // public void addBooking(Bookings ticket)
    // {
    //     bookings.add(ticket);
    // }
    // public List<Bookings> getBookings()
    // {
    //     return bookings;
    // }
}
