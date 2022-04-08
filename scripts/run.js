const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
      value: hre.ethers.utils.parseEther('0.1'),
    });
    await waveContract.deployed();
    
    
    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);
  

    /*
    * Get Contract balance
    */
    let contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      'Contract balance:',
      hre.ethers.utils.formatEther(contractBalance)
    );

    // Call function to get the number of total Waves 
    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    
    // Wave 
    let waveTxn = await waveContract.wave('Hi!');
    await waveTxn.wait();
    
    // Call function to get number of totalWaves, after waving once 
    waveCount = await waveContract.getTotalWaves();

    waveTxn = await waveContract.connect(randomPerson).wave('A message!');
    await waveTxn.wait();
    waveTxn = await waveContract.connect(randomPerson).wave('Another message!');
    await waveTxn.wait(); // Wait for the transaction to be mined
    
    /*
   * Get Contract balance to see what happened!
   */
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
      'Contract balance:',
      hre.ethers.utils.formatEther(contractBalance)
    );

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    // Check waves of a given user 
    waveUserWaveCount = await waveContract.userWaveCount(randomPerson.address);


    waveCount = await waveContract.getTotalWaves();
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();