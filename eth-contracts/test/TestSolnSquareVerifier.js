var SolnSquareVerifier = artifacts.require('SolnSquareVerifier');
var SquareVerifier = artifacts.require('SquareVerifier');

contract('TestSolnSquareVerifier', accounts => {

    const account_one = accounts[0];
    const account_two = accounts[1];

    const owner = account_one;

    describe('SolnSquareVerifier', function () {
        beforeEach(async function () { 
            this.verifierContract = await SquareVerifier.new({from: owner});
            this.contract = await SolnSquareVerifier.new(this.verifierContract.address, {from: owner});
        })
        
        // Test if a new solution can be added for contract - SolnSquareVerifier
        it('should add solution', async function () { 
            let test_tokenId = 1;
            await this.contract.addSolution(test_tokenId, account_one);

            let hash = await this.contract.solutionHash(test_tokenId, account_one);
            let sol = await this.contract.getSolutionByHash(hash);
            let ret_tokenId = sol[0];
            let ret_addr = sol[1];

            assert.equal(test_tokenId, ret_tokenId, "TokenId stored in the solution does not match: " + test_tokenId + " != " + ret_tokenId);
            assert.equal(account_one, ret_addr,     "Address stored in the solution does not match: " + account_one + " != " + ret_addr);
        })

        // Test if an ERC721 token can be minted for contract - SolnSquareVerifier
        it('should return total supply', async function () { 

            // Copy of proof.json for ease
            let proof = {
                "scheme": "g16",
                "curve": "bn128",
                "proof": {
                  "a": [
                    "0x0b0510e9dff90c01a42849650e1651646ea2a268c54452e52768b7c7de4c4b3b",
                    "0x2a9f8c1631666fa421f69c537ed658555aec7f2050de3344c42cefed755895cd"
                  ],
                  "b": [
                    [
                      "0x098cdfe2f8c0e8b4e915505d57240481b701fc1eb37d2b55bcf30c1d6e0b39ce",
                      "0x28dbd97e00e8d5e1fdd048741283bdc02198e6ae3ebeb17c63fefef002efc8a5"
                    ],
                    [
                      "0x1becf3a125e88b658b76951e8b8da3af6be4f6af86ed14d621475441a25094f5",
                      "0x0c5b0df0147ed915c90c4824eb904e0b8595270025e8d70e5638510ed75fee84"
                    ]
                  ],
                  "c": [
                    "0x2c219a4f2ede339bf6660b650d387bce086f703cc405a90752a9c935877bf940",
                    "0x2dd2afac87a8cf42aa2c79bd01040eccd5e2e6e92be94dcad493bcec049cc859"
                  ]
                },
                "inputs": [
                  "0x0000000000000000000000000000000000000000000000000000000000000009",
                  "0x0000000000000000000000000000000000000000000000000000000000000001"
                ]
            };

            let test_tokenId = 1;

            await this.contract.mintNewNFT(test_tokenId, account_one, proof.proof, proof.inputs);

            // Check the account balance that the mint actually worked
            let account_one_bal = await this.contract.balanceOf(account_one);
            assert.equal(account_one_bal, 1, "Mint failed")
        })
    });
});



