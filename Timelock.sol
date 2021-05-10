/**
 *Submitted for verification at BscScan.com on 2021-05-03
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;




library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}









/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}






contract SEASLpTimeLock {
    using SafeMath for uint256;
    IERC20 public seasBNBLpInterFace;

    IERC20 public seasInterFace;

    address public owner;


    uint256 public TIME_TO_WITHDRAW_LP;
    uint256 public constant TEAM_SHARE = 50*10**12 *10**9;






    uint256 public  teamWalletClaimed;


    uint256 public teamReserveReleaseTime;


    uint256 public ONEMONTH = 30 days;


    uint256 public ONEYEARS = 365 days;


    constructor(address _seasBNBLpInterFace,address seasAddress) {
        seasBNBLpInterFace = IERC20(_seasBNBLpInterFace);
        seasInterFace = IERC20(seasAddress);
        owner = msg.sender;
        TIME_TO_WITHDRAW_LP = block.timestamp.add(ONEYEARS.mul(4));

        teamReserveReleaseTime = block.timestamp.add(ONEMONTH);


    }






    function checkSEASBNBBalance() public view  returns(uint256){
        return seasBNBLpInterFace.balanceOf(address(this));
    }


    function getContractBalance() public view returns (uint256){
        return seasInterFace.balanceOf(address(this));
    }








    function withdrawSEASBNBLPs() public {
        require(msg.sender== owner,"You are not authotized");
        require(block.timestamp>TIME_TO_WITHDRAW_LP,"Timelock has not been passed");
        seasBNBLpInterFace.transfer(owner,checkSEASBNBBalance());
    }






    function claimTeamAndAdvisorShare() public {
        require(msg.sender == owner,"You are not authotized");
        require(block.timestamp>teamReserveReleaseTime,"Lock Period has not passed");
        uint256 amount  = TEAM_SHARE.div(10);

        require(teamWalletClaimed.add(amount)<=TEAM_SHARE,"Amount Exceeds");


        teamWalletClaimed = teamWalletClaimed.add(amount);
        seasInterFace.transfer(owner,amount);
        teamReserveReleaseTime = teamReserveReleaseTime.add(ONEMONTH);

    }










}
