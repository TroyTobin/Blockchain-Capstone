const HDWalletProvider = require("@truffle/hdwallet-provider");
const fs   = require('fs');
const web3 = require("web3");

const token = process.argv[2];

const INFURA_KEY       = fs.readFileSync("../.infurakey").toString().trim();
const MNEMONIC         = fs.readFileSync("../.secret").toString().trim();
const CONTRACT         = fs.readFileSync("../build/contracts/SolnSquareVerifier.json").toString().trim();
const CONTRACT_ADDRESS = fs.readFileSync("../.contract_address").toString().trim();
const OWNER_ADDRESS    = fs.readFileSync("../.owner_address").toString().trim();

const NETWORK = "rinkeby";
const NFT_ABI = JSON.parse(CONTRACT).abi;


async function mint(index) {
    let uri = "https://" + NETWORK + ".infura.io/v3/" + INFURA_KEY;
    console.log("MINTING TOKEN: " + index + " @ (" + uri + ")");
    const provider = new HDWalletProvider(MNEMONIC, "https://" + NETWORK + ".infura.io/v3/" + INFURA_KEY);
    const web3Instance = new web3(provider);

    const nftContract = new web3Instance.eth.Contract(
        NFT_ABI,
        CONTRACT_ADDRESS,
        { gasLimit: "1000000" }
    );

    const PROOF_RAW = fs.readFileSync("./proof." + 1 + ".json").toString().trim();
    const PROOF = JSON.parse(PROOF_RAW);

    try {
        let result = await nftContract.methods.mintNewNFT(index, OWNER_ADDRESS, PROOF.proof, PROOF.inputs).send({from:OWNER_ADDRESS, gas:3000000});
    
        console.log("MINTED: " + index);
    }
    catch(e)
    {
        console.log(e);
    }

}

mint(token);