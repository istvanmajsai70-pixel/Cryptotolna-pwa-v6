// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TutifutToken {
    string public name = "TutifutToken";
    string public symbol = "TFT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Valós címek a tokenek kiosztásához
    address public cim1;
    address public cim2;

    constructor(uint256 _initialSupply, address _cim1, address _cim2) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);

        // Deployoló kap 50%, a két valós cím 25-25%
        balanceOf[msg.sender] = totalSupply / 2;
        balanceOf[_cim1] = totalSupply / 4;
        balanceOf[_cim2] = totalSupply / 4;

        cim1 = _cim1;
        cim2 = _cim2;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, unicode"Nincs elegendő tokened");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, unicode"Nincs elegendő tokened");
        require(allowance[_from][msg.sender] >= _value, unicode"Nincs engedélyezve elegendő token");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}





















