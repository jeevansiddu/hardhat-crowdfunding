// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

/**
 * @title FundMe
 * @author Jeevan Siddharth
 * @notice Sample contract
 **/
contract crowdfunding {
    address public immutable owner;
    address[] public funders;
    mapping(address => uint256) public addresstoamtfunded;
    uint256 public target;
    uint256 public totalfundraised;
    // uint256 public moneyleft;
    uint256 public capital;

    uint256 public k;
    uint256 public profitbuy;
    // uint256 public contractbalance;
    uint256 public totalbuy;
    uint256 public threshold;

    uint256 public releaseamount;
    uint256 public buythreshold;
    uint256 public profitthreshold;
    uint8 public releasefundcalled = 0;
    bool public istargetreached = false;
    uint256[] public funderspercentageinvested;

    constructor(uint256 _target, uint256 _threshold, uint256 _profitthreshold) {
        owner = msg.sender;
        target = _target;
        threshold = _threshold;
        releaseamount = (target * 1000) / 10000; // releaseamount is 10% of target
        // converting 10% to basis poimts as solidity wont allow simply dividing by 10
        profitthreshold = _profitthreshold;
        capital = ((target * 2500) / 10000); // capital is 25% of target
    }

    function fund() public payable {
        address[] memory funderarray = funders;
        int f = 0;
        require(msg.value >= 10000000000000, "Insufficient Amount");
        totalfundraised = totalfundraised + msg.value;
        for (uint256 i = 0; i < funderarray.length; i++) {
            if (msg.sender == funderarray[i]) {
                uint256 m = addresstoamtfunded[funderarray[i]];
                addresstoamtfunded[funderarray[i]] = m + msg.value;
                f = 1;
            }
        }
        if (f == 0) {
            funders.push(msg.sender);
            addresstoamtfunded[msg.sender] = msg.value;
        }
        if (totalfundraised >= target && istargetreached == false) {
            releaseCapital();
            getprofitshare();
            istargetreached = true;
            // moneyleft = totalfundraised;
        }
    }

    function getprofitshare() private {
        for (uint256 i = 0; i < funders.length; i++) {
            funderspercentageinvested.push(
                (addresstoamtfunded[funders[i]] * 10000) / totalfundraised
            );
        }
    }

    function releaseCapital() private {
        (bool success, bytes memory callreturned) = payable(owner).call{
            value: capital
        }("");
        require(success, "Failed");
        //    moneyleft=moneyleft-capital;
    }

    // till fund everything is completed

    function buy() public payable {
        // profit == some amount release profit to funder and owner
        // profit == certain threshold achieved then release fund to owner to refill stocks
        //address of buyer dont care
        // if total buy == threshold => release to owner
        //  if profit buy == profit treshold divide the profits
        totalbuy += msg.value;
        profitbuy = address(this).balance;
        if (totalbuy >= threshold && releasefundcalled < 7) {
            releasefund();
            releasefundcalled++;
            totalbuy = 0;
            // threshold = threshold + threshold;
        }
        if (profitbuy >= profitthreshold) {
            releaseprofitfunds();
            profitbuy = 0;
        }
    }

    function viewbalance() public view returns (uint256) {
        return address(this).balance;
    }

    function releasefund() public {
        (bool success, ) = payable(owner).call{value: releaseamount}("");
        require(success, "Failed");

        // k++;
    }

    // releasefund for owner works fine

    // function totalbuy() public{
    //     (bool success,bytes memory callreturned)=payable(owner).call{value:releaseamount}("");
    //     require(success,"Failed");
    // }
    function releaseprofitfunds() public {
        for (uint256 i = 0; i < funders.length; i++) {
            address f = funders[i];
            uint256 contractbalance = address(this).balance -
                (2 * releaseamount);
            (bool success, ) = payable(f).call{
                value: ((funderspercentageinvested[i] * contractbalance) /
                    10000)
            }("");
            require(success, "Failed");
        }
    }

    // release profit funds works fine

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
