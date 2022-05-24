// const main = async () => {
//   const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
//   const waveContract = await waveContractFactory.deploy();
//   await waveContract.deployed();
//   console.log("Endereço do contrato:", waveContract.address);

//   let waveCount;
//   waveCount = await waveContract.getTotalWaves();
//   console.log(waveCount.toNumber());
 
//   /**
//    * Deixe-me enviar alguns tchauzinhos!
//    */
//   let waveTxn = await waveContract.wave("Uma mensagem!");
//   await waveTxn.wait(); // aguarda a transação ser minerada

//   const [_, randomPerson] = await hre.ethers.getSigners();
//   waveTxn = await waveContract.connect(randomPerson).wave("Outra mensagem!");
//   await waveTxn.wait(); // aguarda a transação ser minerada

//   let allWaves = await waveContract.getAllWaves();
//   console.log(allWaves);
// };

// const runMain = async () => {
//   try {
//     await main();
//     process.exit(0);
//   } catch (error) {
//     console.log(error);
//     process.exit(1);
//   }
// };

// runMain();

const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Endereço do contrato:", waveContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Saldo do contrato:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  /*
   * Vamos tentar acenar 2 vezes agora
   */
  const waveTxn = await waveContract.wave("tchauzinho #1");
  await waveTxn.wait();

  const waveTxn2 = await waveContract.wave("tchauzinho #2");
  await waveTxn2.wait();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Saldo do contrato:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
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