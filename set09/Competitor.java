// A Competitor is an object of any class that implements Competitor
//
// Interpretation: the competitor represents an individual or team
//     that may have engaged in one or more contests

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.

import java.util.List;

interface Competitor {

    // returns the name of this competitor

    String name ();

    // GIVEN: another competitor and a list of outcomes
    // RETURNS: true iff one or more of the outcomes indicates this
    //     competitor has defeated or tied the given competitor

    boolean hasDefeated (Competitor c2, List<Outcome> outcomes);

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that are outranked by this competitor,
    //     without duplicates, in alphabetical order

    List<String> outranks (List<Outcome> outcomes);

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that outrank this competitor,
    //     without duplicates, in alphabetical order

    List<String> outrankedBy (List<Outcome> outcomes);

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     one or more of the outcomes, without repetitions, with
    //     the name of competitor A coming before the name of
    //     competitor B in the list if and only if the power-ranking
    //     of A is higher than the power ranking of B.

    List<String> powerRanking (List<Outcome> outcomes);
}
