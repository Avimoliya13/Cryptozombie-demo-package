pragma solidity ^0.4.25;

import "./ownable.sol";
import "./safemath.sol";

contract ZombieFactory is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewZombie(uint zombieId, string name, uint dna);
  event ZombieDeleted(uint zombieId);


  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Zombie[] public zombies;

  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;

   modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

    function changeName(uint _zombieId, string _newName) external onlyOwnerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }

  function _createZombie(string _name, uint _dna) internal {
    uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
    emit NewZombie(id, _name, _dna);
  }

  function _generateRandomDna(string _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function createRandomZombie(string _name) public {
    //require(ownerZombieCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createZombie(_name, randDna);
  }


// Delete (burn) a single zombie that you own
function deleteZombie(uint _zombieId) external onlyOwnerOf(_zombieId) {
    _deleteZombie(_zombieId);
}

// Internal logic for deleting a zombie
function _deleteZombie(uint _zombieId) internal {
    address owner = zombieToOwner[_zombieId];
    require(owner != address(0), "Zombie does not exist");

    // Decrease owner's zombie count
    ownerZombieCount[owner] = ownerZombieCount[owner].sub(1);

    // Clear ownership
    delete zombieToOwner[_zombieId];

    // Optional: visually mark zombie as deleted
    zombies[_zombieId].dna = 0;
    zombies[_zombieId].name = "";

    // Emit an event for front-end tracking
    emit ZombieDeleted(_zombieId);
}

// Delete (burn) multiple zombies at once
function bulkDeleteZombies(uint[] _ids) external {
    for (uint i = 0; i < _ids.length; i++) {
        require(zombieToOwner[_ids[i]] == msg.sender, "You do not own this zombie");
        _deleteZombie(_ids[i]);
    }
}



}
