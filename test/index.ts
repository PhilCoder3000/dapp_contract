import { expect } from "chai";
import { ethers } from "hardhat";

describe("Transactions", function () {
  it("Should return the new greeting once it's changed", async function () {
    const [, addr1, addr2] = await ethers.getSigners();
    const amount = 1;
    const Transactions = await ethers.getContractFactory("Transactions");
    const transactions = await Transactions.deploy(
      "Hello, world! I`m deploying"
    );
    await transactions.deployed();
    expect(await transactions.getTransactionCount()).to.equal(0);
    await transactions.addToBlockchain(
      addr1.address,
      amount,
      "from owner to addr1",
      "keyword"
    );
    expect(await transactions.getTransactionCount()).to.equal(1);
    await transactions.addToBlockchain(
      addr2.address,
      amount,
      "from owner to addr2",
      "keyword"
    );
    expect(await transactions.getTransactionCount()).to.equal(2);
    const AllTransactions = await transactions.getAllTransactions();
    console.log(
      "🚀 ~ file: index.ts ~ line 28 ~ transactions",
      AllTransactions
    );
  });
});

describe("Mint NFT", function () {
  it("Should be deployed", async function () {
    const MintNFT = await ethers.getContractFactory('MintNFT')
    const mintNFT = await MintNFT.deploy('Hello, MintNFT!')
    await mintNFT.deployed();
  
    console.log("MintNFT deployed to:", mintNFT.address)
    let txn = await mintNFT.makeAnEpicNFT()
    await txn.wait()
    txn = await mintNFT.makeAnEpicNFT()
    await txn.wait()
  });
});
