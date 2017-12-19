// This class defines a main method for testing the Players class,
// which implements the Player interface.

public class PlayersTests {

	public static void main(String[] args) {

		// tests for available
		Player gw = Players.make("Gordon Wayhard");
		checkTrue(gw.available(), "returned incorrect player");
		gw.changeInjuryStatus(true);
		checkFalse(gw.available(), "player is unavailable"
				+ "as the Injury status for this player is true");

		// test for isInjured
		checkTrue(gw.isInjured(), "player is injured");

		// test for isSuspended
		gw.changeSuspendedStatus(true);
		checkTrue(gw.isSuspended(), "player is suspended");


		// test for underContract
		Player ih = Players.make("Isaac Homas");
		Player random = ih;
		checkTrue(ih.underContract(), "player is under contract by default");

		// test for name
		checkTrue(ih.name().equals("Isaac Homas"),
				"name of player is Isaac Homas");

		// tests for underContract
		ih.changeContractStatus(false);
		checkFalse(ih.underContract(), "contract status is false");
		ih.changeContractStatus(true);
		checkTrue(ih.underContract(), "player is under contract");

		// tests for equals
		Player a = Players.make("John Doe");
		Player b = Players.make("John Cena");
		Player c = a;
		Player d = Players.make(null);

		c.changeInjuryStatus(true);
		checkTrue(a.equals(c), "equality also depends on status");

		c.changeInjuryStatus(false);
		checkTrue(a.equals(c), "both players are equal");
		checkFalse(a.equals(b), "players have different names");

		// tests for hashcode
		c.changeContractStatus(false);
		checkTrue(a.hashCode()==c.hashCode(), "players have the same name");
		checkFalse(a.hashCode()==b.hashCode(), "players have different name");
		checkFalse(d.hashCode()==b.hashCode(), "players have different name");
		
		// tests for toString
		checkTrue(gw.toString().equals(gw.toString()));
		checkTrue(ih.toString().equals(random.toString()));

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
