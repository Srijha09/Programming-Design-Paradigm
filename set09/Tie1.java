// Constructor template for Tie1:
//     new Tie1 (Competitor c1, Competitor c2)
// Interpretation:
//     c1 and c2 have engaged in a contest that ended in a tie

public class Tie1 implements Outcome {
	
	// c1 and c2 are the two competitors in this Tie Outcome
	private Competitor c1, c2;


	Tie1(Competitor c1, Competitor c2) {
		this.c1 = c1;
		this.c2 = c2;
	}

	// RETURNS: true iff this outcome represents a tie

	public boolean isTie() {
		return true;
	}

	// RETURNS: one of the competitors

	public Competitor first() {
		return this.c1;
	}

	// RETURNS: the other competitor

	public Competitor second() {
		return this.c2;
	}

	// GIVEN: no arguments
	// WHERE: this.isTie() is false
	// RETURNS: the winner of this outcome

	public Competitor winner() {
		throw new UnsupportedOperationException();
	}

	// GIVEN: no arguments
	// WHERE: this.isTie() is false
	// RETURNS: the loser of this outcome

	public Competitor loser() {
		throw new UnsupportedOperationException();
	}

	public static void main(String[] args) {
		// Test cases
		Tie1Tests.main(args);
	}
}
