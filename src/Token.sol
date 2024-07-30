// SPDX-License-Identifier:MIT
pragma solidity 0.8.26;

//?? //////////////////////////////////////////////
// SAFE MATH
import "../src/SafeMath/SafeMath.sol";

//?? //////////////////////////////////////////////
// INTERFACE

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _address) external returns (uint256 balance);
    function approve(
        address _spender,
        uint256 _value
    ) external returns (bool success);
    function allowance(address _spender) external returns (uint256 remainings);
    function transfer(
        address _to,
        uint256 _value
    ) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
    );
}

//?? //////////////////////////////////////////////

contract Permissible {
    bytes32 public ADMIN_ROLE_ID = keccak256("ADMIN");

    mapping(address => mapping(bytes32 => bool)) public role;
    address public owner;

    constructor() {
        owner = msg.sender;
        role[msg.sender][ADMIN_ROLE_ID] = true;
    }

    modifier isAdmin() {
        require(role[msg.sender][ADMIN_ROLE_ID], "Permission denied");
        _;
    }
    function _grantRole(address _address) public isAdmin returns (bool) {
        role[_address][ADMIN_ROLE_ID] = true;
        return true;
    }
}

// TOKEN CONTRACT
contract Token is IERC20, Permissible {
    using SafeMath for uint256;
    string _name;
    string _symbol;
    uint256 _totalSupply;
    uint8 public decimals = 2;

    mapping(address => mapping(address => uint256)) allowed;
    mapping(address => uint256) balance;

    constructor() Permissible() {
        _name = "JOKER TOKEN";
        _symbol = "JKR";
    }

    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function _mint(
        address _to,
        uint256 _value
    ) internal returns (bool success) {
        balance[_to] = balance[_to].add(_value);
        _totalSupply = _totalSupply.add(_value);
        return true;
    }

    function mint(address _to, uint256 _value) public isAdmin returns (bool) {
        return _mint(_to, _value);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return balance[_address];
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(
            _value
        );
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf(msg.sender) >= _value, "Low balance");
        balance[msg.sender] = balance[msg.sender].sub(_value);
        balance[_to] = balance[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(_value <= allowed[_from][msg.sender], "Sales Limit");
        require(_value <= balance[_from], "Insufficiency");
        balance[_from] = balance[_from].sub(_value);
        balance[_to] = balance[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function allowance(
        address _spender
    ) public view returns (uint256 remainings) {
        return allowed[msg.sender][_spender];
    }
}
