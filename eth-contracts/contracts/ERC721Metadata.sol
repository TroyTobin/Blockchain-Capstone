pragma solidity ^0.8.15;

import "openzeppelin-solidity/contracts/utils/Strings.sol";

import "./ERC721Enumerable.sol";
import "./Oraclize.sol";

contract ERC721Metadata is ERC721Enumerable, usingOraclize {
    
    // Private vars for token _name, _symbol, and _baseTokenURI (string)
    string private _name;
    string private _symbol;
    string private _baseTokenURI;

    // Private mapping of tokenId's to token uri's called '_tokenURIs'
    mapping(uint256 => string) private _tokenURIs;

    /*
     * 0x5b5e139f === bytes4(keccak256('name()')) ^ bytes4(keccak256('symbol()')) ^ bytes4(keccak256('tokenURI(uint256)'))
     */
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;


    //=========================================================================
    //
    //                              CONSTRUCTOR
    //
    //=========================================================================

    constructor (string memory aname, string memory asymbol, string memory abaseTokenURI) {
        _name         = aname;
        _symbol       = asymbol;
        _baseTokenURI = abaseTokenURI;

        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    //=========================================================================
    //
    //                              FUNCTIONS
    //
    //=========================================================================

    // Getter functions for name, symbol, and baseTokenURI
    function getNname() public
                        view
                        returns(string memory)
    {
        return _name;
    }

    function getSymbol() public
                         view
                         returns(string memory)
    {
        return _symbol;
    }

    function getBaseTokenURI() public
                               view
                               returns(string memory)
    {
        return _baseTokenURI;
    }

    function getTokenURI(uint256 tokenId) external
                                          view
                                          tokenExists(tokenId)
                                          returns (string memory)
    {
        return _tokenURIs[tokenId];
    }


    // Sets tokenURI to be the _baseTokenURI + the tokenId in string form
    // Requires the token exists before setting
    function setTokenURI(uint256 tokenId) internal
                                          tokenExists(tokenId)
    {
        _tokenURIs[tokenId] = string.concat(getBaseTokenURI(), Strings.toString(tokenId));
    }

}