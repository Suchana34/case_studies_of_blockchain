contract SolarCharge{
    struct User{
        //details about the user
        string name;
        address userAccount;
        uint amountPaid;
        uint solarcoins;
    }
    mapping (bytes32 => User) public users;

    struct Station{
        //details about the solar charging station
        uint rate;
        string location;
        uint coinbalance;
        uint lastActivated;
        uint lastDuration;
    }

    mapping (uint => Station) public stations;

    address public owner;
    uint public numUsers;
    uint public numStations;
    uint public coinRate;

    function SolarCharge() {
        owner = msg.sender;
        numUsers = 0;
        numStations = 0;
        coinRate = 100000;
    }

    function registerUser(string _email, string _name)
    public{
        bytes32 email = stringToBytes(_email);

        if(users[email].userAccount > 0){
            throw;
        }
        User u = users[email];
        u.userAccount = msg.sender;
        u.name = _name;
        u.amountPaid = 0;
        u.solarcoins = 0;

        numUsers += 1;
    }

    function buyCoins(string _email)
    public
    payable
    {
        bytes32 email = stringToBytes(_email);

        if(users[email].userAccount != msg.sender){
            throw;
        }

        users[email].amountPaid += msg.value;
        users[email].solarcoins += msg.value*coinRate;
    }

    function addStation(uint ID, uint _rate, string _location)
    public {
        if(msg.sender != owner){
            throw;
        }
        if(stations[ID].rate != 0){
            throw;
        }
        Station s = stations[ID];

        s.coinbalance = 0;
        s.lastActivated = 0;
        s.lastDuration = 0;
        S.location = _location;
        s.rate = _rate;
        numStations += 1;
    }

    function activateStation(string _email, uint ID, uint duration)
    public{
        bytes32 email = stringToBytes(_email);
        //station doesnt exist
        if(stations[ID].rate == 0){
            throw;
        }

        //station is busy
        if(now<(stations[ID].lastActivated+stations[ID].lastDuration)){
            throw;
        }
        uint coinsRequired = stations[ID].rate*duration;

        //user has insufficient coins
        if(users[email].solarcoins < coinsRequired){
            throw;
        }

        users[email].solarcoins -= coinsRequired ;
        stations[ID].coinbalance += coinsRequired;
        stations[ID].lastActivated = now;
        stations[ID].lastDuration = duration;
    }

    //function to convert string to bytes32
    function stringToBytes (string s)
    public
    returns (bytes32){
        bytes memory b = bytes(s);
        uint r = 0;
        for(uint i=0; i<32; i++){
            if(i<b.length){
                r = r | uint(b[i]);
            }
            if(i<31) r = r*256;
        }
        return bytes32(r);
    }
    function getStationState(uint ID)
    view
    returns(bool){
        if(now< stations[ID].lastActivated+stations[ID].lastDuration ){
            return true;
        }
        else{
            return false;
        }
    }

    function getStation(uint ID)
    view
    returns(uint rate, string location, uint coinBalance, uint lastActivated, uint lastDuration){
        rate = stations[ID].rate;
        location = stations[ID].location;
        coinBalance = stations[ID].coinBalance;
        lastActivated = stations[ID].lastActivated;
        lastDuration = stations[ID].lastDuration;
    }

    function getUser(string _email)
    view
    returns(string name, address userAccount, uint amountPaid, uint solarcoins){
        bytes32 email = stringToBytes(_email);
        name = users[email].name;
        userAccount = users[email].userAccount;
        amountPaid = users[email].amountPaid;
        solarcoins = users[email].solarcoins;
    }

    function destroy() {
        if(msg.sender == owner){
            selfdestruct(owner);
        }
    }

}