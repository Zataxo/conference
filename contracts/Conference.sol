//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
contract Conference {  // can be killed, so the owner gets sent the money in the end

	address payable public organizer;
	mapping (address => uint) public registrantsPaid;
	uint public numRegistrants;
	uint public quota;

    error soldOut(string message);

	event Deposit(address indexed _from, uint _amount); // so you can log the event
	event Refund(address indexed _to, uint _amount); // so you can log the event

	constructor() {
		organizer = payable(msg.sender);		
		quota = 100;
		numRegistrants = 0;
	}
    function getOrginizer() public view returns(address){
        return organizer;
    }

	function buyTicket() public payable {
		if (numRegistrants >= quota) { 
			revert soldOut("Sold out!!!");
		}
		registrantsPaid[msg.sender] = msg.value;
		numRegistrants++;
		emit Deposit(msg.sender, msg.value);
	}

	function changeQuota(uint newquota) public onlyOwner {
		quota = newquota;
	}
    modifier onlyOwner {
        require(msg.sender == organizer, "only owner can call");
        _;
    }

	function refundTicket(address payable  recipient, uint amount) public onlyOwner{
			require(registrantsPaid[recipient] == amount,"Refund Failed");
			if (address(this).balance >= amount) { 
				(bool isSucsses, ) = recipient.call{value:amount}("");
                require(isSucsses,"Refund Failed");
				emit Refund(recipient, amount);
				registrantsPaid[recipient] = 0;
				numRegistrants--;
			}
		
	}

	function destroy() public onlyOwner {
		 selfdestruct(organizer);
	}
}
