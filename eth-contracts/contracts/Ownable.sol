pragma solidity ^0.8.15;

contract Ownable {
    // create a private '_owner' variable of type address
    address private _owner;

    //=========================================================================
    //
    //                              EVENTS
    //
    //=========================================================================
    
    // create an event that emits anytime ownerShip is transfered (including in the constructor)
    event ownershipTransfered(address from, address to);


    //=========================================================================
    //
    //                              CONSTRUCTOR
    //
    //=========================================================================

    // create an internal constructor that sets the _owner var to the creater of the contract 
    constructor()
    {
        _owner = msg.sender;
        emit ownershipTransfered(address(0), _owner);
    }

    //=========================================================================
    //
    //                              MODIFIERS
    //
    //=========================================================================

    // Modifier to verify that the caller is the owner of the contract
    modifier addressIsOwner(address a)
    {
        require(a == _owner, "Address is not owner");
        _;
    }

    // Modifier to verify that the address is not the owner of the contract
    modifier addressNotOwner(address a)
    {
        require(a != _owner, "Address is owner");
        _;
    }

    // Modifier to verify that the address is valid
    modifier isValidAddress(address a)
    {
        require(_isValidAddress(a), "Not a valid address");
        _;
    }

    // Modifier to verify that the addresses are equivalent
    modifier addressMatches(address a, address b)
    {
        require(a == b, "Address mismatch");
        _;
    }

    // Modifer to verify that the addresses are not equivalent
    modifier addressNotMatches(address a, address b)
    {
        require(a != b, "Address match");
        _;
    }


    //=========================================================================
    //
    //                              FUNCTIONS
    //
    //=========================================================================

    function _isValidAddress(address a) internal
                                        pure
                                        returns(bool)
    {
        return (a != address(0));
    }


    // public getter function for owner
    function owner() external
                     view
                     returns(address)
    {
        return _owner;
        
    }

    // Transfer ownership
    // Ensures that the transfer is from the owner to some other valid address
    function transferOwnership(address newOwner) public
                                                 addressIsOwner(msg.sender)
                                                 isValidAddress(newOwner)
                                                 addressNotOwner(newOwner)
    {
        address origOwner = _owner;
        _owner = newOwner;
        emit ownershipTransfered(origOwner, _owner);
    }
}