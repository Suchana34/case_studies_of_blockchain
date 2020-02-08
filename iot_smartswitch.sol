pragma solidity ^0.6.1;

contract SmartSwitch{
    address public owner;
    mapping(address => uint) public usersPaid;
    uint public numUsers;

    event Deposit(address _from, uint _amount);
    event Refund(address _to, uint amount );

    modifier onlyOwner(){
        if(msg.sender != owner) throw;
        _;
    }

    function SmartSwitch()
    external{
        owner = msg.sender;
        numUsers = 0;
    }

    function payToSwitch()
    external
    payable{
        usersPaid[msg.sender] = msg.value;
        numUsers++;
        emit Deposit(msg.sender, msg.value);
    }

    function refundUser(address recipient, uint amount)
    external
    onlyOwner {
        if(usersPaid[recipient] == amount){
            if(this.balance >= amount){
                if(!recipient.transfer(amount)) revert("You have no balance");
                emit Refund(recipient, amount);
                usersPaid[recipient] = 0;
                numUsers--;
            }
        }
    }
    function withdrawFunds() external onlyOwner{
        if(!owner.transfer(this.balance)) throw;
    }

    function kill() external  onlyOwner{
        selfdestruct(owner);
    }
}