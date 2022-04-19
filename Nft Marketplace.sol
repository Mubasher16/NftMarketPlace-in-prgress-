// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NFTMarket {
  using Counters for Counters.Counter;
  Counters.Counter private _itemIds;

  enum nftStatus{Available,notAvailable}
    struct marketItem {
    uint itemId;
    nftStatus status;
    address nftContract;
    uint256 tokenId;
    address payable seller;
    uint256 price;
  }
   mapping(uint256 => marketItem) idToMarketItem;
   

    function addItemToMarket(address nftContract, uint256 tokenId, uint256 price) public payable {
        uint256 itemId = _itemIds.current();      
        //marketItem memory listing= idToMarketItem[itemId];
        require(price > 0, "Price must be at least 1 wei");
        idToMarketItem[itemId] =  marketItem(itemId,nftStatus.Available,nftContract,tokenId,payable(msg.sender),price);
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
        _itemIds.increment();


 }
    function buyNFT(uint256 itemId) public payable {
        //marketItem memory listing= idToMarketItem[itemId];
        require(idToMarketItem[itemId].status==nftStatus.Available, "Not available at the moment");
        require(msg.value == idToMarketItem[itemId].price, "Enter the correct price");
        idToMarketItem[itemId].seller.transfer(msg.value);
        IERC721(idToMarketItem[itemId].nftContract).transferFrom(address(this), msg.sender, idToMarketItem[itemId].tokenId);
  }

    function changeListingStatus(uint256 tokenId, uint256 itemId) external payable returns(bool) {
      //  require(msg.sender == idToMarketItem[itemId].seller,"Not allowed to change the status");
        IERC721(idToMarketItem[itemId].nftContract).transferFrom(address(this),msg.sender,tokenId);
        idToMarketItem[itemId].status=nftStatus.notAvailable;
        return true;
  }

    function check(uint256 itemId)public view returns(marketItem memory){
        return  idToMarketItem[itemId];
    }
}
