# Udacity Blockchain Capstone

The capstone will build upon the knowledge you have gained in the course in order to build a decentralized housing product. 



# Tests

In one terminal run ganachi
$ ganache-cli 

In a second terminal run the tests
$ truffle test

```
Contract: TestERC721Mintable
match erc721 spec
    ✓ should return total supply
    ✓ should get token balance
    ✓ should return token uri (711ms)
    ✓ should transfer token from one owner to another (2726ms)
have ownership properties
    ✓ should fail when minting when address is not contract owner (339ms)
    ✓ should return contract owner

Contract: TestSolnSquareVerifier
SolnSquareVerifier
    ✓ should add solution (86ms)
    ✓ should return total supply (1470ms)

Contract: TestSquareVerifier
SquareVerifier
    ✓ should verify with correct proof (514ms)
    ✓ should FAIL verify with incorrect proof (506ms)


10 passing (15s)
```

# Deploy on Rinkeby

## Contract Address
https://rinkeby.etherscan.io/address/0xa6f96Df59bA3694FAACa2b2dcEc1a2beee4e37F5

## Tokens 
https://rinkeby.etherscan.io/token/0xa6f96Df59bA3694FAACa2b2dcEc1a2beee4e37F5


$ truffle migrate --reset --network rinkeby

```
Compiling your contracts...
===========================
> Compiling ./contracts/ERC721.sol
> Compiling ./contracts/ERC721Enumerable.sol
> Compiling ./contracts/ERC721Metadata.sol
> Compiling ./contracts/ERC721Mintable.sol
> Compiling ./contracts/Ownable.sol
> Compiling ./contracts/Pausable.sol
> Compiling ./contracts/SolnSquareVerifier.sol
> Compiling ./contracts/SquareVerifier.sol
> Compilation warnings encountered:


> Artifacts written to /home/ttobin/udacity/Blockchain-Capstone/eth-contracts/build/contracts
> Compiled successfully using:
   - solc: 0.8.15+commit.e14f2714.Emscripten.clang



Migrations dry-run (simulation)
===============================
> Network name:    'rinkeby-fork'
> Network id:      4
> Block gas limit: 30000000 (0x1c9c380)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > block number:        10959458
   > block timestamp:     1656848642
   > account:             0x4b3E79411233668Af1D46cf790a463EBB07351c0
   > balance:             18.575614853695884536
   > gas used:            257788 (0x3eefc)
   > gas price:           2 gwei
   > value sent:          0 ETH
   > total cost:          0.000515576 ETH

   -------------------------------------
   > Total cost:         0.000515576 ETH


2_deploy_contracts.js
=====================

   Replacing 'SquareVerifier'
   --------------------------
   > block number:        10959460
   > block timestamp:     1656848662
   > account:             0x4b3E79411233668Af1D46cf790a463EBB07351c0
   > balance:             18.573168975695884536
   > gas used:            1195404 (0x123d8c)
   > gas price:           2 gwei
   > value sent:          0 ETH
   > total cost:          0.002390808 ETH


   Replacing 'SolnSquareVerifier'
   ------------------------------
   > block number:        10959461
   > block timestamp:     1656848790
   > account:             0x4b3E79411233668Af1D46cf790a463EBB07351c0
   > balance:             18.565638801695884536
   > gas used:            3765087 (0x39735f)
   > gas price:           2 gwei
   > value sent:          0 ETH
   > total cost:          0.007530174 ETH

0x3A7cabf29060e1e18a607dC1b6A58908cE65514d 0xa6f96Df59bA3694FAACa2b2dcEc1a2beee4e37F5
   -------------------------------------
   > Total cost:         0.009920982 ETH


Summary
=======
> Total deployments:   3
> Final cost:          0.010436558 ETH





Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 29970705 (0x1c95111)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > transaction hash:    0xafe2dac8bfa9e65f29732f3848a91782154e5e2e76ddf1a5027f0264b99f4a1b
   > Blocks: 1            Seconds: 17
   > contract address:    0xfADf7557D672d2F2307610628D564254187CD6D8
   > block number:        10959472
   > block timestamp:     1656848848
   > account:             0x4b3E79411233668Af1D46cf790a463EBB07351c0
   > balance:             18.575445209693691832
   > gas used:            274088 (0x42ea8)
   > gas price:           2.500000008 gwei
   > value sent:          0 ETH
   > total cost:          0.000685220002192704 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:     0.000685220002192704 ETH


2_deploy_contracts.js
=====================

   Replacing 'SquareVerifier'
   --------------------------
   > transaction hash:    0x1a37e038451642044777a817c97f4f3940c2db1cf1e0b6a4992f06d89469d17c
   > Blocks: 2            Seconds: 21
   > contract address:    0x3A7cabf29060e1e18a607dC1b6A58908cE65514d
   > block number:        10959476
   > block timestamp:     1656848908
   > account:             0x4b3E79411233668Af1D46cf790a463EBB07351c0
   > balance:             18.57234186218376112
   > gas used:            1195404 (0x123d8c)
   > gas price:           2.500000008 gwei
   > value sent:          0 ETH
   > total cost:          0.002988510009563232 ETH


   Replacing 'SolnSquareVerifier'
   ------------------------------
   > transaction hash:    0x765fc5751a200b24b71da8d0e5ab190a42ce06d36fb1a37a227493071fa8a8d0
   > Blocks: 2            Seconds: 17
   > contract address:    0xa6f96Df59bA3694FAACa2b2dcEc1a2beee4e37F5
   > block number:        10959478
   > block timestamp:     1656848938
   > account:             0x4b3E79411233668Af1D46cf790a463EBB07351c0
   > balance:             18.562482144652210024
   > gas used:            3943887 (0x3c2dcf)
   > gas price:           2.500000008 gwei
   > value sent:          0 ETH
   > total cost:          0.009859717531551096 ETH

   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:     0.012848227541114328 ETH


Summary
=======
> Total deployments:   3
> Final cost:          0.013533447543307032 ETH
```


