// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../contracts-common/interfaces/access/IOwnable.sol";

interface IVersionManager is IOwnable {
    error VersionManagerInvalidCid(uint16 cid);
    
    function getImplementation(uint16 cid) external view returns(address);
    function setImplementation(uint16 cid, address implementation) external;
    function newContract(uint16 cid) external returns(address);
}
