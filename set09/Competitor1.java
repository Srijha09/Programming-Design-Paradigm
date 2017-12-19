
// Constructor template for Competitor1:
//     new Competitor1 (String s)
//
// Interpretation: the competitor represents an individual or team

import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;

class Competitor1 implements Competitor {
	// c1 is the name of this competitor
	private String c1;

	Competitor1(String s) {
		this.c1 = s;
	}

	// returns the name of this competitor

	public String name() {
		return this.c1;
	}

	// ***********************************************************************//

	// GIVEN: another competitor and a list of outcomes
	// RETURNS: true iff one or more of the outcomes indicates this
	// competitor has defeated or tied the given competitor
	// EXAMPLE: new Competitor1("A").hasDefeated(new Competitor1("B"), [new
	// 			Defeat1(A,B)]) => true

	public boolean hasDefeated(Competitor c2, List<Outcome> outcomes) {
		Boolean defeated, tied;
		Competitor c1 = new Competitor1(this.c1);

		for (int i = 0; i < outcomes.size(); i++) {
			// checks if outcome is defeat AND c1 has defeated c2
			defeated = checkDefeated(c1, c2, outcomes.get(i));
			// checks if outcome is tie AND c1 has tied with c2
			tied = checkTied(c1, c2, outcomes.get(i));

			if (defeated || tied)
				return true;
		}
		return false;
	}

	// ***********************************************************************//

	// GIVEN: a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// the outcomes that are outranked by this competitor,
	// without duplicates, in alphabetical order
	// EXAMPLE: new Competitor1("A").outranks([new Defeat1(C, B), 
	// 			new Defeat1(B,A), new Defeat1(A, C), 
	//			new Tie1(B, C)]) => ["A","B","C"]

	public List<String> outranks(List<Outcome> outcomes) {
		List<String> outrankList = new ArrayList<String>();
		List<Outcome> tempoutcomes = new ArrayList<Outcome>(outcomes);

		outrankList = getOutranks(tempoutcomes);

		outrankList = outrankList.stream().distinct()
				.collect(Collectors.toList());
		outrankList = outrankList.stream().sorted()
				.collect(Collectors.toList());

		return outrankList;
	}

	
	// GIVEN: a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// the outcomes that are outranked by this competitor,
	// with duplicates, and not in alphabetical order

	public List<String> getOutranks(List<Outcome> outcomes) {
		// stores the name of competitors outranked by
		// this competitor
		List<String> outrankList = new ArrayList<String>();
		List<Outcome> tempOutcomes = new ArrayList<Outcome>(outcomes);
		Competitor c = new Competitor1(this.c1);

		// adds the competitors directly defeated or tied by this competitor
		outrankList = directlyDefeated(c, tempOutcomes);
		outcomes = tempOutcomes;

		// adds the competitors indirectly defeated or tied by this competitor
		for (int i = 0; i < outrankList.size(); i++) {
			for (int j = 0; j < outcomes.size(); j++) {
				if (!outcomes.get(j).isTie()) {
					if (outrankList.get(i)
							.equals(outcomes.get(j).first().name())) {
						outrankList.add(outcomes.get(j).second().name());
						outcomes.remove(j);
						j--;
					}
				} else if (outcomes.get(j).isTie()) {
					if (outrankList.get(i)
							.equals(outcomes.get(j).first().name())) {
						outrankList.add(outcomes.get(j).second().name());
						outcomes.remove(j);
						j--;
					} else if (outrankList.get(i)
							.equals(outcomes.get(j).second().name())) {
						outrankList.add(outcomes.get(j).first().name());
						outcomes.remove(j);
						j--;
					}
				}
			}
		}
		return outrankList;
	}

	
	// ***********************************************************************//

	// GIVEN: a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// the outcomes that outrank this competitor,
	// without duplicates, in alphabetical order
	// EXAMPLE: new Competitor1("A").outrankedBy([new Defeat1(C, B), new
	// 			Defeat1(B, A)]) => ["B","C"]

