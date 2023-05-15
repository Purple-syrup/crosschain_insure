// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

interface CallProxy {
    function anyCall(
        address _to,
        bytes calldata _data,
        address _fallback,
        uint256 _toChainID,
        uint256 _flags
    ) external payable;

    function calcSrcFees(
        string calldata _appID,
        uint256 _toChainID,
        uint256 _dataLength
    ) external view returns (uint256);
}

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

error DefiInsure__InvalidValue();
error DefiInsure__NotOwner();
error DefiInsure__TxFailed();

contract DefiInsure {
    struct entity {
        address entityAddr;
        uint256 deadline;
    }

    mapping(string => entity) private s_insured;

    uint256 public s_balance;
    uint256 public s_netStaked;
    uint256 public s_netEntities;

    address private s_owner;
    address public anycallethcontract =
        0xD2b88BA56891d43fB7c108F23FE6f92FEbD32045;
    uint256 immutable MINIMUM_VALUE;
    uint256 constant DECIMALS = 1e18;

    VerseToken public immutable i_verseToken;
    VerseFarm public immutable i_verseFarm;

    constructor(
        VerseToken _verseToken,
        VerseFarm _verseFarm,
        uint256 _minimumValue
    ) {
        s_owner = msg.sender;
        i_verseFarm = _verseFarm;
        i_verseToken = _verseToken;
        MINIMUM_VALUE = _minimumValue;
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
        s_netStaked -= amount;
        i_verseFarm.farmWithdraw(amount);
    }

    function claimReward() external {
        /**function to pull stake rewards from Verse staking contract */
        i_verseFarm.claimReward();
    }

    function transferVerse(uint256 amount) external {
        if (msg.sender != s_owner) revert DefiInsure__NotOwner();
        if (amount > i_verseToken.balanceOf(address(this)))
            revert DefiInsure__InvalidValue();
        s_balance -= amount;
        i_verseToken.transfer(s_owner, amount);
    }

    function withdraw(address addr, uint256 amount) external {
        if (msg.sender != s_owner) revert DefiInsure__NotOwner();
        if (amount > s_balance) revert DefiInsure__InvalidValue();
        s_balance -= amount;
        i_verseToken.transfer(addr, amount);
    }

    function withdrawOtherchains(
        address destinationAddress,
        address to,
        uint256 amount,
        uint256 chainId
    ) external payable {
        if (msg.sender != s_owner) revert DefiInsure__NotOwner();
        require(
            msg.value >=
                CallProxy(anycallethcontract).calcSrcFees("0", chainId, 32),
            "INSUFFICIENT FEE"
        );

        CallProxy(anycallethcontract).anyCall{value: msg.value}(
            destinationAddress,
            // sending the encoded bytes of the string msg and decode on the destination chain
            abi.encode(to, amount, address(this)),
            // 0x as fallback address because we don't have a fallback function
            address(0),
            // chainid of ftm testnet
            chainId,
            // Using 2 flag to pay fee on destination chain
            2
        );
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
