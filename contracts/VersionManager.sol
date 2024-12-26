// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../contracts-common/contracts/access/Ownable.sol";

import "../interfaces/IVersionManager.sol";
import "./proxy/Proxy.sol";

contract VersionManager is IVersionManager, Ownable {
    /// @custom:storage-location erc7201:bitpost.vm.VersionManager
    struct Storage_VersionManager {
        mapping(uint16 => address) implementations;
    }
    
    // keccak256(abi.encode(uint256(keccak256("bitpost.vm.VersionManager")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant STORAGE_LOCATION_VERSIONMANAGER = 0x433f1e912c5d27d7a45609db3e669bf6cc6b4b451297228e4c27368efb8c2300;
    
    constructor() {
        _init_Ownable(msg.sender);
    }
    
    function getImplementation(uint16 cid) external view returns(address) {
        Storage_VersionManager storage $ = _getStorage_VersionManager();
        require($.implementations[cid] != address(0), VersionManagerInvalidCid(cid));
        return $.implementations[cid];
    }
    
    function setImplementation(uint16 cid, address implementation) external onlyOwner {
        Storage_VersionManager storage $ = _getStorage_VersionManager();
        $.implementations[cid] = implementation;
    }
    
    function newContract(uint16 cid) external returns(address) {
        Storage_VersionManager storage $ = _getStorage_VersionManager();
        require($.implementations[cid] != address(0), VersionManagerInvalidCid(cid));
        return address(new Proxy(this, cid));
    }
    
    function _getStorage_VersionManager() private pure returns(Storage_VersionManager storage $) {
        assembly {
            $.slot := STORAGE_LOCATION_VERSIONMANAGER
        }
    }
}
