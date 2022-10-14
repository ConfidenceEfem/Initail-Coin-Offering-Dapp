// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface InftHolder {
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns(uint);

    function balanceOf(address owner) external view returns (uint);
}