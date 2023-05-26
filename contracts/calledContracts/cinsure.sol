// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error DefiInsure__UpkeepNotNeeded();
error DefiInsure__InvalidValue();
error DefiInsure__NotOwner();
error DefiInsure__TxFailed();

interface VerseToken {
    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool);

    function approve(address _spender, uint256 _amount) external returns (bool);

    function balanceOf(address _account) external view returns (uint256);

    function transfer(address _recipient, uint256 _amount)
        external
        returns (bool);
}

interface VerseFarm {
    function farmDeposit(uint256 _stakeAmount) external;

    function exitFarm() external;

    function farmWithdraw(uint256 _withdrawAmount) external;

    function claimReward() external returns (uint256 rewardAmount);
}

contract CDefiInsure is
    KeeperCompatibleInterface,
    ChainlinkClient,
    ConfirmedOwner
{
    using Chainlink for Chainlink.Request;

    struct entity {
        address entityAddr;
        uint256 deadline;
    }

    event FalseSender(string sourceAddress);

    mapping(string => entity) private s_insured;
    event RewardClaim(uint256 Amount);

    uint256 public s_numDays;
    uint256 public s_balance;
    uint256 public s_netStaked;
    uint256 public s_netEntities;
    uint256 public s_fee;

    string public s_plasticInflation;
    string public s_jobId;

    address public s_oracleId;

    uint256 public immutable MINIMUM_VALUE;
    uint256 constant DECIMALS = 1e18;

    address private s_owner;
    address private immutable CALLER;
    VerseToken public immutable i_verseToken;
    VerseFarm public immutable i_verseFarm;

    constructor(
        address _verseToken,
        address _verseFarm,
        uint256 _minimumValue,
        address caller_,
        address oracleId_,
        string memory jobId_,
        uint256 fee_,
        address token_
    ) ConfirmedOwner(msg.sender) {
        s_owner = msg.sender;
        CALLER = caller_;
        i_verseFarm = VerseFarm(_verseFarm);
        i_verseToken = VerseToken(_verseToken);
        MINIMUM_VALUE = _minimumValue;
        setChainlinkToken(token_);
        s_oracleId = oracleId_;
        s_jobId = jobId_;
        s_fee = fee_;
    }

    function payInsurance(string calldata id) external {
        i_verseToken.transferFrom(msg.sender, address(this), MINIMUM_VALUE);
        //call verse staking platform and stake 50% of insurance paid
        uint256 verseStake = MINIMUM_VALUE / 2;
        i_verseToken.approve(address(i_verseFarm), verseStake);
        i_verseFarm.farmDeposit(verseStake);

        s_balance += MINIMUM_VALUE;
        s_netStaked += verseStake;
        if (s_insured[id].entityAddr == address(0)) s_netEntities += 1;
        s_insured[id] = entity({
            entityAddr: msg.sender,
            deadline: block.timestamp + 365 days
        });
    }

    function unStake(uint256 amount) external {
        /**function to pull stake from Verse staking contract */
        if (msg.sender != s_owner) revert DefiInsure__NotOwner();
        s_netStaked -= amount;
        i_verseFarm.farmWithdraw(amount);
    }

    function claimReward() internal {
        /**function to pull stake rewards from Verse staking contract */
        uint256 rewardAmount = i_verseFarm.claimReward();
        emit RewardClaim(rewardAmount);
    }

    function transferVerse(uint256 amount) external {
        if (msg.sender != s_owner) revert DefiInsure__NotOwner();
        if (amount > i_verseToken.balanceOf(address(this)))
            revert DefiInsure__InvalidValue();
        s_balance -= amount;
        i_verseToken.transfer(s_owner, amount);
    }

    function _withdraw(address addr, uint256 amount) internal {
        if (amount > s_balance) revert DefiInsure__InvalidValue();
        s_balance -= amount;
        i_verseToken.transfer(addr, amount);
    }

    function anyExecute(bytes memory _data)
        external
        returns (bool success, bytes memory result)
    {
        (address _to, uint256 _amount, address sourceAddress) = abi.decode(
            _data,
            (address, uint256, address)
        );
        if (sourceAddress != CALLER) {
            revert();
        }

        _withdraw(_to, _amount);
        success = true;
        result = "";
    }

    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        bool timeUP = block.timestamp >= s_numDays;
        upkeepNeeded = timeUP;
        return (upkeepNeeded, "0x0");
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert DefiInsure__UpkeepNotNeeded();
        }
        s_numDays = block.timestamp + 10 days;
        claimReward();
    }

    function requestPlasticInflation() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            bytes32(bytes(s_jobId)),
            address(this),
            this.fulfillPlasticInflation.selector
        );
        req.add("service", "truflation/current");
        req.add("keypath", "yearOverYearInflation");
        req.add("abi", "json");
        req.add("refundTo", Strings.toHexString(uint160(msg.sender), 20));
        return sendChainlinkRequestTo(s_oracleId, req, s_fee);
    }

    function fulfillPlasticInflation(
        bytes32 _requestId,
        bytes memory _inflation
    ) public recordChainlinkFulfillment(_requestId) {
        s_plasticInflation = string(_inflation);
    }

    function getPlasticInflation() external view returns (string memory) {
        return s_plasticInflation;
    }

    function getEntity(string calldata id)
        external
        view
        returns (entity memory)
    {
        return s_insured[id];
    }

    function getDeadline(string calldata id) external view returns (uint256) {
        return s_insured[id].deadline;
    }
}
