pragma solidity ^0.6.1;

contract CrowdFunding {
    struct backer {
        address addr;
        uint256 amount;
    }
    address public owner;
    uint256 public numBackers;
    uint256 public deadline;
    string public campaignStatus;
    bool ended;
    uint256 public goal;
    uint256 public amountRaised;
    mapping(uint256 => backer) backers;

    event Deposit(address _from, uint256 _address);
    event Refund(address _to, uint256 _amount);

    modifier onlyOwner() {
        if (msg.sender != owner) revert("Sorry you cant access");
        _;
    }

    //constructor
    function CrowdFunding(uint256 _deadline, uint256 _goal) external {
        owner = msg.sender;
        deadline = _deadline;
        goal = _goal;
        campaignStatus = "Funding";
        amountRaised = 0;
        numBackers = 0;
        ended = false;
    }

    function fund() external payable {
        backer b = backers[numBackers++];
        b.addr = msg.sender;
        b.amount = msg.value;
        amountRaised += b.amount;
        emit Deposit(msg.sender, msg.value);
    }

    function checkgoalreached() external onlyOwner returns (bool ended) {
        if (ended) {
            throw;
        }
        if (block.timestamp < deadline) {
            throw;
        }
        if (amountRaised >= goal) {
            campaignStatus = "Campaign Succeeded";
            ended = true;
            if (!owner.transfer(this.balance)) {
                throw;
            } else {
                uint256 i = 0;
                campaignStatus = "Campaign failed";
                ended = true;
                while (i <= numBackers) {
                    backers[i].amount = 0;
                    emit Refund(backers[i].addr, backers[i].amount);
                    i++;
                }
            }
        }
    }
    function destroy() external {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}
