pragma solidity ^0.8.15;

import "./SquareVerifier.sol";
import "./ERC721Mintable.sol";

// Using this as a guide
// https://knowledge.udacity.com/questions/720350
// https://www.youtube.com/watch?v=aTtiIWfl910
// https://andresaaap.medium.com/capstone-real-estate-marketplace-project-faq-udacity-blockchain-69fe13b4c14e

// Contract that inherits from your ERC721Mintable class
contract SolnSquareVerifier is CustomERC721Token
{
    // Verifier contract
    SquareVerifier verifierContract;

    // Solutions struct that can hold an index & an address
    struct Solution {
        uint256 index;
        address addr;
    }

    // A mapping to store unique solutions submitted
    // Using "hash" of solution as the key to ensure uniqeness
    mapping (bytes32 => Solution) solutionMap;

    //=========================================================================
    //
    //                              EVENTS
    //
    //=========================================================================

    // TODO Create an event to emit when a solution is added
    event solutionAdded(Solution s);


    //=========================================================================
    //
    //                              CONSTRUCTOR
    //
    //=========================================================================

    // Constructor sets the verifier contract address to that which is already deployed
    constructor(address verifierContractAddress) CustomERC721Token()
    {
        verifierContract = SquareVerifier(verifierContractAddress);
    }

    //=========================================================================
    //
    //                              MODIFIERS
    //
    //=========================================================================

    modifier solutionNotUsed(uint256 index, address addr) 
    {
        bytes32 s_hash = solutionHash(index, addr);
        // Is not used if both the token and the addres are not valid
        require(!isValidToken(solutionMap[s_hash].index) && !_isValidAddress(solutionMap[s_hash].addr), "Solution is already used");
        _;
    }


    modifier proofValid(SquareVerifier.Proof memory proof, uint[2] memory input)
    {
        // 3. Verify that the proof is valid
        require(verifierContract.verifyTx(proof, input), "Proof is not valid");
        _;
    }


    //=========================================================================
    //
    //                              FUNCTIONS
    //
    //=========================================================================

    function getSolutionByHash(bytes32 s_hash) public
                                               view
                                               returns (uint256, address) 
    {
        Solution memory s = solutionMap[s_hash];
        return (s.index, s.addr);
    }

    function solutionHash(uint256 index, address addr) public
                                                         pure
                                                         returns(bytes32)
    {
        bytes32 s_hash = keccak256(abi.encode(index, addr));
        return s_hash;
    }


    // TODO Create a function to add the solutions to the array and emit the event
    function addSolution(uint256 tokenId, address addr) public
    {
        Solution memory s = Solution(tokenId, addr);
        bytes32 s_hash = solutionHash(s.index, s.addr);
        solutionMap[s_hash] = s;

        emit solutionAdded(s);
    }


    // TODO Create a function to mint new NFT only after the solution has been verified
    //  - make sure the solution is unique (has not been used before)
    //  - make sure you handle metadata as well as tokenSupply

    // 1. mint function and inputs necessary parameters to mint and proof
    function mintNewNFT(uint256 tokenId, address addr, SquareVerifier.Proof memory proof, uint[2] memory input) external
                                                                                                                solutionNotUsed(tokenId, addr)
                                                                                                                proofValid(proof, input)
    {
        // 4. Execute the add Solution function to store the solution to make sure that this solution cant be used in the future
        addSolution(tokenId, addr);

        // 5. mint the token
        super.mint(addr, tokenId);
    }
}

























