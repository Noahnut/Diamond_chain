pragma solidity ^0.5.2;

import "./DiamondPrice.sol";

contract DiamondBase is DiamondPrice{
    
    
    event Transfer(address from, address to, uint256 TokenId);
    
    struct diamond_profile{
        uint256  diamond_id;
        uint diamond_price;
        uint  diamond_carat;
        string diamond_color;
        string diamond_clear;
        address prev;
    }
    
    struct money_list{
        uint diamond_index;
        bool take;
    }
    
    
    
    diamond_profile[] Diamonds;
    
    money_list[] list;
    
    
    mapping(uint256 => address) internal DiamondIndexToOwner;
    mapping(address => uint256[]) internal OwnerToDiamondId;
    mapping(uint256 => address) internal DiamondIndexToapproved;
    mapping(uint256 => uint256) internal DiamodIdToDiamondIndex;
    
    mapping(uint256 => uint256) internal DiamondIndexToListId;
    
    function _getTheDiamond(address company, uint256 DiamondIndex) internal 
    {
        if(root_premission[company] != true){return;}
        else if(root_premission[company] == true){
              money_list memory temp;
              temp.diamond_index = DiamondIndex;
              temp.take = false;
              uint256 list_index = list.push(temp)-1;
              DiamondIndexToListId[DiamondIndex] = list_index;
        }
    }
    
    
    function _transfer(address _from, address _to, uint256 _tokenId) internal{
        require(DiamondIndexToOwner[_tokenId] == _from);
        
        //The 0 is point to the Diamonds first default place 
        for(uint i = 0; i < OwnerToDiamondId[_from].length; i++){
            if(OwnerToDiamondId[_from][i] == _tokenId){
                OwnerToDiamondId[_from][i] = 0;
            }
        }
        if(_from != address(0) || _from != address(this)){
             _getTheDiamond(_from, _tokenId);
        }
        
        OwnerToDiamondId[_to].push(_tokenId);
        DiamondIndexToOwner[_tokenId] = _to;
        Diamonds[_tokenId].prev = _from;
        emit Transfer(_from, _to, _tokenId);
    }
    
    function _creat_diamond(
        uint256 _diamond_id,
        uint _diamond_carat,
        string memory diamond_color,
        string memory diamond_clear,
        address _owner
    ) internal returns(uint)
    {
        require(change_flag == false);
        uint _diamond_price = price_count(_diamond_carat, diamond_color, diamond_clear);  
        diamond_profile memory _diamond_profile = diamond_profile({
           diamond_id: _diamond_id,
           diamond_price: _diamond_price,
           diamond_carat: _diamond_carat,
           diamond_clear: diamond_clear,
           diamond_color: diamond_color,
           prev         : address(0)
        });
        
        uint256 newDiamondId = Diamonds.push(_diamond_profile) - 1;
        _transfer(address(0), _owner, newDiamondId);
        
        require(DiamodIdToDiamondIndex[_diamond_id] == 0);
        DiamodIdToDiamondIndex[_diamond_id] = newDiamondId;
        
        return newDiamondId;
    }
    
    function ChangeAllPrice() external{
        require(root_premission[msg.sender] == true);

        for(uint256 i = 1; i < Diamonds.length; i++){
            Diamonds[i].diamond_price = price_count(Diamonds[i].diamond_carat, Diamonds[i].diamond_color, Diamonds[i].diamond_clear);
        }
        change_flag = false;
    }
    
    
}

