import { ethers } from "hardhat";

async function main() {
  const Genesis = await ethers.getContractFactory("Genesis");
  const genesis = await Genesis.deploy("Genesis HonestWork", "GHW");
  await genesis.deployed();
  console.log("Genesis deployed:", genesis.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
