// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./NexusToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NexusGenerator is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of NXSs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accNexusPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accNexusPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }
    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. NXSs to distribute per block.
        uint256 lastRewardBlock; // Last block number that NXSs distribution occurs.
        uint256 accNexusPerShare; // Accumulated NXSs per share, times 1e12. See below.
    }
    // The NXS TOKEN!
    NexusToken public nexus;
    // Dev address.
    address public multiStakingDistributor;
    // Block number when bonus NXS period ends.
    uint256 public bonusEndBlock;
    // NXS tokens % distributed to multistaking.
    uint256 public multiStakingDistRate = 10;
    // NXS tokens created per block.
    uint256 public nexusPerBlock;
    // Bonus muliplier for early nexus makers.
    uint256 public constant BONUS_MULTIPLIER = 10;
    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each user that stakes LP tokens.
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    // The block number when NXS mining starts.
    uint256 public startBlock;
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(
        address indexed user,
        uint256 indexed pid,
        uint256 amount
    );

    constructor(
        NexusToken _nexus,
        address _multiStakingDistributor,
        uint256 _nexusPerBlock,
        uint256 _startBlock,
        uint256 _bonusEndBlock
    ) public {
        nexus = _nexus;
        multiStakingDistributor = _multiStakingDistributor;
        nexusPerBlock = _nexusPerBlock;
        bonusEndBlock = _bonusEndBlock;
        startBlock = _startBlock;
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    // Add a new lp to the pool. Can only be called by the owner.
    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    function add(
        uint256 _allocPoint,
        IERC20 _lpToken,
        bool _withUpdate
    ) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock =
            block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(
            PoolInfo({
                lpToken: _lpToken,
                allocPoint: _allocPoint,
                lastRewardBlock: lastRewardBlock,
                accNexusPerShare: 0
            })
        );
    }

    // Update the given pool's NXS allocation point. Can only be called by the owner.
    function set(
        uint256 _pid,
        uint256 _allocPoint,
        bool _withUpdate
    ) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
            _allocPoint
        );
        poolInfo[_pid].allocPoint = _allocPoint;
    }


    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to)
        public
        view
        returns (uint256)
    {
        if (_to <= bonusEndBlock) {
            return _to.sub(_from).mul(BONUS_MULTIPLIER);
        } else if (_from >= bonusEndBlock) {
            return _to.sub(_from);
        } else {
            return
                bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
                    _to.sub(bonusEndBlock)
                );
        }
    }

    // View function to see pending NXSs on frontend.
    function pendingNexus(uint256 _pid, address _user)
        external
        view
        returns (uint256)
    {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accNexusPerShare = pool.accNexusPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier =
                getMultiplier(pool.lastRewardBlock, block.number);
            uint256 nexusReward =
                multiplier.mul(nexusPerBlock).mul(pool.allocPoint).div(
                    totalAllocPoint
                );
            accNexusPerShare = accNexusPerShare.add(
                nexusReward.mul(1e12).div(lpSupply)
            );
        }
        return user.amount.mul(accNexusPerShare).div(1e12).sub(user.rewardDebt);
    }

    // Update reward vairables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 nexusReward =
            multiplier.mul(nexusPerBlock).mul(pool.allocPoint).div(
                totalAllocPoint
            );
        nexus.mint(multiStakingDistributor, nexusReward.mul(multiStakingDistRate).div(100));
        nexus.mint(address(this), nexusReward);
        pool.accNexusPerShare = pool.accNexusPerShare.add(
            nexusReward.mul(1e12).div(lpSupply)
        );
        pool.lastRewardBlock = block.number;
    }

    // Deposit LP tokens to NexusGenerator for NXS allocation.
    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending =
                user.amount.mul(pool.accNexusPerShare).div(1e12).sub(
                    user.rewardDebt
                );
            safeNexusTransfer(msg.sender, pending);
        }
        pool.lpToken.safeTransferFrom(
            address(msg.sender),
            address(this),
            _amount
        );
        user.amount = user.amount.add(_amount);
        user.rewardDebt = user.amount.mul(pool.accNexusPerShare).div(1e12);
        emit Deposit(msg.sender, _pid, _amount);
    }

    // Withdraw LP tokens from NexusGenerator.
    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending =
            user.amount.mul(pool.accNexusPerShare).div(1e12).sub(
                user.rewardDebt
            );
        safeNexusTransfer(msg.sender, pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accNexusPerShare).div(1e12);
        pool.lpToken.safeTransfer(address(msg.sender), _amount);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        pool.lpToken.safeTransfer(address(msg.sender), user.amount);
        emit EmergencyWithdraw(msg.sender, _pid, user.amount);
        user.amount = 0;
        user.rewardDebt = 0;
    }

    // Safe nexus transfer function, just in case if rounding error causes pool to not have enough NXSs.
    function safeNexusTransfer(address _to, uint256 _amount) internal {
        uint256 nexusBal = nexus.balanceOf(address(this));
        if (_amount > nexusBal) {
            nexus.transfer(_to, nexusBal);
        } else {
            nexus.transfer(_to, _amount);
        }
    }

    // Update the Multistaking getter contract address
    function setMultiStakingDistributorGetter(address _multiStakingDistributor) external onlyOwner {
        multiStakingDistributor = _multiStakingDistributor;
    }

    function updateNexusPerBlock(uint256 _nexusPerBlock) public onlyOwner {
        nexusPerBlock = _nexusPerBlock;
    }

    function setMultiStakingDistRate(uint256 _rate) external onlyOwner {
        require(_rate <= 10, "Cannot be large than 10%");
        multiStakingDistRate = _rate;
    }
}
