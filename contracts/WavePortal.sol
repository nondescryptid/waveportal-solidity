// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {

    // var that tracks number of Waves; automatically initialized to 0. 
    // This is a state variable that is stored permanently in the contract 
    uint256 totalWaves;

    // Helps to generate a random number 
    uint256 private seed; 

    // mapping that stores how many times each user has waved
    mapping(address => uint) public indivWaveCount; 

    // mapping that associates an address with the last time it waved
    mapping(address => uint256) public lastWavedAt;
    
    /*
     * A little magic, Google what events are in Solidity!
     */
    event NewWave(address indexed from, uint256 timestamp, string message);

     /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    Wave[] waves;

    constructor() payable {
        console.log("software is eating the law");
         /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    // This is a function that can be accessed by anyone -> public 
    function wave(string memory _message) public {
         /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;
        
        // Increase totalWaves by 1
        totalWaves += 1; 
        indivWaveCount[msg.sender] += 1;
        // indicate that the address of the person [msg.sender] using the wave() function has waved 
        console.log("%s waved with message %s", msg.sender, _message);
        
        /*
         * This is where I actually store the wave data in the array.
         */
        waves.push(Wave(msg.sender, _message, block.timestamp));

        /// Prize time 
          /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;
        
        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 20) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        /*
         * I added some fanciness here, Google it and try to figure out what it is!
         * Let me know what you learn in #general-chill-chat
         */
        emit NewWave(msg.sender, block.timestamp, _message);

    }

    // This function is view-only, where it returns the number of totalWaves. There is no computation being done, only information retrieval.
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
    
    function userWaveCount(address userAddress) public view returns (uint) {
        console.log("User %s has waved %s time(s)!", userAddress, indivWaveCount[userAddress]);
        return indivWaveCount[userAddress];
        
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}