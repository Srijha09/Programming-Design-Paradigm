import java.util.ArrayList;
import java.util.List;

//RosterWithStreams.empty() is a static factory method that returns a
//RosterWithStream with no players.

public class RosterWithStreams {
	// Returns an empty roster

	public static RosterWithStream empty() {
		List<Player> p = new ArrayList<Player>();
		RosterWithStream r = new RosterWithStream1(p);
		return r;
	}

}
