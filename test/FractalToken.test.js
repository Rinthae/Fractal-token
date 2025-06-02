const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FractalToken", function () {
  let Token, token, owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    Token = await ethers.getContractFactory("FractalToken");
    token = await Token.deploy(ethers.parseEther("1000"));
    await token.waitForDeployment();
  });

  it("deployment assigns total supply to owner", async function () {
    expect(await token.name()).to.equal("FractalToken");
    expect(await token.symbol()).to.equal("FCT");
    const supply = await token.totalSupply();
    expect(await token.balanceOf(owner.address)).to.equal(supply);
  });

  it("allows transfers only between whitelisted addresses", async function () {
    await expect(token.transfer(addr1.address, 10)).to.be.revertedWith(
      "not whitelisted"
    );

    await token.whitelistAddress(addr1.address);
    await token.transfer(addr1.address, 10);
    expect(await token.balanceOf(addr1.address)).to.equal(10);

    await expect(
      token.connect(addr1).transfer(addr2.address, 1)
    ).to.be.revertedWith("not whitelisted");
  });

  it("claims available yield", async function () {
    await token.whitelistAddress(addr1.address);
    await token.allocateYield(addr1.address, 50);

    expect(await token.yield_right(addr1.address)).to.equal(50);
    await token.connect(addr1).claimYield();
    expect(await token.balanceOf(addr1.address)).to.equal(50);
    expect(await token.yield_right(addr1.address)).to.equal(0);

    await expect(token.connect(addr1).claimYield()).to.be.revertedWith(
      "no yield"
    );

    await token.allocateYield(addr2.address, 10);
    await expect(token.connect(addr2).claimYield()).to.be.revertedWith(
      "not whitelisted"
    );
  });

  it("returns governance and yield metadata", async function () {
    await token.whitelistAddress(addr1.address);
    await token.transfer(addr1.address, 20);
    await token.allocateYield(addr1.address, 5);

    expect(await token.governance_power(addr1.address)).to.equal(20);
    expect(await token.yield_right(addr1.address)).to.equal(5);
  });
});
