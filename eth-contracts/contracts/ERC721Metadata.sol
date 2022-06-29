pragma solidity ^0.8.15;

import "openzeppelin-solidity/contracts/utils/Strings.sol";

import "./ERC721Enumerable.sol";
import "./Oraclize.sol";

contract ERC721Metadata is ERC721Enumerable, usingOraclize {
    
    // TODO: Create private vars for token _name, _symbol, and _baseTokenURI (string)
    string private _name;
    string private _symbol;
    string private _baseTokenURI;

    // TODO: create private mapping of tokenId's to token uri's called '_tokenURIs'
    mapping(uint256 => string) private _tokenURIs;

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    /*
     * 0x5b5e139f ===
     *     bytes4(keccak256('name()')) ^
     *     bytes4(keccak256('symbol()')) ^
     *     bytes4(keccak256('tokenURI(uint256)'))
     */


    constructor (string memory aname, string memory asymbol, string memory abaseTokenURI) {
        // TODO: set instance var values
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

    // TODO: create external getter functions for name, symbol, and baseTokenURI
    function name() public
                    view
                    returns(string memory)
    {
        return _name;
    }

    function symbol() public
                      view
                      returns(string memory)
    {
        return _symbol;
    }

    function baseTokenURI() public
                            view
                            returns(string memory)
    {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) external
                                       view
                                       tokenExists(tokenId)
                                       returns (string memory)
    {
        return _tokenURIs[tokenId];
    }


    // TODO: Create an internal function to set the tokenURI of a specified tokenId
    // It should be the _baseTokenURI + the tokenId in string form
    // TIP #1: use strConcat() from the imported oraclizeAPI lib to set the complete token URI
    // TIP #2: you can also use uint2str() to convert a uint to a string
        // see https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol for strConcat()
    // require the token exists before setting
    function setTokenURI(uint256 tokenId) internal
                                          tokenExists(tokenId)
    {
        _tokenURIs[tokenId] = string.concat(baseTokenURI(), Strings.toString(tokenId));
    }

}