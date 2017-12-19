import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class RostersTests {

	public static void main(String[] args) {
		Player a = Players.make("a");
		Player b = Players.make("b");
		Player c = Players.make("c");
		Player d = Players.make("d");
		Player e = Players.make("e");
		List<Player> playerList1 = new ArrayList<Player>();
		Collections.addAll(playerList1, a, b, c);
		List<Player> playerList2 = new ArrayList<Player>();
		Collections.addAll(playerList2, c, a);
		Roster r1 = new Rosters(playerList1);
		Roster r2 = new Rosters(playerList2);
		Roster r3 = new Rosters(playerList1);
		
		// test for empty()
		Roster rempty = Rosters.empty();
		checkTrue(rempty.equals(r1.without(a).without(b).without(c)), "both the rosters are empty");
		Roster rosterempty = Rosters.empty();

		// tests for with, without and size
		checkTrue(r1.with(d).with(d).equals(r1.with(d)), "calling with method twice");
		checkTrue(r1.with(e).has(e), "roster has player e");
		checkFalse(r1.without(b).has(b), "roster does not have player b");
		checkFalse(r1.without(e).has(e), "roster does not have player e");
		checkTrue(r1.size()==3, "size of roster is 3");
		
		// tests for readyCount and readyRoster
		b.changeInjuryStatus(true);
		checkTrue(r1.readyCount()==2, "player a is not available");
		checkTrue(r1.readyRoster().equals(r2), "both rosters should be equal");
		
		// tests for iterator
		Iterator<Player> itr = r1.iterator();
		checkTrue(itr.hasNext());
		checkTrue(itr.next().equals(a));
		checkTrue(itr.next().name()=="b");
		checkTrue(itr.next()==c);
		checkFalse(itr.hasNext());
		
		// tests for hashCode and equals
		checkFalse(r1.equals(r2));
		playerList2.add(b);
		checkTrue(r1.equals(r2), "both the rosters are equal");
		playerList2.add(e);
		checkFalse(r1.equals(r2), "both the rosters are not equal");
		checkTrue(r1.hashCode()==r3.hashCode());
		checkFalse(r1.hashCode()==r2.hashCode());
		checkFalse(rempty.hashCode()==rosterempty.with(a).hashCode());
		
		// test for toString
		checkTrue(rempty.toString().equals(rosterempty.toString()));
		checkTrue(r1.toString().equals(r3.toString()));
		
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
