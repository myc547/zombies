pragma solidity >=0.5.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
/// @title 僵尸工厂
/// @notice 僵尸生成
contract ZombieFactory is Ownable {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    // 创建完僵尸的事件
    event NewZombie(uint zombieId, string name, uint dna);

    // 僵尸dna算法
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint coolDownTime = 1 days; // 冷却时间

    // 僵尸结构
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    // 僵尸归谁所有
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount; // 僵尸数量

    /// @dev 创建僵尸
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + coolDownTime), 0, 0)) -1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        NewZombie(id, _name, _dna);
    }

    /// @dev 生成dna
    function _generateRandomDna(string _str) private view returns(uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;

    }

    /// @dev 创建一个随机僵尸
    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }


}
