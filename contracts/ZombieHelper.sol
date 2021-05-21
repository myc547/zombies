pragma solidity >=0.5.0;

import "./ZombieFeeding.sol";

/// @title zombie help
contract ZombieHelper is ZombieFeeding {

    uint levelUpFree = 0.001 ether;

    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    /// @dev withdraw
    function withdraw() external onlyOwner {
        owner.transfer(this.balance);
    }

    function setLevelUpFree(uint _fee) external onlyOwner {
        levelUpFree = _fee;
    }

    /// @dev level + 1
    function levelUp(uint _zombieId) external payable{
        require(msg.value == levelUpFee);
        zombies[_zombieId].level = zombies[_zombieId].level.add(1);
    }

    /// @dev change zombie name
    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
        zombies[_zombieId].dna = _newDna;
    }

    /// @dev get zombies for current owner
    function getZombiesByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }


}
