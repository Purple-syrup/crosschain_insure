# SubZero (Insurance but with DEFI)

> ## Table of Contents

-   [Project Details](#project-description)
-   [Problem Statement](#problem-statement)
-   [Solution](#solution)
-   [Technologies Used](#technologies-used)
    -   [Multichain Anycall](#multichain-anycall)
    -   [Verse Token and Staking](#verse-token-and-staking)
    -   [Trufflation](#trufflation)
    -   [Chainlink](#chainlink)
    -   [Goerli](#goerli-testnet)
    -   [Smart Contract](#solidity-smart-contracts)
    -   [Fantom](#fantom-testnet)
-   [Important Live Links](#importantlive-hosted-project-links)
-   [Team Members](#contributors)
-   [Project Features](#project-features)
-   [Why SubZero](#why-subzero)
-   [Features We Couldn't Complete](#features-we-couldnt-complete)
-   [Future Project Plans](#future-project-plans)

#

> ## Project Description

<p><b style="color:orange">Subzero is a decentralized platform built to monitor and control the after use liability of plastics and it’s effect on inflation.</b>
<b style="color:orange">Conserv</b> This is a global sustainability initiative to save the earth and aquatics from plastic dumps and its effect on inflation. Research shows that over 8 million tons of waste plastics are found dumped in the ocean as a result of human activities. our platform envisions to reduce and control the dumping and disposal of plastics after use by insuring plastic producing companies,our monthly insurance premium is 1000$ per registered company, 50% of this fee is staked as security in our pool and the other 50% is used to fund projects and initiatives on ocean cleaning,waste plastics recycling and control .  </p>

#

## Important/Live Hosted Project Links


-   **Github** > [https://github.com/Godhanded/SubZero](https://github.com/Godhanded/SubZero)

-   **Contract** >

    -   Goerli [0x265Ea122D562f8464CbfBcfd0cb6768cE86FFc87](https://goerli.etherscan.io/address/0x265Ea122D562f8464CbfBcfd0cb6768cE86FFc87#code)

    -   extra chains supported by verse

-   **Crosschain** > [see here](#multichain-anycall)

#

> ## Problem Statement

plastics in ocean is a threatening environmental issue as its pollution rises by the day as over 8 million tones of plastics after use end up in the ocean endangering aquatic animals leading to their hostage and death,some other consequences of plastics in ocean are ;

-   Physical impact on marine life: entanglement, ingestion, starvation.
-   Chemical impact: the buildup of persistent organic pollutants like PCBs and DDT.
-   Transport of invasive species and pollutants from polluted rivers to remote areas in the ocean.
-   Economic impact: damage to fisheries, shipping, and tourism.

Currently we do not have enough legislation on after use act for plastic producing companies as the ought to take complete responsibility of how this plastics are disposed and recycled after use for environmental sustainability. [see solution here](#solution)

#

> ## Contributors

-   Godhanded(Blockchain Dev)
    -   [Twitter, @Godand](https://twitter.com/Godand_)
    -   [Github, @Godhanded](https://github.com/Godhanded) <br>

-   Nuelvations(Product Manager)
    -   [Twitter, @defiprince\_](https://twitter.com/defiprince_)
    -   [Github, @nuelvations](https://github.com/nuelvations) <br>

#

> ## Technologies Used

| <b><u>Stack</u></b>      | <b><u>UsageSummary</u></b>                           |
| :----------------------- | :--------------------------------------------------- |
| **`Solidity`**           | Smart contract                                       |
| **`Multichain_Anycall`** | Crosschain functionalities                           |
|  **`Verse Token and Staking`**            | 50% of premium is staked in verse staking farm                                 |
| **`Goerli Chain`**      | Main contract deployed/performs call to other chains |
| **`Trufflation`**       | used its Oracle to queary year of year inflation index|
| **`ChainLink`**       | using chainlink keepers to call claim reward functions and AnyApi to get inflationindex from Trufflation |
| **`other Chains`**       | to be deployed child on other chains when supported by verse and Trufflation              |

-   ### **Solidity smart contracts**

    Conserve makes use of two smart contracts see [2 contracts](hhttps://github.com/Godhanded/SubZero/tree/main/contracts)

    -   **DefiInsure** The main or home contract through which calls to other chains are made possible
    -   **CDefiInsure** the same contract but with an execute function which is called by another contract from a different chain to peform an internal contract call
    -   <b style="color: orange">The two contracts communicate with each other through multichain-anycall protocol and are deployed on three different chains</b>

-   ### **Multichain Anycall**

    -   <b style="color: orange">The multichain-anycall protocol is phenominal</b>, we used it to perform crosschain functions like call our withdraw function on our multiple contracts deployed on different chains(Goerli, FTM) see [code here](https://github.com/Godhanded/SubZero/blob/main/contracts/insure.sol#L78) and [here](https://github.com/Godhanded/SubZero/blob/main/contracts/calledContracts/cinsure.sol#L62)

- ###  **Verse Token and Staking**
    - 50% of premium is staked in verse staking farm to earn rewards on each premium, this will later be used to support Plastic companies and perform ocean clean ups.

- ### **Trufflation**
    - We used trufflation to retrieve on-chain through chainlink, the year out of year inflation index, used for transperency and will later be modified for tracking progress for plastics only.

- ### **ChainLink**
    - using chainlink keepers to call claim reward functions and AnyApi to get inflation index from Trufflation 

-   ### **Goerli Testnet**

    -   The contract on this chain was used as <b style="color: orange">the Home or main </b>through which calls to two other chains can be made, The contract was deployed and verified, see [Contract here](https://goerli.etherscan.io/address/0x265Ea122D562f8464CbfBcfd0cb6768cE86FFc87#code)

-   ### **Fantom Testnet**

    -   <b style="color: orange">A crosschain enabled</b> smart contract will be deployed and Verified on the FTM Test net once Trufffleation and Verse tokens and staking platforms are present there.

    -   insurance is payed by calling the payInsurance function on the contract

#

> ## Solution

<p>it is our responsibility to keep our ocean clean to sustain aqua life and humanity also,we wish to control plastics in ocean and monitor it’s effect on inflation ,subzero is doing this by increasing producer responsibility,improve plastic waste management by taxing producing companies to fund ocean clean-up projects as an after use liability on plastics,50% of the license tax payed by insured companies is used to fund projects on plastic waste clean-up,recycle projects,and 50% is staked on the Verse network as security for our insured companies.
</p>
<p><b style="color: orange">Blockchain adoption - </b>
 Subzero is not just an insurance service but a decentralised platform built on multichain network,our dapp monitors the effect of plastics on inflation rate using Chainlink oracle to load data from Truflation,our insured companies funds are secured in a TVL token yield pool which has total transparency not just that,our insured companies have the rights to outvote any after use plastic clean up project we wish to sponsor,as the have voting power in our decision making,our plans with time is to build a strong DAO which oversees the decision making and project mapping of our product as we are just executives, our vision is to exploit decentralised Finance on Verse network by insuring after-use liability of plastics to promote sustainability of ocean and aquatic animals .</p>
<p><b style="color:orange">Subzero - </b>If we all focus insurance on manufacturing assets,technology and property what now happens to the after use liability of this plastics? Our insurance covers plastic after use liability which is a producer responsibility and this shields you from any form of lawsuit on plastic afteruse disposal and ocean dumping. As we also use 50% of your insurance fee to fund a staking pool as security to your companies general asset insurance,and 50% to fund ocean clean up projects and plastic recycle. 
</p>

#

> ## Product -

<p><b style="color:orange">Subzero</b> is a decentralized platform built on Verse network with multichain function,to monitor/control plastic disposal and it’s effect on inflation rate, and control ocean pollution caused by plastic after use dumping,which was estimated to be over 8 million tons found in the ocean, our platform registers plastic producing company and shares the insurance premium paid <b style="color:orange">($1000)</b> into 2 automatically in a smart contract call,uses 50% as company insurance security and 50% as an after use liability fund used to sponsor projects on ocean cleaning,plastic in ocean recycling and plastic waste control .</p>

#

> ## Why Subzero -

<p><b style="color:orange">We understand the Defi game</b> and we are building on the most reliable networks,
We are the first insurance platform to leverage on defi by using the Ethereum/ftm staking pool as our value lock vault,all our transactions are transparent and trusted,our core focus is on after-use liability of plastics as this is an arising environmental issue and we have the best metrics to solve it.</p>

#

## Project features

-   Insurance & Security
-   Staking on Verse
-   Multichain
-   uses Multichain-anycall, Trufflation YOY inflation Index,Verse Tokens and Staking ,Fantom chains

#

## Features we couldn't complete

-   we could not find a Inflation Index for Plastics alone on Trufflation
    > we wanted to immediately collect data concerning plastic waste and use it to calculate its contribution to the year out of year inflation index.

- We couldn't finish building a front end for the project hence made deu with remix IDE 

#

## Future Project Plans


 We plan to push this project further after the hackathon, and integrate some stacks we weren’t able to complete due to time lapse .
 - <b style="color:orange">Firstly</b>,Improved Analytics to track and provide on chain data on plastic dumping per geo location and it’s effect on inflation rate. This would be a KPI for our dapp as we envision to save the earth from the hazards of waste plastics.


