# Team Zombies

1. Avikumar Moliya - 820797413 - avikumarsmoliya@csu.fullerton.edu
2. Darshil Mangukiya - 824541791 - Darshil_03@csu.fullerton.edu
3. Priya Intwala - 817014160 - priyaintwala@csu.fullerton.edu
4. Vidhi Sharma - 820240299 - vidhis2001@csu.fullerton.edu

# Repo Link
https://github.com/Avimoliya13/Cryptozombie-demo-package

# Video Demo
https://youtu.be/eGBlI2EYCAw

# Project Overview
CryptoZombie Blockchain DApp is a decentralized web application built using Solidity, Truffle, Ganache, and Web3.js.
It extends the popular CryptoZombies tutorial with advanced features such as dynamic NFT trading, and DNA-based image extraction.
The project demonstrates strong concepts of smart contract deployment, frontend–blockchain integration, and NFT marketplace mechanics.

# Improvments
1. Developed a responsive and modern website UI for the DApp.
2. Added dynamic zombie images extracting according to the DNA from RoboHash.
3. Updated the starter code and made it dynamic so data comes from key.json 
4. Apart from starter pack below are the additional functionalities :
   1. Zombie Leve-Up
   2. Many Zombie can be created in the same account
   3. Delete Single Zombie
   4. Change Name
   5. Change Dna
   6. Delete Multiple Zombie
   7. List the zombie on NFT Market:
       - If user clicks buy, Whatever ether posted is debited from buyer
       - Ownership transfer from seller to buyer
   8. Cancel Listing

# To run this application
1. Install the dependencies using npm install
    - If specific version needed use nvm and start using that version with nvm use.
2. Install Ganache and update the truffle-config.js file with the its network configuration.
3. Compile all the contracts using truffle compile.
    - for ganache use truffle compile --network development
4. Migrate all the contracts using truffle migrate.
    - for ganache use truffle migrate --network development
5. Create a key.json file. Put the contract address from ZombieOwnership there. Here's the format. { "Ganacheaddress" : "Your ZombieOwnership contract address from ganache" }
6. Install Metamask and connect to the Ganache network using the following details:
    * Network Name: Ganache
    * New RPC URL: http://localhost:7545
    * Chain ID: 1337 (if your network id is different, change it to 1337)
    * Symbol: ETH
7. Copy the private key of any account from Ganache (copy a key from any account) and add a new account (import account) in Metamask using the private key.
8. In index.html use var cryptoZombiesAddress = secrets.Ganacheaddress; for ganache at line 151
9. install http server with npm i http-server
10. Run http-server

# Additional Instructions
1. Use truffle migrate --reset to redeploy on Ganache.
