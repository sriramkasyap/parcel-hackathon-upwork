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
  const [address1, address2, address3, address4] = await ethers.getSigners();
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
  // console.log({ categories });

  // If Category doesn't exist
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
    await BountyStation.connect(address2).createBounty(
      "Second Bounty",
      "This is a second bounty",
      "https://google.com",
      0,
      BigNumber.from(100000000000000),
      {
        value: BigNumber.from(100000000000000),
      },
    );

    await BountyStation.connect(address3).createBounty(
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

  // Get all bounties
  let allBounties = await BountyStation.getAllBounties();
  console.log({ allBounties });

  // Get My Bounties
  const addr2Bounties = await BountyStation.connect(address2).getMyBounties();
  // console.log({ addr2Bounties });

  // Withdraw Bounty
  // try {
  //   let preBal: BigNumber = await address2.getBalance();

  //   let bountyValue = allBounties[1].bountyValueETH;

  //   let res = await BountyStation.connect(address2).withdrawBounty(1);
  //   res = await res.wait();

  //   let postBal: BigNumber = await address2.getBalance();

  //   // This value should equal the value sent while creating the bounty
  //   const returned = postBal.sub(preBal).add(res.gasUsed.mul(res.effectiveGasPrice));

  //   console.log({ returned: returned.eq(bountyValue) });
  // } catch (error: any) {
  //   console.error(error.reason || error.message);
  // }

  // Get all bounties
  // allBounties = await BountyStation.getAllBounties();
  // console.log({ allBounties });

  // Add proposal to Bounty
  try {
    await BountyStation.connect(address2).addProposalToBounty(
      0,
      "My Proposal to First",
      "This is my Proposal",
      "https://google.com",
      500000000000,
      50000000000,
      {
        value: 50000000000,
      },
    );

    await BountyStation.connect(address3).addProposalToBounty(
      0,
      "Address 3 to Bounty 0",
      "This is my Proposal",
      "https://google.com",
      700000000000,
      70000000000,
      {
        value: 70000000000,
      },
    );

    await BountyStation.connect(address4).addProposalToBounty(
      2,
      "Address 4 to Bounty 2",
      "This is my Proposal",
      "https://google.com",
      100000000000,
      10000000000,
      {
        value: 10000000000,
      },
    );
  } catch (error) {
    console.error(error);
  }

  // Get Proposals of Bounty
  let proposals0 = await BountyStation.getProposalsOfBounty(0);
  let proposals2 = await BountyStation.getProposalsOfBounty(2);
  // console.log({ proposals0 });
  // console.log({ proposals2 });

  try {
    await BountyStation.selectProposal(0, 0);
    await BountyStation.connect(address3).selectProposal(2, 0);
  } catch (error) {
    console.error(error);
  }

  let deals2 = await BountyStation.connect(address1).getMyCreatorDeals();
  let deals4 = await BountyStation.connect(address2).getMyCreatorDeals();
  console.log({ deals2, deals4 });

  let dealsh2 = await BountyStation.connect(address2).getMyHunterDeals();
  let dealsh4 = await BountyStation.connect(address4).getMyHunterDeals();
  console.log({ dealsh2, dealsh4 });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
