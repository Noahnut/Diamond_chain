pragma solidity ^0.5.2;

import "./DiamondAccessControl.sol";

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
