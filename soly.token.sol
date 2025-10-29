// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; // Stabil, EVM-kompatibilis verzió

// OpenZeppelin importok
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/access/Ownable.sol";

/// @title ExampleERC20 - 500,000,000,000 token 18 decimállal
/// @notice Fix kínálatú token, tulajdonosi és felhasználói burn funkciókkal
contract ExampleERC20 is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 500_000_000_000 * 10 ** 18;

    // Esemény a tulajdonosi burn-hoz
    event OwnerBurn(address indexed owner, uint256 amount);

    /// @notice Konstruktor: teljes kínálat a deployerhez kerül
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /// @notice Explicit decimál beállítás
    function decimals() public pure override returns (uint8) {
        return 18;
    }

    /// @notice Teljes kínálat token egységekben
    function totalSupplyTokens() external view returns (uint256) {
        return totalSupply();
    }

    /// @notice Tulajdonos vészégetése, esemény küldéssel
    function ownerBurn(uint256 amount) external onlyOwner {
        require(amount > 0, "ERC20: burn amount must be greater than zero");
        _burn(msg.sender, amount);
        emit OwnerBurn(msg.sender, amount);
    }

    /// @notice Bárki égetheti a saját tokenjeit
    function burn(uint256 amount) external {
        require(amount > 0, "ERC20: burn amount must be greater than zero");
        _burn(msg.sender, amount);
    }

    /// @notice Bárki égetheti a tokeneket, ha jóváhagyással rendelkezik
    function burnFrom(address account, uint256 amount) external {
        require(account != address(0), "ERC20: burn from the zero address");
        require(amount > 0, "ERC20: burn amount must be greater than zero");

        uint256 currentAllowance = allowance(account, msg.sender);
        require(currentAllowance >= amount, "ERC20: allowance too low");

        unchecked {
            _approve(account, msg.sender, currentAllowance - amount);
        }

        _burn(account, amount);
    }
}