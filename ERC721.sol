pragma solidity ^0.5.2;

contract ERC721{
    
    function ownerof(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);
    
    event ShowOwnerDiamond(uint256 ID, uint price, uint carat, string color, string clear);
    event prevaccount(address prev);
    
    event Showunpay(uint256 ID);
    // supportsInterface(bytes4 _interfaceID) external view returns (bool);
}
