const hre = require("hardhat");

async function main() {
  const WETH_USDC_POOL = "0x88e6A0c2dDD26FEEb64F039a2c41296fcB3f5640"; // Mainnet
  const INTERVAL = 1800; // 30 minutes

  const Oracle = await hre.ethers.getContractFactory("StaticTWAPOracle");
  const oracle = await Oracle.deploy(WETH_USDC_POOL, INTERVAL);

  await oracle.waitForDeployment();
  console.log("TWAP Oracle deployed to:", await oracle.getAddress());
  console.log("Monitoring 30-minute window for WETH/USDC.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
