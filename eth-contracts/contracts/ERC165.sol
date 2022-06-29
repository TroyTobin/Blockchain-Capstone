pragma solidity ^0.8.15;

contract ERC165 {
    /*
     * 0x01ffc9a7 ===
     *     bytes4(keccak256('supportsInterface(bytes4)'))
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev a mapping of interface id to whether or not it's supported
     */
    mapping(bytes4 => bool) private _supportedInterfaces;


    //=========================================================================
    //
    //                              MODIFIERS
    //
    //=========================================================================
    modifier validInterface(bytes4 interfaceId) {
        require(interfaceId != 0xffffffff, "Interface ID invalid");
        _;
    }

    /**
     * @dev A contract implementing SupportsInterfaceWithLookup
     * implement ERC165 itself
     */
    constructor ()
    {
        _registerInterface(_INTERFACE_ID_ERC165);
    }


    //=========================================================================
    //
    //                              FUNCTIONS
    //
    //=========================================================================

    /**
     * @dev implement supportsInterface(bytes4) using a lookup table
     */
    function supportsInterface(bytes4 interfaceId) external
                                                   view
                                                   returns (bool)
    {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev internal method for registering an interface
     */
    function _registerInterface(bytes4 interfaceId) internal
                                                    validInterface(interfaceId)
    {
        _supportedInterfaces[interfaceId] = true;
    }
}