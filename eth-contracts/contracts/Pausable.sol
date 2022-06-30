pragma solidity ^0.8.15;

import "./Ownable.sol";

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

    // Modifier to verify the states don't match
    modifier stateNotMatch(bool a, bool b)
    {
        require(a != b, "States match");
        _;
    }

    // Modifier to verify the states match
    modifier stateMatch(bool a, bool b)
    {
        require(a = b, "States don't match");
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
                                 stateNotMatch(_paused, val)
    {
        _paused = val;

        // send event of change
        if (_paused) 
            emit Paused(msg.sender);
        else
            emit Unpaused(msg.sender);
    }

    // Getter for the private member
    function getPaused() public
                         view
                         returns(bool)
    {
        return _paused;
    }
}