	public List<String> outrankedBy(List<Outcome> outcomes) {
		List<String> outrankedByList = new ArrayList<String>();
		List<Outcome> tempoutcomes = new ArrayList<Outcome>(outcomes);

		outrankedByList = getOutrankedBy(tempoutcomes);

		outrankedByList = outrankedByList.stream().distinct()
				.collect(Collectors.toList());
		outrankedByList = outrankedByList.stream().sorted()
				.collect(Collectors.toList());

		return outrankedByList;
	}

	
	// GIVEN: a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// the outcomes that outrank this competitor,
	// with duplicates, not in alphabetical order
	// EXAMPLE: new Competitor1("A").outrankedBy([new Defeat1(C, B), new
	// 			Defeat1(B, A)]) => ["C","B"]

	private List<String> getOutrankedBy(List<Outcome> outcomes) {
		List<String> outrankedByList = new ArrayList<String>();
		List<Outcome> tempOutcomes = new ArrayList<Outcome>(outcomes);
		Competitor c = new Competitor1(this.c1);

		// adds the competitors that directly defeat or tie this competitor
		outrankedByList = directlyDefeats(c, tempOutcomes);
		outcomes = tempOutcomes;

		// adds the competitors that indirectly defeat or tie this competitor
		for (int i = 0; i < outrankedByList.size(); i++) {
			for (int j = 0; j < outcomes.size(); j++) {
				if (!outcomes.get(j).isTie()) {
					if (outrankedByList.get(i)
							.equals(outcomes.get(j).second().name())) {
						outrankedByList.add(outcomes.get(j).first().name());
						outcomes.remove(j);
						j--;
					}
				} else if (outcomes.get(j).isTie()) {
					if (outrankedByList.get(i)
							.equals(outcomes.get(j).first().name())) {
						outrankedByList.add(outcomes.get(j).second().name());
						outcomes.remove(j);
						j--;
					} else if (outrankedByList.get(i)
							.equals(outcomes.get(j).second().name())) {
						outrankedByList.add(outcomes.get(j).first().name());
						outcomes.remove(j);
						j--;
					}
				}
			}
		}
		return outrankedByList;
	}

	
	// ***********************************************************************//

	// GIVEN: a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// one or more of the outcomes, without repetitions, with
	// the name of competitor A coming before the name of
	// competitor B in the list if and only if the power-ranking
	// of A is higher than the power ranking of B.
	// EXAMPLE: new Competitor1("A").powerRanking([new Defeat1(B,C),
	// new Defeat1(C,B), new Tie1(A,B), new Tie1(A,C),
	// new Defeat1(C,A)]) => ["C", "A", "B"]

	public List<String> powerRanking(List<Outcome> outcomes) {
		List<String> allCompNameList = new ArrayList<String>();
		allCompNameList = allCompetitors(outcomes);

		return (insertionSort(allCompNameList, outcomes));
	}

	
	// GIVEN: a list of names of all the competitors and a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// one or more of the outcomes, without repetitions, with
	// the name of competitor A coming before the name of
	// competitor B in the list if and only if the power-ranking
	// of A is higher than the power ranking of B.
	// EXAMPLE: insertionSort(["A", "B", "C"],
	// 			[new Defeat1(B,C), new Defeat1(C,B), new Tie1(A,B), 
	//			new Tie1(A,C), new Defeat1(C,A)]) => ["C", "A", "B"]

	private List<String> insertionSort(List<String> compNameList,
			List<Outcome> outcomes) {

		// converts the list of competitor names into a list of competitors
		List<Competitor> compList = new ArrayList<Competitor>();
		for (int i = 0; i < compNameList.size(); i++) {
			Competitor x = new Competitor1(compNameList.get(i));
			compList.add(x);
		}

		// performs insertion sort
		for (int i = 1; i < compList.size(); i++) {
			Competitor tmp = compList.get(i);
			int j = i;

			while ((j > 0)
					&& powerRankingTest((compList.get(j - 1)), tmp, outcomes)) {
				compList.set(j, compList.get(j - 1));
				j--;
			}
			compList.set(j, tmp);
		}

		List<String> sortedList = new ArrayList<String>();
		// converts the list of competitors into a list of competitor names
		for (int i = 0; i < compList.size(); i++) {
			sortedList.add(compList.get(i).name());
		}
		return sortedList;
	}

	
	public static void main(String[] args) {
		// Test cases
		Competitor1Tests.main(args);
	}

