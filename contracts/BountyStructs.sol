// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BountyStructs {
    // Enums
    enum Status {
        pending,
        approved,
        disputed
    }

    enum DealStatus {
        ongoing,
        completed,
        withdrawn
    }

    // Structs
    struct Bounty {
        uint256 bountyId;
        address bountyCreator;
        string bountyTitle;
        string bountyDescription;
        string bountyLink;
        uint256 bountyCategory;
        uint256 bountyValueETH;
    }

    struct Deal {
        address dealCreator;
        address dealReceiver;
        string dealTitle;
        string dealDescription;
        string dealLink;
        uint256 dealCategory;
        uint256 dealValueETH;
        uint256 hunterDepositETH;
        DealStatus dealStatus;
    }

    struct Proposal {
        uint256 proposalId;
        uint256 bountyId;
        string proposalTitle;
        string proposalDescription;
        string proposalLink;
        address proposalCreator;
        uint256 depositValueETH;
        uint256 proposalValue;
    }

    struct Submission {
        uint256 dealId;
        string submissionTitle;
        string submissionDescription;
        string submissionLink;
        address submissionCreator;
        Status submissionStatus;
        string submissionComment;
    }

    struct Category {
        string categoryName;
        uint256 creatorId;
        uint256 hunterId;
    }
}
