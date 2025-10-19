// var safemath = artifacts.require("./safemath.sol");
// var zombiefactory = artifacts.require("./zombiefactory.sol");
// var zombiefeeding = artifacts.require("./zombiefeeding.sol");
// var zombiehelper = artifacts.require("./zombiehelper.sol");
// var zombieattack = artifacts.require("./zombieattack.sol");
// var zombieownership = artifacts.require("./zombieownership.sol");

// module.exports = function(deployer) {

//     deployer.deploy(safemath);
//     deployer.deploy(zombiefactory);
//     deployer.deploy(zombiefeeding);
//     deployer.deploy(zombiehelper);
//     deployer.deploy(zombieattack);
//     deployer.deploy(zombieownership);
// }
var safemath = artifacts.require("./safemath.sol");
var zombiefactory = artifacts.require("./zombiefactory.sol");
var zombiefeeding = artifacts.require("./zombiefeeding.sol");
var zombiehelper = artifacts.require("./zombiehelper.sol");
var zombieattack = artifacts.require("./zombieattack.sol");
var zombieownership = artifacts.require("./zombieownership.sol");

const fs = require('fs');
const path = require('path');

module.exports = async function(deployer, network) {
  await deployer.deploy(safemath);
  await deployer.deploy(zombiefactory);
  await deployer.deploy(zombiefeeding);
  await deployer.deploy(zombiehelper);
  await deployer.deploy(zombieattack);
  await deployer.deploy(zombieownership);
  
  // Get deployed instance
  const zombieOwnershipInstance = await zombieownership.deployed();
  const contractAddress = zombieOwnershipInstance.address;
  
  // Path to key.json
  const filePath = path.join(__dirname, '..', 'key.json');
  
  // Default config structure
  let config = {
    "OwnershipAddress": "",
    "Ganacheaddress": ""
  };
  
  // Try to read existing key.json
  if (fs.existsSync(filePath)) {
    try {
      const fileContent = fs.readFileSync(filePath, 'utf8');
      config = JSON.parse(fileContent);
    } catch (error) {
      console.log('Could not parse existing key.json, creating new one');
    }
  }
  
  // Update the appropriate address based on network
  if (network === 'development' || network === 'ganache') {
    config.Ganacheaddress = contractAddress;
  } else {
    config.OwnershipAddress = contractAddress;
  }
  
  // Save to key.json
  fs.writeFileSync(filePath, JSON.stringify(config, null, 2));
  
 
  console.log('All contracts deployed successfully!');
  console.log('ZombieOwnership Address:', contractAddress);
  console.log('Network:', network);
  console.log('Saved to: key.json');

};