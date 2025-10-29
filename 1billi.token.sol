// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Salana Token (SLN) - 1,000,000,000,000 fixed supply ERC20
/// @notice Hibamentes, Remix-kompatibilis ERC20 token
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/access/Ownable.sol";

contract SalanaToken is ERC20, ERC20Burnable, Ownable {
    // 1,000,000,000,000 * 10^18
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000_000 * 10 ** 18;

    constructor() ERC20("Salana Token", "SLN") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /// @notice Explicit decimál beállítás
    function decimals() public pure override returns (uint8) {
        return 18;
    }

    /// @notice Tulajdonosi vészégetés
    function ownerBurn(uint256 amount) external onlyOwner {
        require(amount > 0, "SalanaToken: burn amount must be > 0");
        _burn(msg.sender, amount);
    }
}