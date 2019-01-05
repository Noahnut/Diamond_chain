pragma solidity ^0.5.2;



contract DiamondAccessControl{
    
    
    //Now only one level Premission type
    mapping(address => bool) internal root_premission;
    
    address internal devlop_company;
    
    modifier RootPremission(){
        require(root_premission[msg.sender]);
        _;
    }
    
    modifier DevelopPremission(){
        require(devlop_company == msg.sender);
        _;
    }
    
    function setThePremission(address newCompany) external DevelopPremission{
        require(newCompany != address(0));
        
        root_premission[newCompany] = true;
    }
    
    function cancelPremision(address Company) external DevelopPremission{
        require(Company != address(0));
        require(Company != msg.sender);
        root_premission[Company] = false;
    }
    
}

contract ERC721{
    
    function ownerof(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);
    
    event ShowOwnerDiamond(uint256 ID, uint price, uint carat, string color, string clear);
    event prevaccount(address prev);
    // supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

contract DiamondPrice is DiamondAccessControl{
    
    
    bool change_flag = false;
    
    mapping(string => mapping(string => uint256)) internal color_clear_price;
    
    function price_D(uint256 fl, uint256 vvs, uint256 vs, uint256 sl, uint256 l1) external{
        require(root_premission[msg.sender] == true);
        color_clear_price['D']['FL'] = fl;
        color_clear_price['D']['VVS'] = vvs;
        color_clear_price['D']['VS'] = vs;
        color_clear_price['D']['SL'] = sl;
        color_clear_price['D']['L1'] = l1;
        change_flag = true;
    }
    
    function price_G(uint256 fl, uint256 vvs, uint256 vs, uint256 sl, uint256 l1) external{
        require(root_premission[msg.sender] == true);
        color_clear_price['G']['FL'] = fl;
        color_clear_price['G']['VVS'] = vvs;
        color_clear_price['G']['VS'] = vs;
        color_clear_price['G']['SL'] = sl;
        color_clear_price['G']['L1'] = l1;
        change_flag = true;
    }
    
    function price_J(uint256 fl, uint256 vvs, uint256 vs, uint256 sl, uint256 l1) external{
        require(root_premission[msg.sender] == true);
        color_clear_price['J']['FL'] = fl;
        color_clear_price['J']['VVS'] = vvs;
        color_clear_price['J']['VS'] = vs;
        color_clear_price['J']['SL'] = sl;
        color_clear_price['J']['L1'] = l1;
        change_flag = true;
    }
    
    function price_M(uint256 fl, uint256 vvs, uint256 vs, uint256 sl, uint256 l1) external{
        require(root_premission[msg.sender] == true);
        color_clear_price['M']['FL'] = fl;
        color_clear_price['M']['VVS'] = vvs;
        color_clear_price['M']['VS'] = vs;
        color_clear_price['M']['SL'] = sl;
        color_clear_price['M']['L1'] = l1;
        change_flag = true;
    }
    
    function price_Z(uint256 fl, uint256 vvs, uint256 vs, uint256 sl, uint256 l1) external{
        require(root_premission[msg.sender] == true);
        color_clear_price['Z']['fl'] = fl;
        color_clear_price['Z']['vvs'] = vvs;
        color_clear_price['Z']['vs'] = vs;
        color_clear_price['Z']['sl'] = sl;
        color_clear_price['Z']['l1'] = l1;
        change_flag = true;
    }
    
    function price_count(uint256 carat, string memory color, string memory clear) internal view returns(uint256){
        require(root_premission[msg.sender] == true);
        color = upper(color);
        clear = upper(clear);
        uint256 number = color_clear_price[color][clear];
        return (number * uint256(carat) * 100);
        
    }
    
    function upper(string memory _base) 
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _upper(_baseBytes[i]);
        }
        return string(_baseBytes);
    }
    
    function _upper(bytes1 _b1)
        private
        pure
        returns (bytes1) {

        if (_b1 >= 0x61 && _b1 <= 0x7A) {
            return bytes1(uint8(_b1)-32);
        }

        return _b1;
    }
}

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
}

