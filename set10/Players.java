

public class Players extends Player1 {
	
	// Constructor
	Players(String n) {
		super(n);
	}

	// Returns a player with the given name n who is (initially) available.

	public static Player make(String n) {
		Player p = new Player1(n);
		return p;
	}

}
