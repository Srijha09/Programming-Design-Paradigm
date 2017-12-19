import java.util.ArrayList;
import java.util.List;

public class Rosters extends Roster1 {

	Rosters(List<Player> p) {
		super(p);
	}

	// Returns an empty roster
	
		public static Roster empty() {
			List<Player> p = new ArrayList<Player>();
			Roster r = new Roster1(p);
			return r;
		}

}