# Mint 10 tokens

In the scripts folder run the follwing mint.js script that can be parameterised with
the tokenId to mint.  Noting that a proof for that token needs to be present in the form
`proof.<tokenId>.json`

$ node mint.js 1
```
MINTING TOKEN: 1 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 1
```

$ node mint.js 2
```
MINTING TOKEN: 2 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 2
```
$ node mint.js 3
```
MINTING TOKEN: 3 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 3
```

$ node mint.js 4
```
MINTING TOKEN: 4 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 4
```

$ node mint.js 5
```
MINTING TOKEN: 5 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 5
```

$ node mint.js 6
```
MINTING TOKEN: 6 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 6
```

$ node mint.js 7
```
MINTING TOKEN: 7 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 7
```

$ node mint.js 8
```
MINTING TOKEN: 8 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 8
```

$ node mint.js 9
```
MINTING TOKEN: 9 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 9
```

$ node mint.js 10
```
MINTING TOKEN: 10 @ (https://rinkeby.infura.io/v3/4c94da61fa524b089dbb77a31718dbd9)
MINTED: 10
```

# Opensea collection
https://testnets.opensea.io/collection/udacitycapstonerealestate


# Project Resources

* [Remix - Solidity IDE](https://remix.ethereum.org/)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Truffle Framework](https://truffleframework.com/)
* [Ganache - One Click Blockchain](https://truffleframework.com/ganache)
* [Open Zeppelin ](https://openzeppelin.org/)
* [Interactive zero knowledge 3-colorability demonstration](http://web.mit.edu/~ezyang/Public/graph/svg.html)
* [Docker](https://docs.docker.com/install/)
* [ZoKrates](https://github.com/Zokrates/ZoKrates)
