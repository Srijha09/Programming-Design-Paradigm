// A Player is an object of any class that implements the Player interface.
//
// A Player object represents a member of a team.
// Player objects are mutable because their status can change without
// changing the identity of the Player.
// 
// If p1 and p2 are players, then p1.equals(p2) if and only if
// p1 and p2 are the same object (i.e. (p1 == p2), p1 and p2
// have the same name and status, and changing the status of p1
// necessarily changes the status of p2 in the same way).
//
// If p is a player, then p.hashCode() always returns the same
// value, even after the player's status is changed by calling
// one of the last three methods listed below.
//
// If p1 and p2 are players with distinct names, then
// p1.toString() is not the same string as p2.toString().
//
// Players.make(String name) is a static factory method that returns
// a player with the given name who is (initially) available.

interface Player {

    // Returns the name of this player.
    // Example:
    //     Players.make("Gordon Wayhard").name()  =>  "Gordon Wayhard"

    String name ();

    // Returns true iff this player is
    //     under contract, and
    //     not injured, and
    //     not suspended
    // Example:
    //     Player gw = Players.make ("Gordon Wayhard");
    //     System.out.println (gw.available());  // prints true
    //     gw.changeInjuryStatus (true);
    //     System.out.println (gw.available());  // prints false

    boolean available ();

    // Returns true iff this player is under contract (employed).
    // Example:
    //     Player ih = Players.make ("Isaac Homas");
    //     System.out.println (ih.underContract());  // prints true
    //     ih.changeContractStatus (false);
    //     System.out.println (ih.underContract());  // prints false
    //     ih.changeContractStatus (true);
    //     System.out.println (ih.underContract());  // prints true

    boolean underContract ();

    // Returns true iff this player is injured.

    boolean isInjured ();

    // Returns true iff this player is suspended.

    boolean isSuspended ();

    // Changes the underContract() status of this player
    // to the specified boolean.

    void changeContractStatus (boolean newStatus);

    // Changes the isInjured() status of this player
    // to the specified boolean.

    void changeInjuryStatus (boolean newStatus);

    // Changes the isSuspended() status of this player
    // to the specified boolean.

    void changeSuspendedStatus (boolean newStatus);
}
