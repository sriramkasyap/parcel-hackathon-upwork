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
    bytes32 empty = keccak256(abi.encodePacked(""));

    // Map proposals to respective bountyId
    mapping(uint256 => Proposal[]) proposals;

    // Map submit to respective bountyId
    mapping(uint256 => Submission[]) submissions;

    // Map bounties for a creator
    mapping(address => uint256[]) creatorBounties;

    // Map active deals for a hunter
    mapping(address => uint256[]) hunterDeals;

    // Map active propsals for a hunter
    mapping(address => mapping(uint256 => uint256[])) hunterproposals;

    // Modifiers
    modifier onlyBountyCreator(uint256 _bountyId) {
        require(msg.sender == bounties[_bountyId].bountyCreator, "Only Bounty creators can perform this action");
        _;
    }

    modifier onlyDealCreator(uint256 _dealId) {
        require(msg.sender == deals[_dealId].dealCreator, "Only Deal creators can perform this action");
        _;
    }

    modifier onlyProposalCreator(uint256 _bountyId, uint256 _proposalId) {
        require(
            msg.sender == proposals[_bountyId][_proposalId].proposalCreator,
            "Only Proposal creator can perform this action"
        );
        _;
    }

    modifier onlyDealReciever(uint256 _dealId) {
        require(msg.sender == deals[_dealId].dealReceiver, "Only Deal receiver can perform this action");
        _;
    }

    modifier bountyExists(uint256 _bountyId) {
        require(bounties[_bountyId].bountyValueETH > 0, "Bounty Does not Exist");
        _;
    }

    // Functions
    constructor(address _protocolWallet) {
        protocolWallet = _protocolWallet;
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
        string calldata _bountyTitle,
        string calldata _bountyDescription,
        string calldata _bountyLink,
        uint256 _bountyCategory,
        uint256 _bountyValueETH
    ) public payable returns (uint256) {
        require(_bountyValueETH > 0, "Bounty Value has to be greater than 0");
        require(msg.value == _bountyValueETH, "Bounty Value does not match with the supplied amount");
        require(
            keccak256(abi.encodePacked(_bountyTitle)) != empty &&
                keccak256(abi.encodePacked(_bountyDescription)) != empty &&
                keccak256(abi.encodePacked(_bountyLink)) != empty,
            "Invalid Bounty data supplied"
        );
        require(categories[_bountyCategory].hunterId > 0, "Invalid Category selected");

        bounties.push(
            Bounty(msg.sender, _bountyTitle, _bountyDescription, _bountyLink, _bountyCategory, _bountyValueETH)
        );
        creatorBounties[msg.sender].push(bounties.length - 1);
        return bounties.length - 1;
    }

    // Get All Bounties
    function getAllBounties() public view returns (Bounty[] memory) {
        return bounties;
    }

    // Get My Bounties
    function getMyBounties() public view returns (Bounty[] memory) {
        Bounty[] memory toReturn = new Bounty[](creatorBounties[msg.sender].length);

        for (uint256 i = 0; i < creatorBounties[msg.sender].length; i++) {
            toReturn[i] = bounties[creatorBounties[msg.sender][i]];
        }
        return toReturn;
    }

    // Create Proposal to bounty
    function addProposalToBounty(
        uint256 _bountyId,
        string memory _proposalTitle,
        string memory _proposalDescription,
        string memory _proposalLink,
        uint256 _proposalValue,
        uint256 _depositValueETH
    ) public payable bountyExists(_bountyId) returns (uint256) {
        require(_proposalValue > 0, "Proposal Value has to be greater than 0");
        require(_depositValueETH > 0, "Proposal Value has to be greater than 0");
        require(msg.value == _depositValueETH, "Bounty Value does not match with the supplied amount");
        require(
            keccak256(abi.encodePacked(_proposalTitle)) != empty &&
                keccak256(abi.encodePacked(_proposalDescription)) != empty &&
                keccak256(abi.encodePacked(_proposalLink)) != empty,
            "Invalid Bounty data supplied"
        );
        require(_depositValueETH >= (_proposalValue / 10), "Atleast 10% of the proposal value has to be deposited");

        proposals[_bountyId].push(
            Proposal(
                _bountyId,
                _proposalTitle,
                _proposalDescription,
                _proposalLink,
                msg.sender,
                _depositValueETH,
                _proposalValue
            )
        );
        hunterproposals[msg.sender][_bountyId].push(proposals[_bountyId].length - 1);
        return proposals[_bountyId].length - 1;
    }

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
