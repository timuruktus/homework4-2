
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract nft {

    struct car{
        string name;
        uint speed;
        uint level;
        uint contollability;
        bool forSale;
        uint price;
    }

    uint constant BASIC_LEVEL = 1;
    uint constant PRO_LEVEL = 2;
    uint constant LEGENDARY_LEVEL = 3;

    uint constant REQUIRE_BASIC_LEVEL_ERROR = 201;
    uint constant REQUIRE_UNIQUE_NAME_ERROR = 202;
    uint constant NOT_AN_OWNER_ERROR = 203;

    uint constant NOT_FOR_SALE_PRICE = 0;


    car[] carsArray;
    mapping (uint => uint) carIdToOwner;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkIfNameUnique(string name) {
        bool isUnique = true;
        for(uint i = 0; i < carsArray.length; i++){
            if(carsArray[i].name == name){
                isUnique = false;
            }
        }
        require(isUnique, REQUIRE_UNIQUE_NAME_ERROR);
        _;
    }

    modifier checkIfOwner(uint pubkey, uint carId){
        require(msg.pubkey() == carIdToOwner[carId], NOT_AN_OWNER_ERROR);
        _;
    }

    function createCar(string name, uint speed, uint controllability) public 
    checkIfNameUnique(name){
        tvm.accept();
        carsArray.push(car(name, speed, BASIC_LEVEL, controllability, false, NOT_FOR_SALE_PRICE));
        carIdToOwner[carsArray.length - 1] = msg.pubkey();
    }

    function sellCar(uint carId, uint price) public checkIfOwner(msg.pubkey(), carId){
        tvm.accept();
        carsArray[carId].forSale = true;
        carsArray[carId].price = price;
    }

    //This is debug function. Shows al created cars.
    function getAllCars() public returns(car[]){
        return carsArray;
    }

}
