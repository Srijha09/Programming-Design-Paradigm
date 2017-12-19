// A Roster is an object of any class that implements the Roster interface.
//
// A Roster object represents a set of players.
//
// Roster objects are immutable, but all players on a roster
// have mutable status, which can affect the values returned by
// the readyCount() and readyRoster() methods.
//
// If r1 and r2 are rosters, then r1.equals(r2) if and only if
// every player on roster r1 is also on roster r2, and
// every player on roster r2 is also on roster r1.
//
// If r is a roster, then r.hashcode() always returns the same
// value, even if r has some players whose status changes.
//
// If r1 and r2 are rosters of different sizes, then
// r1.toString() is not the same string as r2.toString().
//
// Rosters.empty() is a static factory method that returns an
// empty roster.

import java.util.Iterator;

interface Roster extends Iterable<Player> {

    // Returns a roster consisting of the given player together
    // with all players on this roster.
    // Example:
    //     r.with(p).with(p)  =>  r.with(p)

    Roster with (Player p);

    // Returns a roster consisting of all players on this roster
    // except for the given player.
    // Examples:
    //     Rosters.empty().without(p)  =>  Rosters.empty()
    //     r.without(p).without(p)     =>  r.without(p)

    Roster without (Player p);

    // Returns true iff the given player is on this roster.
    // Examples:
    //
    //     Rosters.empty().has(p)  =>  false
    //
    // If r is any roster, then
    //
    //     r.with(p).has(p)     =>  true
    //     r.without(p).has(p)  =>  false

    boolean has (Player p);

    // Returns the number of players on this roster.
    // Examples:
    //
    //     Rosters.empty().size()  =>  0
    //
    // If r is a roster with r.size() == n, and r.has(p) is false, then
    //
    //     r.without(p).size()          =>  n
    //     r.with(p).size               =>  n+1
    //     r.with(p).with(p).size       =>  n+1
    //     r.with(p).without(p).size()  =>  n

    int size ();

    // Returns the number of players on this roster whose current
    // status indicates they are available.

    int readyCount ();

    // Returns a roster consisting of all players on this roster
    // whose current status indicates they are available.

    Roster readyRoster ();

    // Returns an iterator that generates each player on this
    // roster exactly once, in alphabetical order by name.

    Iterator<Player> iterator ();
}
