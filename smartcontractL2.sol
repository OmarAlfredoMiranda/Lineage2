pragma solidity ^0.8.0;

contract Lineage2 {
    address public owner;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(uint => Item)) public itemsOf;

    struct Item {
        string name;
        uint level;
        uint rarity;
    }

    event Transfer(address indexed from, address indexed to, uint indexed tokenId);

    constructor() public {
        owner = msg.sender;
    }

    function createItem(string memory _name, uint _level, uint _rarity) public {
        require(msg.sender == owner, "Only owner can create items");
        Item memory newItem = Item(_name, _level, _rarity);
        uint tokenId = itemsOf[msg.sender].length++;
        itemsOf[msg.sender][tokenId] = newItem;
        balanceOf[msg.sender]++;
    }

    function transfer(address _to, uint _tokenId) public {
        require(itemsOf[msg.sender][_tokenId].name != "", "Item does not exist");
        require(balanceOf[msg.sender] > _tokenId, "Not enough items");
        require(_to != address(0), "Invalid address");
        require(msg.sender != _to, "Cannot transfer to self");
        Item memory item = itemsOf[msg.sender][_tokenId];
        itemsOf[msg.sender][_tokenId] = Item("", 0, 0);
        balanceOf[msg.sender]--;
        itemsOf[_to][balanceOf[_to]++] = item;
        balanceOf[_to]++;
        emit Transfer(msg.sender, _to, _tokenId);
    }
}
