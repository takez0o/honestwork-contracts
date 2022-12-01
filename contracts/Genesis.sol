// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Genesis is ERC721 {
    mapping(address => uint256) userState;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        _mint(msg.sender, 1);
    }

    // free
    function bind() public {
        require(balanceOf(msg.sender) == 1);
        userState[msg.sender] = 2;
    }

    // pay
    function tier() public {
        if (userState[msg.sender] < 4) {
            userState[msg.sender]++;
        }
    }

    // pay
    function mint() public {
        _mint(msg.sender, 1);
        userState[msg.sender] = 1;
    }

    // 0-no tokens, 1-not soulbound, 2-soulbound(tier 1), 3-soulbound(tier 2), 4-soulbound(tier-3)
    function getUserState(address _user) public view returns (uint256) {
        return userState[_user];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 id,
        uint256 batchSize
    ) internal virtual override {
        if (from == address(0)) {
            require(balanceOf(msg.sender) == 0, "1 per wallet");
        } else if (to != address(0)) {
            require(userState[msg.sender] < 2, "Your token is bounded");
            require(balanceOf(to) == 0, "Receiver already has a token");
        }
        super._beforeTokenTransfer(from, to, id, batchSize);
    }
}
