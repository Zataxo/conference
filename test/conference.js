const {expect} = require("chai");
const hre = require("hardhat");

describe("Restrictions", function(){
    let conference;
    let orginizer;
    let addressOne;
    let addressTwo;
    beforeEach(async function(){
        conference = await hre.ethers.deployContract("Conference");
        [orginizer,addressOne,addressTwo] = await hre.ethers.getSigners();
    });
    it("Should set ownership to orginizer",async function(){
        const orginizerAddress = await conference.getOrginizer();
        // console.log(orginizerAddress);
        expect(orginizerAddress).to.equal(orginizer.address);
    });
    it("Ticket can not excceds 100 ticket",async function(){
        await expect(conference.buyTicket()).to.be.reverted;
    });
    it("Only orginizer can change quota and refund tickets",async function(){
        await expect(conference.connect(addressOne).changeQuota(120)).to.be.revertedWith("only owner can call");
        await expect(conference.connect(addressOne).refundTicket(addressTwo.address,10)).to.be.revertedWith("only owner can call");
    });

})