import java.util.*;
import java.util.stream.Stream;

//Constructor template for RosterWithStream1:
//new RosterWithStream1 (p)
//Interpretation:
//p is the list of players in this roster

public class RosterWithStream1 implements RosterWithStream {
	// list of players in the roster
	private final List<Player> playerList;

	public RosterWithStream1(List<Player> p) {
		this.playerList = p;
	}

	// Returns a roster consisting of the given player together
	// with all players on this roster.
	// Example:
	// r.with(p).with(p) => r.with(p)

	public RosterWithStream with(Player p) {
		List<Player> withPlayerList = new ArrayList<Player>(this.playerList);
		RosterWithStream r = new RosterWithStream1(withPlayerList);

		if (withPlayerList.contains(p)) {
			return r;
		} else {
			withPlayerList.add(p);
			r = new RosterWithStream1(withPlayerList);
			return r;
		}
	}

	// Returns a roster consisting of all players on this roster
	// except for the given player.
	// Examples:
	// RosterWithStreams.empty().without(p) => RosterWithStreams.empty()
	// r.without(p).without(p) => r.without(p)

	public RosterWithStream without(Player p) {
		List<Player> withoutPlayerList = new ArrayList<Player>(this.playerList);
		RosterWithStream r = new RosterWithStream1(withoutPlayerList);

		if (withoutPlayerList.contains(p)) {
			withoutPlayerList.remove(p);
			r = new RosterWithStream1(withoutPlayerList);
			return r;
		}
		return r;
	}

	// Returns true iff the given player is on this roster.
	// Examples:
	//
	// RosterWithStreams.empty().has(p) => false
	//
	// If r is any roster, then
	//
	// r.with(p).has(p) => true
	// r.without(p).has(p) => false

	public boolean has(Player p) {
		return this.playerList.contains(p);
	}

	// Returns the number of players on this roster.
	// Examples:
	//
	// RosterWithStreams.empty().size() => 0
	//
	// If r is a roster with r.size() == n, and r.has(p) is false, then
	//
	// r.without(p).size() => n
	// r.with(p).size() => n+1
	// r.with(p).with(p).size() => n+1
	// r.with(p).without(p).size() => n

	public int size() {
		return this.playerList.size();
	}

	// Returns the number of players on this roster whose current
	// status indicates they are available.

	public int readyCount() {
		int count = 0;
		for (Player p : playerList) {
			if (p.available())
				count++;
		}
		return count;
	}

	// Returns a roster consisting of all players on this roster
	// whose current status indicates they are available.

	public RosterWithStream readyRoster() {
		List<Player> readyPlayers = new ArrayList<Player>();

		for (Player p : playerList) {
			if (p.available())
				readyPlayers.add(p);
		}
		RosterWithStream r = new RosterWithStream1(readyPlayers);
		return r;
	}

	// Returns an iterator that generates each player on this
	// roster exactly once, in alphabetical order by name.

	public Iterator<Player> iterator() {
		List<Player> itrList = new ArrayList<Player>(this.playerList);
		itrList.sort((p1, p2) -> p1.name().compareTo(p2.name()));

		Iterator<Player> itr = itrList.iterator();
		return itr;
	}

	// Returns a sequential Stream with this RosterWithStream
	// as its source.
	// The result of this method generates each player on this
	// roster exactly once, in alphabetical order by name.
	// Examples:
	//
	// RosterWithStreams.empty().stream().count() => 0
	//
	// RosterWithStreams.empty().stream().findFirst().isPresent()
	// => false
	//
	// RosterWithStreams.empty().with(p).stream().findFirst().get()
	// => p
	//
	// this.stream().distinct() => true
	//
	// this.stream().filter((Player p) -> p.available()).count()
	// => this.readyCount()

	public Stream<Player> stream() {
		List<Player> strList = new ArrayList<Player>(this.playerList);
		strList.sort((p1, p2) -> p1.name().compareTo(p2.name()));

		Stream<Player> str = strList.stream();
		return str;
	}

	public static void main(String[] args) {
		TestRosterWithStream.main(args);
	}

	// Returns the same value for a roster even if the status of some players in
	// the roster is changed

	@Override
	public int hashCode() {
		int result = 1;
		for (Player p : playerList) {
			result += p.hashCode();
		}
		return result;
	}

	// Returns true iff every player on this roster is also on roster obj

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof RosterWithStream1) {
			if (this == obj)
				return true;

			RosterWithStream1 other = (RosterWithStream1) obj;
			List<Player> itrList1 = new ArrayList<Player>(this.playerList);
			itrList1.sort((p1, p2) -> p1.name().compareTo(p2.name()));

			List<Player> itrList2 = new ArrayList<Player>(other.playerList);
			itrList2.sort((p1, p2) -> p1.name().compareTo(p2.name()));

			if (itrList1.equals(itrList2))
				return true;
			else
				return false;
		} else
			return false;
	}

	// Returns different strings for two rosters with different sizes

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Roster:[ ");
		for (int i = 0; i < this.playerList.size(); i++) {
			builder.append(this.playerList.get(i).toString() + " ");
		}
		builder.append("]");
		return builder.toString();
	}
}
