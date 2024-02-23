// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./tokens/ERC404.sol";
import "./utils/Strings.sol";

contract Token is ERC404 {
  string public baseTokenURI;

  event BaseTokenURIChanged(string baseTokenURI);

  constructor(
    string memory name,
    string memory symbol,
    uint8 decimals,
    uint256 totalSupply,
    address receiver
  ) ERC404(name, symbol, decimals, totalSupply, receiver) {}

  function tokenURI(uint256 id) public view override returns (string memory) {
    return
      string(
        abi.encodePacked(baseTokenURI, Strings.toString(id), ".json")
      );
  }

  function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
    baseTokenURI = _baseTokenURI;
    emit BaseTokenURIChanged(_baseTokenURI);
  }
}