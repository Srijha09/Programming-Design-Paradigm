import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;

//This class defines a main method for testing the RosterWithStreams class,
//which implements the RosterWithStream interface.

public class TestRosterWithStream {

	public static void main(String[] args) {
		Player a = Players.make("a");
		Player b = Players.make("b");
		Player c = Players.make("c");
		Player d = Players.make("d");
		Player e = Players.make("e");
		RosterWithStream rosterempty = RosterWithStreams.empty();

		// test for empty()
		RosterWithStream r1 = rosterempty.with(a).without(a);
		checkTrue(rosterempty.equals(r1), "both the rosters are empty");

		// tests for with, without and size
		checkTrue(rosterempty.with(d).with(d).equals(rosterempty.with(d)),
				"calling with method twice");
		checkTrue(rosterempty.with(e).has(e), "roster has player e");
		checkFalse(rosterempty.without(b).has(b),
				"roster does not have player b");
		checkTrue(rosterempty.with(a).with(b).with(c).size() == 3,
				"size of roster is 3");

		// tests for readyCount and readyRoster
		b.changeInjuryStatus(true);
		checkTrue(rosterempty.with(a).with(b).with(c).readyCount() == 2,
				"player b is not available");
		checkTrue(rosterempty.with(a).with(b).with(c).readyRoster()
				.equals(r1.with(a).with(c)), "both rosters should be equal");

		// tests for iterator
		Iterator<Player> itr = rosterempty.with(a).with(b).with(c).iterator();
		checkTrue(itr.hasNext());
		checkTrue(itr.next().equals(a));
		checkTrue(itr.next().name() == "b");
		checkTrue(itr.next() == c);
		checkFalse(itr.hasNext());

		// tests for hashCode and equals
		checkTrue(rosterempty.equals(rosterempty));
		checkFalse(rosterempty.equals(a));
		checkFalse(rosterempty.with(a).equals(r1.with(b)),
				"both rosters are not equal");
		checkTrue(rosterempty.hashCode() == r1.hashCode(),
				"both the rosters are empty");
		checkFalse(rosterempty.with(c).hashCode() == r1.with(d).hashCode(),
				"rosters with different players");
		checkFalse(rosterempty.hashCode() == r1.with(a).hashCode(),
				"empty roster and non empty roster");

		// test for toString
		checkTrue(
				rosterempty.with(a).with(a).toString()
						.equals(r1.with(a).toString()),
				"toString returned unexpected result");
		checkFalse(
				rosterempty.with(b).toString()
						.equals(rosterempty.with(c).toString()),
				"toString returned unexpected result");

		RosterWithStream r = RosterWithStreams.empty();
		// Predicates for testing stream
		Predicate<Player> availability = p -> p.available();
		Predicate<Player> unavailability = p -> !p.available();

		// TESTS FOR STREAM

		// tests for allMatch
		b.changeInjuryStatus(true);
		checkTrue(r.with(a).with(c).with(d).stream().allMatch(availability),
				"all the players are available");
		checkFalse(r.with(a).with(b).with(d).stream().allMatch(availability),
				"player b is not available");

		// tests for anyMatch
		checkFalse(r.with(a).with(c).with(d).stream().anyMatch(unavailability),
				"all the players are available");
		checkTrue(r.with(a).with(b).with(d).stream().anyMatch(unavailability),
				"player b is not available");

		// tests for count
		checkTrue(r.with(a).with(b).stream().count() == 2,
				"roster has 2 players");
		checkFalse(r.with(a).with(b).with(c).stream().count() == 2,
				"roster does not have 2 players");

		// test for distinct	
		List<Player> distinctPlayers = r.with(a).with(a).with(b).stream()
				.distinct().collect(Collectors.toList());
		List<Player> testDistinct = r.with(a).with(a).with(b).stream().collect(Collectors.toList());
		checkTrue(distinctPlayers.toString().equals(testDistinct.toString()),
				"distinct returned unexpected result");

		// tests for filter
		checkTrue(r.with(a).with(b).with(c).stream().filter(availability)
				.count() == 2, "player a and player b are available");
		checkTrue(r.with(a).with(b).with(c).stream().filter(unavailability)
				.count() == 1, "only player b is unavailable");

		// test for findAny
		Optional<Player> optionalA = Optional.of(a);
		checkTrue(
				r.with(a).with(c).with(d).stream().findAny().equals(optionalA),
				"findAny returned unexpected result");

		// test for findFirst
		Optional<Player> optionalC = Optional.of(c);
		checkTrue(
				r.with(e).with(c).with(d).stream().findFirst()
						.equals(optionalC),
				"player c is the first element in the stream");

		// tests for forEach
		r.with(a).with(c).with(d).stream()
				.forEach(p -> p.changeInjuryStatus(true));
		checkTrue(r.with(a).with(c).with(d).stream().allMatch(unavailability),
				"forEach returned unexpected result");

		r.with(a).with(c).with(d).stream()
				.forEach(p -> p.changeInjuryStatus(false));
		checkFalse(r.with(a).with(c).with(d).stream().allMatch(unavailability),
				"forEach returned unexpected result");

		// tests for map
		List<String> playerNames = r.with(a).with(c).with(d).stream()
				.map(p -> p.name()).collect(Collectors.toList());
		List<String> test = new ArrayList<String>();
		Collections.addAll(test, "a", "c", "d");

		checkTrue(playerNames.equals(test), "map returned unexpected result");

		// test for reduce
		String names = r.with(a).with(b).with(c).stream().map(p -> p.name())
				.reduce("", String::concat);
		String nameTest = "abc";
		checkTrue(names.equals(nameTest));

		// test for skip
		List<Player> skip2Players = r.with(a).with(c).with(d).stream().skip(2)
				.collect(Collectors.toList());
		List<Player> skip3Players = r.with(a).with(c).with(b).with(d).stream()
				.skip(3).collect(Collectors.toList());
		checkTrue(skip2Players.equals(skip3Players));

		// test for toArray
		Player[] roster1 = r.with(a).with(c).with(d).stream()
				.toArray(Player[]::new);
		for (Player p : roster1) {
			checkTrue(r.with(a).with(c).with(d).has(p));
		}

		summarize();
	}

