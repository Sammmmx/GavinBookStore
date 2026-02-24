//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract GavinBookStore {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct BookDetails {
        uint BookID;
        string _title;
        string _author;
        string _publication;
        bool _available;
    }

    mapping (uint => BookDetails) Books;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can access this function");
        _;
    }

    uint _id = 1;

    function addBook(string memory title, string memory author, string memory publication) public onlyOwner {
        Books[_id]._title = title;
        Books[_id]._author = author;
        Books[_id]._publication = publication;
        Books[_id].BookID = _id;
        Books[_id]._available = true;
        _id++;
    }

    function removeBook(uint id) public onlyOwner {
        require(id > 0 && Books[id]._available == true, "Invalid input");
        Books[id]._available = false;
    }

    function updateDetails(
        uint id, 
        string memory title, 
        string  memory author, 
        string memory publication, 
        bool available) public onlyOwner {
            require(id == Books[id].BookID, "No book exist with this id");
            Books[id] = BookDetails(Books[id].BookID , title, author, publication, available);
        }

    function findBookByTitle(string memory title) public view returns (uint[] memory)  {
        uint[] memory result = new uint[](_id - 1);
        uint count;
        if(msg.sender == owner) {
            for(uint i = 1; i < _id; i++) {
                if(keccak256(abi.encodePacked((title))) == keccak256(abi.encodePacked((Books[i]._title)))) {
                    result[count] = Books[i].BookID;
                    count++;
                }
            }
        } else {
            for(uint i = 1; i < _id; i++) {
                if(keccak256(abi.encodePacked((title))) == keccak256(abi.encodePacked((Books[i]._title))) && Books[i]._available == true) {
                    result[count] = Books[i].BookID;
                    count++;
                }
            }
        }

        assembly {
        mstore(result, count)
    }

        return result;
    }

    function findAllBooksOfPublication (string memory publication) public view returns (uint[] memory)  {
        uint[] memory result = new uint[](_id);
        uint count;
        if(msg.sender == owner) {
            for(uint i = 1; i < _id; i++) {
                if(keccak256(abi.encodePacked((publication))) == keccak256(abi.encodePacked((Books[i]._publication)))) {
                    result[count] =Books[i].BookID;
                    count++;
                }
            }
        } else {
            for(uint i = 1; i < _id; i++) {
                if(keccak256(abi.encodePacked((publication))) == keccak256(abi.encodePacked((Books[i]._publication))) && Books[i]._available) {
                    result[count] = Books[i].BookID;
                    count++;
                }
            }
        }
        assembly {
        mstore(result, count)
    }
        return result;
    }

    function findAllBooksOfAuthor (string memory author) public view returns (uint[] memory)  {
        uint[] memory result = new uint[](_id);
        uint count;
        if(msg.sender == owner) {
            for(uint i = 1; i < _id; i++) {
                if(keccak256(abi.encodePacked((author))) == keccak256(abi.encodePacked((Books[i]._author)))) {
                    result[count] =Books[i].BookID;
                    count++;
                }
            }
        } else {
            for(uint i = 1; i < _id; i++) {
                if(keccak256(abi.encodePacked((author))) == keccak256(abi.encodePacked((Books[i]._author))) && Books[i]._available) {
                    result[count] = Books[i].BookID;
                    count++;
                }
            }
        }
        assembly {
        mstore(result, count)
    }
        return result;
    }

    function getDetailsById(uint id) public view returns (
        string memory title, 
        string memory author, 
        string memory publication, 
        bool available)  {
            if(msg.sender == owner){
                return (Books[id]._title, Books[id]._author, Books[id]._publication, Books[id]._available);
            } else if(Books[id]._available == true) {
                return (Books[id]._title, Books[id]._author, Books[id]._publication, Books[id]._available);
            } else {
                revert("Book not available");
            }
        
    }
}