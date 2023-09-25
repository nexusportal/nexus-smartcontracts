import { time, loadFixture, mine } from "@nomicfoundation/hardhat-network-helpers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect, util } from "chai";
import { Contract, utils } from "ethers";
import hre, { ethers } from "hardhat";
import { ERC20ABI } from "../abis/ERC20";
import { parseEther } from "ethers/lib/utils";


let superfarm: Contract;
let nexusToken: Contract;
let _signer: SignerWithAddress;
let accounts: SignerWithAddress[];
let token0: Contract;
let token1: Contract;
let token2: Contract;
let nexusRouter: Contract;
let nexusFactory: Contract;
let pairContract: Contract;

describe("NexusSuperfarmGenerator", function () {
  beforeEach(async () => {

    const [owner, otherAccount] = await ethers.getSigners();
    accounts = await hre.ethers.getSigners();
    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const timestampBefore = blockBefore.timestamp;
    _signer = owner;
    const NexusToken = await ethers.getContractFactory("NexusToken");
    nexusToken = await NexusToken.deploy();

    const ERC20 = await ethers.getContractFactory("MyNToken");
    const WETH = await ERC20.deploy("Wrapped Ether", "WETH");
    token0 = await ERC20.deploy("tokenZero", "TokenZero");
    token0.mint(owner.address, parseEther("400"));
    token1 = await ERC20.deploy("tokenOne", "TokenOne");
    token1.mint(owner.address, parseEther("1000"));
    token2 = await ERC20.deploy("tokenTwo", "TokenTwo");
    token2.mint(owner.address, parseEther("1400"));

//     const CalHash = await ethers.getContractFactory("CalHash");
//     const calHash = await CalHash.deploy();
//     const res = await calHash.getInitHash();
// console.log(res)
    const NexusFactory = await ethers.getContractFactory("NexusFactory");
    nexusFactory = await NexusFactory.deploy(owner.address);
    const NexusRouter = await ethers.getContractFactory("NexusRouter");
    nexusRouter = await NexusRouter.deploy(nexusFactory.address, WETH.address);
    token0.approve(nexusRouter.address, parseEther("400"))
    token1.approve(nexusRouter.address, parseEther("1000"))
    token2.approve(nexusRouter.address, parseEther("400"))
    await nexusRouter.addLiquidity(
      token0.address,
      token1.address,
      parseEther("100"),
      parseEther("100"),
      0,
      0,
      owner.address,
      timestampBefore + 1000
    )
    await nexusRouter.addLiquidity(
      token0.address,
      token2.address,
      parseEther("100"),
      parseEther("100"),
      0,
      0,
      owner.address,
      timestampBefore + 1000
    )
    await nexusRouter.addLiquidity(
      token1.address,
      token2.address,
      parseEther("100"),
      parseEther("100"),
      0,
      0,
      owner.address,
      timestampBefore + 1000
    )

    // await nexusRouter.addLiquidityETH(
    //   token1.address,
    //   token2.address,
    //   parseEther("100"),
    //   parseEther("100"),
    //   0,
    //   0,
    //   owner.address,
    //   timestampBefore + 1000
    // )

    const pair1 = await nexusFactory.getPair(token0.address, token1.address);
    const pair2 = await nexusFactory.getPair(token0.address, token2.address);
    const pair3 = await nexusFactory.getPair(token1.address, token2.address);
    const MultiStaking = await ethers.getContractFactory("NexusNFTMultiStakingDistributor");
    const multiStaking = await MultiStaking.deploy(owner.address);

    const NexusGenerator = await ethers.getContractFactory("NexusGenerator");
    superfarm = await NexusGenerator.deploy(nexusToken.address, multiStaking.address, parseEther("5"), blockNumBefore, 1);

    await token2.approve(superfarm.address, parseEther("1400"));
    await token1.approve(superfarm.address, parseEther("500"));
    await token0.approve(superfarm.address, parseEther("500"));
    await superfarm.add(2, pair1, false);
    await superfarm.add(3, pair2, false);
    await superfarm.add(5, pair3, false);
    await superfarm.setRewardToken(pair1, token2.address, parseEther("3"));
    // await superfarm.setRewardToken(pair1, token1.address, parseEther("3"));
    // await superfarm.setRewardToken(pair1, token0.address, parseEther("3"));
  });
  it("Check depositRewardToken", async function () {
    await superfarm.setNexusTreasury(_signer.address);
    await superfarm.depositRewardToken(0, token2.address, parseEther("200"));
    // await superfarm.depositRewardToken(0, token1.address, parseEther("200"));
    // await superfarm.depositRewardToken(0, token0.address, parseEther("200"));
  })

  it("Check halving", async function () {
    const lpToken = await nexusFactory.getPair(token0.address, token1.address);
    const lpErc20 = new ethers.Contract(lpToken, ERC20ABI, _signer);

    await lpErc20.approve(superfarm.address, parseEther("200"));
    await lpErc20.transfer(accounts[1].address, parseEther("50"));
    await lpErc20.connect(accounts[1]).approve(superfarm.address, parseEther("200"));
    await nexusToken.setOwner(_signer.address, superfarm.address, _signer.address);
    await superfarm.depositLP(0, parseEther("20"));
    await time.increase(1000);
    await superfarm.setNexusTreasury(_signer.address);
    await superfarm.depositRewardToken(0, token2.address, parseEther("200"));
    // await superfarm.depositRewardToken(0, token1.address, parseEther("200"));
    // await superfarm.depositRewardToken(0, token0.address, parseEther("200"));
    await time.increase(100);
    await mine(500);
    await superfarm.depositLP(0, parseEther("5"));
    await superfarm.connect(accounts[1]).depositLP(0, parseEther("20"));
    await superfarm.depositRewardToken(0, token2.address, parseEther("200"));
    await time.increase(100);
    await superfarm.withdraw(0, parseEther("15"))
    // await superfarm.depositRewardToken(0, token0.address, parseEther("140"));
    // await superfarm.depositRewardToken(0, token0.address, parseEther("50"));
    await time.increase(1000);
    await superfarm.depositLP(0, parseEther("15"));
  })
});
  // describe("Withdrawals", function () {
  //   describe("Validations", function () {
  //     it("Should revert with the right error if called too soon", async function () {
  //       const { lock } = await loadFixture(deployOneYearLockFixture);

  //       await expect(lock.withdraw()).to.be.revertedWith(
  //         "You can't withdraw yet"
  //       );
  //     });

  //     it("Should revert with the right error if called from another account", async function () {
  //       const { lock, unlockTime, otherAccount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // We can increase the time in Hardhat Network
  //       await time.increaseTo(unlockTime);

  //       // We use lock.connect() to send a transaction from another account
  //       await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
  //         "You aren't the owner"
  //       );
  //     });

  //     it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
  //       const { lock, unlockTime } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // Transactions are sent using the first signer by default
  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).not.to.be.reverted;
  //     });
  //   });

  //   describe("Events", function () {
  //     it("Should emit an event on withdrawals", async function () {
  //       const { lock, unlockTime, lockedAmount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw())
  //         .to.emit(lock, "Withdrawal")
  //         .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
  //     });
  //   });

  //   describe("Transfers", function () {
  //     it("Should transfer the funds to the owner", async function () {
  //       const { lock, unlockTime, lockedAmount, owner } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).to.changeEtherBalances(
  //         [owner, lock],
  //         [lockedAmount, -lockedAmount]
  //       );
  //     });
  //   });
  // }); 