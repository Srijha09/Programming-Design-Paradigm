
public class Player1 implements Player {
	// name of the player
		private String name;
		// booleans to represent if the player is under contract, injured or
		// suspended
		private Boolean underContract, injured, suspended;

	Player1(String n) {
		this.name = n;
		this.underContract = true;
		this.injured = false;
		this.suspended = false;
	}

	// Returns the name of this player.
		// Example:
		// Players.make("Gordon Wayhard").name() => "Gordon Wayhard"

		public String name() {
			return this.name;
		}

		// Returns true iff this player is under contract,
		// and not injured, and not suspended
		// Example:
		// Player gw = Players.make ("Gordon Wayhard");
		// System.out.println (gw.available()); // prints true
		// gw.changeInjuryStatus (true);
		// System.out.println (gw.available()); // prints false

		public boolean available() {
			return (this.underContract && !this.injured && !this.suspended);
		}

		// Returns true iff this player is under contract (employed).
		// Example:
		// Player ih = Players.make ("Isaac Homas");
		// System.out.println (ih.underContract()); // prints true
		// ih.changeContractStatus (false);
		// System.out.println (ih.underContract()); // prints false
		// ih.changeContractStatus (true);
		// System.out.println (ih.underContract()); // prints true

		public boolean underContract() {
			return this.underContract;
		}

		// Returns true iff this player is injured.

		public boolean isInjured() {
			return this.injured;
		}

		// Returns true iff this player is suspended.

		public boolean isSuspended() {
			return this.suspended;
		}

		// Changes the underContract() status of this player
		// to the specified boolean.

		public void changeContractStatus(boolean newStatus) {
			this.underContract = newStatus;
		}

		// Changes the isInjured() status of this player
		// to the specified boolean.

		public void changeInjuryStatus(boolean newStatus) {
			this.injured = newStatus;
		}

		// Changes the isSuspended() status of this player
		// to the specified boolean.

		public void changeSuspendedStatus(boolean newStatus) {
			this.suspended = newStatus;
		}


		// Always returns the same value for a player even after the
		// player's status is changed

		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result + ((name == null) ? 0 : name.hashCode());
			return result;
		}

		// Returns true if and only if this player and obj are the same object

		@Override
		public boolean equals(Object obj) {
			return (this == obj);
		}

		// Returns different strings for two players with distinct names

		@Override
		public String toString() {
			return ("[ " + name + " ]");
		}

		public static void main(String[] args) {
			PlayersTests.main(args);
		}
	}
