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
        require(msg.sender == devlop_company);
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