	// testsPassed stores the total number of tests passed
	private static int testsPassed = 0;
	// testsFailed stores the total number of tests failed
	private static int testsFailed = 0;

	private static final String FAILED = "    TEST FAILED: ";

	// GIVEN: a Boolean result
	// RETURNS: increments the number of tests passed if
	// result is true; otherwise prints an error with
	// error name as anonymous
	static void checkTrue(boolean result) {
		checkTrue(result, "anonymous");
	}

	// GIVEN: a Boolean result and a String name
	// RETURNS: increments the number of tests passed if
	// result is true; otherwise prints an error with
	// name
	static void checkTrue(boolean result, String name) {
		if (result)
			testsPassed = testsPassed + 1;
		else {
			testsFailed = testsFailed + 1;
			System.err.println(FAILED + name);
		}
	}

	// GIVEN: a Boolean result
	// RETURNS: increments the number of tests passed if
	// result is true; otherwise prints an error with
	// error name as anonymous
	static void checkFalse(boolean result) {
		checkFalse(result, "anonymous");
	}

	// GIVEN: a Boolean result and a String name
	// RETURNS: increments the number of tests passed if
	// result is true; otherwise prints an error with
	// name
	static void checkFalse(boolean result, String name) {
		checkTrue(!result, name);
	}

	// RETURNS: prints the total number of tests passed and failed (if any)
	static void summarize() {
		System.err.println("Passed " + testsPassed + " tests");
		if (testsFailed > 0) {
			System.err.println("Failed " + testsFailed + " tests");
		}
	}
}
