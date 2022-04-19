// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 mintPrice=100;
    constructor() ERC721("My Marketplace", "MMP"){
    }

    function createToken(string memory tokenURI) public payable returns (uint256) {
        require(msg.value==mintPrice);
        uint256 itemId = _tokenIds.current();
        _safeMint(msg.sender, itemId);
        _setTokenURI(itemId, tokenURI);
        _tokenIds.increment();
        return itemId;
    }
}
