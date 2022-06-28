pragma solidity ^0.8.15;

import "./SquareVerifier.sol";
import "./ERC721Mintable.sol";

// Using this as a guide
// https://knowledge.udacity.com/questions/720350
// https://www.youtube.com/watch?v=aTtiIWfl910
// https://andresaaap.medium.com/capstone-real-estate-marketplace-project-faq-udacity-blockchain-69fe13b4c14e

// // TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
// interface Verifier {
//     function verifyTx(Proof memory proof, uint[2] memory input) public
//                                                                 view
//                                                                 returns (bool r);
// }

// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is CustomERC721Token
{
    // Verifier contract
    SquareVerifier verifierContract;

    // TODO define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 tokenId;
        address addr;
    }

    // TODO define a mapping to store unique solutions submitted
    // Using "hash" of solution as the key
    mapping (bytes32 => Solution) solutionMap;


    // TODO Create an event to emit when a solution is added
    event solutionAdded(Solution s);

    // Constructor sets the verifier contract address to that which is already deployed
    constructor(address verifierContractAddress) CustomERC721Token()
    {
        verifierContract = SquareVerifier(verifierContractAddress);
    }

    function solutionHash(Solution memory s) internal
                                             pure
                                             returns(bytes32)
    {
        bytes32 s_hash = keccak256(abi.encode(s.tokenId, s.addr));
        return s_hash;
    }


    // TODO Create a function to add the solutions to the array and emit the event
    function addSolution(Solution memory s) internal
    {
        bytes32 s_hash = solutionHash(s);
        solutionMap[s_hash] = s;

        emit solutionAdded(s);
    }


    // TODO Create a function to mint new NFT only after the solution has been verified
    //  - make sure the solution is unique (has not been used before)
    //  - make sure you handle metadata as well as tokenSupply

    // 1. mint function and inputs necessary parameters to mint and proof
    function mintNewNFT(uint256 tokenId, address addr, SquareVerifier.Proof memory proof, uint[2] memory input) external
    {

        // 2. Solution is uniq
        Solution memory s = Solution(tokenId, addr);
        bytes32 s_hash = solutionHash(s);
        require(solutionMap[s_hash].tokenId == 0 && solutionMap[s_hash].addr == address(0), "Solution is already used");


        // 3. Verify that the proof is valid
        require(verifierContract.verifyTx(proof, input), "Proof is not valid");

        // 4. Execute the add Solution function to store the solution to make sure that this solution cant be used in the future
        addSolution(s);

        // 5. mint the token
        super.mint(addr, tokenId);
    }
}

























