pragma solidity ^0.5.2;

import "./DiamondOwnship.sol";

contract DiamondCreate is DiamondOwnerShip
{
    
    function creat_diamond(address target_address,uint256 diamond_id, uint _diamond_carat, string calldata _diamond_color, string calldata _diamond_clear) external payable{
        require(root_premission[msg.sender] == true);
        uint256 newDiamondId = _creat_diamond(diamond_id,_diamond_carat,_diamond_color, _diamond_clear, address(this));
        _transfer(address(this), target_address, newDiamondId);
    }    
    
    function look_prevaccount(uint256 diamond_id) external{
        require(root_premission[msg.sender] == true);
        uint256 diamondIndex = DiamodIdToDiamondIndex[diamond_id];
        address prev_account = Diamonds[diamondIndex].prev;
        emit prevaccount(prev_account);
    }
}
