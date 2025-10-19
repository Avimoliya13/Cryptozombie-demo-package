pragma solidity ^0.4.25;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) zombieApprovals;

  // ===== MARKETPLACE STORAGE =====
  struct Listing {
    address seller;
    uint256 price;
    bool isActive;
  }
  
  mapping(uint256 => Listing) public zombieListings;
  uint256[] public listedZombies;
  
  // ===== MARKETPLACE EVENTS =====
  event ZombieListed(uint256 indexed zombieId, address indexed seller, uint256 price);
  event ZombieSold(uint256 indexed zombieId, address indexed seller, address indexed buyer, uint256 price);
  event ListingCancelled(uint256 indexed zombieId, address indexed seller);

  // ===== ERC721 FUNCTIONS =====
  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]   = ownerZombieCount[_to].add(1);
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    
    // Cancel listing if zombie is being transferred
    if (zombieListings[_tokenId].isActive) {
      zombieListings[_tokenId].isActive = false;
      emit ListingCancelled(_tokenId, zombieToOwner[_tokenId]);
    }
    
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  // ===== MARKETPLACE FUNCTIONS =====
  
  // List a zombie for sale
  function listZombieForSale(uint256 _zombieId, uint256 _price) external onlyOwnerOf(_zombieId) {
    require(_price > 0, "Price must be greater than 0");
    require(!zombieListings[_zombieId].isActive, "Zombie already listed");
    
    zombieListings[_zombieId] = Listing({
      seller: msg.sender,
      price: _price,
      isActive: true
    });
    
    listedZombies.push(_zombieId);
    
    emit ZombieListed(_zombieId, msg.sender, _price);
  }
  
  // Buy a listed zombie
  function buyZombie(uint256 _zombieId) external payable {
    Listing storage listing = zombieListings[_zombieId];
    
    require(listing.isActive, "Zombie is not listed for sale");
    require(msg.value >= listing.price, "Insufficient payment");
    require(msg.sender != listing.seller, "Cannot buy your own zombie");
    require(zombieToOwner[_zombieId] == listing.seller, "Seller no longer owns this zombie");
    
    address seller = listing.seller;
    uint256 price = listing.price;
    
    // Mark listing as inactive
    listing.isActive = false;
    
    // Transfer zombie ownership
    _transfer(seller, msg.sender, _zombieId);
    
    // Transfer payment to seller
    seller.transfer(price);
    
    // Refund excess payment
    if (msg.value > price) {
      msg.sender.transfer(msg.value - price);
    }
    
    emit ZombieSold(_zombieId, seller, msg.sender, price);
  }
  
  // Cancel a listing
  function cancelListing(uint256 _zombieId) external {
    Listing storage listing = zombieListings[_zombieId];
    
    require(listing.isActive, "Zombie is not listed");
    require(msg.sender == listing.seller, "Only seller can cancel listing");
    
    listing.isActive = false;
    
    emit ListingCancelled(_zombieId, msg.sender);
  }
  
  // Get all active listings
  function getActiveListings() external view returns (uint256[]) {
    uint256 activeCount = 0;
    
    // Count active listings
    for (uint256 i = 0; i < listedZombies.length; i++) {
      if (zombieListings[listedZombies[i]].isActive) {
        activeCount++;
      }
    }
    
    // Create array of active listings
    uint256[] memory activeListings = new uint256[](activeCount);
    uint256 index = 0;
    
    for (uint256 j = 0; j < listedZombies.length; j++) {
      if (zombieListings[listedZombies[j]].isActive) {
        activeListings[index] = listedZombies[j];
        index++;
      }
    }
    
    return activeListings;
  }
  
  // Check if a zombie is listed
  function isListed(uint256 _zombieId) external view returns (bool) {
    return zombieListings[_zombieId].isActive;
  }
  
  // Get listing details
  function getListing(uint256 _zombieId) external view returns (address seller, uint256 price, bool isActive) {
    Listing memory listing = zombieListings[_zombieId];
    return (listing.seller, listing.price, listing.isActive);
  }

}