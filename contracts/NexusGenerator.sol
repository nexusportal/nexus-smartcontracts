// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./NexusToken.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./Utils/MultiOwnable.sol";

contract NexusGenerator is MultiOwnable {
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
    // Info of each Reward Token.
    struct RewardTokenInfo {
        IERC20 rewardToken; //Address of Reward Token contract for stakers
        uint256 distRate; //Distributed Rate per block
        uint256 remainAmount; // Deposited Amount as reward token for any lp token contract
        uint256 rewardDuration;
        uint256 lastRewardTimestamp; // Last timestamp that Reward Token distribution occurs.
        uint256 accRewardPerShare;
    }
    // The NXS TOKEN!
    NexusToken public nexus;
    // Dev address.
    address public multiStakingDistributor;

    // Block number when bonus NXS period ends.
    uint256 public bonusEndBlock;
    // NXS tokens % distributed to multistaking.
    uint256 public multiStakingDistRate = 10;
    // NXS tokens created per block
    uint256 public nexusPerBlock;
    // Bonus muliplier for early nexus makers.
    uint256 public constant BONUS_MULTIPLIER = 10;

    uint256 public constant REDUCTION_RATE = 9100; // 91% for every

    uint256 public constant REDUCTION_PERIOD = 3000; // The reduction occurs for every 3000 blocks.

    uint256 public nextReductionBlock;

    // Info of each pool.
    PoolInfo[] public poolInfo;

    //Reward Token Infoes of each pool
    mapping(uint256 => RewardTokenInfo[]) public rewardTokenInfo;

    // Info of each user that stakes LP tokens.
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;

    // Info of each user that claimed the reward token. pid -> user -> rewardToken -> amount.
    mapping(uint256 => mapping(address => mapping(address => uint256))) rewardTokenDebt;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    // The block number when NXS mining starts.
    uint256 public startBlock;
    event DepositLP(address indexed user, uint256 indexed pid, uint256 amount);
    event DepositRwardToken(
        address indexed user,
        uint256 indexed pid,
        address indexed rewardToken,
        uint256 amount
    );
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
    ) {
        nexus = _nexus;
        multiStakingDistributor = _multiStakingDistributor;
        nexusPerBlock = _nexusPerBlock;
        bonusEndBlock = _bonusEndBlock;
        startBlock = _startBlock;
        nextReductionBlock = block.number.add(REDUCTION_PERIOD);
        setOwner(msg.sender, msg.sender);
    }

    function poolLength() public view returns (uint256) {
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
        uint256 lastRewardBlock = block.number > startBlock
            ? block.number
            : startBlock;
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

    // Add a new Reward Token to the pool, It will be distributed e.g XYZ token
    function setRewardToken(
        IERC20 _lpToken,
        IERC20 _rewardToken,
        uint256 _distRate
    ) external onlyOwner {
        uint256 _pid = getPoolId(_lpToken);
        if (_pid == poolLength()) {
            add(0, _lpToken, false);
        }
        uint256 _rid = getRewardTokenId(_pid, _rewardToken);
        if (_rid < rewardTokenInfo[_pid].length) {
            updateRewardTokenStatus(_pid, _rid);

            RewardTokenInfo storage rtInfo = rewardTokenInfo[_pid][_rid];
            rtInfo.rewardDuration = rtInfo.remainAmount.div(_distRate);
            rtInfo.distRate = _distRate;
        } else {
            rewardTokenInfo[_pid].push(
                RewardTokenInfo({
                    rewardToken: _rewardToken,
                    distRate: _distRate,
                    remainAmount: 0,
                    rewardDuration: 0,
                    lastRewardTimestamp: type(uint256).max,
                    accRewardPerShare: 0
                })
            );
        }
    }

    function removeRewardToken(
        uint256 _pid,
        IERC20 _rewardToken
    ) public onlyOwner {
        require(_pid < poolInfo.length, "No Such Pool");
        uint256 _rid = getRewardTokenId(_pid, _rewardToken);
        require(
            _rid < rewardTokenInfo[_pid].length,
            "No Such Reward Token in pool"
        );
        RewardTokenInfo[] storage rtInfo = rewardTokenInfo[_pid];
        rtInfo[_rid] = rtInfo[rtInfo.length - 1];
        rtInfo.pop();
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
    function getMultiplier(
        uint256 _from,
        uint256 _to
    ) public view returns (uint256) {
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
    function pendingNexus(
        uint256 _pid,
        address _user
    ) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accNexusPerShare = pool.accNexusPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 nexusReward;

            if (block.number <= nextReductionBlock) {
                uint256 multiplier = getMultiplier(
                    pool.lastRewardBlock,
                    block.number
                );
                nexusReward = multiplier
                    .mul(nexusPerBlock)
                    .mul(pool.allocPoint)
                    .div(totalAllocPoint);
            } else {
                uint256 multiplier1 = getMultiplier(
                    pool.lastRewardBlock,
                    nextReductionBlock
                );
                uint256 multiplier2 = getMultiplier(
                    nextReductionBlock,
                    block.number
                );
                uint256 nexusReward1 = multiplier1
                    .mul(nexusPerBlock)
                    .mul(pool.allocPoint)
                    .div(totalAllocPoint);
                uint256 nextNexusPerBlock = nexusPerBlock
                    .mul(REDUCTION_RATE)
                    .div(10000);
                uint256 nexusReward2 = multiplier2
                    .mul(nextNexusPerBlock)
                    .mul(pool.allocPoint)
                    .div(totalAllocPoint);
                nexusReward = nexusReward1.add(nexusReward2);
            }
            accNexusPerShare = accNexusPerShare.add(
                nexusReward.mul(1e12).div(lpSupply)
            );
        }
        return user.amount.mul(accNexusPerShare).div(1e12).sub(user.rewardDebt);
    }

    function pendingRewardToken(
        uint256 _pid,
        uint256 _rid,
        address _user
    ) public view returns (uint256) {
        PoolInfo memory pool = poolInfo[_pid];
        RewardTokenInfo memory rtInfo = rewardTokenInfo[_pid][_rid];
        UserInfo memory user = userInfo[_pid][_user];
        uint256 accRewardPerShare = rtInfo.accRewardPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (rtInfo.rewardDuration != 0 && lpSupply != 0) {
            uint256 rewardDuration;
            if (rtInfo.lastRewardTimestamp > block.timestamp)
                rewardDuration = 0;
            else if (
                block.timestamp >=
                rtInfo.lastRewardTimestamp.add(rtInfo.rewardDuration)
            ) {
                rewardDuration = rtInfo.rewardDuration;
            } else {
                rewardDuration = block.timestamp.sub(
                    rtInfo.lastRewardTimestamp
                );
            }
            uint256 reward = rewardDuration.mul(rtInfo.distRate);
            uint256 sendingAmount = rtInfo.remainAmount >= reward
                ? reward
                : rtInfo.remainAmount;
            uint256 sendingMulti = sendingAmount.mul(multiStakingDistRate).div(
                100
            );
            accRewardPerShare = accRewardPerShare.add(
                (sendingAmount.sub(sendingMulti)).mul(1e12).div(lpSupply)
            );
        }
        uint256 rewardDebt = rewardTokenDebt[_pid][_user][
            address(rtInfo.rewardToken)
        ];
        return user.amount.mul(accRewardPerShare).div(1e12).sub(rewardDebt);
    }

    // Update reward vairables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    function massRTInfoesUpdate(uint256 _pid) public {
        RewardTokenInfo[] storage rtInfoes = rewardTokenInfo[_pid];
        uint len = rtInfoes.length;
        for (uint256 i = 0; i < len; i++) {
            updateRewardTokenStatus(_pid, i);
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
        uint256 nexusReward;

        if (block.number <= nextReductionBlock) {
            uint256 multiplier = getMultiplier(
                pool.lastRewardBlock,
                block.number
            );
            nexusReward = multiplier
                .mul(nexusPerBlock)
                .mul(pool.allocPoint)
                .div(totalAllocPoint);
        } else {
            uint256 multiplier1 = getMultiplier(
                pool.lastRewardBlock,
                nextReductionBlock
            );
            uint256 multiplier2 = getMultiplier(
                nextReductionBlock,
                block.number
            );
            uint256 nexusReward1 = multiplier1
                .mul(nexusPerBlock)
                .mul(pool.allocPoint)
                .div(totalAllocPoint);
            updateNexusPerBlock();
            uint256 nexusReward2 = multiplier2
                .mul(nexusPerBlock)
                .mul(pool.allocPoint)
                .div(totalAllocPoint);
            nexusReward = nexusReward1.add(nexusReward2);
        }

        nexus.mint(
            multiStakingDistributor,
            nexusReward.mul(multiStakingDistRate).div(100)
        );
        nexus.mint(address(this), nexusReward);
        pool.accNexusPerShare = pool.accNexusPerShare.add(
            nexusReward.mul(1e12).div(lpSupply)
        );
        pool.lastRewardBlock = block.number;
    }

    function updateRewardTokenStatus(uint256 _pid, uint256 _rid) public {
        PoolInfo storage pool = poolInfo[_pid];
        RewardTokenInfo storage rtInfo = rewardTokenInfo[_pid][_rid];
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0 || rtInfo.remainAmount == 0) {
            rtInfo.lastRewardTimestamp = type(uint256).max;
            rtInfo.rewardDuration == 0;
            return;
        }
        uint256 rewardDuration;
        if (rtInfo.lastRewardTimestamp > block.timestamp) return;
        uint256 last = rtInfo.lastRewardTimestamp.add(rtInfo.rewardDuration);
        if (block.timestamp > last) {
            rewardDuration = rtInfo.rewardDuration;
            rtInfo.lastRewardTimestamp = type(uint256).max;
            rtInfo.rewardDuration = 0;
        } else {
            rewardDuration = block.timestamp.sub(rtInfo.lastRewardTimestamp);
            rtInfo.lastRewardTimestamp = block.timestamp;
            rtInfo.rewardDuration = rtInfo.rewardDuration.sub(rewardDuration);
        }
        uint256 expectedReward = rewardDuration.mul(rtInfo.distRate);
        uint256 reward = rtInfo.remainAmount >= expectedReward
            ? expectedReward
            : rtInfo.remainAmount;
        uint256 sendingMulti = reward.mul(multiStakingDistRate).div(100);
        uint256 moreShare = (reward.sub(sendingMulti)).mul(1e12).div(lpSupply);
        rtInfo.accRewardPerShare = rtInfo.accRewardPerShare.add(moreShare);
        rtInfo.remainAmount = rtInfo.remainAmount.sub(reward);
    }

    // Deposit LP tokens to NexusGenerator for NXS allocation.
    function depositLP(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        RewardTokenInfo[] storage rtInfoes = rewardTokenInfo[_pid];
        uint256 rtLen = rtInfoes.length;
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending = user
                .amount
                .mul(pool.accNexusPerShare)
                .div(1e12)
                .sub(user.rewardDebt);
            if (pending > 0) safeNexusTransfer(msg.sender, pending);
        }
        pool.lpToken.safeTransferFrom(
            address(msg.sender),
            address(this),
            _amount
        );
        user.amount = user.amount.add(_amount);
        user.rewardDebt = user.amount.mul(pool.accNexusPerShare).div(1e12);
        massRTInfoesUpdate(_pid);
        for (uint256 i = 0; i < rtLen; i++) {
            RewardTokenInfo memory rtInfo = rtInfoes[i];
            uint256 pendingReward = user
                .amount
                .mul(rtInfo.accRewardPerShare)
                .div(1e12)
                .sub(
                    rewardTokenDebt[_pid][msg.sender][
                        address(rtInfo.rewardToken)
                    ]
                );
            rewardTokenDebt[_pid][msg.sender][address(rtInfo.rewardToken)] = (user.amount).mul(rtInfo.accRewardPerShare).div(1e12);
            if (pendingReward > 0)
                rtInfo.rewardToken.safeTransfer(msg.sender, pendingReward);
        }
        emit DepositLP(msg.sender, _pid, _amount);
    }

    //Deposit Reward Token to this smart contract.
    function depositRewardToken(
        uint256 _pid,
        IERC20 _rewardToken,
        uint256 _amount
    ) public {
        require(_pid < poolLength(), "Non Exist Pool");
        uint256 _rid = getRewardTokenId(_pid, _rewardToken);
        require(_rid < rewardTokenInfo[_pid].length, "No reward token setting");
        updateRewardTokenStatus(_pid, _rid);
        RewardTokenInfo storage rtInfo = rewardTokenInfo[_pid][_rid];
        rtInfo.remainAmount += _amount;
        rtInfo.lastRewardTimestamp = block.timestamp;
        rtInfo.rewardDuration += _amount.div(rtInfo.distRate);
        _rewardToken.safeTransferFrom(
            address(msg.sender),
            address(this),
            _amount
        );
        emit DepositRwardToken(
            msg.sender,
            _pid,
            address(_rewardToken),
            _amount
        );
    }

    // Withdraw LP tokens from NexusGenerator.
    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        RewardTokenInfo[] storage rtInfoes = rewardTokenInfo[_pid];
        uint256 rtLen = rtInfoes.length;
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        massRTInfoesUpdate(_pid);
        uint256 pending = user.amount.mul(pool.accNexusPerShare).div(1e12).sub(
            user.rewardDebt
        );
        if (pending > 0) safeNexusTransfer(msg.sender, pending);
        for (uint256 i = 0; i < rtLen; i++) {
            RewardTokenInfo memory rtInfo = rtInfoes[i];
            uint256 pendingReward = user
                .amount
                .mul(rtInfo.accRewardPerShare)
                .div(1e12)
                .sub(
                    rewardTokenDebt[_pid][msg.sender][
                        address(rtInfo.rewardToken)
                    ]
                );
            rewardTokenDebt[_pid][msg.sender][address(rtInfo.rewardToken)] = (
                user.amount.sub(_amount)
            ).mul(rtInfo.accRewardPerShare).div(1e12);
            if (pendingReward > 0)
                rtInfo.rewardToken.safeTransfer(msg.sender, pendingReward);
        }
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accNexusPerShare).div(1e12);
        pool.lpToken.safeTransfer(address(msg.sender), _amount);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdrawLP(uint256 _pid) public {
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
    function setMultiStakingDistributorGetter(
        address _multiStakingDistributor
    ) external onlyOwner {
        multiStakingDistributor = _multiStakingDistributor;
    }

    function setMultiStakingDistRate(uint256 _rate) external onlyOwner {
        require(_rate <= 10, "Cannot be large than 10%");
        multiStakingDistRate = _rate;
    }

    function updateNexusPerBlock() internal {
        if (block.number <= nextReductionBlock) return;
        nexusPerBlock = nexusPerBlock.mul(REDUCTION_RATE).div(10000);
        nextReductionBlock += REDUCTION_PERIOD;
    }

    function getPoolInfo(uint256 _pid) external view returns (PoolInfo memory) {
        return poolInfo[_pid];
    }

    function getRewardTokenInfo(
        uint256 _pid
    ) external view returns (RewardTokenInfo[] memory) {
        return rewardTokenInfo[_pid];
    }

    function getRewardTokenId(
        uint256 _pid,
        IERC20 _rewardToken
    ) public view returns (uint256) {
        RewardTokenInfo[] memory rtInfoes = rewardTokenInfo[_pid];
        for (uint256 i = 0; i < rtInfoes.length; i++) {
            if (rtInfoes[i].rewardToken == _rewardToken) return i;
        }
        return rtInfoes.length;
    }

    function getPoolId(IERC20 _lpToken) public view returns (uint256) {
        uint256 pLen = poolLength();
        for (uint256 i = 0; i < pLen; ++i) {
            if (poolInfo[i].lpToken == _lpToken) return i;
        }
        return pLen;
    }
}
