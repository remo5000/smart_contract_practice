pragma solidity ^0.4.16;

/// @title Sending and receiving a single message to and from any given account.
contract SendSingleMessage {

  // A Message is the string(semantically, the actual message)
  // and a boolean to indicate if this message has been sent already
  struct Message {
    string msg_str;
    bool sent;
    bool can_send;
  }

  // an event to mark that the sending has occured. Unsure of it's significance.
  event SingleMessageSent(address from, address to);
  // to track if a user has sent a message already
  mapping(address => Message) public send_log;
  // to track what message a user receives
  mapping(address => Message) public mailbox;
  // the admin (who has admin rights)
  address public admin;

  // Constructor of this contract, admin has a message entry assigned to him.
  function SendSingleMessage(string opening_message) public {
    admin = msg.sender
    send_log[admin].msg_str = opening_message;
  }

  // Give 'sender' the right to send a message, if he has not done so.
  // May only be called by the admin.
  function giveRightToSendMessage(address sender) public {
      require((msg.sender == admin) && !send_log[sender].sent);
      send_log[sender].can_send = true;
  }

  // Allows any user to modify a draft of their message, without permission
  function ModifyDraft(string new_message) {
    require(!send_log[msg.sender].sent);
    send_log[msg.sender].msg_str = new_message;
  }

  // User can send their message if it has been approved.
  function Send(address receiver) {
    require(send_log[msg.sender].can_send && receiver != msg.sender);
    send_log[msg.sender].sent = true;
    mailbox[receiver].msg_str = send_log[msg.sender].msg_str;
    send_log[msg.sender].can_send = false;
    SingleMessageSent(msg.sender, receiver);
  }
}
