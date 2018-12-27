pragma solidity ^0.5.2;

contract ERC721{
    
    //基於加密貓所使用的ERC721規範
    


    //function totalSupply() public view returns (uint256 total);
    //function balanceOf(address _owner) public view returns (uint256 balance);
    //_tokenId == Diamond ID
    //檢測是否擁有這顆鑽石
    function ownerof(uint256 _tokenId) external view returns (address owner);

    //確認被轉移過去的鑽石是否正確，主要用在transferFrom
    //_to 鑽石轉移的目標帳戶
    function approve(address _to, uint256 _tokenId) external;

    //轉移鑽石的函數
    //_to 鑽石轉移的目標帳戶
    function transfer(address _to, uint256 _tokenId) external;

    //在次確認交易
    //_from 鑽石的原本主人
    //_to   鑽石的目標帳戶
    //_tokenId 鑽石ID
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    
    
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);
    
    // supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

contract DiamondBase{
    
    //基於ERC721的鑽石交換
    event Transfer(address from, address to, uint256 TokenId);
    
   
    
    struct diamond_profile{
        uint256 diamond_id;
        uint diamond_price;
        uint diamond_carat;
    }
    
    diamond_profile[] Diamonds;
    
    //每個鑽石ID都有一個其對應的主人
    mapping(uint256 => address) public Diamond_Index_To_Owner;

    //使用者的地址擁有哪些鑽石id
    mapping(address => uint256) public Owner_To_Diamond_Id;

    //哪些鑽石是要交易時，作為交易人確認用之映射
    mapping(uint256 => address) public DiamondInder_To_approved;
    

    //_from 鑽石原本使用者
    //_to   鑽石目標帳戶
    //_tokenId 鑽石ID
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        //此鑽石ID必須是屬於原本使用者
        require(Diamond_Index_To_Owner[_tokenId] == _from);
        
        //將此ID所對應的使用者改變
        Diamond_Index_To_Owner[_tokenId] = _to;

        //觸發事件
        emit Transfer(_from, _to, _tokenId);
    }
    
    //
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
        _transfer(address(0), _owner, _diamond_id);
        
        return newDiamondId;
    }
}

contract DiamondOwnerShip is DiamondBase, ERC721 {
    bytes4 constant interfaceSignature_ERC721 = 
        bytes4(keccak256('totalSupply()'))^
        bytes4(keccak256('balanceOf(adress'))^
        bytes4(keccak256('ownerof(uint256)'))^
        bytes4(keccak256('approve(address, uint256)')) ^
        bytes4(keccak256('transfer(address, uint256)')) ^
        bytes4(keccak256('transferFrom(address, address, uint256)'));
        
   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool){
       return Diamond_Index_To_Owner[_tokenId] == _claimant;
   }
   
   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool){
       return DiamondInder_To_approved[_tokenId] == _claimant;
   }
   
   function _approve(uint256 _tokenId, address _approved) internal {
       DiamondInder_To_approved[_tokenId] = _approved;
   }
   
   function transfer(
       address _to, 
       uint256 _tokenId
    ) external
    {
        require(_to != address(0));
        require(_to != address(this));
        
        require(_owns(msg.sender, _tokenId));
        
        _transfer(msg.sender, _to, _tokenId);
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
        require(_to != address(this));
        require(_approvedFor(msg.sender, _tokenId));
        require(_owns(_from, _tokenId));
        
        _transfer(_from, _to, _tokenId);
    }
    
    
    function ownerof(uint256 _tokenId)
        external view returns(address owner)
    {
        owner = Diamond_Index_To_Owner[_tokenId];
        require(owner != address(0));
    }
}


contract DiamondCreate is DiamondOwnerShip
{
    function creat_diamond(address target_address,uint256 diamond_id,uint _diamond_price, uint _diamond_carat) external{
        _creat_diamond(diamond_id,_diamond_price,_diamond_carat, address(this));
        _transfer(address(this), target_address, diamond_id);
    }    
}