	// ***********************************************************************//

	// HELPER FUNCTIONS: //

	// GIVEN: a String c1, a competitor c2 and an outcome o
	// RETURNS: true iff the outcome o indicates that the competitor with name
	// as given string c1 has defeated the given competitor c2
	// EXAMPLE: checkTied(A, new Competitor1("B"), new Defeat1(A, new
	// 			Competitor1("B"))) => true

	private boolean checkDefeated(Competitor c1, Competitor c2, Outcome o) {
		return ((!(o.isTie())) && (o.winner().name().equals(c1.name()))
				&& (o.loser().name().equals(c2.name())));
	}

	
	// GIVEN: a String c1, a competitor c2 and an outcome o
	// RETURNS: true iff the outcome o indicates that the competitor with name
	// as given string c1 has tied the given competitor c2
	// EXAMPLE: checkTied(A, new Competitor1("B"), new Tie1(A, new
	// 			Competitor1("B"))) => true

	private boolean checkTied(Competitor c1, Competitor c2, Outcome o) {
		return (o.isTie() && (((o.first().name().equals(c1.name()))
				&& (o.second().name().equals(c2.name())))
				|| ((o.second().name().equals(c1.name()))
						&& (o.first().name().equals(c2.name())))));
	}

	
	// GIVEN: a competitor c and a list of outcomes
	// RETURNS: a list of names of all competitors that are direcly defeated by
	// the given competitor c
	// EXAMPLE: direcltyDefeated(new Competitor("A"), 
	//			[Defeat1(A,B), Tie1(A,C), Defeat1(B,D)]) => ["B", "C"]

	private List<String> directlyDefeated(Competitor c,
			List<Outcome> outcomes) {
		List<String> directlyDefeatedList = new ArrayList<String>();

		for (int i = 0; i < outcomes.size(); i++) {
			if (!outcomes.get(i).isTie()) {
				if (outcomes.get(i).first().name().equals(c.name())) {
					directlyDefeatedList.add(outcomes.get(i).second().name());
					outcomes.remove(i);
					i--;
				}
			} else if (outcomes.get(i).first().name().equals(c.name())
					|| outcomes.get(i).second().name().equals(c.name())) {
				directlyDefeatedList.add(outcomes.get(i).first().name());
				directlyDefeatedList.add(outcomes.get(i).second().name());
				outcomes.remove(i);
				i--;
			}
		}
		return directlyDefeatedList;
	}

	
	// GIVEN: a competitor c and a list of outcomes
	// RETURNS: a list of names of all competitors that direcly defeat
	// given competitor c
	// EXAMPLE: direcltyDefeats(new Competitor("A"),
	//			[Defeat1(A,B), Tie1(A,C), Defeat1(D,A)]) => ["C", "D"]

	private List<String> directlyDefeats(Competitor c, List<Outcome> outcomes) {
		List<String> directlyDefeatsList = new ArrayList<String>();
		for (int i = 0; i < outcomes.size(); i++) {
			if (!outcomes.get(i).isTie()) {
				if (outcomes.get(i).loser().name().equals(c.name())) {
					directlyDefeatsList.add(outcomes.get(i).winner().name());
					outcomes.remove(i);
					i--;
				}
			} else {
				if (outcomes.get(i).first().name().equals(c.name())
						|| outcomes.get(i).second().name().equals(c.name())) {
					directlyDefeatsList.add(outcomes.get(i).first().name());
					directlyDefeatsList.add(outcomes.get(i).second().name());
					outcomes.remove(i);
					i--;
				}
			}
		}
		return directlyDefeatsList;
	}

	
	// GIVEN: a list of outcomes
	// RETURNS: a list of names of all the comopetitors in the given list of
	// outcomes, without duplicates, in alphabetical order
	// EXAMPLE: allCompetitors([Defeat1(A, B), Tie1(B, C), Defeat1(B, D)])
	// => ["A", "B", "C", "D"]

