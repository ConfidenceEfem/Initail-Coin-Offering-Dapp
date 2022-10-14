// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./InftHolder.sol";

contract CryptoDevICO is ERC20, Ownable {

    InftHolder nftHolder;

    uint public oneToken = 10 ** 18;

    uint public maxToken = 10000 * oneToken;

    uint public pricePerToken = 0.001 ether;

    uint public tokenPerNft = 10 * oneToken;

    // uint public tokenId;

    mapping(uint => bool) public checkTokenId;

    constructor(address nftHolderAddr) ERC20("Crypto Dev ICO","CDT"){
        nftHolder = InftHolder(nftHolderAddr);
    }

    function mintToken(uint amount) payable public {
        uint totalPrice = amount * pricePerToken;
        uint totalTokenPurchase = oneToken * amount;
        require(msg.value >= totalPrice, "Incorrect Ethers");
        require((totalSupply() + totalTokenPurchase) <= maxToken, "Insufficient Token");

        _mint(msg.sender, totalTokenPurchase);
    }

    function claimToken() payable public {
        require(nftHolder.balanceOf(msg.sender) <= 0, "You don't have right for this operation");

        uint balance = nftHolder.balanceOf(msg.sender);

        uint tokenId;

        for(uint i=0; i<balance; i++){
            uint nftTokenId = nftHolder.tokenOfOwnerByIndex(msg.sender, i);
            if(!checkTokenId[nftTokenId]){
               
                tokenId++; 
                checkTokenId[nftTokenId] = true;
            }
        }
        require(tokenId <=0, "You have use all NFT");
        _mint(msg.sender,tokenId * tokenPerNft);
    }

    function withdrawEther() onlyOwner public  {
        address  _owner = owner();
        uint balance = address(this).balance;
        (bool sent, ) = _owner.call{value: balance}(" ");
        require(sent, "Failed to send ethers");

    }

    receive() external payable {}
    fallback() external payable {}

}