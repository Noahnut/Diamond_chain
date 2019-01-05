pragma solidity ^0.5.2;

import "./DiamondBase.sol";
import "./ERC721.sol";

contract DiamondOwnerShip is DiamondBase, ERC721 {
    
        
   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool){
       uint256 diamond_index = DiamodIdToDiamondIndex[_tokenId];
       return DiamondIndexToOwner[diamond_index] == _claimant;
   }
   
   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool){
      
       return DiamondIndexToapproved[_tokenId] == _claimant;
   }
   
   function _approve(uint256 _tokenId, address _approved) internal {
       DiamondIndexToapproved[_tokenId] = _approved;
   }
   
   
    function approve(
        address _to,
        uint256 _tokenId
    ) external
    {
        require(_owns(msg.sender, _tokenId));
       
        _approve(_tokenId, _to);
        
        emit Approval(msg.sender, _to, _tokenId);
    }
    
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external
    {
        require(_to != address(0));
        require(_approvedFor(msg.sender, _tokenId));
        require(_owns(_from, _tokenId));
        uint256 index = DiamodIdToDiamondIndex[_tokenId];
        _transfer(_from, _to, index);
    }
    
    
    function ownerof(uint256 DiamondId)
        external view returns(address owner)
    {
        uint256 _tokenId = DiamodIdToDiamondIndex[DiamondId];
        owner = DiamondIndexToOwner[_tokenId];
        require(owner != address(0));
    }
}
