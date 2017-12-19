// Players.make(String name) is a static factory method that returns
// a player with the given name who is (initially) available.

public class Players{
	// Returns a player with the given name n who is (initially) available.

	public static Player make(String n) {
		Player p = new Player1(n);
		return p;
	}

}
