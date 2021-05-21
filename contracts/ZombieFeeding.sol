pragma solidity >=0.5.0;

import "./ZombieFactory.sol";

/// @title 给僵尸喂食
contract ZombieFeeding is ZombieFactory{

    KittyInterface kittyInterface;

    /// @title 只能是自己的验证修饰
    modifier onlyOwnerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    /// @dev 设置kitty的合约地址
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    /// @dev 触发冷却时间
    function _triggerCoolDown(Zombile storage _zombie) internal {
        _zombie.readyTime = uint32(now + coolDownTime);
    }

    /// @dev 是否冷却时间到了
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }

    /// @dev 喂食
    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna.add(_targetDna)).div(2);
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna.sub(newDna % 100 + 99);
        }
        _createZombie("noName", newDna);
        _triggerCoolDown(myZombie);
    }

    /// @dev 喂喵
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
