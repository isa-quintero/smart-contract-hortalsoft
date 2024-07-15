// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^4.0.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";

contract Hortalsoft is ERC721, Ownable, EIP712, ERC721Votes {
    uint256 private _nextTokenId;

    struct TokenMetadata {
        uint256 price;
        uint256 amount;
        uint256 productId;
        uint256 farmerId;
    }

    mapping(uint256 => TokenMetadata) private _tokenData;

    constructor(address initialOwner)
        ERC721("Hortalsoft", "HTS")
        Ownable(initialOwner)
        EIP712("Hortalsoft", "1")
    {}

    function safeMint(
        address to,
        uint256 price,
        uint256 amount,
        uint256 productId,
        uint256 farmerId
    ) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);

        TokenMetadata storage metadata = _tokenData[tokenId];
        metadata.price = price;
        metadata.amount = amount;
        metadata.productId = productId;
        metadata.farmerId = farmerId;
    }

    function getTokenMetadata(uint256 tokenId)
        public
        view
        returns (
            uint256 price,
            uint256 amount,
            uint256 productId,
            uint256 farmerId
        )
    {
        TokenMetadata storage metadata = _tokenData[tokenId];
        return (
            metadata.price,
            metadata.amount,
            metadata.productId,
            metadata.farmerId
        );
    }

    function clock() public view override returns (uint48) {
        return uint48(block.timestamp);
    }

    // solhint-disable-next-line func-name-mixedcase
    function CLOCK_MODE() public pure override returns (string memory) {
        return "mode=timestamp";
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Votes)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Votes)
    {
        super._increaseBalance(account, value);
    }
}
