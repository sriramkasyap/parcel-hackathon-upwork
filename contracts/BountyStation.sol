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
        string memory bountyTitle,
        string memory bountyDescription,
        string memory bountyLink,
        uint256 bountyCategory,
        uint256 bountyValueETH
    ) public returns (uint256) {}

    // Withdraw a Bounty

    // Create Proposal to bounty

    // Select proposal for bounty

    // Add Submission to deal

    // Approve Submission

    // Dispute Submission

    // Withdraw a Deal

    // Hooks
}
