// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import { BigNumber, Contract, ContractFactory } from "ethers";

async function main(): Promise<void> {
  // Hardhat always runs the compile task when running scripts through it.
  // If this runs in a standalone fashion you may want to call compile manually
  // to make sure everything is compiled
  // await run("compile");
  // We get the contract to deploy
  const [address1] = await ethers.getSigners();
  const BountyStationFactory: ContractFactory = await ethers.getContractFactory("BountyStation");
  const BountyStation: Contract = await BountyStationFactory.deploy(address1.getAddress());
  await BountyStation.deployed();
  console.log("BountyStation deployed to: ", BountyStation.address);

  // Add Category
  await BountyStation.addCategory("Product");
  await BountyStation.addCategory("Marketing");
  await BountyStation.addCategory("News");

  // Get Categories
  const categories = await BountyStation.getAllCategories();
  console.log({ categories });

  // If Çategory deos not exist
  try {
    const category = await BountyStation.getCategory(3);
    console.log({ category });
  } catch (error: any) {
    console.error(error.reason);
  }

  // Create new Bounty
  try {
    await BountyStation.createBounty(
      "First Bounty",
      "This is the first bounty",
      "https://google.com",
      0,
      BigNumber.from(1000000000000),
      {
        value: BigNumber.from(1000000000000),
      },
    );
    await BountyStation.createBounty(
      "Second Bounty",
      "This is a second bounty",
      "https://google.com",
      0,
      BigNumber.from(100000000000000),
      {
        value: BigNumber.from(100000000000000),
      },
    );
    await BountyStation.createBounty(
      "Third Bounty",
      "This is a third bounty",
      "https://google.com",
      0,
      BigNumber.from(100000000000000).mul(100),
      {
        value: BigNumber.from(100000000000000).mul(100),
      },
    );
  } catch (error: any) {
    console.error(error.message);
  }

  const allBounties = await BountyStation.getAllBounties();
  console.log({ allBounties });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
