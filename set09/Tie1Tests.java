// This class defines a main method for testing the Tie1 class,
// which implements the Outcome interface.

public class Tie1Tests {

	public static void main(String[] args) {
		// Competitor and Defeat for test cases
		Competitor a = new Competitor1("A");
		Competitor b = new Competitor1("B");
		Tie1 t = new Tie1(a, b);

		// Test for isTie()
		checkTrue(t.isTie(), "Tie(A,B).isTie() should be true");

		// Test for first()
		checkTrue(t.first() == a, "Tie(A,B).first() should be A");
		checkFalse(t.first() == b, "Tie(A,B).first() should not be B");

		// Test for second()
		checkFalse(t.second() == a, "Tie(A,B).second() should not be A");
		checkTrue(t.second() == b, "Tie(A,B).second() should be B");

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
