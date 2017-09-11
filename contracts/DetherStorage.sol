pragma solidity 0.4.16;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract DetherStorage is Ownable {

  struct TellerPosition {
    int256 lat;
    int256 lng;
    uint zoneId;
  }

  struct TellerProfile {
    int8 avatarId;
    int8 currencyId;
    bytes32 messagingAddr;
    bytes32 name;
    uint nbTrade;
    int16 rate;
    uint volumeTrade;
  }

  struct Teller {
    TellerPosition tellerPosition;
    TellerProfile tellerProfile;
    uint balance;
  }

  mapping(address => Teller) tellers;
  mapping (uint => address[]) public tellerPerZone;

  // Teller Position
  function setTellerPosition(address _address, int256 lat, int256 lng, uint zoneId) onlyOwner {
    tellers[_address].tellerPosition = TellerPosition(lat, lng, zoneId);
  }

  function getTellerPosition(address _teller) view returns (
    int256 lat,
    int256 lng,
    uint zoneId) {
    return (
      tellers[_teller].tellerPosition.lat,
      tellers[_teller].tellerPosition.lng,
      tellers[_teller].tellerPosition.zoneId
    );
  }


  // Teller Profile
  function setTellerProfile(
    address _address,
    int8 _avatarId,
    int8 _currencyId,
    bytes32 _messagingAddr,
    bytes32 _name,
    int16 _rate) onlyOwner {
      tellers[_address].tellerProfile.avatarId = _avatarId;
      tellers[_address].tellerProfile.currencyId = _currencyId;
      tellers[_address].tellerProfile.messagingAddr = _messagingAddr;
      tellers[_address].tellerProfile.name = _name;
      tellers[_address].tellerProfile.rate = _rate;
  }

  function getTellerProfile(address _teller) view returns (
    int16 rate,
    uint volumeTrade,
    uint nbTrade,
    bytes32 name,
    int8 currencyId,
    int8 avatarId,
    bytes32 messagingAddr) {
      return (
        tellers[_teller].tellerProfile.rate,
        tellers[_teller].tellerProfile.volumeTrade,
        tellers[_teller].tellerProfile.nbTrade,
        tellers[_teller].tellerProfile.name,
        tellers[_teller].tellerProfile.currencyId,
        tellers[_teller].tellerProfile.avatarId,
        tellers[_teller].tellerProfile.messagingAddr
      );
  }


  // Teller Zone
  function setTellerZone(address _address, uint _zoneId) onlyOwner {
    if (tellers[_address].tellerPosition.zoneId != _zoneId) {
      tellerPerZone[_zoneId].push(_address);
    }
  }

  function getZone(uint _zone) view returns (address[]) {
    return tellerPerZone[_zone];
  }


  // Teller Reputation
  function setTellerReputation(address _address, uint _nbTrade, uint _volumeTrade) onlyOwner {
    tellers[_address].tellerProfile.nbTrade = _nbTrade;
    tellers[_address].tellerProfile.volumeTrade = _volumeTrade;
  }

  function getTellerReputation(address _address) view returns (uint nbTrade, uint volumeTrade) {
      return (tellers[_address].tellerProfile.nbTrade, tellers[_address].tellerProfile.volumeTrade);
  }


  // Teller Balance
  function setTellerBalance(address _address, uint _balance) onlyOwner {
    tellers[_address].balance = _balance;
  }

  function getTellerBalance(address _address) view returns (uint) {
    return tellers[_address].balance;
  }

  function clearMessagingAddress(address _address) onlyOwner returns (bool){
    tellers[_address].tellerProfile.messagingAddr = "";
    return true;
  }
}
