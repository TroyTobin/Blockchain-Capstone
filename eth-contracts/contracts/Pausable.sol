pragma solidity ^0.8.15;

import "./Ownable.sol";

//  TODO's: Create a Pausable contract that inherits from the Ownable contract
//  1) create a private '_paused' variable of type bool
//  2) create a public setter using the inherited onlyOwner modifier 
//  3) create an internal constructor that sets the _paused variable to false
//  4) create 'whenNotPaused' & 'paused' modifier that throws in the appropriate situation
//  5) create a Paused & Unpaused event that emits the address that triggered the event
contract Pausable is Ownable {

    bool private _paused;

    //=========================================================================
    //
    //                              EVENTS
    //
    //=========================================================================

    event Paused(address triggeredBy);
    event Unpaused(address triggeredBy);


    //=========================================================================
    //
    //                              CONSTRUCTOR
    //
    //=========================================================================

    constructor()
    {
        _paused = false;
    }

    //=========================================================================
    //
    //                              MODIFIERS
    //
    //=========================================================================

    // Modifer to verify that the contract is paused
    modifier isPaused()
    {
        require(_paused, "Contract is unpaused");
        _;
    }

    // Modifier to verify that the contract is not paused
    modifier isNotPaused() 
    {
        require(!_paused, "Contract is paused");
        _;
    }

    //=========================================================================
    //
    //                              FUNCTIONS
    //
    //=========================================================================

    // Set the paused state of the contract
    // Ensures only the owner of the contract can execute this function
    function setPaused(bool val) public 
                                 addressIsOwner(msg.sender) 
    {
        // only set the value if it is different
        if (_paused != val)
        {
            _paused = val;

            // send event of change
            if (_paused) 
                emit Paused(msg.sender);
            else
                emit Unpaused(msg.sender);
        }
    }
}
