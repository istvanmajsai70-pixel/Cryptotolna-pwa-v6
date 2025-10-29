// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Uniswap V2 interfészek (csak a szükséges részek)
interface IUniswapV2Router {
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract MegaToken is ERC20, Ownable {
    struct ContractData {
        string name;
        string content;
        uint256 createdAt;
    }

    mapping(uint256 => ContractData) public contracts;
    uint256 public contractCount;

    IUniswapV2Router public uniswapRouter;
    address public liquidityPair;

    constructor(address _router) ERC20("MegaToken", "MTK") {
        // 1000 milliárd token, 18 decimals
        _mint(msg.sender, 1_000_000_000_000 * 10**18);

        uniswapRouter = IUniswapV2Router(_router);
    }

    // ========================
    // Szerződés mentés
    // ========================
    function addContract(string memory _name, string memory _content) external onlyOwner {
        contracts[contractCount] = ContractData(_name, _content, block.timestamp);
        contractCount++;
    }

    function getContract(uint256 _id) external view returns (string memory, string memory, uint256) {
        ContractData memory c = contracts[_id];
        return (c.name, c.content, c.createdAt);
    }

    // ========================
    // Likviditás hozzáadás Uniswap-hoz
    // ========================
    function addLiquidity(uint256 tokenAmount) external payable onlyOwner {
        // engedélyezés a routernek
        _approve(address(this), address(uniswapRouter), tokenAmount);

        // likviditás hozzáadása
        uniswapRouter.addLiquidityETH{value: msg.value}(
            address(this),
            tokenAmount,
            0,
            0,
            owner(),
            block.timestamp + 300
        );
    }

    // Fogadja az ETH-t
    receive() external payable {}
}