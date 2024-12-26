// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../../contracts-common/contracts/upgrade/Upgradeable.sol";

import "../VersionManager.sol";

contract Proxy is Upgradeable {
    constructor(VersionManager versionManager, uint16 cid) {
        _init_Upgradeable(versionManager, cid);
    }
    
    fallback() external payable {
        address target = _getVersionManager().getImplementation(_getCid());
        
        // The target address is stored on the stack, not in memory, 
        // so it won't be affected by operations using memory offset 0.
        
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), target, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
