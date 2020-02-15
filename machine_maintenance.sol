//this smart contract uses IOT devices connected to machines which can directly monitor machine health and send service requests to the smart contracts in case of maintainence need.
//The smart contract acts as an agreement between the machine and the service vendor to schedule a service request for the machine.

contract Maintainence {
    struct Machine {
        string machineName;
        uint256 purchasedate;
        address owner;
        string manufacturer;
    }

    struct ServiceRequest {
        uint256 timestamp;
        string remarks;
        address requester;
    }

    address public creator;
    uint256 public numMachines;
    uint256 public numServiceRequests;
    mapping(uint256 => ServiceRequest) serviceRequests;
    mapping(uint256 => Machine) machines;
    bool public result;

    event ServiceRequested(
        address requester,
        uint256 timestamp,
        uint256 machineID,
        string remarks
    );

    function maintainence() {
        creator = msg.sender;
        numMachines = 0;
        numServiceRequests = 0;
    }

    function registerMachine(
        uint256 machineID,
        string machinename,
        uint256 purchaseDate,
        string manufacturer
    ) public {
        Machine m = machines[machineID];
        m.machineName = machineName;
        m.purchaseDate = purchaseDate;
        m.owner = msg.sender;
        m.mnufacturer = manufacturer;
        numMachines++;
    }

    function getMachineDetails(uint256 machineID)
        public
        returns (
            string machineName,
            uint256 purchaseDate,
            address owner,
            string manufacturer
        )
    {
        machineName = machines[machineID].machineName;
        purchaseDate = machines[machineID].purchaseDate;
        owner = machines[machineID].owner;
        manufacturer = machines[machineID].manufacturer;
    }
    function getServiceRequest(uint256 machineID)
        public
        returns (uint256 timestamp, string remarks, address requester)
    {
        timestamp = serviceRequests[machineID].timestamp;
        remarks = serviceRequests[machineID].remarks;
        requester = serviceRequester[machineID].requester;
    }
    function requestService(
        uint256 timestamp,
        uint256 machineID,
        string remarks
    ) public {
        ServiceRequest s = serviceRequests[machineID];
        s.timestamp = timestamp;
        s.requester = msg.sender;
        s.remarks = remarks;
        numServiceRequests++;
        ServiceRequested(msg.sender, timestamp, machineID, remarks);
    }
    function destroy() {
        if (msg.sender == creator) {
            suicide(creator);
        }
    }
}
