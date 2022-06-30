pragma solidity ^0.8.15;

import 'openzeppelin-solidity/contracts/utils/Address.sol';
import 'openzeppelin-solidity/contracts/utils/Counters.sol';
import 'openzeppelin-solidity/contracts/utils/math/SafeMath.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol';

import "./ERC165.sol";
import "./Pausable.sol";

contract ERC721 is Pausable, ERC165 {

    using SafeMath for uint256;
    using Address  for address;
    using Counters for Counters.Counter;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    // IMPORTANT: this mapping uses Counters lib which is used to protect overflow when incrementing/decrementing a uint
    // use the following functions when interacting with Counters: increment(), decrement(), and current() to get the value
    // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/drafts/Counters.sol
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;


    //=========================================================================
    //
    //                              EVENTS
    //
    //=========================================================================

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    
    //=========================================================================
    //
    //                              CONSTRUCTOR
    //
    //=========================================================================

    constructor () 
    {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    //=========================================================================
    //
    //                              MODIFIERS
    //
    //=========================================================================

    modifier tokenOwner(address a, uint256 tokenId)
    {
        address owner = ownerOf(tokenId);
        require(a == owner, "");
        _;
    }

    modifier notTokenOwner(address a, uint256 tokenId)
    {
        address owner = ownerOf(tokenId);
        require(a != owner, "");
        _;
    }

    modifier ownerOrIsApprovedForAll(uint256 tokenId)
    {
        address owner = ownerOf(tokenId);
        require(owner == msg.sender || isApprovedForAll(owner, msg.sender), 
                "Owner of token is not the sender and sender is not approved for operation");
        _;
    }

    modifier isSender(address a)
    {
        require(a == msg.sender, "Address is not the sender");
        _;
    }

    modifier isNotSender(address a)
    {
        require(a != msg.sender, "Address is the sender");
        _;
    }

    modifier isApprovedOrOwner(uint256 tokenId)
    {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Transer not approved or owner");
        _;
    }

    modifier tokenExists(uint256 tokenId) 
    {
        require(_exists(tokenId), "Token does not exists");
        _;
    }

    modifier tokenNotExist(uint256 tokenId) 
    {
        require(!_exists(tokenId), "Token already exists");
        _;
    }

    //=========================================================================
    //
    //                              FUNCTIONS
    //
    //=========================================================================

    // Check if a token id is valid    
    function isValidToken(uint256 tokenId) internal
                                           pure
                                           returns(bool)
    {
        return (tokenId != 0);
    }


    // Returns the token balance of given address
    function balanceOf(address owner) public
                                      view
                                      returns (uint256)
    {
        return _ownedTokensCount[owner].current();
    }
        
    // Returns the owner of the given tokenId
    function ownerOf(uint256 tokenId) public
                                      view
                                      returns (address)
    {
        return _tokenOwner[tokenId];
    }

    // @dev Approves another address to transfer the given token ID
    // Requires the contract to not be paused
    // Requires the given address to not be the owner of the tokenId
    // Requiree the msg sender to be the owner of the contract or isApprovedForAll() to be true
    function approve(address to, uint256 tokenId) public
                                                  isNotPaused()
                                                  notTokenOwner(to, tokenId)
                                                  ownerOrIsApprovedForAll(tokenId)
    {
        // Add 'to' address to token approvals
        _tokenApprovals[tokenId] = to;

        // emit Approval Event
        emit Approval(msg.sender, to, tokenId);
    }

    
    // Returns token approval if it exists
    function getApproved(uint256 tokenId) public
                                          view
                                          returns (address)
    {
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf
     * @param to operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address to, bool approved) public
                                                          isNotPaused()
                                                          isNotSender(to)
    {
        _operatorApprovals[msg.sender][to] = approved;

        emit ApprovalForAll(msg.sender, to, approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address owner, address operator) public
                                                               view
                                                               returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public
                                                                     isNotPaused()
                                                                     isApprovedOrOwner(tokenId)
    {
        _transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public
                                                                         isNotPaused()
    {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public
                                                                                             isNotPaused()
    {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "check ERC721Recieved Failed");
    }

    /**
     * @dev Returns whether the specified token exists
     * @param tokenId uint256 ID of the token to query the existence of
     * @return bool whether the token exists
     */
    function _exists(uint256 tokenId) internal view returns (bool)
    {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     * is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool)
    {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    // @dev Internal function to mint a new token
    // TIP: remember the functions to use for Counters. you can refresh yourself with the link above
    // Revert if given tokenId already exists or given address is invalid
    function _mint(address to, uint256 tokenId) internal 
                                                virtual
                                                isNotPaused()
                                                tokenNotExist(tokenId)
    {
        // Mint tokenId to given address & increase token count of owner
        // Note - can't do a "transfer" here as this is a mint - and is not owned yet
        _ownedTokensCount[to].increment();
        _tokenOwner[tokenId] = to;

        // Emit transfer event
        // There is no "from" address as this is the mint of the token
        emit Transfer(address(0), to, tokenId);

    }

    // @dev Internal function to transfer ownership of a given token ID to another address.
    // TIP: remember the functions to use for Counters. you can refresh yourself with the link above
    function _transferFrom(address from, address to, uint256 tokenId) internal
                                                                      virtual
                                                                      isNotPaused()
                                                                      addressMatches(from, ownerOf(tokenId))
                                                                      isValidAddress(to)
    {
        // Clear approval
        _clearApproval(tokenId);

        // Update token counts & transfer ownership of the token ID
        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();
        _tokenOwner[tokenId] = to;

        // Emit transfer event
        emit Transfer(msg.sender, to, tokenId);
    }

    /**
     * @dev Internal function to invoke `onERC721Received` on a target address
     * The call is not executed if the target address is not a contract
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal
                                                                                                   returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    // @dev Private function to clear current approval of a given token ID
    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}
