pragma solidity ^0.5.2;



contract DiamondAccessControl{
    
    
    //Now only one level Premission type
    mapping(address => bool) internal root_premission;
    
    modifier RootPremission(){
        require(root_premission[msg.sender]);
        _;
    }
    
    function setThePremission(address newCompany) external RootPremission{
        require(newCompany != address(0));
        
        root_premission[newCompany] = true;
    }
    
    function cancelPremision(address Company) external RootPremission{
        require(Company != address(0));
        require(Company != msg.sender);
        root_premission[Company] = false;
    }
    
    
    /*
    function test_function() external view returns(bool){
        return(root_premission[msg.sender]);
    }
    */
    
    
}

contract ERC721{
    
    
    //function totalSupply() public view returns (uint256 total);
    //function balanceOf(address _owner) public view returns (uint256 balance);
    function ownerof(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
    function transfer(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);
    
    event ShowOwnerDiamond(uint256 ID, uint price, uint carat);
    
    // supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

contract DiamondBase is DiamondAccessControl{
    
    
    event Transfer(address from, address to, uint256 TokenId);
    
    
    
    struct diamond_profile{
        uint256 diamond_id;
        uint diamond_price;
        uint diamond_carat;
    }
    
  
    diamond_profile[] Diamonds;
    
    
    
    mapping(uint256 => address) internal DiamondIndexToOwner;
    
    mapping(address => uint256[]) internal OwnerToDiamondId;
    mapping(uint256 => address) internal DiamondIndexToapproved;
    
    mapping(uint256 => uint256) internal DiamodIdToDiamondIndex;
   
    
    function _transfer(address _from, address _to, uint256 _tokenId) internal{
        require(DiamondIndexToOwner[_tokenId] == _from);
        
        //The 0 is point to the Diamonds first default place 
        for(uint i = 0; i < OwnerToDiamondId[_from].length; i++){
            if(OwnerToDiamondId[_from][i] == _tokenId){
                OwnerToDiamondId[_from][i] = 0;
            }
        }
        
        OwnerToDiamondId[_to].push(_tokenId);
        DiamondIndexToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
    
    function _creat_diamond(
        uint256 _diamond_id,
        uint _diamond_price,
        uint _diamond_carat,
        address _owner
    ) internal returns(uint)
    {
        diamond_profile memory _diamond_profile = diamond_profile({
           diamond_id: _diamond_id,
           diamond_price: _diamond_price,
           diamond_carat: _diamond_carat
        });
        
        uint256 newDiamondId = Diamonds.push(_diamond_profile) - 1;
        _transfer(address(0), _owner, newDiamondId);
        
        require(DiamodIdToDiamondIndex[_diamond_id] == 0);
        DiamodIdToDiamondIndex[_diamond_id] = newDiamondId;
        
        return newDiamondId;
    }
}

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


contract DiamondCreate is DiamondOwnerShip
{
    
    function creat_diamond(address target_address,uint256 diamond_id,uint _diamond_price, uint _diamond_carat) external payable{
        require(root_premission[msg.sender] == true);
        uint256 newDiamondId = _creat_diamond(diamond_id,_diamond_price,_diamond_carat, address(this));

        _transfer(address(this), target_address, newDiamondId);
    }    
}

contract DiamondCore is DiamondCreate
{
    //set the Diamonds array 0 is the default array all the empty will point to this place
    constructor() public {
       diamond_profile memory _diamond_profile = diamond_profile({
           diamond_id: 0,
           diamond_price: 0,
           diamond_carat: 0
        });
        
        Diamonds.push(_diamond_profile);
        
        root_premission[msg.sender] = true;}
    
   
        
    function showOwnerDiamond() external {
        
        for(uint i = 0; i < OwnerToDiamondId[msg.sender].length; i++){
            uint256 DiamondIndex = OwnerToDiamondId[msg.sender][i];
            if(DiamondIndex != 0){
                emit ShowOwnerDiamond(Diamonds[DiamondIndex].diamond_id, Diamonds[DiamondIndex].diamond_price, Diamonds[DiamondIndex].diamond_carat);
            }
        }
     
    } 
   
}

