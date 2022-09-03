// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BountyStructs.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BountyStation is BountyStructs, Ownable {
    // Storage
    Category[] categories;
    Bounty[] bounties;
    Deal[] deals;

    uint256 identifierNonce = 1;

    address protocolWallet;

    // Map proposals to respective bountyId
    mapping(uint256 => Proposal[]) propsals;

    // Map submit to respective bountyId
    mapping(uint256 => Submission[]) submissions;

    // Map active deals for a hunter
    mapping(address => uint256[]) hunterDeals;

    // Map active propsals for a hunter
    mapping(address => uint256[]) hunterproposals;

    // Modifiers

    // Functions
    constructor(address _protocolWallet) {
        protocolWallet = _protocolWallet;
    }

    function hello() public pure returns (string memory) {
        return "Hello World";
    }

    // Update Protocol Receiver Contract
    function updateProtocol(address _newProtocolWallet) external onlyOwner {
        protocolWallet = _newProtocolWallet;
    }

    // Add New Category
    function addCategory(string calldata _categoryName) external onlyOwner returns (uint256) {
        categories.push(Category(_categoryName, identifierNonce, identifierNonce + 1));
        identifierNonce += 2;
        return categories.length - 1;
    }

    // Get Categories
    function getAllCategories() public view returns (Category[] memory) {
        return categories;
    }

    // Get Category
    function getCategory(uint256 _catId) public view returns (Category memory) {
        require(categories.length > _catId, "Category Does not exist");
        return categories[_catId];
    }

    // Create a Bounty
    function createBounty(
        string memory _bountyTitle,
        string memory _bountyDescription,
        string memory _bountyLink,
        uint256 _bountyCategory,
        uint256 _bountyValueETH
    ) public returns (uint256) {}

    // Withdraw a Bounty
    function withdrawBounty(uint256 _bountyId) public {}

    // Create Proposal to bounty
    function addProposalToBounty(
        uint256 _bountyId,
        string memory _proposalTitle,
        string memory _proposalDescription,
        string memory _proposalLink,
        uint256 _depositValueETH
    ) public returns (uint256) {}

    // Select proposal for bounty
    function selectProposal(uint256 _bountyId, uint256 _proposalId) public {}

    // Add Submission to deal
    function submitToDeal(
        uint256 _dealId,
        string memory _submissionTitle,
        string memory _submissionDescription,
        string memory _submissionLink
    ) public {}

    // Approve Submission
    function approveSubmission(uint256 _dealId, uint256 _submissionid) public {}

    // Dispute Submission
    function disputeSubmission(
        uint256 _dealid,
        uint256 _submissionId,
        string memory _comment
    ) public {}

    // Withdraw a Deal
    function withdrawDeal(uint256 _dealId) public {}

    // Get My Deals
    function getMyDeals() public view returns (Deal[] memory) {}

    // get my proposals
    function getMyProposals() public view returns (Proposal[] memory) {}

    // Get Proposals for deal
    function getProposalsOfDeal(uint256 _dealId) public view returns (Proposal[] memory) {}

    // Get Submissions for deal
    function getSubmissionsOfDeal(uint256 _dealId) public view returns (Submission[] memory) {}

    // Hooks
}
