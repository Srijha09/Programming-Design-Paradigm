
// This class defines a main method for testing the Competitor1 class,
// which implements the Competitor interface.

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class Competitor1Tests {
	public static void main(String[] args) {

		// Competitors used in test cases
		Competitor a = new Competitor1("A");
		Competitor b = new Competitor1("B");
		Competitor c = new Competitor1("C");
		Competitor d = new Competitor1("D");
		Competitor e = new Competitor1("E");
		Competitor f = new Competitor1("F");
		Competitor g = new Competitor1("G");
		Competitor h = new Competitor1("H");
		Competitor i = new Competitor1("I");
		Competitor j = new Competitor1("J");
		Competitor k = new Competitor1("K");
		Competitor l = new Competitor1("L");
		Competitor m = new Competitor1("M");
		Competitor n = new Competitor1("N");
		Competitor o = new Competitor1("O");
		Competitor p = new Competitor1("P");
		Competitor q = new Competitor1("Q");
		Competitor r = new Competitor1("R");
		Competitor s = new Competitor1("S");
		Competitor t = new Competitor1("T");
		Competitor u = new Competitor1("U");
		Competitor v = new Competitor1("V");
		Competitor w = new Competitor1("W");
		Competitor x = new Competitor1("X");
		Competitor y = new Competitor1("Y");
		Competitor z = new Competitor1("Z");

		// List of outcomes used in test cases
		List<Outcome> outcomes = new ArrayList<Outcome>();
		Collections.addAll(outcomes, new Defeat1(a, b), new Tie1(b, c),
				new Defeat1(c, d), new Tie1(d, e), new Defeat1(e, h),
				new Tie1(f, i), new Tie1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Tie1(j, n), new Defeat1(k, o),
				new Tie1(l, p), new Defeat1(m, k), new Tie1(n, l),
				new Defeat1(o, a), new Tie1(p, b), new Tie1(c, e),
				new Tie1(j, p));

		List<Outcome> defeatedolist = new ArrayList<Outcome>();
		Collections.addAll(defeatedolist, new Defeat1(a, b), new Tie1(b, c));

		// *******************************************************************//

		// test for name()
		checkTrue(a.name() == "A", "name Test #1");
		checkFalse(b.name() == "A", "name Test #2");

		// test for hasDefeated()
		checkTrue(a.hasDefeated(b, defeatedolist), "hasDefeated Test#1");
		checkFalse(a.hasDefeated(c, defeatedolist), "hasDefeated Test#2");
		checkTrue(b.hasDefeated(c, defeatedolist), "hasDefeated Test#3");

		// *******************************************************************//

		// Lists of outcomes and lists of Strings used in test cases

		// Outranks Test #3
		List<Outcome> outranks3 = new ArrayList<Outcome>();
		Collections.addAll(outranks3, new Defeat1(c, b), new Defeat1(b, a),
				new Defeat1(a, c), new Tie1(b, c));
		List<String> outranksResult3 = new ArrayList<String>();
		Collections.addAll(outranksResult3, "A", "B", "C");

		// Outranks Test #4
		List<Outcome> outranks4 = new ArrayList<Outcome>();
		Collections.addAll(outranks4, new Defeat1(c, b), new Defeat1(a, c),
				new Tie1(b, d));
		List<String> outranksResult4 = new ArrayList<String>();
		Collections.addAll(outranksResult4, "B", "C", "D");

		// Outranks Test #5
		List<Outcome> outranks5 = new ArrayList<Outcome>();
		Collections.addAll(outranks5, new Defeat1(c, e), new Defeat1(b, c),
				new Tie1(b, d), new Tie1(d, b));

		// Outranks Test #6
		List<Outcome> outranks6 = new ArrayList<Outcome>();
		Collections.addAll(outranks6, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Tie1(a, e));
		List<String> outranksResult6 = new ArrayList<String>();
		Collections.addAll(outranksResult6, "A", "B", "C", "D", "E");

		// OutrankedBy Test #7
		List<Outcome> outrankedBy7 = new ArrayList<Outcome>();
		Collections.addAll(outrankedBy7, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Tie1(c, e));
		List<String> outrankedByResult7 = new ArrayList<String>();
		Collections.addAll(outrankedByResult7, "A", "B", "C", "D", "E");

		// OutrankedBy Test #9
		List<Outcome> outrankedBy9 = new ArrayList<Outcome>();
		Collections.addAll(outrankedBy9, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Defeat1(e, h),
				new Defeat1(f, i), new Defeat1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Defeat1(j, n), new Defeat1(k, o),
				new Defeat1(l, p), new Defeat1(m, k), new Defeat1(n, l),
				new Defeat1(o, a), new Defeat1(p, b), new Tie1(c, e));

		// Outranks Test #10
		List<Outcome> outranks10 = new ArrayList<Outcome>();
		Collections.addAll(outranks10, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Defeat1(e, h),
				new Defeat1(f, i), new Defeat1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Defeat1(j, n), new Defeat1(k, o),
				new Defeat1(l, p), new Defeat1(m, k), new Defeat1(n, l),
				new Defeat1(o, a), new Defeat1(p, b), new Tie1(c, e));
		List<String> outranksResult10 = new ArrayList<String>();
		Collections.addAll(outranksResult10, "A", "B", "C", "D", "E", "H", "I",
				"K", "L", "M", "O", "P");

		// OutrankedBy Test #11
		List<Outcome> outrankedBy11 = new ArrayList<Outcome>();
		Collections.addAll(outrankedBy11, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Defeat1(e, h),
				new Defeat1(f, i), new Defeat1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Defeat1(j, n), new Defeat1(k, o),
				new Defeat1(l, p), new Defeat1(m, k), new Defeat1(n, l),
				new Defeat1(o, a), new Defeat1(p, b), new Tie1(c, e),
				new Tie1(j, p));
		List<String> outrankedByResult11 = new ArrayList<String>();
		Collections.addAll(outrankedByResult11, "A", "B", "C", "D", "E", "F",
				"G", "H", "I", "J", "K", "L", "M", "N", "O", "P");

		// Outranks Test #12
		List<Outcome> outranks12 = new ArrayList<Outcome>();
		Collections.addAll(outranks12, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Defeat1(e, h),
				new Defeat1(f, i), new Defeat1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Defeat1(j, n), new Defeat1(k, o),
				new Defeat1(l, p), new Defeat1(m, k), new Defeat1(n, l),
				new Defeat1(o, a), new Defeat1(p, b), new Tie1(c, e),
				new Tie1(j, p));
		List<String> outranksResult12 = new ArrayList<String>();
		Collections.addAll(outranksResult12, "B", "C", "D", "E", "H", "J", "L",
				"N", "P");

		// OutrankedBy Test #13
		List<Outcome> outrankedBy13 = new ArrayList<Outcome>(outcomes);
		List<String> outrankedByResult13 = new ArrayList<String>();
		Collections.addAll(outrankedByResult13, "F", "I");

		// Outranks Test #14
		List<Outcome> outranks14 = new ArrayList<Outcome>(outcomes);
		List<String> outranksResult14 = new ArrayList<String>();
		Collections.addAll(outranksResult14, "A", "B", "C", "D", "E", "F", "G",
				"H", "I", "J", "K", "L", "M", "N", "O", "P");

		// Outranks Test #16
		List<Outcome> outranks16 = new ArrayList<Outcome>(outcomes);
		List<String> outranksResult16 = new ArrayList<String>();
		Collections.addAll(outranksResult16, "B", "C", "D", "E", "H", "J", "L",
				"N", "P");

		// *******************************************************************//

		// tests for outranks()
		checkTrue(a.outranks(outranks3).equals(outranksResult3), "Test #3");
		checkTrue(a.outranks(outranks4).equals(outranksResult4), "Test #4");
		checkTrue(e.outranks(outranks5).equals(Collections.EMPTY_LIST),
				"Test #5");
		checkTrue(a.outranks(outranks6).equals(outranksResult6), "Test #6");
		checkTrue(f.outranks(outranks10).equals(outranksResult10), "Test #10");
		checkTrue(e.outranks(outranks12).equals(outranksResult12), "Test #12");
		checkTrue(f.outranks(outranks14).equals(outranksResult14), "Test #14");
		checkTrue(e.outranks(outranks16).equals(outranksResult16), "Test #16");

		// tests for outrankedBy()
		checkTrue(c.outrankedBy(outrankedBy7).equals(outrankedByResult7),
				"Test #7");
		checkTrue(a.outrankedBy(outrankedBy7).equals(Collections.EMPTY_LIST),
				"Test #7");
		checkTrue(f.outrankedBy(outrankedBy9).equals(Collections.EMPTY_LIST),
				"Test #9");
		checkTrue(e.outrankedBy(outrankedBy11).equals(outrankedByResult11),
				"Test #11");
		checkTrue(f.outrankedBy(outrankedBy13).equals(outrankedByResult13),
				"Test #13");

		// *******************************************************************//

		// Lists of outcomes and lists of Strings used in test cases

		// PowerRanking Test #1
		List<Outcome> pr1 = new ArrayList<Outcome>();
		Collections.addAll(pr1, new Defeat1(b, c), new Defeat1(c, b),
				new Tie1(a, b), new Tie1(a, c), new Defeat1(c, a));
		List<String> prResult1 = new ArrayList<String>();
		Collections.addAll(prResult1, "C", "A", "B");

		// PowerRanking Test #2
		List<Outcome> pr2 = new ArrayList<Outcome>();
		Collections.addAll(pr2, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Tie1(d, e), new Defeat1(e, h),
				new Tie1(f, i), new Tie1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Tie1(j, n), new Tie1(p, b),
				new Tie1(c, e), new Defeat1(j, p), new Tie1(q, p),
				new Defeat1(r, k), new Tie1(s, l), new Defeat1(t, a),
				new Defeat1(u, b), new Defeat1(v, e), new Defeat1(w, p),
				new Tie1(x, b), new Defeat1(y, e), new Defeat1(z, p));
		List<String> prResult2 = new ArrayList<String>();
		Collections.addAll(prResult2, "T", "U", "W", "Z", "V", "Y", "R", "A",
				"J", "N", "F", "I", "M", "G", "K", "Q", "X", "B", "P", "C", "E",
				"D", "H", "S", "L");

		// PowerRanking Test #3
		List<Outcome> pr3 = new ArrayList<Outcome>();
		Collections.addAll(pr3, new Defeat1(a, b), new Tie1(b, c),
				new Defeat1(c, d), new Tie1(d, e), new Defeat1(e, h),
				new Tie1(f, i), new Defeat1(r, k), new Tie1(s, l),
				new Defeat1(t, a), new Tie1(u, b), new Tie1(v, e),
				new Defeat1(w, p), new Tie1(x, b), new Defeat1(y, e),
				new Tie1(z, p));
		List<String> prResult3 = new ArrayList<String>();
		Collections.addAll(prResult3, "T", "Y", "W", "R", "A", "K", "F", "I",
				"L", "S", "Z", "P", "C", "U", "X", "B", "V", "E", "D", "H");

		// PowerRanking Test #4
		List<Outcome> pr4 = new ArrayList<Outcome>();
		Collections.addAll(pr4, new Defeat1(a, b), new Tie1(b, c),
				new Defeat1(c, d), new Tie1(d, e), new Defeat1(e, h),
				new Tie1(f, i), new Tie1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Tie1(j, n), new Defeat1(k, o),
				new Tie1(l, p), new Defeat1(m, k), new Tie1(n, l),
				new Defeat1(o, a), new Tie1(p, b), new Tie1(c, e),
				new Defeat1(j, p), new Tie1(q, p), new Defeat1(r, k),
				new Tie1(s, l), new Defeat1(t, a), new Tie1(u, b),
				new Tie1(v, e), new Defeat1(w, p), new Tie1(x, b),
				new Defeat1(y, e), new Tie1(z, p));
		List<String> prResult4 = new ArrayList<String>();
		Collections.addAll(prResult4, "R", "T", "W", "Y", "F", "I", "M", "G",
				"K", "O", "A", "C", "J", "N", "Q", "S", "U", "V", "X", "Z", "B",
				"E", "L", "P", "D", "H");

		// PowerRanking Test #5
		List<Outcome> pr5 = new ArrayList<Outcome>();
		Collections.addAll(pr5, new Tie1(b, c), new Tie1(a, b));
		List<String> prResult5 = new ArrayList<String>();
		Collections.addAll(prResult5, "A", "B", "C");

		// PowerRanking Test #6
		List<Outcome> pr6 = new ArrayList<Outcome>();
		Collections.addAll(pr6, new Defeat1(a, b), new Tie1(b, c),
				new Tie1(d, e), new Defeat1(e, h), new Tie1(f, i),
				new Defeat1(h, l), new Defeat1(i, m), new Tie1(j, n),
				new Defeat1(k, o), new Tie1(l, p), new Defeat1(m, k),
				new Tie1(p, b), new Tie1(c, e), new Tie1(j, p));
		List<String> prResult6 = new ArrayList<String>();
		Collections.addAll(prResult6, "A", "F", "I", "M", "K", "O", "C", "D",
				"E", "J", "N", "P", "B", "H", "L");

		// PowerRanking Test #7
		List<Outcome> pr7 = new ArrayList<Outcome>();
		Collections.addAll(pr7, new Tie1(a, b), new Tie1(b, c), new Tie1(c, d),
				new Tie1(d, e), new Tie1(e, h), new Tie1(f, i), new Tie1(g, k),
				new Tie1(h, l), new Tie1(i, m), new Tie1(j, n), new Tie1(k, o),
				new Tie1(l, p), new Tie1(m, k), new Tie1(n, l),
				new Defeat1(o, a), new Tie1(p, b), new Tie1(c, e),
				new Tie1(j, p));
		List<String> prResult7 = new ArrayList<String>();
		Collections.addAll(prResult7, "F", "G", "I", "K", "M", "O", "B", "C",
				"D", "E", "H", "J", "L", "N", "P", "A");

		// PowerRanking Test #8
		List<Outcome> pr8 = new ArrayList<Outcome>();
		Collections.addAll(pr8, new Tie1(a, e), new Defeat1(c, b),
				new Defeat1(b, a), new Defeat1(a, c), new Tie1(b, c));
		List<String> prResult8 = new ArrayList<String>();
		Collections.addAll(prResult8, "E", "A", "B", "C");

		// PowerRanking Test #9
		List<Outcome> pr9 = new ArrayList<Outcome>();
		Collections.addAll(pr9, new Defeat1(c, e), new Defeat1(d, c),
				new Tie1(b, d));
		List<String> prResult9 = new ArrayList<String>();
		Collections.addAll(prResult9, "B", "D", "C", "E");

		// PowerRanking Test #10
		List<Outcome> pr10 = new ArrayList<Outcome>();
		Collections.addAll(pr10, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Tie1(c, e));
		List<String> prResult10 = new ArrayList<String>();
		Collections.addAll(prResult10, "A", "B", "C", "D", "E");

		// PowerRanking Test #11
		List<Outcome> pr11 = new ArrayList<Outcome>();
		Collections.addAll(pr11, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Defeat1(e, h),
				new Defeat1(f, i), new Defeat1(i, m), new Defeat1(m, k),
				new Defeat1(n, l), new Defeat1(o, a), new Defeat1(p, b),
				new Tie1(c, e));
		List<String> prResult11 = new ArrayList<String>();
		Collections.addAll(prResult11, "O", "P", "F", "N", "A", "I", "L", "M",
				"B", "K", "C", "E", "D", "H");

		// PowerRanking Test #12
		List<Outcome> pr12 = new ArrayList<Outcome>();
		Collections.addAll(pr12, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Defeat1(e, h),
				new Defeat1(f, i), new Defeat1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Defeat1(j, n), new Defeat1(k, o),
				new Defeat1(l, p), new Defeat1(m, k), new Defeat1(n, l),
				new Defeat1(o, a), new Defeat1(p, b), new Tie1(c, e));
		List<String> prResult12 = new ArrayList<String>();
		Collections.addAll(prResult12, "F", "G", "J", "I", "N", "M", "K", "O",
				"A", "C", "E", "D", "H", "P", "B", "L");

		// PowerRanking Test #13
		List<Outcome> pr13 = new ArrayList<Outcome>();
		Collections.addAll(pr13, new Defeat1(a, b), new Defeat1(b, c),
				new Defeat1(c, d), new Defeat1(d, e), new Defeat1(e, h),
				new Defeat1(f, i), new Defeat1(g, k), new Defeat1(h, l),
				new Defeat1(i, m), new Defeat1(j, n), new Defeat1(k, o),
				new Defeat1(l, p), new Defeat1(m, k), new Defeat1(n, l),
				new Defeat1(o, a), new Defeat1(p, b), new Tie1(c, e),
				new Tie1(j, p));
		List<String> prResult13 = new ArrayList<String>();
		Collections.addAll(prResult13, "F", "G", "I", "M", "K", "O", "A", "J",
				"C", "E", "P", "D", "H", "N", "B", "L");

		// PowerRanking Test #14
		List<Outcome> pr14 = new ArrayList<Outcome>();
		Collections.addAll(pr14, new Defeat1(a, d), new Defeat1(a, e),
				new Defeat1(c, b), new Defeat1(c, f), new Tie1(d, b),
				new Defeat1(f, e));
		List<String> prResult14 = new ArrayList<String>();
		Collections.addAll(prResult14, "C", "A", "F", "E", "B", "D");

		// PowerRanking Test #15
		List<Outcome> pr15 = new ArrayList<Outcome>(outcomes);
		List<String> prResult15 = new ArrayList<String>();
		Collections.addAll(prResult15, "F", "I", "M", "G", "K", "O", "A", "C",
				"E", "J", "N", "P", "B", "L", "D", "H");

		// *******************************************************************//

		// test for powerRanking()
		checkTrue(a.powerRanking(pr1).equals(prResult1), "PowerRanking Test#1");
		checkTrue(a.powerRanking(pr2).equals(prResult2), "PowerRanking Test#2");
		checkTrue(a.powerRanking(pr3).equals(prResult3), "PowerRanking Test#3");
		checkTrue(a.powerRanking(pr4).equals(prResult4), "PowerRanking Test#4");
		checkTrue(a.powerRanking(pr5).equals(prResult5), "PowerRanking Test#5");
		checkTrue(a.powerRanking(pr6).equals(prResult6), "PowerRanking Test#6");
		checkTrue(a.powerRanking(pr7).equals(prResult7), "PowerRanking Test#7");
		checkTrue(a.powerRanking(pr8).equals(prResult8), "PowerRanking Test#8");
		checkTrue(a.powerRanking(pr9).equals(prResult9), "PowerRanking Test#9");
		checkTrue(a.powerRanking(pr10).equals(prResult10),
				"PowerRanking Test#10");
		checkTrue(a.powerRanking(pr11).equals(prResult11),
				"PowerRanking Test#11");
		checkTrue(a.powerRanking(pr12).equals(prResult12),
				"PowerRanking Test#12");
		checkTrue(a.powerRanking(pr13).equals(prResult13),
				"PowerRanking Test#13");
		checkTrue(a.powerRanking(pr14).equals(prResult14),
				"PowerRanking Test#14");
		checkTrue(a.powerRanking(pr15).equals(prResult15),
				"PowerRanking Test#15");

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