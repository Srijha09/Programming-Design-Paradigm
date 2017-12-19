// An Outcome is an object of any class that implements Outcome
//
// Interpretation: the two competitors have engaged in a contest
//   If this.isTie() is true, the contest ended in a tie.
//   Otherwise the contest did not end in a tie, and
//       this.winner() defeated this.loser()

interface Outcome {

    // RETURNS: true iff this outcome represents a tie

    boolean isTie ();

    // RETURNS: one of the competitors

    Competitor first ();

    // RETURNS: the other competitor

    Competitor second ();

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the winner of this outcome

    Competitor winner ();

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the loser of this outcome

    Competitor loser ();
}
