pragma solidity ^0.6.1;

contract DocVerify {
    struct Document {
        address owner;
        uint256 blockTimestamp;
    }

    address public creator;
    uint256 public numDocuments;
    mapping(bytes32 => Document) public documentHashMap;

    function DocVerify() {
        creator = msg.sender;
        numDocuments = 0;
    }

    function newDocument(bytes32 hash) external returns (bool success) {
        if (documentExists(hash)) {
            success = false;
        } else {
            Document d = documentHashMap[hash];
            d.hash = hash;
            d.owner = msg.sender;
            d.blockTimestamp = block.Timestamp;
            numDocuments++;
            success = true;
        }
        return success;
    }

    function documentExists(bytes32 hash) external view returns (bool exists) {
        if (documentHashMap[hash].blockTimestamp > 0) {
            exists = true;
        } else {
            exists = false;
        }
        return exists;
    }

    function getDocument(bytes32 hash)
        external
        view
        returns (uint256 blockTimestamp, address owner)
    {
        blockTimestamp = documentHashMap[hash].blockTimestamp;
        owner = documentHashMap[hash].owner;
    }

    function destroy()
    external{
        if(msg.sender == creator){
            selfdestruct(creator);
        }
    }
}