	private List<String> allCompetitors(List<Outcome> outcomes) {
		List<String> complist = new ArrayList<String>();
		for (int i = 0; i < outcomes.size(); i++) {
			complist.add(outcomes.get(i).first().name());
			complist.add(outcomes.get(i).second().name());
		}
		complist = complist.stream().distinct().collect(Collectors.toList());
		complist = complist.stream().sorted().collect(Collectors.toList());
		return complist;
	}

	
	// GIVEN: two competitors c1 and c2, and a list of outcomes
	// RETURNS: true iff the the power-ranking of Competitor c1 is
	// higher than the power ranking of Competitor c2.

	private Boolean powerRankingTest(Competitor c1, Competitor c2,
			List<Outcome> outcomes) {
		return ((c1.outrankedBy(outcomes).size() > c2.outrankedBy(outcomes)
				.size())
				|| (((c1.outrankedBy(outcomes).size() == c2
				.outrankedBy(outcomes).size()))
						&& (c1.outranks(outcomes).size() < c2.outranks(outcomes)
								.size()))
				|| ((((c1.outrankedBy(outcomes).size() == c2
				.outrankedBy(outcomes).size()))
						&& (c1.outranks(outcomes).size() == c2
						.outranks(outcomes).size()))
						&& (nonLosingPercentage(c1,
								outcomes) < (nonLosingPercentage(c2,
										outcomes))))
				|| ((((c1.outrankedBy(outcomes).size() == c2
				.outrankedBy(outcomes).size()))
						&& (c1.outranks(outcomes).size() == c2
						.outranks(outcomes).size()))
						&& (nonLosingPercentage(c1,
								outcomes) == (nonLosingPercentage(c2,
										outcomes)))
						&& ((c1.name().compareTo(c2.name()) > 0))));
	}

	
	// GIVEN: a competitor and a list of outcomes
	// RETURNS: the number of times competitor c has been mentioned in the
	// given list of outcomes
	// EXAMPLE: mentionCount(B, [Defeat1(A, B), Tie1(B, C), Defeat1(B, D)])
	// => 3

	private Float mentionCount(Competitor c, List<Outcome> outcomes) {
		Float count = (float) 0;
		for (int i = 0; i < outcomes.size(); i++) {
			if (outcomes.get(i).first().name().equals(c.name())
					|| outcomes.get(i).second().name().equals(c.name()))
				count++;
		}
		return count;
	}

	
	// GIVEN: a competitor and a list of outcomes
	// RETURNS: the number of times competitor c defeats or ties another
	// competitor in the given list of outcomes
	// EXAMPLE: defeatTieCount(B, [Defeat1(A, B), Tie1(B, C), Defeat1(B, D)])
	// => 2

	private Float defeatTieCount(Competitor c, List<Outcome> outcomes) {
		Float count = (float) 0;
		for (int i = 0; i < outcomes.size(); i++) {
			if (!outcomes.get(i).isTie()
					&& outcomes.get(i).first().name().equals(c.name()))
				count++;
			else if (outcomes.get(i).isTie()) {
				if (outcomes.get(i).first().name().equals(c.name())
						|| outcomes.get(i).second().name().equals(c.name()))
					count++;
			}
		}
		return count;
	}

	
	// GIVEN: a competitor and a list of outcomes
	// RETURNS: the non-losing percentage for the given competitor c

	private Float nonLosingPercentage(Competitor c, List<Outcome> outcomes) {
		return(defeatTieCount(c, outcomes) / mentionCount(c, outcomes));
	}

}
