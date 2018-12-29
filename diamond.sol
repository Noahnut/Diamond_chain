pragma solidity ^0.5.2;



contract DiamondAccessControl{
    
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
    
    // supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

contract DiamondBase is DiamondAccessControl{
    
    
    event Transfer(address from, address to, uint256 TokenId);
    
    
    
    struct diamond_profile{
        uint256 diamond_id;
        uint diamond_price;
        uint diamond_carat;
    }
    
    struct diamond_id{
        uint256 diamond_id;
    }
    
    diamond_profile[] Diamonds;
    
    mapping(uint256 => address) public DiamondIndexToOwner;
    mapping(address => uint256[]) public OwnerToDiamondId;
    mapping(uint256 => address) public DiamondInderToapproved;
    
    function _transfer(address _from, address _to, uint256 _tokenId) internal{
        require(DiamondIndexToOwner[_tokenId] == _from);
        
        DiamondIndexToOwner[_tokenId] = _to;
        for(uint i = 0; i < OwnerToDiamondId[_from].length; i++){
            if(OwnerToDiamondId[_from][i] == _tokenId){
                OwnerToDiamondId[_from][i] = 0;
            }
        }
        
        OwnerToDiamondId[_to].push(_tokenId);
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
       return DiamondIndexToOwner[_tokenId] == _claimant;
   }
   
   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool){
       return DiamondInderToapproved[_tokenId] == _claimant;
   }
   
   function _approve(uint256 _tokenId, address _approved) internal {
       DiamondInderToapproved[_tokenId] = _approved;
   }
   
   function transfer(
       address _to, 
       uint256 _tokenId
    ) external
    {
        require(_to != address(0));
        require(_to != address(this));
        
       
        
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
        owner = DiamondIndexToOwner[_tokenId];
        require(owner != address(0));
    }
}


contract DiamondCreate is DiamondOwnerShip
{
    
    function creat_diamond(address target_address,uint256 diamond_id,uint _diamond_price, uint _diamond_carat) external payable{
        require(root_premission[msg.sender] == true);
        _creat_diamond(diamond_id,_diamond_price,_diamond_carat, address(this));

        _transfer(address(this), target_address, diamond_id);
    }    
}

contract DiamondCore is DiamondCreate
{
    constructor() public {root_premission[msg.sender] = true;}
    
}
