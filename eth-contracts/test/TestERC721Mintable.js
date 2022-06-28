var ERC721MintableComplete = artifacts.require('CustomERC721Token');

contract('TestERC721Mintable', accounts => {

    const account_one = accounts[0];
    const account_two = accounts[1];

    const owner = account_one;

    const TOTAL_SUPPLY_PER_USER = 10;

    describe('match erc721 spec', function () {
        beforeEach(async function () { 
            this.contract = await ERC721MintableComplete.new({from: owner});

            // TODO: mint multiple tokens
            // Mint 10 tokens for each address
            for (let i = 0; i < TOTAL_SUPPLY_PER_USER; i++) {

                let token_one = 1000 + i;
                let token_two = 2000 + i;

                await this.contract.mint(account_one, token_one, {from: owner});
                await this.contract.mint(account_two, token_two, {from: owner});
            }
        })

        it('should return total supply', async function () { 
            let supply = await this.contract.totalSupply();
            assert.equal(supply, TOTAL_SUPPLY_PER_USER * 2, "Total supply returned: " + supply + " != " + TOTAL_SUPPLY_PER_USER*2)
        })

        it('should get token balance', async function () { 
            
            let account_one_bal = await this.contract.balanceOf(account_one);
            let account_two_bal = await this.contract.balanceOf(account_two);

            assert.equal(account_one_bal, TOTAL_SUPPLY_PER_USER, "Total supply of account one returned: " + account_one_bal + " != " + TOTAL_SUPPLY_PER_USER)
            assert.equal(account_two_bal, TOTAL_SUPPLY_PER_USER, "Total supply of account two returned: " + account_two_bal + " != " + TOTAL_SUPPLY_PER_USER)
        })

        // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
        it('should return token uri', async function () { 
            // For each token get the tokenURI and check against expected
            for(let i = 0; i < TOTAL_SUPPLY_PER_USER; i++)
            {
                let tokenId_one  = await this.contract.tokenOfOwnerByIndex(account_one, i);
                let tokenURI_one = await this.contract.tokenURI(tokenId_one)
                let expected_one = "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/" + (1000 + i)
                assert.equal(tokenURI_one, expected_one, "Token '" + tokenId_one + "' does not match: " + tokenURI_one + " != " + expected_one);


                let tokenId_two  = await this.contract.tokenOfOwnerByIndex(account_two, i);
                let tokenURI_two = await this.contract.tokenURI(tokenId_two)
                let expected_two = "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/" + (2000 + i)
                assert.equal(tokenURI_two, expected_two, "Token '" + tokenId_two + "' does not match: " + tokenURI_two + " != " + expected_two);
            }
        })

        it('should transfer token from one owner to another', async function () { 
            // Try transfering all of account one tokens to account two and visa versa
            for(let i = 0; i < TOTAL_SUPPLY_PER_USER; i++)
            {
                await this.contract.safeTransferFrom(account_one, account_two, 1000 + i, {from: account_one});
            }

            // Balance of account one should be 0 and account two should be 20
            let account_one_bal = await this.contract.balanceOf(account_one);
            let account_two_bal = await this.contract.balanceOf(account_two);

            assert.equal(account_one_bal, 0, "Total supply of account one returned: " + account_one_bal + " != " + 0)
            assert.equal(account_two_bal, 2*TOTAL_SUPPLY_PER_USER, "Total supply of account two returned: " + account_two_bal + " != " + 2*TOTAL_SUPPLY_PER_USER)

            // Double check the order of the tokens and the tokenURIS
            for(let i = 0; i < TOTAL_SUPPLY_PER_USER; i++)
            {
                let tokenId_two  = await this.contract.tokenOfOwnerByIndex(account_two, i);
                let tokenURI_two = await this.contract.tokenURI(tokenId_two)
                let expected_two = "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/" + (2000 + i)
                assert.equal(tokenURI_two, expected_two, "Token '" + tokenId_two + "' does not match: " + tokenURI_two + " != " + expected_two);
            }
            // The transfered tokens should be in ascending order
            for(let i = TOTAL_SUPPLY_PER_USER; i < 2 * TOTAL_SUPPLY_PER_USER; i++)
            {
                let tokenId_two  = await this.contract.tokenOfOwnerByIndex(account_two, i);
                let tokenURI_two = await this.contract.tokenURI(tokenId_two)
                let expected_two = "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/" + (1000 + (i - TOTAL_SUPPLY_PER_USER))
                assert.equal(tokenURI_two, expected_two, "Token '" + tokenId_two + "' does not match: " + tokenURI_two + " != " + expected_two);
            }

            // Now transfer what originally was originally account_two's token to account_one.
            // Note due to the way that the "removeTokenFromOwnerEnumeration" works - it fills gaps in indexes with the last token
            // This mean that the ordering of tokens for account_two will end up being inversed
            for(let i = 0; i < TOTAL_SUPPLY_PER_USER; i++)
            {
                await this.contract.safeTransferFrom(account_two, account_one, 2000 + i, {from: account_two});
            }

            // Balance of account one and account two should be 10 again
            account_one_bal = await this.contract.balanceOf(account_one);
            account_two_bal = await this.contract.balanceOf(account_two);

            assert.equal(account_one_bal, TOTAL_SUPPLY_PER_USER, "Total supply of account one returned: " + account_one_bal + " != " + TOTAL_SUPPLY_PER_USER)
            assert.equal(account_two_bal, TOTAL_SUPPLY_PER_USER, "Total supply of account two returned: " + account_two_bal + " != " + TOTAL_SUPPLY_PER_USER)

            // Double check the order of the tokens and the tokenURIS
            for(let i = 0; i < TOTAL_SUPPLY_PER_USER; i++)
            {
                let tokenId_one  = await this.contract.tokenOfOwnerByIndex(account_one, i);
                let tokenURI_one = await this.contract.tokenURI(tokenId_one)
                let expected_one = "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/" + (2000 + i)
                assert.equal(tokenURI_one, expected_one, "Token '" + tokenId_one + "' does not match: " + tokenURI_one + " != " + expected_one);
            }

            // Double check the order of the tokens and the tokenURIS ( not the inversion of the tokenIds)
            for(let i = 0; i < TOTAL_SUPPLY_PER_USER; i++)
            {
                let tokenId_two  = await this.contract.tokenOfOwnerByIndex(account_two, i);
                let tokenURI_two = await this.contract.tokenURI(tokenId_two)
                let expected_two = "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/" + (1000 + (TOTAL_SUPPLY_PER_USER - 1 - i))
                assert.equal(tokenURI_two, expected_two, "Token '" + tokenId_two + "' does not match: " + tokenURI_two + " != " + expected_two);
            }
        })
    });

    describe('have ownership properties', function () {
        beforeEach(async function () { 
            this.contract = await ERC721MintableComplete.new({from: account_one});
        })

        it('should fail when minting when address is not contract owner', async function () { 
            
        })

        it('should return contract owner', async function () { 
            
        })

    });
})