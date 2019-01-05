pragma solidity ^0.5.2;
import "./DiamondCreate.sol";
contract DiamondCore is DiamondCreate
{
    //set the Diamonds array 0 is the default array all the empty will point to this place
    constructor() public {
       diamond_profile memory _diamond_profile = diamond_profile({
           diamond_id: 0,
           diamond_price: 0,
           diamond_carat: 0,
           diamond_color: "",
           diamond_clear: "",
           prev:  address(0)
        });
        
        Diamonds.push(_diamond_profile);
        devlop_company = msg.sender;}
    
    
     function showOwnerDiamond() external {
        for(uint i = 0; i < OwnerToDiamondId[msg.sender].length; i++){
            uint256 DiamondIndex = OwnerToDiamondId[msg.sender][i];
            if(DiamondIndex != 0){
                emit ShowOwnerDiamond(Diamonds[DiamondIndex].diamond_id, Diamonds[DiamondIndex].diamond_price, Diamonds[DiamondIndex].diamond_carat, Diamonds[DiamondIndex].diamond_color, Diamonds[DiamondIndex].diamond_clear);
            }
        }
    } 
    
    function showAllunpay() external DevelopPremission{
        for(uint i = 0; i < list.length; i++){
            if(list[i].take == false){
                uint256 _diamond_id = Diamonds[list[i].diamond_index].diamond_id;
                emit Showunpay(_diamond_id);
            }
        }
    }
    
    function GetTheMoney(uint256 diamond_id) external DevelopPremission{
        uint256 _diamond_index = DiamodIdToDiamondIndex[diamond_id];
        uint256 list_index = DiamondIndexToListId[_diamond_index];
        list[list_index].take = true;
    }
}
