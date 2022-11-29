// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Genesis is ERC721 {
    mapping(address => bool) soulbound;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        _mint(msg.sender, 1);
    }

    // make your token untransferable
    function makeSoulbound() public {
        require(balanceOf(msg.sender) == 1);
        soulbound[msg.sender] = true;
    }

    // free mint, 1-per-wallet
    function mint() public {
        _mint(msg.sender, 1);
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
            require(soulbound[msg.sender] == false, "Your token is bounded");
            require(balanceOf(to) == 0, "Receiver already has a token");
        }
        require(soulbound[msg.sender], "No soulbound tokens");
        super._beforeTokenTransfer(from, to, id, batchSize);
    }
}
