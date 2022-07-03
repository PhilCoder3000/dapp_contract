// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";

// contract MintNFT is ERC721URIStorage {

//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;

//     constructor(string memory message) ERC721 ("SquareNFT", "SQUARE") {
//         console.log(message);
//         console.log("This is my NFT contract. Whoa!");
//     }

//     function makeAnEpicNFT() public {
//     uint256 newItemId = _tokenIds.current();
//     _safeMint(msg.sender, newItemId);
//     _setTokenURI(newItemId, "blah");
//     _tokenIds.increment();
//   }
// }


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract MintNFT is ERC721, VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 public fee;
    uint256 public tokenCounter;

    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    event RequestedCollectible(bytes32 indexed requestId);

    constructor(
        address _VRFCoordinator,
        address _LinkToken,
        bytes32 _keyHash
    )
        public
        VRFConsumerBase(_VRFCoordinator, _LinkToken)
        ERC721("Doggies", "DOG")
    {
        keyHash = _keyHash;
        fee = 0.1 * 10 ** 18;
        tokenCounter = 0;
    }

    function createCollectible(uint256 userProviderSeed, string memory tokenURI) public returns(bytes32) {
        bytes32 requestId = requestRandomness(keyHash, fee, userProviderSeed);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit RequestedCollectible(requestId);
    }

    function fullfilRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        address dogOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;
        _safeMint(dogOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);
    }
}
