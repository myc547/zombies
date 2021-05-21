pragma solidity >=0.5.0;

import "./ZombieBattle.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
contract ZombieOwnership is ZombieBattle, ERC721 {

    mapping (uint => address) zombieApprovals;

}
